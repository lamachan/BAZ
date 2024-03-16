/* Projekt na 3 zajęcia */
/* Weronika Zbierowska, nr indeksu: 319130, GR 5.*/
/* stworzyć udostępnianie rowerów (uproszczoną)
**
** Tabela Rower (model, id_roweru, stan_pocz, stan_dostepny - dom stan_pocz) z min modeli rowerów
** np. ('wigry3', 1, 35, 35) nalezy stworzyć trigger na INSERT ROWER, który przepisze
** stan_pocz do stan_dostepny - czyli kupilismy 35 sztuk danej puli rowerów i tyle na
** wstepie jest dostępnych
** Skorzystać z tabeli OSOBY którą macie
** Tabela WYP (id_osoby, id_roweru, data, id_wyp PK)
** Tabela ZWR (id_osoby, id_roweru, data, id_zwr PK (int not null IDENTITY))
** Napisać triggery aby:
** dodanie rekordow do WYP powodowalo aktualizację Rower (stan_dostepny)
** UWAGA zakladamy ze na raz mozna dodawac wiele rekordow
** w tym dla tej samej osoby, z tym samym id_roweru
*/
--CREATE TABLE #wyp(id_os int not null, id_roweru int not null)
--INSERT INTO #wyp (id_os, id_roweru) VALUES (1, 1), (1, 1), (2, 5)
/*
Zwrot zwiększa stan_dostepny
** UWAGA !!! Zrealizować TRIGERY na kasowanie z WYP lub ZWR
** Zrealizować TRIGGERY, ze nastapiła pomyłka czyli UPDATE na WYP lub ZWR
** Wydaje mi sie, ze mozna napisac po jednym triggerze na WYP lub ZWR na
** wszystkie akcje INSERT / UPDATE / DELETE
**
** Testowanie: stworzcie procedurę, która pokaze wszystkie rowery,
** model, stan_pocz, stan_dost + SUM(liczba) z ZWR - SUM(liczba) z WYP =>
** ISNULL(SUM(Liczba),0) te dwie kolumny powiny być równe
** po wielu dzialaniach w bazie
** dzialania typu kasowanie rejestrowac w tabeli skasowane
** (rodzaj (wyp/zwr), id_os, id_roweru)
** osobne triggery na DELETE z WYP i ZWR które będą rejestrować skasowania
** opisać pełną historie wyp i zwr (łaczniem z kasowaniem) i ze po wszystkim stan OK
*/

CREATE TABLE dbo.rowery
(
	model NVARCHAR(20) NOT NULL,
	id_roweru INT NOT NULL IDENTITY CONSTRAINT PK_ROWERY PRIMARY KEY,
	stan_pocz INT NOT NULL,
	stan_dostepny INT NOT NULL
)
GO
CREATE TABLE dbo.wyp
(
	id_osoby INT NOT NULL CONSTRAINT FK_WYP_OSOBY FOREIGN KEY REFERENCES osoby(id_osoby),
	id_roweru INT NOT NULL CONSTRAINT FK_WYP_ROWERY FOREIGN KEY REFERENCES rowery(id_roweru),
	data DATETIME NOT NULL,
	id_wyp INT NOT NULL IDENTITY CONSTRAINT PK_WYP PRIMARY KEY
)
GO
CREATE TABLE dbo.zwr
(
	id_osoby INT NOT NULL CONSTRAINT FK_ZWR_OSOBY FOREIGN KEY REFERENCES osoby(id_osoby),
	id_roweru INT NOT NULL CONSTRAINT FK_ZWR_ROWERY FOREIGN KEY REFERENCES rowery(id_roweru),
	data DATETIME NOT NULL,
	id_zwr INT NOT NULL IDENTITY CONSTRAINT PK_ZWR PRIMARY KEY
)
GO

CREATE TRIGGER dbo.TR_rowery_ins ON rowery FOR INSERT
AS
	IF UPDATE(stan_dostepny) AND EXISTS
	(
		SELECT 1
		FROM inserted i
		WHERE i.stan_dostepny <> i.stan_pocz
	)
		UPDATE rowery SET stan_dostepny = stan_pocz
		WHERE id_roweru IN
		(
			SELECT i.id_roweru
			FROM inserted i
			WHERE i.stan_dostepny <> i.stan_pocz
		)
GO

INSERT INTO rowery(model, stan_pocz, stan_dostepny) VALUES
	(N'Cross', 20, 15),
	(N'Wigry 3', 30, 12),
	(N'Amanda', 40, 40),
	(N'Piorun', 50, 10),
	(N'Gwardia X', 30, 30)

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          20
Wigry 3              2           30          30
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Trigger zadziałał poprawnie przy próbie wstawienia rekorów o stanie dostępnym różnym od początkowego.*/

