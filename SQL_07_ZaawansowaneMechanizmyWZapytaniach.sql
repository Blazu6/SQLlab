-- 1. Napisz zapytanie, które wyświetli nazwiska i pensje trzech najlepiej zarabiających
pracowników (ustalając ranking weź pod uwagę wartości płac podstawowych
pracowników). Zadanie rozwiąż:
 używając konstrukcji FETCH FIRST,
 używając podzapytania z pseudokolumną ROWNUM (jeśli pracujesz w OracleDB). 
SELECT 
    NAZWISKO, PLACA_POD
FROM 
    PRACOWNICY
ORDER BY 
    PLACA_POD DESC, NAZWISKO
FETCH FIRST 3 ROWS ONLY;
SELECT 
    ROWNUM,NAZWISKO, PLACA_POD
FROM 
    (SELECT NAZWISKO, PLACA_POD
    FROM PRACOWNICY
    ORDER BY PLACA_POD DESC)
WHERE ROWNUM <= 3

-- 2. Napisz zapytanie, które wyświetli „drugą piątkę” (od pozycji 6. do 10.) pracowników
zgodnie z ich zarobkami (płacami podstawowymi). Zadanie rozwiąż:
 używając konstrukcji OFFSET,
 używając podzapytań z pseudokolumną ROWNUM (jeśli pracujesz w OracleDB). 
SELECT 
    NAZWISKO, PLACA_POD
FROM 
   PRACOWNICY
ORDER BY 
    PLACA_POD DESC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS WITH TIES
SELECT NAZWISKO, PLACA_POD
FROM (
    SELECT NAZWISKO, PLACA_POD, ROWNUM AS RN
    FROM PRACOWNICY
    ORDER BY PLACA_POD DESC
)
WHERE RN > 5 AND RN <= 10;
 
-- 3. Dla każdego pracownika podaj jego nazwisko, płacę podstawową oraz różnicę między
jego płacą podstawową a średnią płacą podstawową w zespole, do którego pracownik
należy Ogranicz zbiór tylko do tych pracowników, którzy zarabiają więcej niż średnia w
ich zespole (czyli mających dodatnią wartość różnicy między ich płacą podstawową a
średnią płacą w ich zespole). Użyj klauzuli WITH do definicji zbioru, wyliczającego
średnie płace w poszczególnych zespołach. 
WITH SREDNIA AS 
    (SELECT AVG(PLACA_POD) AS SRE, ID_ZESP FROM PRACOWNICY GROUP BY ID_ZESP)
SELECT
    NAZWISKO, PLACA_POD, PLACA_POD-S.SRE AS ROZNICA
FROM 
    PRACOWNICY P
JOIN 
    SREDNIA S ON P.ID_ZESP=S.ID_ZESP
WHERE
    PLACA_POD-S.SRE > 0
ORDER BY 
    NAZWISKO;

-- 4. Wyświetl dla każdego roku liczbę zatrudnionych w nim pracowników. Wynik uporządkuj
zgodnie z malejącą liczbą zatrudnionych. Użyj klauzuli WITH do zdefiniowania zbioru o
nazwie Lata, pokazującego dla każdego roku liczbę zatrudnionych w nim pracowników.
WITH LATA AS (
    SELECT EXTRACT(YEAR FROM ZATRUDNIONY) AS ROK, COUNT(*) AS LICZBA FROM PRACOWNICY GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY)
)
SELECT ROK, LICZBA FROM LATA ORDER BY LICZBA DESC;

-- 5. Dodaj do powyższego zapytania dodatkowy warunek, który spowoduje, że zostanie
wyświetlony tylko ten rok, w którym przyjęto najwięcej pracowników. Posłuż się
ponownie zbiorem Lata. 
WITH LATA AS (
    SELECT EXTRACT(YEAR FROM ZATRUDNIONY) AS ROK, COUNT(*) AS LICZBA FROM PRACOWNICY GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY)
)
SELECT ROK, LICZBA FROM LATA ORDER BY LICZBA DESC FETCH FIRST ROW WITH TIES;
WITH LATA AS (
    SELECT EXTRACT(YEAR FROM ZATRUDNIONY) AS ROK, COUNT(*) AS LICZBA
    FROM PRACOWNICY
    GROUP BY EXTRACT(YEAR FROM ZATRUDNIONY)
)
SELECT ROK, LICZBA
FROM LATA
WHERE LICZBA = (SELECT MAX(LICZBA) FROM LATA);

