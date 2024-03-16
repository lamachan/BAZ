/*
Z3, Weronika Zbierowska, nr indeksu: 319130

Z3.1 - policzyć liczbę stanowisk w ETATY
(zapytanie z grupowaniem w wyniku STANOWISKO, LICZBA_ST)
Najlepiej wynik zapamiętać w tabeli tymczasowej

Z3.2 - korzystając z wyniku Z3,1 - pokazać, które STANOWISKO najczęściej występuje
(zapytanie z fa - analogiczne do zadań z Z2)

Z3.3 Pokazać liczbę firm w każdym z województw (czyli grupowanie po kod_woj)

Z3.4 Pokazać województwa w których nie ma żadnej firmy

(suma z3.3 i z3.4 powinna dać nam pełną listę województw
- woj gdzie sa firmy i gdzie ich nie ma to razem powinny byc wszystkie)
*/

/*Z3.1*/
SELECT e.stanowisko,
	COUNT(*) AS liczba_stanowisk
INTO #T
FROM etaty e
GROUP BY e.stanowisko

SELECT * FROM #T
/*
stanowisko                                         liczba_stanowisk
-------------------------------------------------- ----------------
adjunkt                                            1
administrator baz danych                           1
bibliotekarz                                       1
doradca klienta                                    1
dostawca                                           1
higienista stomatologiczny                         1
kelner                                             1
menadżer lokalu                                    1
nauczyciel języka kaszubkiego                      1
opiekun delfinów                                   1
ortodonta                                          1
piekarz                                            1
pizzer                                             1
pracownik naukowy                                  1
przewodnik muzealny                                1
recepcjonista                                      2
sprzątacz                                          1
sprzedawca                                         2
stylista fryzur                                    1
ślusarz                                            1

(20 row(s) affected)
*/

/*SPRAWDZENIE DO Z3.1*/
SELECT e.id_etatu,
	e.stanowisko
FROM etaty e
ORDER BY 2
/*
id_etatu    stanowisko
----------- --------------------------------------------------
1           adjunkt
19          administrator baz danych
14          bibliotekarz
15          doradca klienta
13          dostawca
12          higienista stomatologiczny
22          kelner
17          menadżer lokalu
9           nauczyciel języka kaszubkiego
8           opiekun delfinów
5           ortodonta
11          piekarz
2           pizzer
21          pracownik naukowy
6           przewodnik muzealny
18          recepcjonista
20          recepcjonista
7           sprzątacz
10          sprzedawca
16          sprzedawca
3           stylista fryzur
4           ślusarz

(22 row(s) affected)

Dzięki posortowaniu widać, że są po 2 etaty o stanowisku recepcjonista i sprzedawca, a reszta po 1 etacie.
Rozwiązanie jest poprawne.*/

/*Z3.2*/
DECLARE @max INT
SELECT @max = MAX(t.liczba_stanowisk)
FROM #T t

SELECT t.stanowisko,
	t.liczba_stanowisk
FROM #T t
WHERE (t.liczba_stanowisk = @max)
/*
stanowisko                                         liczba_stanowisk
-------------------------------------------------- ----------------
recepcjonista                                      2
sprzedawca                                         2

(2 row(s) affected)

Wyniki są zgodne z tabelą #T przedstawioną w Z3.1, więc jest poprawnie.*/

/*Z3.3*/
SELECT m.kod_woj,
	w.nazwa,	
	COUNT(*) AS liczba_firm
FROM firmy f
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
	JOIN woj w ON (m.kod_woj = w.kod_woj)
GROUP BY m.kod_woj, w.nazwa
/*
kod_woj nazwa                                              liczba_firm
------- -------------------------------------------------- -----------
KUJ     kujawsko-pomorskie                                 2
MAZ     mazowieckie                                        3
MLP     małopolskie                                        3
POM     pomorskie                                          5
WLK     wielkopolskie                                      1

(5 row(s) affected)
*/

/*Z3.4*/
SELECT *
FROM woj w
WHERE NOT EXISTS
(
	SELECT 1
	FROM firmy fW
		JOIN miasta mW ON (fW.id_miasta = mW.id_miasta)
	WHERE mW.kod_woj = w.kod_woj
)
/*
kod_woj nazwa
------- --------------------------------------------------
PKR     podkarpackie
POD     podlaskie

(2 row(s) affected)
*/

/*SPRAWDZENIE DO Z3.3 I Z3.4*/
SELECT * FROM woj
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

(7 row(s) affected)

W Z3.3 wyszło 5 rekordów, w Z3.4 wyszły 2 rekordy. 
Suma rekordów wynosi 7, czyli tyle ile wszystkich rekordów w tabeli woj.
Jest poprawnie.*/