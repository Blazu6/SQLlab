-- 1. Utwórz relację o nazwie PROJEKTY o następującej strukturze: 
CREATE TABLE PROJEKTY (
    ID_PROJEKTU NUMBER(4) GENERATED ALWAYS AS IDENTITY,
    OPIS_PROJEKTU VARCHAR2(20),
    DATA_ROZPOCZECIA DATE DEFAULT SYSDATE,
    DATA_ZAKONCZENIA DATE,
    FUNDUSZ NUMBER(7,2)
)

-- 2. Wstaw do relacji PROJEKTY dwa rekordy: 
INSERT INTO PROJEKTY (OPIS_PROJEKTU, DATA_ROZPOCZECIA, DATA_ZAKONCZENIA, FUNDUSZ)
VALUES ('INDESKY BITMAPOWE', '1990-04-02', '2001-08-31', 25000);

INSERT INTO PROJEKTY (OPIS_PROJEKTU, DATA_ZAKONCZENIA, FUNDUSZ)
VALUES ('SIECI KREGOSLUPOWE', NULL, 19000);

-- 3. Sprawdź, wykonując odpowiednie zapytanie, jakie wartości zostały umieszczone w
atrybucie ID_PROJEKTU relacji PROJEKTY w dodanych rekordach.
SELECT * FROM PROJEKTY
1 I 2


-- 4. Spróbuj wstawić do relacji PROJEKTY trzeci rekord, tym razem jawnie podaj wartość dla
SQL> insert into PROJEKTY...
Czy polecenie zakończyło się sukcesem? Jeśli nie, wykonaj je w taki sposób, aby
definicja projektu zakończyła się powodzeniem (pomiń podanie wartości dla
ID_PROJEKTU). 
INSERT INTO PROJEKTY (OPIS_PROJEKTU, DATA_ROZPOCZECIA, DATA_ZAKONCZENIA, FUNDUSZ)
VALUES ('INDEKSY DRZAWIASTE', '2013-12-24', '2014-01-01', 1200)

-- 5. Spróbuj zmienić aktualną wartość w atrybucie ID_PROJEKTU relacji PROJEKTY w
rekordzie opisującym projekt o nazwie „Indeksy drzewiaste” na wartość 10. Czy operacja
się powiodła?
UPDATE PROJEKTY 
SET ID_PROJEKTU = 10
WHERE OPIS_PROJEKTU = 'INDEKSY DRZEWIASTE'
NIE BO KOLUMNY GENERATED ALWAYS AS IDENTITY NIE MOZNA ZMIENIAC

-- 6. Utwórz kopię relacji PROJEKTY o nazwie PROJEKTY_KOPIA. Nowa relacja ma być
identyczna zarówno pod względem struktury i jak i danych z relacją PROJEKTY. Użyj
polecenia CREATE TABLE … AS SELECT …. Sprawdź zawartość nowo utworzonej
relacji
CREATE TABLE PROJEKTY_KOPIA AS SELECT * FROM PROJEKTY;


-- 7. Do relacji PROJEKTY_KOPIA dodaj nowy rekord
INSERT INTO PROJEKTY_KOPIA VALUES (10, 'SIECI LOKALNE', SYSDATE, SYSDATE + INTERVAL '1' YEAR, 24500)
MOZNA BO KOPIUJAC NIE KOPIUJEMY OGRANICZEN INTEGRALNOSCIOWYCH

-- 8. Usuń z relacji PROJEKTY rekord opisujący projekt o nazwie „Indeksy drzewiaste”. Czy
rekord, opisujący usunięty projekt, został również automatycznie usunięty z relacji
PROJEKTY_KOPIA? 
DELETE PROJEKTY
WHERE OPIS_PROJEKTU = 'INDEKSY DRZAWIASTE'
NIE TO DWA ODDZIELNE BYTY SA

