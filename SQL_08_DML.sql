-- 1. Wstaw do relacji PRACOWNICY trzy nowe rekordy:
INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, PLACA_DOD, ID_ZESP)
VALUES (250, 'KOWALSKI', 'ASYSTENT', NULL, TO_DATE('2015-01-13', 'YYYY-MM-DD'), 1500, NULL, 10);

INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, PLACA_DOD, ID_ZESP)
VALUES (260, 'ADAMSKI', 'ASYSTENT', NULL, TO_DATE('2014-09-10', 'YYYY-MM-DD'), 1500, NULL, 10);

INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, PLACA_DOD, ID_ZESP)
VALUES (270, 'NOWAK', 'ADIUNKT', NULL, TO_DATE('1990-05-01', 'YYYY-MM-DD'), 2050, 540, 20);

-- 2.  Dodanym w p. 1. pracownikom zwiększ płacę podstawową o 10% a dodatkową o 20%
(jeśli pracownik nie miał do tej pory płacy dodatkowej, ustaw ją na wartość 100). Użyj
tylko jednego polecenia! 
UPDATE PRACOWNICY 
SET PLACA_POD = PLACA_POD*1.1, PLACA_DOD = COALESCE(PLACA_DOD*1.2, 100)
WHERE ID_PRAC IN (250,260,270);

-- 3. Wstaw do relacji ZESPOLY rekord opisujący nowy zespół o nazwie BAZY DANYCH,
identyfikatorze równym 60 i lokalizacji PIOTROWO 2. 
INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES) VALUES (60 ,'BAZY DANYCH', 'PIOTROWO 2');

-- 4. Przenieś dodanych w punkcie 1. pracowników do zespołu BAZY DANYCH. W poleceniu
użyj podzapytania, które wyszuka w relacji ZESPOLY identyfikator zespołu BAZY
DANYCH (nie podawaj go wprost w poleceniu!) 
UPDATE PRACOWNICY
SET ID_ZESP = (SELECT ID_ZESP FROM ZESPOLY WHERE NAZWA='BAZY DANYCH')
WHERE ID_PRAC IN (250,260,270);

-- 5. Ustaw wszystkim pracownikom zespołu BAZY DANYCH pracownika o nazwisku
MORZY jako szefa (zapytanie, wyszukujące w relacji PRACOWNICY identyfikator
pracownika MORZY powinno być częścią polecenia UPDATE). 
  UPDATE PRACOWNICY 
SET ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY WHERE NAZWISKO = 'MORZY')
WHERE ID_ZESP = 60;

-- 6. Spróbuj usunąć z relacji ZESPOLY rekord opisujący zespół o nazwie BAZY DANYCH.
SQL> delete from ZESPOLY...
Czy polecenie zakończyło się sukcesem? Jeśli nie – dlaczego? 
NIE MOZNA USUNAC BO JEST TAM ID_ZESP KTORE JEST KLUCZEM OBCYM W TABELI PRACOWNICY

-- 7. Usuń wszystkich pracowników, którzy należą do zespołu BAZY DANYCH. Następnie
ponów operację usunięcia zespołu BAZY DANYCH. 
DELETE FROM PRACOWNICY WHERE ID_PRAC IN (250,260,270);
DELETE FROM ZESPOLY WHERE NAZWA = 'BAZY DANYCH';

SELECT * FROM PRACOWNICY;
SELECT * FROM ZESPOLY;

-- 8. Skonstruuj zapytanie, które dla każdego pracownika wyliczy kwotę podwyżki, jaką
dostanie. Podwyżka powinna być równa 10% średniej płacy podstawowej w zespole, do
którego należy pracownik.
SELECT 
    NAZWISKO, 
    PLACA_POD, 
    0.1 * (
        SELECT AVG(PLACA_POD) 
        FROM PRACOWNICY 
        WHERE ID_ZESP = P.ID_ZESP
    ) AS PODWYZKA
FROM PRACOWNICY P
ORDER BY NAZWISKO;

-- 9. Zrealizuj podwyżkę z poprzedniego punktu. 
UPDATE PRACOWNICY P
SET PLACA_POD = PLACA_POD + 0.1 *
    (
        SELECT AVG(PLACA_POD) 
        FROM PRACOWNICY 
        WHERE ID_ZESP = P.ID_ZESP
    ) 