GO
CREATE TRIGGER dbo.wyp_stan ON wyp FOR INSERT, UPDATE, DELETE
AS
	UPDATE rowery SET stan_dostepny = stan_dostepny - x.liczba
		FROM rowery r
			JOIN 
			(
				SELECT i.id_roweru,
					COUNT(*) AS liczba
				FROM inserted i
				GROUP BY i.id_roweru
			) x ON (r.id_roweru = x.id_roweru)

	UPDATE rowery SET stan_dostepny = stan_dostepny + x.liczba
		FROM rowery r
			JOIN
			(
				SELECT d.id_roweru,
					COUNT(*) AS liczba
				FROM deleted d
				GROUP BY d.id_roweru
			) x ON (r.id_roweru = x.id_roweru)

	IF EXISTS
	(
		SELECT 1
		FROM rowery r
		WHERE r.stan_dostepny < 0
	)
	BEGIN
		RAISERROR(N'Nie można wypożyczyć więcej rowerów niż są dostępne!', 16, 3)
		ROLLBACK TRAN
	END
GO

GO
CREATE TRIGGER dbo.zwr_stan ON zwr FOR INSERT, UPDATE, DELETE
AS
	UPDATE rowery SET stan_dostepny = stan_dostepny + x.liczba
		FROM rowery r
			JOIN 
			(
				SELECT i.id_roweru,
					COUNT(*) AS liczba
				FROM inserted i
				GROUP BY i.id_roweru
			) x ON (r.id_roweru = x.id_roweru)

	UPDATE rowery SET stan_dostepny = stan_dostepny - x.liczba
		FROM rowery r
			JOIN
			(
				SELECT d.id_roweru,
					COUNT(*) AS liczba
				FROM deleted d
				GROUP BY d.id_roweru
			) x ON (r.id_roweru = x.id_roweru)

	IF EXISTS
	(
		SELECT 1
		FROM rowery r
		WHERE r.stan_dostepny > r.stan_pocz
	)
	BEGIN
		RAISERROR(N'Nie można zwrócić więcej rowerów niż istnieją!', 16, 3)
		ROLLBACK TRAN
	END
GO

CREATE TABLE dbo.skasowane
(
	rodzaj NCHAR(3) NOT NULL,
	id_osoby INT NOT NULL CONSTRAINT FK_SKASOWANE_OSOBY FOREIGN KEY REFERENCES osoby(id_osoby),
	id_roweru INT NOT NULL CONSTRAINT FK_SKASOWANE_ROWERY FOREIGN KEY REFERENCES rowery(id_roweru)
)
GO

CREATE TRIGGER dbo.TR_skasowane_wyp ON wyp FOR DELETE
AS
	INSERT INTO skasowane(rodzaj, id_osoby, id_roweru)
	(
		SELECT N'wyp',
			d.id_osoby,
			d.id_roweru
		FROM deleted d
	)
GO

CREATE TRIGGER dbo.TR_skasowan_zwr ON zwr FOR DELETE
AS
	INSERT INTO skasowane(rodzaj, id_osoby, id_roweru)
	(
		SELECT N'zwr',
			d.id_osoby,
			d.id_roweru
		FROM deleted d
	)
GO

ALTER PROCEDURE dbo.P_rowery_test
AS
	SELECT r.model,
		r.stan_pocz,
		r.stan_dostepny - ISNULL(z.liczba, 0) + ISNULL(w.liczba, 0) AS suma
	FROM rowery r
		LEFT OUTER JOIN
		(
			SELECT z.id_roweru,
				COUNT(*) AS liczba
			FROM zwr z
			GROUP BY z.id_roweru
		) z ON (r.id_roweru = z.id_roweru)
		LEFT OUTER JOIN
		(
			SELECT w.id_roweru,
				COUNT(*) AS liczba
			FROM wyp w
			GROUP BY w.id_roweru
		) w ON (r.id_roweru = w.id_roweru)
GO

/*TESTOWANIE*/
/*DODANIE WYPOŻYCZEŃ*/
INSERT INTO wyp VALUES
	(1, 1, GETDATE()),
	(2, 1, GETDATE()),
	(2, 2, GETDATE())