-- 6. Wyświetl informacje o asystentach pracujących na Piotrowie. Zastosuj klauzulę WITH,
zdefiniuj przy jej pomocy dwa zbiory: Asystenci i Piotrowo, następnie użyj tych zbiorów
w zapytaniu wykonując na nich operację połączenia.
WITH ASYSTENCI AS (
    SELECT ID_ZESP, NAZWISKO, ETAT FROM PRACOWNICY WHERE ETAT = 'ASYSTENT'
),
PIOTROWO AS (
    SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY WHERE ADRES LIKE 'PIOTROWO%'
)
SELECT NAZWISKO, ETAT, NAZWA, ADRES FROM ASYSTENCI A JOIN PIOTROWO P ON A.ID_ZESP=P.ID_ZESP

-- 7.  Używając klauzuli WITH ponownie znajdź dane zespołu, wypłacającego sumarycznie
najwięcej swoim pracownikom.
WITH ZESPOL AS (
    SELECT NAZWA, SUM(PLACA_POD) AS SUMA_PLAC FROM ZESPOLY Z JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP GROUP BY NAZWA ORDER BY SUM(PLACA_POD) DESC
)
SELECT NAZWA, SUMA_PLAC FROM ZESPOL FETCH FIRST ROW ONLY
WITH SUMA_PLAC_ZESPOL AS (
    SELECT NAZWA, SUM(PLACA_POD) AS SUMA_PLAC
    FROM ZESPOLY Z JOIN PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
    GROUP BY NAZWA
)
SELECT NAZWA, SUMA_PLAC
FROM SUMA_PLAC_ZESPOL
WHERE SUMA_PLAC = (SELECT MAX(SUMA_PLAC) FROM SUMA_PLAC_ZESPOL);

-- 8. Wyświetl hierarchię szef-podwładny rozpoczynając od pracownika-szefa o nazwisku
BRZEZINSKI. Zadanie rozwiąż dwoma sposobami:
 używając zapytań hierarchicznych z rekurencyjną klauzulą WITH,
 używając zapytań hierarchicznych w składni Oracle (jeśli pracujesz w OracleDB)
WITH    
    PODWLADNI(ID_PRAC, ID_SZEFA, NAZWISKO, POZIOM) AS (
        SELECT ID_PRAC, ID_SZEFA, NAZWISKO, 1 AS POZIOM
        FROM PRACOWNICY
        WHERE NAZWISKO = 'BRZEZINSKI'
        
        UNION ALL
        
        SELECT P.ID_PRAC, P.ID_SZEFA, P.NAZWISKO, H.POZIOM + 1
        FROM PRACOWNICY P
        JOIN PODWLADNI H ON P.ID_SZEFA = H.ID_PRAC
    )
    SEARCH DEPTH FIRST BY NAZWISKO SET PORZADEK_POTOMKOW
SELECT NAZWISKO, POZIOM
FROM PODWLADNI
ORDER BY PORZADEK_POTOMKOW;
SELECT nazwisko, LEVEL AS poziom 
FROM pracownicy
CONNECT BY id_szefa = PRIOR id_prac
START WITH nazwisko = 'BRZEZINSKI'
ORDER SIBLINGS BY nazwisko;

-- 9. Przerób zapytania z poprzedniego punktu, aby uzyskać efekt wcięcia przed nazwiskami,
zależnego od pozycji pracownika w hierarchii. Aby zobaczyć wcięcia, wynik zapytania
wyświetl w postaci tekstowej.
SELECT 
    LPAD(NAZWISKO, LEVEL + LENGTH(NAZWISKO), ' ') AS NAZWISKO_Z_WCIECIEM,
    LEVEL AS POZIOM
FROM 
    PRACOWNICY
CONNECT BY 
    PRIOR ID_PRAC = ID_SZEFA
START WITH 
    NAZWISKO = 'BRZEZINSKI'
ORDER SIBLINGS BY 
    NAZWISKO;

-- 10. Zbuduj zapytanie, w którym podasz, ile pełnych tysięcy zarabia dany pracownik (do
wyliczeń weź sumę płacy podstawowej i dodatkowej). Użyj generatora rekordów do
zbudowania odwzorowania „cyfra-nazwa” (nie używaj CASE!), połącz zbiór danych z
generatora z danymi tabeli Pracownicy. 
WITH CYFRA AS (
    SELECT 0 AS CYFRA, 'zero' AS NAZWA FROM DUAL
    UNION ALL
    SELECT 1, 'jeden' FROM DUAL
    UNION ALL
    SELECT 2, 'dwa' FROM DUAL
),
ZAROBKI AS (
    SELECT NAZWISKO, FLOOR((PLACA_POD + COALESCE(PLACA_DOD, 0)) / 1000) AS TYSIACE
    FROM PRACOWNICY
)
SELECT 
    Z.NAZWISKO || ', zarobki w tysiącach: ' || C.NAZWA AS ZAROBKI
FROM 
    ZAROBKI Z
JOIN 
    CYFRA C ON Z.TYSIACE = C.CYFRA
ORDER BY 
    Z.NAZWISKO;