-- 10. Wyświetl dane pracowników, którzy zarabiają najmniej. Weź pod uwagę tylko wartość
płacy podstawowej.
SELECT * FROM PRACOWNICY WHERE PLACA_POD = (SELECT MIN(PLACA_POD) FROM PRACOWNICY)

-- 11. Daj kolejną podwyżkę, tym razem tylko najmniej zarabiającym pracownikom. Ustaw im
płacę podstawową na wartość równą średniej płacy podstawowej wszystkich
pracowników (dokonaj zaokrąglenia wartości płacy do dwóch miejsc po przecinku). 
UPDATE PRACOWNICY 
SET PLACA_POD = (SELECT AVG(PLACA_POD) FROM PRACOWNICY)
WHERE PLACA_POD = (SELECT MIN(PLACA_POD) FROM PRACOWNICY)

-- 12. Uaktualnij płace dodatkowe pracowników zespołu 20. Nowe płace dodatkowe mają być
równe średniej płacy podstawowej pracowników, których przełożonym jest pracownik
MORZY.
UPDATE PRACOWNICY
SET PLACA_DOD = (SELECT AVG(PLACA_POD) FROM PRACOWNICY WHERE ID_SZEFA = (SELECT ID_PRAC FROM PRACOWNICY WHERE NAZWISKO = 'MORZY'))
WHERE ID_ZESP=20

-- 13. Pracownikom zespołu o nazwie SYSTEMY ROZPROSZONE daj 25% podwyżkę (płaca
podstawowa). Tym razem zastosuj modyfikację operacji połączenia. 
UPDATE (
    SELECT PLACA_POD FROM PRACOWNICY P JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP WHERE NAZWA = 'SYSTEMY ROZPROSZONE'
)
SET PLACA_POD = PLACA_POD *1.25

-- 14. Usuń bezpośrednich podwładnych pracownika o nazwisku MORZY. Zastosuj usuwanie
krotek z wyniku połączenia relacji.
DELETE FROM (
    SELECT P.NAZWISKO AS PRACOWNIK FROM PRACOWNICY P JOIN PRACOWNICY S ON P.ID_SZEFA = S.ID_PRAC WHERE S.NAZWISKO = 'MORZY'
)

-- 15. Utwórz sekwencję o nazwie PRAC_SEQ, rozpoczynającą generację wartości od 300 z
krokiem 10. Sekwencja będzie używana do generacji wartości dla atrybutu ID_PRAC
relacji PRACOWNICY w nowo definiowanych rekordach. 
  CREATE SEQUENCE PRAC_SEQ START WITH 300 INCREMENT BY 10;

-- 16.  Wykorzystaj utworzoną sekwencję do wstawienia nowego stażysty o nazwisku
Trąbczyński i płacy równej 1000 do relacji Pracownicy. 
INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, PLACA_POD) VALUES 
(PRAC_SEQ.nextval, 'TRABCZYNSKI', 'STAZYSTA', 1000)

-- 17.  Wykorzystaj utworzoną sekwencję do wstawienia nowego stażysty o nazwisku
Trąbczyński i płacy równej 1000 do relacji Pracownicy. 
UPDATE PRACOWNICY
SET PLACA_DOD = PRAC_SEQ.CURRVAL
WHERE NAZWISKO = 'TRABCZYNSKI'

-- 18. Usuń pracownika o nazwisku Trąbczyński
DELETE FROM PRACOWNICY WHERE NAZWISKO = 'TRABCZYNSKI'

-- 19. Utwórz nową sekwencję MALA_SEQ o niskiej wartości maksymalnej (np. 10).
Zaobserwuj, co się dzieje, gdy następuje przekroczenie wartości maksymalnej sekwencji.
  CREATE SEQUENCE MALA_SEQ START WITH 1 INCREMENT BY 1 MAXVALUE 10;
DO 10 SIE WYWOLUJE POTEM BLAD BO OSIAGNELA SWOJE MAKSIMUM MOZNA ZASTOSOWAC CYCLE TO WTEDY GDY OSOGNIE 10 TO ZACZYNA OD NOWA LICZYC
