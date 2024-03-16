/*
Z2, Weronika Zbierowska, GR 5, nr indeksu: 319130

Pokazać dane podstawowe osoby, w jakim mieście mieszka i w jakim to jest województwie

Pokazać wszystkie etaty o STANOWISKU na literę P (zamienione na S) i ostatniej literze STANOWISKA s (zamienione na r) lub a
(jeżeli nie macie takowych to wybierzcie takie warunki - inną literę początkową i inne 2 końcowe)
które mają pensje pomiędzy 3000 a 5000 (zamienione na 2000 a 3000) (też możecie zmienić jeżeli macie głownie inne zakresy)
mieszkajace w innym mieście niż znajduje się firma, w której mają etat
(wystarczą dane z tabel etaty, firmy, osoby , miasta)

Pokazać które miasto ma najdłuższą nazwę w bazie
(najpierw szukamy MAX z LEN(NAZWA)
a potem pokazujemy te miasta z taką długością pola NAZWA)

Policzyć liczbę etatów w firmie o nazwie (tu daję Wam wybór)

*/

/*POLECENIE 1.*/
SELECT CONVERT(NVARCHAR(15), o.imie) AS imie,
	CONVERT(NCHAR(10), o.nazwisko) AS nazwisko,
	CONVERT(NCHAR(10), m.nazwa) AS nazwa_miasta,
	CONVERT(NVARCHAR(20), w.nazwa) AS nazwa_województwa
FROM osoby o
	JOIN miasta m ON (o.id_miasta = m.id_miasta)
	JOIN woj w ON (m.kod_woj = w.kod_woj)
/*
imie            nazwisko   nazwa_miasta nazwa_województwa
--------------- ---------- ------------ --------------------
Krzesisława     Kot        Warszawa     mazowieckie
Jaromira        Kluska     Radom        mazowieckie
Tolisława       Pączek     Poznań       wielkopolskie
Dobrowieść      Król       Toruń        kujawsko-pomorskie
Włościsława     Grzybek    Bydgoszcz    kujawsko-pomorskie
Boguwola        Raciczka   Gdańsk       pomorskie
Kazimira        Wilk       Kartuzy      pomorskie
Ludomiła        Kwiat      Malbork      pomorskie
Żytomir         Lampion    Warszawa     mazowieckie
Sulim           Marko      Warszawa     mazowieckie
Świętopełk      Farty      Poznań       wielkopolskie
Bogumił         Złość      Gdańsk       pomorskie
Mszczuj         Gruszka    Gdańsk       pomorskie
Mścisław        Petronel   Kartuzy      pomorskie
Budzimir        Gąska      Kartuzy      pomorskie
Gniewosz        Belka      Malbork      pomorskie

(16 rows affected)
*/

/*sprawdzenie do polecenia 1.*/
SELECT o.id_miasta,
	o.imie,
	o.nazwisko
FROM osoby o
/*
id_miasta   imie                                               nazwisko
----------- -------------------------------------------------- --------------------------------------------------
1           Krzesisława                                        Kot
2           Jaromira                                           Kluska
4           Tolisława                                          Pączek
5           Dobrowieść                                         Król
6           Włościsława                                        Grzybek
7           Boguwola                                           Raciczka
8           Kazimira                                           Wilk
9           Ludomiła                                           Kwiat
1           Żytomir                                            Lampion
1           Sulim                                              Marko
4           Świętopełk                                         Farty
7           Bogumił                                            Złość
7           Mszczuj                                            Gruszka
8           Mścisław                                           Petronel
8           Budzimir                                           Gąska
9           Gniewosz                                           Belka

(16 rows affected)
*/
SELECT * FROM miasta
/*
id_miasta   kod_woj nazwa
----------- ------- --------------------------------------------------
1           MAZ     Warszawa
2           MAZ     Radom
3           MLP     Kraków
4           WLK     Poznań
5           KUJ     Toruń
6           KUJ     Bydgoszcz
7           POM     Gdańsk
8           POM     Kartuzy
9           POM     Malbork

(9 rows affected)
*/
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

