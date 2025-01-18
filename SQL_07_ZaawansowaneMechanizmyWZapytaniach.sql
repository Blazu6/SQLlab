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
