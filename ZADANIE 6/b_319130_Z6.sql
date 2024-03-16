/* Weronika Zbierowska, nr indeksu: 319130, GR 5.
**
** 3 reguły tworzenia TRIGGERA
** R1 - Trigger nie może aktualizować CALEJ tabeli a co najwyżej elementy zmienione
** R2 - Trigger może wywołać sam siebie - uzysamy niesończoną rekurencję == stack overflow
** R3 - Zawsze zakladamy, że wstawiono / zmodyfikowano / skasowano wiecej jak 1 rekord
**
** Z1: Napisać trigger, który będzie zamieniał spacje (na _) z pola NAZWA_SKR w tabeli FIRMY
** Trigger na INSERT, UPDATE
** UWAGA !! Trigger będzie robił UPDATE na polu NAZWA_SKR
** To grozi REKURENCJĄ i przepelnieniem stosu
** Dlatego trzeba będzie sprawdzać UPDATE(NAZWA_SKR) i sprawdzać czy we
** wstawionych rekordach były spacje i tylko takowe poprawiać (ze spacjami w NAZWA_SKR)
** REPLACE(pole, ze_znakow, na_znaki)
**
** Z2: Napisać procedurę szukającą WOJ z paramertrami
** @nazwa_wzor nvarchar(20) = NULL
** @kod_woj_wzor nvarchar(20) = NULL
** @pokaz_zarobki bit = 0
** Procedura ma mieć zmienną @sql nvarchar(1000), którą buduje dynamicznie
** @pokaz_zarobki = 0 => (WOJ.NAZWA AS woj, kod_woj)
** @pokaz_zarobki = 1 => (WOJ.NAZWA AS woj, kod_woj
, śr_z_akt_etatow)
** Mozliwe wywołania: EXEC sz_w @nazw_wzor = N'M%'
** powinno zbudować zmienną tekstową
** @sql = N'SELECT w.* FROM woj w WHERE w.nazwa LIKE NM% '
** uruchomienie zapytania to EXEC sp_sqlExec @sql
** rekomenduję aby najpierw procedura zwracała zapytanie SELECT @sql
** a dopiero jak będą poprawne uruachamiała je
*/

/*Z1*/
GO
CREATE TRIGGER dbo.TR_firmy ON firmy FOR INSERT, UPDATE
AS
	IF UPDATE(nazwa_skr)
		AND EXISTS
		(
			SELECT 1
			FROM inserted i
			WHERE i.nazwa_skr LIKE N'% %'
		)
		UPDATE firmy SET nazwa_skr = REPLACE(nazwa_skr, N' ', N'_')
		WHERE nazwa_skr IN
		(
			SELECT i.nazwa_skr
			FROM inserted i
			WHERE i.nazwa_skr LIKE N'% %'
		)
GO

/*Command(s) completed successfully.*/

/*Z1 - SPRAWDZENIE*/
SELECT f.nazwa_skr,
	f.nazwa
FROM firmy f

/*
nazwa_skr nazwa
--------- --------------------------------------------------
BPE       Bazarek Przypraw Egzotycznych
CKK       Centrum Kultury Kaszubskiej
DP        Drukarnia Piesek
GSF       Gabinet Stomatologiczny Fantazja
GW        Galeria Wypieków
KK        Kraina Kluczy
LN        Lodziarnia Nadmorska
MP        Muzeum Piernika
OBW       Oczyszczalnia Brudnych Wód
ON        Oceanarium Nowoczesne
PF        Prawdziwa Firma
PW        Politechnika Warszawska
RK        Restauracja Krzyżacka
SFF       Salon Fryzur Fikuśnych

(14 row(s) affected)
Pierwotny wygląd tabeli firmy (Oczysczalnia Brudnych Wód - OBW).*/

UPDATE firmy SET nazwa_skr = N'O BW' WHERE nazwa_skr = N'OBW'

SELECT f.nazwa_skr,
	f.nazwa
FROM firmy f

/*
(1 row affected)

(1 row affected)
nazwa_skr nazwa
--------- --------------------------------------------------
BPE       Bazarek Przypraw Egzotycznych
CKK       Centrum Kultury Kaszubskiej
DP        Drukarnia Piesek
GSF       Gabinet Stomatologiczny Fantazja
GW        Galeria Wypieków
KK        Kraina Kluczy
LN        Lodziarnia Nadmorska
MP        Muzeum Piernika
O_BW      Oczyszczalnia Brudnych Wód
ON        Oceanarium Nowoczesne
PF        Prawdziwa Firma
PW        Politechnika Warszawska
RK        Restauracja Krzyżacka
SFF       Salon Fryzur Fikuśnych

(14 rows affected)
Próba zmiany 'OBW' na 'O BW' spowodowała uruchomienie triggera i zamianę na 'O_BW'.
Trigger działa poprawnie.*/

