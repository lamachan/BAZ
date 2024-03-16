/*Weronika Zbierowska, nr indeksu: 319130*/

IF OBJECT_ID(N'etaty') IS NOT NULL
	DROP TABLE etaty
GO
IF OBJECT_ID(N'osoby') IS NOT NULL
	DROP TABLE osoby
GO
IF OBJECT_ID(N'firmy') IS NOT NULL
	DROP TABLE firmy
GO
IF OBJECT_ID(N'miasta') IS NOT NULL
	DROP TABLE miasta
GO
IF OBJECT_ID(N'woj') IS NOT NULL
	DROP TABLE woj
GO

CREATE TABLE dbo.woj
(
	kod_woj NCHAR(4) NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY,
	nazwa NVARCHAR(50) NOT NULL
)
GO
CREATE TABLE dbo.miasta
(
	id_miasta INT NOT NULL IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY,
	kod_woj NCHAR(4) NOT NULL CONSTRAINT FK_MIASTA_WOJ FOREIGN KEY REFERENCES woj(kod_woj),
	nazwa NVARCHAR(50) NOT NULL
)
GO
CREATE TABLE dbo.osoby
(
	id_osoby INT NOT NULL IDENTITY CONSTRAINT PK_OSOBY PRIMARY KEY,
	id_miasta INT NOT NULL CONSTRAINT FK_OSOBY_MIASTA FOREIGN KEY REFERENCES miasta(id_miasta),
	imie NVARCHAR(50) NOT NULL,
	nazwisko NVARCHAR(50) NOT NULL
)
GO
CREATE TABLE dbo.firmy
(
	nazwa_skr NCHAR(4) NOT NULL CONSTRAINT PK_FIRMY PRIMARY KEY,
	id_miasta INT NOT NULL CONSTRAINT FK_FIRMY_MIASTA FOREIGN KEY REFERENCES miasta(id_miasta),
	nazwa NVARCHAR(50) NOT NULL,
	kod_pocztowy NCHAR(6) NOT NULL,
	ulica NVARCHAR(50) NOT NULL
)
GO
CREATE TABLE dbo.etaty
(
	id_osoby INT NOT NULL CONSTRAINT FK_ETATY_OSOBY FOREIGN KEY REFERENCES osoby(id_osoby),
	id_firmy NCHAR(4) NOT NULL CONSTRAINT FK_ETATY_FIRMY FOREIGN KEY REFERENCES firmy(nazwa_skr),
	stanowisko NVARCHAR(50) NOT NULL,
	pensja MONEY NOT NULL,
	od DATETIME NOT NULL,
	do DATETIME NULL,
	id_etatu INT NOT NULL IDENTITY CONSTRAINT PK_ETATY PRIMARY KEY
)
GO

INSERT INTO woj(kod_woj, nazwa) VALUES (N'MAZ', N'mazowieckie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'MLP', N'małopolskie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'WLK', N'wielkopolskie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'POD', N'podlaskie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'POM', N'pomorskie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'KUJ', N'kujawsko-pomorskie')
INSERT INTO woj(kod_woj, nazwa) VALUES (N'PKR', N'podkarpackie')

DECLARE @id_war INT, @id_rad INT, @id_kra INT,
		@id_poz INT, @id_tor INT, @id_byd INT,
		@id_gda INT, @id_kar INT, @id_mal INT
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'MAZ', N'Warszawa')
SET @id_war = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'MAZ', N'Radom')
SET @id_rad = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'MLP', N'Kraków')
SET @id_kra = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'WLK', N'Poznań')
SET @id_poz = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'KUJ', N'Toruń')
SET @id_tor = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'KUJ', N'Bydgoszcz')
SET @id_byd = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'POM', N'Gdańsk')
SET @id_gda = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'POM', N'Kartuzy')
SET @id_kar = SCOPE_IDENTITY()
INSERT INTO miasta(kod_woj, nazwa) VALUES (N'POM', N'Malbork')
SET @id_mal = SCOPE_IDENTITY()

