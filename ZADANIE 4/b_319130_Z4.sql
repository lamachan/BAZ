/*
Z4 Weronika Zbierowska, nr indeksu: 319130, GR 5.

Z4.1 - pokazać firmy z miasta o kodzie X, w których nigdy
nie pracowały / nie pracują (ignorujemy kolumny OD i DO) osoby mieszkające w mieście o kodzie id_miasta=Y (zapytanie z NOT EXISTS)
Czyli jak FIRMA PW ma 2 etaty i jeden
osoby mieszkającej w mieście o ID=X
a drugi etat osoby mieszkającej w mieście o ID=Y
to takiej FIRMY NIE POKOZUJEMY !!!
A nie, że pokażemy jeden etat a drugi nie

Z4.2 - pokazać liczbę firm w MIASTO. Ale tylko takie mające więcej jak jedną firmę

Z4.3 - pokazać średnią pensję w MIASTA ale MIAST posiadających więcej jak jedną firmę
Srednia w miastach może być liczona z osób tam mieszkających lub firm tam będących
1 wariant -> etaty -> osoby
teraz złaczamy wynik tego zapytania z FIRMY (grupowane po ID_MIASTA z HAVING)
2 wariant -> (średnia z firm o danym id_miasta)
(łaczymy wynik z firmy -> miasta z grupowaniem poprzez ID_MIASTA)
*/

/*Z4.1*/
DECLARE @X INT
DECLARE @Y INT
SET @X = 7
SET @Y = 9

SELECT f.nazwa
FROM firmy f
WHERE NOT EXISTS
(
	SELECT 1
	FROM etaty eW
		JOIN osoby oW ON (eW.id_osoby = oW.id_osoby)
	WHERE (eW.id_firmy = f.nazwa_skr)
		AND (oW.id_miasta = @Y)
)
	AND (f.id_miasta = @X)
/*
nazwa
--------------------------------------------------
Oceanarium Nowoczesne
Prawdziwa Firma

(2 row(s) affected)
*/

/*SPRAWDZENIE DO Z4.1*/
SELECT f.nazwa,
	f.nazwa_skr
FROM firmy f
WHERE f.id_miasta = @X
/*
nazwa                                              nazwa_skr
-------------------------------------------------- ---------
Lodziarnia Nadmorska                               LN  
Oceanarium Nowoczesne                              ON  
Prawdziwa Firma                                    PF  

(3 row(s) affected)

W mieście o ID=7(X) są 3 firmy*/
SELECT o.id_osoby,
	e.id_firmy
FROM etaty e
	JOIN osoby o ON (e.id_osoby = o.id_osoby)
WHERE o.id_miasta = @Y
/*
id_osoby    id_firmy
----------- --------
8           LN  
16          RK  

(2 row(s) affected)

W mieście o ID=9(Y) 1 osoba pracuje w firmie LN, która znajduje się w mieście o ID=7(X).
Skoro wynikiem były 2 z 3 firm (Oceanarium Nowoczesne, Prawdziwa Firma), to zapytanie było poprawne.
*/
/*Z4.2*/
SELECT m.id_miasta,
	COUNT(DISTINCT f.nazwa_skr) AS liczba_firm
INTO #T1
FROM miasta m
	JOIN firmy f ON (m.id_miasta = f.id_miasta)
GROUP BY m.id_miasta
	HAVING COUNT(DISTINCT f.nazwa_skr) > 1

SELECT m.nazwa,
	t.liczba_firm
FROM #T1 t
	JOIN miasta m ON (t.id_miasta = m.id_miasta)
/*
nazwa                                              liczba_firm
-------------------------------------------------- -----------
Warszawa                                           2
Kraków                                             3
Gdańsk                                             3

(3 row(s) affected)
*/
/*SPRAWDZENIE DO Z4.2*/
SELECT f.id_miasta,
	f.nazwa
FROM firmy f
ORDER BY 1
/*
id_miasta   nazwa
----------- --------------------------------------------------
1           Galeria Wypieków
1           Politechnika Warszawska
2           Kraina Kluczy
3           Oczyszczalnia Brudnych Wód
3           Bazarek Przypraw Egzotycznych
3           Drukarnia Piesek
4           Gabinet Stomatologiczny Fantazja
5           Muzeum Piernika
6           Salon Fryzur Fikuśnych
7           Oceanarium Nowoczesne
7           Prawdziwa Firma
7           Lodziarnia Nadmorska
8           Centrum Kultury Kaszubskiej
9           Restauracja Krzyżacka

(14 row(s) affected)
*/
SELECT m.id_miasta,
	m.nazwa