(7 rows affected)

Wynikiem zapytania jest 16 rekordów (tyle ile w tabeli osoby) i dane się zgadzają, więc wynik jest poprawny.*/

/*POLECENIE 2.*/
SELECT CONVERT(NVARCHAR(10), o.imie) AS imie,
	CONVERT(NCHAR(10), o.nazwisko) AS nazwisko,
	CONVERT(NCHAR(10), mO.nazwa) AS miasto_osoby,
	CONVERT(NVARCHAR(20), f.nazwa) AS nazwa_firmy,
	CONVERT(NCHAR(10), mF.nazwa) AS miasto_firmy,
	CONVERT(NCHAR(10), e.stanowisko) AS stanowisko,
	CONVERT(NCHAR(10), e.pensja) AS pensja,
	CONVERT(NCHAR(10), e.od, 103) AS od,
	CONVERT(NCHAR(10), e.do, 103) AS do
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
	JOIN osoby o ON (e.id_osoby = o.id_osoby)
	JOIN miasta mF ON (f.id_miasta = mF.id_miasta)
	JOIN miasta mO ON (o.id_miasta = mO.id_miasta)
WHERE (e.stanowisko LIKE N'S%r' OR e.stanowisko LIKE N'S%a')
	AND (e.pensja BETWEEN 2000 AND 3000)
	AND (mF.id_miasta <> mO.id_miasta)
/*
imie       nazwisko   miasto_osoby nazwa_firmy          miasto_firmy stanowisko pensja     od         do
---------- ---------- ------------ -------------------- ------------ ---------- ---------- ---------- ----------
Ludomiła   Kwiat      Malbork      Lodziarnia Nadmorska Gdańsk       sprzedawca    2350.00 12/04/2020 NULL

(1 row affected)
*/

/*sprawdzenie do polecenia 2.*/
SELECT CONVERT(NVARCHAR(10), o.imie) AS imie,
	CONVERT(NCHAR(10), o.nazwisko) AS nazwisko,
	CONVERT(NCHAR(10), mO.nazwa) AS miasto_osoby,
	CONVERT(NVARCHAR(35), f.nazwa) AS nazwa_firmy,
	CONVERT(NCHAR(10), mF.nazwa) AS miasto_firmy,
	CONVERT(NVARCHAR(30), e.stanowisko) AS stanowisko,
	CONVERT(NCHAR(10), e.pensja) AS pensja,
	CONVERT(NCHAR(10), e.od, 103) AS od,
	CONVERT(NCHAR(10), e.do, 103) AS do
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
	JOIN osoby o ON (e.id_osoby = o.id_osoby)
	JOIN miasta mF ON (f.id_miasta = mF.id_miasta)
	JOIN miasta mO ON (o.id_miasta = mO.id_miasta)