DECLARE @id_kk INT, @id_jk INT, @id_tp INT, @id_dk INT,
		@id_wg INT, @id_br INT, @id_kw INT, @id_lk INT,
		@id_zl INT, @id_sm INT, @id_sf INT, @id_bz INT,
		@id_mg INT, @id_mp INT, @id_bg INT, @id_gb INT
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_war, N'Krzesisława', N'Kot')
SET @id_kk = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_rad, N'Jaromira', N'Kluska')
SET @id_jk = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_poz, N'Tolisława', N'Pączek')
SET @id_tp = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_tor, N'Dobrowieść', N'Król')
SET @id_dk = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_byd, N'Włościsława', N'Grzybek')
SET @id_wg = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_gda, N'Boguwola', N'Raciczka')
SET @id_br = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_kar, N'Kazimira', N'Wilk')
SET @id_kw = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_mal, N'Ludomiła', N'Kwiat')
SET @id_lk = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_war, N'Żytomir', N'Lampion')
SET @id_zl = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_war, N'Sulim', N'Marko')
SET @id_sm = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_poz, N'Świętopełk', N'Farty')
SET @id_sf = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_gda, N'Bogumił', N'Złość')
SET @id_bz = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_gda, N'Mszczuj', N'Gruszka')
SET @id_mg = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_kar, N'Mścisław', N'Petronel')
SET @id_mp = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_kar, N'Budzimir', N'Gąska')
SET @id_bg = SCOPE_IDENTITY()
INSERT INTO osoby(id_miasta, imie, nazwisko) VALUES (@id_mal, N'Gniewosz', N'Belka')
SET @id_gb = SCOPE_IDENTITY()

INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'PW', @id_war, N'Politechnika Warszawska', N'02-904', N'Plac Politechniki 1')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'GW', @id_war, N'Galeria Wypieków', N'02-734', N'Jana III Sobieskiego 39')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'KK', @id_rad, N'Kraina Kluczy', N'07-098', N'Michałków 55')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'OBW', @id_kra, N'Oczyszczalnia Brudnych Wód', N'54-712', N'Kanalizacyjna 23')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'BPE', @id_kra, N'Bazarek Przypraw Egzotycznych', N'55-823', N'Kurkumy 9a')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'DP', @id_kra, N'Drukarnia Piesek', N'54-107', N'Gilberta Franza 143')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'GSF', @id_poz, N'Gabinet Stomatologiczny Fantazja', N'13-554', N'Obrońców Lwowa 4')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'MP', @id_tor, N'Muzeum Piernika', N'39-062', N'Mikołaja Kopernika 10')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'SFF', @id_byd, N'Salon Fryzur Fikuśnych', N'36-106', N'Skarbowa 3')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'ON', @id_gda, N'Oceanarium Nowoczesne', N'74-080', N'Muszelki 12b')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'PF', @id_gda, N'Prawdziwa Firma', N'74-812', N'Oszustów 4')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'LN', @id_gda, N'Lodziarnia Nadmorska', N'75-294', N'Nadmorska 39')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'CKK', @id_kar, N'Centrum Kultury Kaszubskiej', N'80-105', N'Chlebowa 7')
INSERT INTO firmy(nazwa_skr, id_miasta, nazwa, kod_pocztowy, ulica)
	VALUES (N'RK', @id_mal, N'Restauracja Krzyżacka', N'63-193', N'Ulricha von Jungingena 12')

INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_kk, N'PW', N'adjunkt', 4000, CONVERT(DATETIME, '20050912', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_kk, N'GW', N'pizzer', 2750, CONVERT(DATETIME, '20210804', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_kk, N'SFF', N'stylista fryzur', 3100, CONVERT(DATETIME, '19960304', 112), CONVERT(DATETIME, '20041231', 112))
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_jk, N'KK', N'ślusarz', 3000, CONVERT(DATETIME, '19990627', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_tp, N'GSF', N'ortodonta', 15600, CONVERT(DATETIME, '20160202', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_dk, N'MP', N'przewodnik muzealny', 4160, CONVERT(DATETIME, '20101125', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_wg, N'SFF', N'sprzątacz', 2300, CONVERT(DATETIME, '19980415', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_br, N'ON', N'opiekun delfinów', 4620, CONVERT(DATETIME, '20090608', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_kw, N'CKK', N'nauczyciel języka kaszubkiego', 5800, CONVERT(DATETIME, '20171205', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_lk, N'LN', N'sprzedawca', 2350, CONVERT(DATETIME, '20200412', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_sm, N'GW', N'piekarz', 4300, CONVERT(DATETIME, '20181127', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_sf, N'GSF', N'higienista stomatologiczny', 6800, CONVERT(DATETIME, '20120819', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_bz, N'LN', N'dostawca', 3670, CONVERT(DATETIME, '20190513', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_bz, N'PW', N'bibliotekarz', 3300, CONVERT(DATETIME, '19970326', 112), CONVERT(DATETIME, '20030807', 112))
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_mg, N'BPE', N'doradca klienta', 3760, CONVERT(DATETIME, '20060916', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_mg, N'LN', N'sprzedawca', 2350, CONVERT(DATETIME, '20220117', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_mg, N'RK', N'menadżer lokalu', 16700, CONVERT(DATETIME, '19860329', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_mp, N'ON', N'recepcjonista', 4600, CONVERT(DATETIME, '20080618', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_bg, N'CKK', N'administrator baz danych', 21450, CONVERT(DATETIME, '20161230', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_bg, N'GSF', N'recepcjonista', 5700, CONVERT(DATETIME, '20070419', 112), CONVERT(DATETIME, '20081026', 112))
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_bg, N'PW', N'pracownik naukowy', 6590, CONVERT(DATETIME, '19960312', 112), NULL)
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (@id_gb, N'RK', N'kelner', 2950, CONVERT(DATETIME, '20060917', 112), NULL)

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
*/
SELECT * FROM osoby
/*
id_osoby    id_miasta   imie                                               nazwisko
----------- ----------- -------------------------------------------------- --------------------------------------------------
1           1           Krzesisława                                        Kot
2           2           Jaromira                                           Kluska
3           4           Tolisława                                          Pączek
4           5           Dobrowieść                                         Król
5           6           Włościsława                                        Grzybek
6           7           Boguwola                                           Raciczka
7           8           Kazimira                                           Wilk
8           9           Ludomiła                                           Kwiat
9           1           Żytomir                                            Lampion
10          1           Sulim                                              Marko
11          4           Świętopełk                                         Farty
12          7           Bogumił                                            Złość
13          7           Mszczuj                                            Gruszka
14          8           Mścisław                                           Petronel
15          8           Budzimir                                           Gąska
16          9           Gniewosz                                           Belka
*/
SELECT * FROM firmy
/*
nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica
--------- ----------- -------------------------------------------------- ------------ --------------------------------------------------
BPE       3           Bazarek Przypraw Egzotycznych                      55-823       Kurkumy 9a
CKK       8           Centrum Kultury Kaszubskiej                        80-105       Chlebowa 7
DP        3           Drukarnia Piesek                                   54-107       Gilberta Franza 143
GSF       4           Gabinet Stomatologiczny Fantazja                   13-554       Obrońców Lwowa 4
GW        1           Galeria Wypieków                                   02-734       Jana III Sobieskiego 39
KK        2           Kraina Kluczy                                      07-098       Michałków 55
LN        7           Lodziarnia Nadmorska                               75-294       Nadmorska 39
MP        5           Muzeum Piernika                                    39-062       Mikołaja Kopernika 10
OBW       3           Oczyszczalnia Brudnych Wód                         54-712       Kanalizacyjna 23
ON        7           Oceanarium Nowoczesne                              74-080       Muszelki 12b
PF        7           Prawdziwa Firma                                    74-812       Oszustów 4
PW        1           Politechnika Warszawska                            02-904       Plac Politechniki 1
RK        9           Restauracja Krzyżacka                              63-193       Ulricha von Jungingena 12
SFF       6           Salon Fryzur Fikuśnych                             36-106       Skarbowa 3
*/
SELECT * FROM etaty
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
*/

/*Próba wstawienie do tabeli etaty rekordu osoby nieistniejącej kończy się niepowodzeniem:*/
INSERT INTO etaty(id_osoby, id_firmy, stanowisko, pensja, od, do)
	VALUES (3333, N'PW', N'rektor', 1000000, CONVERT(DATETIME, '20000101', 112), NULL)
/*Msg 547, Level 16, State 0, Line 297
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ETATY_OSOBY".
The conflict occurred in database "b_319130", table "dbo.osoby", column 'id_osoby'.
The statement has been terminated.*/

/*Próba usunięcia miasta, w którym znajdują się firmy lub osoby kończy się niepowodzeniem:*/
DELETE FROM miasta WHERE nazwa = N'Malbork'
/*Msg 547, Level 16, State 0, Line 305
The DELETE statement conflicted with the REFERENCE constraint "FK_OSOBY_MIASTA".
The conflict occurred in database "b_319130", table "dbo.osoby", column 'id_miasta'.
The statement has been terminated.*/

/*Próba usunięcia tabeli osoby (istnieje tabela etaty) kończy się niepowodzeniem:*/
DROP TABLE osoby
/*Msg 3726, Level 16, State 1, Line 312
Could not drop object 'osoby' because it is referenced by a FOREIGN KEY constraint.*/