FROM miasta m
/*
id_miasta   nazwa
----------- --------------------------------------------------
1           Warszawa
2           Radom
3           Kraków
4           Poznań
5           Toruń
6           Bydgoszcz
7           Gdańsk
8           Kartuzy
9           Malbork

(9 row(s) affected)

Tylko w miastach o ID={1, 3, 7} jest więcej niż 2 firmy,
co odpowiada Warszawie, Krakowie i Gdańsku.
Ich liczba też się zgadza, więc zapytanie jest poprawne.*/

/*Z4.3 - wariant 2.*/
/*średnia z pensji z firm w miastach*/
SELECT m.id_miasta,
	AVG(e.pensja) AS srednia_pensja
INTO #T2
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
GROUP BY m.id_miasta

SELECT m.id_miasta
INTO #T3
FROM firmy f
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
GROUP BY m.id_miasta
	HAVING COUNT(DISTINCT f.nazwa_skr) > 1

SELECT m.nazwa,
	t2.srednia_pensja
FROM #T2 t2
	JOIN #T3 t3 ON (t2.id_miasta = t3.id_miasta)
	JOIN miasta m ON (t3.id_miasta = m.id_miasta)
/*
nazwa                                              srednia_pensja
-------------------------------------------------- ---------------------
Warszawa                                           4188,00
Kraków                                             3760,00
Gdańsk                                             3518,00

(3 row(s) affected)
*/
/*SPRAWDZENIE DO Z4.3*/
/*Z Z4.2 wiemy, że Warszawa, Kraków i Gdańsk to jedyne miasta z więcej niż 1 firmą.*/
SELECT m.nazwa,
	e.pensja
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
WHERE m.nazwa IN (N'Warszawa', N'Kraków', N'Gdańsk')
ORDER BY 1
/*
nazwa                                              pensja
-------------------------------------------------- ---------------------
Gdańsk                                             2350,00
Gdańsk                                             3670,00
Gdańsk                                             2350,00
Gdańsk                                             4620,00
Gdańsk                                             4600,00
Kraków                                             3760,00
Warszawa                                           2750,00
Warszawa                                           4300,00
Warszawa                                           4000,00
Warszawa                                           3300,00
Warszawa                                           6590,00

(11 row(s) affected)

Gdyby policzyć średnie z pensji dla tych miast, to by się zgodziło z wynikiem,
więc zapytanie jest poprawne.
(W Krakowie jest tylko 1 etat, ponieważ istnieją tam firmy bez żadnych etatów.)*/

/*Z4.3 - wariant 1.*/
/*średnia z pensji osób w miastach*/
SELECT m.id_miasta,
	AVG(e.pensja) AS srednia_pensja
INTO #T4
FROM etaty e
	JOIN osoby o ON (e.id_osoby = o.id_osoby)
	JOIN miasta m ON (o.id_miasta = m.id_miasta)
GROUP BY m.id_miasta

SELECT m.id_miasta
INTO #T5
FROM firmy f
	JOIN miasta m ON (f.id_miasta = m.id_miasta)
GROUP BY m.id_miasta
	HAVING COUNT(DISTINCT f.nazwa_skr) > 1

SELECT m.nazwa,
	t4.srednia_pensja
FROM #T4 t4
	JOIN #T5 t5 ON (t4.id_miasta = t5.id_miasta)
	JOIN miasta m ON (t5.id_miasta = m.id_miasta)
/*
nazwa                                              srednia_pensja
-------------------------------------------------- ---------------------
Warszawa                                           3537,50
Gdańsk                                             5733,3333

(2 rows affected)
*/

/*SPRAWDZENIE DO Z4.3*/
/*Z Z4.2 wiemy, że Warszawa, Kraków i Gdańsk to jedyne miasta z więcej niż 1 firmą.*/
SELECT m.nazwa,
	e.pensja
FROM etaty e
	JOIN osoby o ON (e.id_osoby = o.id_osoby)
	JOIN miasta m ON (o.id_miasta = m.id_miasta)
WHERE m.nazwa IN (N'Warszawa', N'Kraków', N'Gdańsk')
ORDER BY 1
/*
nazwa                                              pensja
-------------------------------------------------- ---------------------
Gdańsk                                             4620,00
Gdańsk                                             3670,00
Gdańsk                                             3300,00
Gdańsk                                             3760,00
Gdańsk                                             2350,00
Gdańsk                                             16700,00
Warszawa                                           4000,00
Warszawa                                           2750,00
Warszawa                                           3100,00
Warszawa                                           4300,00

(10 rows affected)

Gdyby policzyć średnie z pensji dla tych miast, to by się zgodziło z wynikiem,
więc zapytanie jest poprawne.
(W Krakowie nie mieszka nikt, pomimo istnienia tam więcej niż 1 firmy.)*/