/*
imie       nazwisko   miasto_osoby nazwa_firmy                         miasto_firmy stanowisko                     pensja     od         do
---------- ---------- ------------ ----------------------------------- ------------ ------------------------------ ---------- ---------- ----------
Krzesisław Kot        Warszawa     Politechnika Warszawska             Warszawa     adjunkt                           4000.00 12/09/2005 NULL
Krzesisław Kot        Warszawa     Galeria Wypieków                    Warszawa     pizzer                            2750.00 04/08/2021 NULL
Krzesisław Kot        Warszawa     Salon Fryzur Fikuśnych              Bydgoszcz    stylista fryzur                   3100.00 04/03/1996 31/12/2004
Jaromira   Kluska     Radom        Kraina Kluczy                       Radom        ślusarz                           3000.00 27/06/1999 NULL
Tolisława  Pączek     Poznań       Gabinet Stomatologiczny Fantazja    Poznań       ortodonta                        15600.00 02/02/2016 NULL
Dobrowieść Król       Toruń        Muzeum Piernika                     Toruń        przewodnik muzealny               4160.00 25/11/2010 NULL
Włościsław Grzybek    Bydgoszcz    Salon Fryzur Fikuśnych              Bydgoszcz    sprzątacz                         2300.00 15/04/1998 NULL
Boguwola   Raciczka   Gdańsk       Oceanarium Nowoczesne               Gdańsk       opiekun delfinów                  4620.00 08/06/2009 NULL
Kazimira   Wilk       Kartuzy      Centrum Kultury Kaszubskiej         Kartuzy      nauczyciel języka kaszubkiego     5800.00 05/12/2017 NULL
Ludomiła   Kwiat      Malbork      Lodziarnia Nadmorska                Gdańsk       sprzedawca                        2350.00 12/04/2020 NULL
Sulim      Marko      Warszawa     Galeria Wypieków                    Warszawa     piekarz                           4300.00 27/11/2018 NULL
Świętopełk Farty      Poznań       Gabinet Stomatologiczny Fantazja    Poznań       higienista stomatologiczny        6800.00 19/08/2012 NULL
Bogumił    Złość      Gdańsk       Lodziarnia Nadmorska                Gdańsk       dostawca                          3670.00 13/05/2019 NULL
Bogumił    Złość      Gdańsk       Politechnika Warszawska             Warszawa     bibliotekarz                      3300.00 26/03/1997 07/08/2003
Mszczuj    Gruszka    Gdańsk       Bazarek Przypraw Egzotycznych       Kraków       doradca klienta                   3760.00 16/09/2006 NULL
Mszczuj    Gruszka    Gdańsk       Lodziarnia Nadmorska                Gdańsk       sprzedawca                        2350.00 17/01/2022 NULL
Mszczuj    Gruszka    Gdańsk       Restauracja Krzyżacka               Malbork      menadżer lokalu                  16700.00 29/03/1986 NULL
Mścisław   Petronel   Kartuzy      Oceanarium Nowoczesne               Gdańsk       recepcjonista                     4600.00 18/06/2008 NULL
Budzimir   Gąska      Kartuzy      Centrum Kultury Kaszubskiej         Kartuzy      administrator baz danych         21450.00 30/12/2016 NULL
Budzimir   Gąska      Kartuzy      Gabinet Stomatologiczny Fantazja    Poznań       recepcjonista                     5700.00 19/04/2007 26/10/2008
Budzimir   Gąska      Kartuzy      Politechnika Warszawska             Warszawa     pracownik naukowy                 6590.00 12/03/1996 NULL
Gniewosz   Belka      Malbork      Restauracja Krzyżacka               Malbork      kelner                            2950.00 17/09/2006 NULL

(22 rows affected)

Wybrałam wiersze, które były znaczące w tym poleceniu, żeby nie zajmowały zbyt dużo miejsca.
Tylko 1 rekord spełnia warunki postawione w poleceniu, więc wynik jest poprawny.*/

/*POLECENIE 3.*/
DECLARE @max INT
SELECT @max = MAX(LEN(m.nazwa))
FROM miasta m

SELECT CONVERT(NCHAR(10), m.nazwa) AS miasto_max,
	LEN(m.nazwa) AS dlugosc_max
FROM miasta m
WHERE (LEN(m.nazwa) = @max)
/*
miasto_max dlugosc_max
---------- -----------
Bydgoszcz  9

(1 row affected)
*/

/*sprawdzenie do polecenia 3.*/
SELECT m.nazwa
FROM miasta m
/*
nazwa
--------------------------------------------------
Warszawa
Radom
Kraków
Poznań
Toruń
Bydgoszcz
Gdańsk
Kartuzy
Malbork

(9 rows affected)

Widać, że Bydgoszcz ma najdłuższą nazwę, więc wynik jest poprawny.*/