/*Z2*/
GO
ALTER PROCEDURE dbo.P_szukaj_woj (@nazwa_wzor NVARCHAR(20) = NULL, @kod_woj_wzor NVARCHAR(20) = NULL, @pokaz_zarobki BIT = 0)
AS
	DECLARE @sql NVARCHAR(1000)
	DECLARE @select NVARCHAR(100)
	DECLARE @from NVARCHAR(500)
	DECLARE @where NVARCHAR(100)

	SET @select = N'SELECT w.*'
	SET @from = N'FROM woj w'
	SET @where = N''

	IF @pokaz_zarobki = 1
		BEGIN
			SET @select = @select + N', x.srednia_pensja'
			SET @from = @from +
			N' JOIN
			(
				SELECT mW.kod_woj,
					ROUND(AVG(eW.pensja), 2) AS srednia_pensja
				FROM etaty eW
					JOIN firmy fW ON (eW.id_firmy = fW.nazwa_skr)
					JOIN miasta mW ON (fW.id_miasta = mW.id_miasta)
				WHERE eW.do IS NULL
				GROUP BY mW.kod_woj
			) x ON (w.kod_woj = x.kod_woj)'
		END

	IF @nazwa_wzor IS NOT NULL
		SET @where = N'WHERE w.nazwa LIKE N''' + @nazwa_wzor + N''''

	IF @kod_woj_wzor IS NOT NULL
		IF @nazwa_wzor IS NOT NULL
			SET @where = @where + N' AND w.kod_woj LIKE N''' + @kod_woj_wzor + N''''
		ELSE
			SET @where = N'WHERE w.kod_woj LIKE N''' + @kod_woj_wzor + N''''

	SET @sql = @select + N' ' + @from + N' ' + @where
	--SELECT @sql
	EXEC sp_sqlexec @sql
GO

/*Commands completed successfully.*/

/*Z2 - SPRAWDZENIE*/
EXEC dbo.P_szukaj_woj

/*
kod_woj nazwa
------- --------------------------------------------------
KUJ     kujawsko-pomorskie
MAZ     mazowieckie
MLP     małopolskie
PKR     podkarpackie
POD     podlaskie
POM     pomorskie
WLK     wielkopolskie

(7 rows affected)
Wywołanie bez parametrów -
wyświetlenie wszystkich województw.*/

EXEC dbo.P_szukaj_woj @nazwa_wzor = N'p%'

/*
kod_woj nazwa
------- --------------------------------------------------
PKR     podkarpackie
POD     podlaskie
POM     pomorskie

(3 rows affected)
Wywołanie z parametrem @nazwa_wzor -
wyświetlenie wszystkich województw na 'p'.*/

EXEC dbo.P_szukaj_woj @kod_woj_wzor = N'PO%'

/*
kod_woj nazwa
------- --------------------------------------------------
POD     podlaskie
POM     pomorskie

(2 rows affected)
Wywołanie z parametrem @kod_woj_wzor -
wyświetlenie wszystkich województw o kodzie na 'PO'*/

EXEC dbo.P_szukaj_woj @pokaz_zarobki = 1

/*
kod_woj nazwa                                              srednia_pensja
------- -------------------------------------------------- ---------------------
KUJ     kujawsko-pomorskie                                 3230,00
MAZ     mazowieckie                                        4128,00
MLP     małopolskie                                        3760,00
POM     pomorskie                                          7165,56
WLK     wielkopolskie                                      11200,00

(5 rows affected)
Wywołanie z parametrem @pokaz_zarobki -
wyświetlenie wszystkich województw (z aktualnymi etatami) i średnimi pensjami w nich.*/

EXEC dbo.P_szukaj_woj @nazwa_wzor = N'pom%', @kod_woj_wzor = N'PO%'

/*
kod_woj nazwa
------- --------------------------------------------------
POM     pomorskie

(1 row affected)
Wywołanie z parametrami @nazwa_wzor i @kod_woj_wzor jednocześnie -
wyświetlenie wszystkich województw o nazwie na 'pom' i kodzie na 'PO'.*/

EXEC dbo.P_szukaj_woj @nazwa_wzor = N'pom%', @kod_woj_wzor = N'PO%', @pokaz_zarobki = 1

/*
kod_woj nazwa                                              srednia_pensja
------- -------------------------------------------------- ---------------------
POM     pomorskie                                          7165,56

(1 row affected)
Kombinacja wszystkich parametrów.*/