SELECT * FROM wyp
/*
id_osoby    id_roweru   data                    id_wyp
----------- ----------- ----------------------- -----------
1           1           2022-05-23 11:31:58.090 1
2           1           2022-05-23 11:31:58.090 2
2           2           2022-05-23 11:31:58.090 3

(3 rows affected)

Wypożyczenia zostały zarejestrowane poprawnie.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          18
Wigry 3              2           30          29
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępności rowerów zmienił się poprawnie (-2 rowery Cross, -1 rower Wigry 3).*/

/*DODANIE ZWROTÓW*/
INSERT INTO zwr VALUES
	(1, 1, GETDATE()),
	(2, 2, GETDATE())

SELECT * FROM zwr
/*
id_osoby    id_roweru   data                    id_zwr
----------- ----------- ----------------------- -----------
1           1           2022-05-23 11:32:32.253 1
2           2           2022-05-23 11:32:32.253 2

(2 rows affected)

Zwroty zostały zarejestrowane poprawnie.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          19
Wigry 3              2           30          30
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępności rowerów zmienił się poprawnie (+1 rower Cross, +1 rower Wigry 3).*/

/*AKTUALIZACJA WYPOŻYCZEŃ*/
UPDATE wyp SET id_roweru = 3 WHERE id_wyp = 2

SELECT * FROM wyp
/*
id_osoby    id_roweru   data                    id_wyp
----------- ----------- ----------------------- -----------
1           1           2022-05-23 11:31:58.090 1
2           3           2022-05-23 11:31:58.090 2
2           2           2022-05-23 11:31:58.090 3

(3 rows affected)

Wypożyczenie o id_wyp = 2 zostało zaktualizowane poprawnie.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          20
Wigry 3              2           30          30
Amanda               3           40          39
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępny zaktualizował się poprawnie (+1 rower Cross, -1 rower Amanda).*/

/*AKTUALIZACJA ZWROTÓW*/
UPDATE zwr SET id_roweru = 3 WHERE id_zwr = 2

SELECT * FROM zwr
/*
id_osoby    id_roweru   data                    id_zwr
----------- ----------- ----------------------- -----------
1           1           2022-05-23 11:32:32.253 1
2           3           2022-05-23 11:32:32.253 2

(2 rows affected)

Zwrot o id_zwr = 2 został zaktualizowany poprawnie.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          20
Wigry 3              2           30          29
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępny zaktualizował się poprawnie (+1 rower Amanda, -1 rower Wigry 3).*/

/*USUWANIE WYPOŻYCZEŃ*/
DELETE FROM wyp WHERE id_wyp = 3

SELECT * FROM wyp
/*
id_osoby    id_roweru   data                    id_wyp
----------- ----------- ----------------------- -----------
1           1           2022-05-23 11:31:58.090 1
2           3           2022-05-23 11:31:58.090 2

(2 rows affected)

Wypożyczenie o id_wyp = 3 zostało poprawnie usunięte.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          20
Wigry 3              2           30          30
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępny zaktualizował się poprawnie (+1 rower Wigry 3).*/

SELECT * FROM skasowane
/*
rodzaj id_osoby    id_roweru
------ ----------- -----------
wyp    2           2

(1 row affected)

Skasowane wypożyczenie zapisało się poprawnie.*/

/*USUWANIE ZWROTÓW*/
DELETE FROM zwr WHERE id_zwr = 1

SELECT * FROM zwr
/*
id_osoby    id_roweru   data                    id_zwr
----------- ----------- ----------------------- -----------
2           3           2022-05-23 11:32:32.253 2

(1 row affected)

Zwrot o id_zwr = 1 został1 poprawnie usunięty.*/

SELECT * FROM rowery
/*
model                id_roweru   stan_pocz   stan_dostepny
-------------------- ----------- ----------- -------------
Cross                1           20          19
Wigry 3              2           30          30
Amanda               3           40          40
Piorun               4           50          50
Gwardia X            5           30          30

(5 rows affected)

Stan dostępny zaktualizował się poprawnie (-1 rower Cross).*/

SELECT * FROM skasowane
/*
rodzaj id_osoby    id_roweru
------ ----------- -----------
wyp    2           2
zwr    1           1

(2 rows affected)

Skasowany zwrot zapisał się poprawnie.*/

/*STAN KOŃCOWY*/
EXEC P_rowery_test
/*
model                stan_pocz   suma
-------------------- ----------- -----------
Cross                20          20
Wigry 3              30          30
Amanda               40          40
Piorun               50          50
Gwardia X            30          30

(5 rows affected)

Suma rowerów po wielu operacjach w bazie zgadza się ze stanem początkowym.*/