/*POLECENIE 4.*/
/*Nie wiedziałam, którą wersję wybrać (czy dozwolone było użycie GROUP BY), więc wstawiłam obydwie.*/
/*wersja 1. bez GROUP BY*/
SELECT N'Lodziarnia Nadmorska' AS nazwa_firmy,
	COUNT(*) AS liczba_etatow
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
WHERE f.nazwa = N'Lodziarnia Nadmorska'
/*
nazwa_firmy          liczba_etatow
-------------------- -------------
Lodziarnia Nadmorska 3

(1 row affected)
*/

/*wersja 2. z GROUP BY*/
SELECT CONVERT(NVARCHAR(20), f.nazwa) AS nazwa_firmy,
	COUNT(*) AS liczba_etatow
FROM etaty e
	JOIN firmy f ON (e.id_firmy = f.nazwa_skr)
WHERE f.nazwa = N'Lodziarnia Nadmorska'
GROUP BY f.nazwa
/*
nazwa_firmy          liczba_etatow
-------------------- -------------
Lodziarnia Nadmorska 3

(1 row affected)
*/

/*sprawdzenie do polecenia 4.*/
SELECT * FROM etaty e
/*
id_osoby    id_firmy stanowisko                                         pensja                od                      do                      id_etatu
----------- -------- -------------------------------------------------- --------------------- ----------------------- ----------------------- -----------
1           PW       adjunkt                                            4000,00               2005-09-12 00:00:00.000 NULL                    1
1           GW       pizzer                                             2750,00               2021-08-04 00:00:00.000 NULL                    2
1           SFF      stylista fryzur                                    3100,00               1996-03-04 00:00:00.000 2004-12-31 00:00:00.000 3
2           KK       ślusarz                                            3000,00               1999-06-27 00:00:00.000 NULL                    4
3           GSF      ortodonta                                          15600,00              2016-02-02 00:00:00.000 NULL                    5
4           MP       przewodnik muzealny                                4160,00               2010-11-25 00:00:00.000 NULL                    6
5           SFF      sprzątacz                                          2300,00               1998-04-15 00:00:00.000 NULL                    7
6           ON       opiekun delfinów                                   4620,00               2009-06-08 00:00:00.000 NULL                    8
7           CKK      nauczyciel języka kaszubkiego                      5800,00               2017-12-05 00:00:00.000 NULL                    9
8           LN       sprzedawca                                         2350,00               2020-04-12 00:00:00.000 NULL                    10
10          GW       piekarz                                            4300,00               2018-11-27 00:00:00.000 NULL                    11
11          GSF      higienista stomatologiczny                         6800,00               2012-08-19 00:00:00.000 NULL                    12
12          LN       dostawca                                           3670,00               2019-05-13 00:00:00.000 NULL                    13
12          PW       bibliotekarz                                       3300,00               1997-03-26 00:00:00.000 2003-08-07 00:00:00.000 14
13          BPE      doradca klienta                                    3760,00               2006-09-16 00:00:00.000 NULL                    15
13          LN       sprzedawca                                         2350,00               2022-01-17 00:00:00.000 NULL                    16
13          RK       menadżer lokalu                                    16700,00              1986-03-29 00:00:00.000 NULL                    17
14          ON       recepcjonista                                      4600,00               2008-06-18 00:00:00.000 NULL                    18
15          CKK      administrator baz danych                           21450,00              2016-12-30 00:00:00.000 NULL                    19
15          GSF      recepcjonista                                      5700,00               2007-04-19 00:00:00.000 2008-10-26 00:00:00.000 20
15          PW       pracownik naukowy                                  6590,00               1996-03-12 00:00:00.000 NULL                    21
16          RK       kelner                                             2950,00               2006-09-17 00:00:00.000 NULL                    22

(22 rows affected)

W tabeli etaty są 3 rekordy z id_firmy "LN" odpowiadającym firmie "Lodziarnia Nadmorska", więc wynik jest poprawny.*/