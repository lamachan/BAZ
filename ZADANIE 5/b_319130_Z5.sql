/*
Z5 Weronika Zbierowska, nr indeksu: 319130, GR 5.

Z5.1 - Pokazać województwa wraz ze średnią aktualna
pensją w nich (z firm tam się mieszczących)
Używając UNION, rozważyć opcję ALL
jak nie ma etatów to 0 pokazujemy
(czyli musimy obsłużyć WOJ bez etatów AKT firm)
kod_woj, nazwa (z WOJ), avg(pensja) lub 0
jak brak etatow firmowych w danym miescie

Z5.2 - to samo co w Z5.1
Ale z wykorzystaniem LEFT OUTER

Z5.3 Napisać procedurę pokazującą średnią pensję z
osób z miasta - parametr procedure @kod_woj
WYNIK:
id_miasta, nazwa (z MIASTA), avg(pensja)
czyli srednie pensje osob mieszkających w danym MIESCIE
z danego WOJ (@kod_woj)
*/

/*Z5.1*/
SELECT w.kod_woj,
	w.nazwa,
	x.srednia_pensja
FROM woj w
	JOIN
	(
		SELECT mW.kod_woj,
			ROUND(AVG(eW.pensja), 2) AS srednia_pensja
		FROM etaty eW
			JOIN firmy fW ON (eW.id_firmy = fW.nazwa_skr)
			JOIN miasta mW ON (fW.id_miasta = mW.id_miasta)
		WHERE eW.do IS NULL
		GROUP BY mW.kod_woj
	) x ON (w.kod_woj = x.kod_woj)
UNION ALL
	SELECT w.kod_woj,
		w.nazwa,
		ISNULL(CONVERT(MONEY, NULL), 0) AS XX
	FROM woj w
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM etaty eW
			JOIN firmy fW ON (eW.id_firmy = fW.nazwa_skr)
			JOIN miasta mW ON (fW.id_miasta = mW.id_miasta)
		WHERE (w.kod_woj = mW.kod_woj)
			AND (eW.do IS NULL)
	)
	ORDER BY 2
/*
kod_woj nazwa                                              srednia_pensja
------- -------------------------------------------------- ---------------------
KUJ     kujawsko-pomorskie                                 3230,00
MLP     małopolskie                                        3760,00
MAZ     mazowieckie                                        4128,00
PKR     podkarpackie                                       0,00
POD     podlaskie                                          0,00
POM     pomorskie                                          7165,56
WLK     wielkopolskie                                      11200,00

(7 row(s) affected)
*/

/*SPRAWDZENIE Z5.1*/
SELECT w.nazwa,
	e.id_firmy,
	e.pensja
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
	JOIN woj w ON (m.kod_woj = w.kod_woj)
WHERE e.do IS NULL
ORDER BY 1
/*
nazwa                                              id_firmy pensja
-------------------------------------------------- -------- ---------------------
kujawsko-pomorskie                                 MP       4160,00
kujawsko-pomorskie                                 SFF      2300,00
małopolskie                                        BPE      3760,00
mazowieckie                                        GW       2750,00
mazowieckie                                        GW       4300,00
mazowieckie                                        PW       4000,00
mazowieckie                                        PW       6590,00
mazowieckie                                        KK       3000,00
pomorskie                                          LN       2350,00
pomorskie                                          LN       3670,00
pomorskie                                          LN       2350,00
pomorskie                                          ON       4620,00
pomorskie                                          ON       4600,00
pomorskie                                          CKK      5800,00
pomorskie                                          CKK      21450,00
pomorskie                                          RK       16700,00
pomorskie                                          RK       2950,00
wielkopolskie                                      GSF      15600,00
wielkopolskie                                      GSF      6800,00

(19 row(s) affected)

Jedynymi województwami, w których nie ma firm z aktualnymi etatami są podkarpackie i podlaskie.
To odpowiada wynikowi zapytania Z5.1, więc jest poprawnie.*/

/*Z5.2*/
SELECT w.kod_woj,
	w.nazwa,
	ISNULL(x.srednia_pensja, 0)
FROM woj w
	LEFT OUTER JOIN
	(
		SELECT mW.kod_woj,
			ROUND(AVG(eW.pensja), 2) AS srednia_pensja
		FROM etaty eW
			JOIN firmy fW ON (eW.id_firmy = fW.nazwa_skr)
			JOIN miasta mW ON (fW.id_miasta = mW.id_miasta)
		WHERE eW.do IS NULL
		GROUP BY mW.kod_woj
	) x ON (w.kod_woj = x.kod_woj)
ORDER BY 2
/*
kod_woj nazwa                                              
------- -------------------------------------------------- ---------------------
KUJ     kujawsko-pomorskie                                 3230,00
MLP     małopolskie                                        3760,00
MAZ     mazowieckie                                        4128,00
PKR     podkarpackie                                       0,00
POD     podlaskie                                          0,00
POM     pomorskie                                          7165,56
WLK     wielkopolskie                                      11200,00

(7 row(s) affected)
*/

/*SPRAWDZENIE Z5.2*/
/*Wynik zapytania Z5.2 jest taki sam, jak Z5.1, więc jest poprawnie.
(uzasadnienie w sekcji "SPRAWDZENIE Z5.1")*/

/*Z5.3*/
GO
CREATE PROCEDURE dbo.P1 (@kod_woj NCHAR(4))
AS
	SELECT m.id_miasta,
		m.nazwa,
		ISNULL(x.srednia_pensja, 0) AS srednia_pensja
	FROM miasta m
		JOIN woj wM ON (m.kod_woj = wM.kod_woj)
		LEFT OUTER JOIN
		(
			SELECT mW.id_miasta,
				ROUND(AVG(eW.pensja), 2) AS srednia_pensja
			FROM etaty eW
				JOIN osoby oW ON (eW.id_osoby = oW.id_osoby)
				JOIN miasta mW ON (oW.id_miasta = mW.id_miasta)
			WHERE eW.do IS NULL
			GROUP BY mW.id_miasta
		) x ON (m.id_miasta = x.id_miasta)
	WHERE wM.kod_woj = @kod_woj
	ORDER BY 1
GO
/*Command(s) completed successfully.*/

/*SPRAWDZENIE Z5.3*/
EXEC P1 N'MAZ'
/*
id_miasta   nazwa                                              srednia_pensja
----------- -------------------------------------------------- ---------------------
1           Warszawa                                           3683,33
2           Radom                                              3000,00

(2 row(s) affected)
*/
EXEC P1 N'POM'
/*
id_miasta   nazwa                                              srednia_pensja
----------- -------------------------------------------------- ---------------------
7           Gdańsk                                             6220,00
8           Kartuzy                                            9610,00
9           Malbork                                            2650,00

(3 row(s) affected)
*/