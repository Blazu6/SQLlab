-- 1. Wyświetl informacje o zespołach, które nie zatrudniają pracowników. Rozwiązanie powinno
korzystać z podzapytania skorelowanego.
SELECT 
    ID_ZESP, NAZWA, ADRES
FROM 
    ZESPOLY Z
WHERE 
    (SELECT COUNT(*) 
     FROM PRACOWNICY P 
     WHERE P.ID_ZESP = Z.ID_ZESP) = 0;

-- 2. Wyświetl nazwiska, płace podstawowe i nazwy etatów pracowników zarabiających więcej niż
średnia pensja dla ich etatu. Wynik uporządkuj malejąco wg wartości płac podstawowych. Czy da się
ten problem rozwiązać podzapytaniem zwykłym (bez korelacji)? 
SELECT  
    NAZWISKO, PLACA_POD, ETAT
FROM    
    PRACOWNICY P
WHERE 
    PLACA_POD > (SELECT AVG(PLACA_POD)
                FROM PRACOWNICY
                WHERE ETAT = P.ETAT)

-- 3. Wyświetl nazwiska i pensje pracowników którzy zarabiają co najmniej 75% pensji swojego szefa.
Wynik uporządkuj wg nazwisk. 
SELECT  
    NAZWISKO, PLACA_POD
FROM 
    PRACOWNICY P
WHERE
    PLACA_POD > (SELECT 0.75*PLACA_POD
                FROM PRACOWNICY
                WHERE P.ID_SZEFA=ID_PRAC)

-- 4. Wyświetl nazwiska tych profesorów, którzy wśród swoich podwładnych nie mają żadnych
stażystów. Użyj podzapytania skorelowanego. 
SELECT 
    NAZWISKO
FROM 
    PRACOWNICY P
WHERE
    ETAT = 'PROFESOR' AND NOT EXISTS (SELECT * FROM PRACOWNICY
                                       WHERE  ID_SZEFA = P.ID_PRAC AND ETAT = 'STAZYSTA')

-- 5. Wyświetl zespół z najwyższą sumaryczną pensją wśród zespołów. Użyj tylko podzapytań w klauzuli
FROM: pierwsze ma znaleźć maksymalną sumaryczną płacę wśród zespołów (pojedyncza wartość),
drugie wyliczy sumę płac w każdym zespole (zbiór rekordów, struktura zbioru: identyfikator
zespołu, suma płac w zespole). Zapytanie główne ma wykonać dwa połączenia: pierwsze połączy
zbiory wynikowe obu podzapytań do znalezienia szukanego zespołu, drugie, z tabelą Zespoly,
uzupełni zbiór wynikowy o nazwę zespołu.
SELECT Z.NAZWA AS NAZWA, T1.SUMA_PLAC AS MAKS_SUMA_PLAC
FROM (
    SELECT MAX(SUMA_PLAC) AS MAKSYMALNA_SUMA_PLAC
    FROM (
        SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC
        FROM PRACOWNICY
        GROUP BY ID_ZESP
    )
) T2
JOIN (
    SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC
    FROM PRACOWNICY
    GROUP BY ID_ZESP
) T1
ON T1.SUMA_PLAC = T2.MAKSYMALNA_SUMA_PLAC
JOIN ZESPOLY Z
ON T1.ID_ZESP = Z.ID_ZESP;

SELECT Z.NAZWA AS NAZWA_ZESPOLU, S.SUMA_PLAC AS NAJWYZSZA_SUMA_PLAC
FROM (
    SELECT ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC
    FROM PRACOWNICY
    GROUP BY ID_ZESP
    HAVING SUM(PLACA_POD) = (
        SELECT MAX(SUMA_PLAC)
        FROM (
            SELECT SUM(PLACA_POD) AS SUMA_PLAC
            FROM PRACOWNICY
            GROUP BY ID_ZESP
        )
    )
) S
JOIN ZESPOLY Z
ON S.ID_ZESP = Z.ID_ZESP;


-- 6. Wyświetl nazwiska i pensje trzech najlepiej zarabiających pracowników. Uporządkuj ich zgodnie z
wartościami pensji w porządku malejącym. Zastosuj podzapytanie skorelowane. 
SELECT NAZWISKO, PLACA_POD
FROM PRACOWNICY P1
WHERE 3 > (
    SELECT COUNT(*)
    FROM PRACOWNICY P2
    WHERE P2.PLACA_POD > P1.PLACA_POD
)
ORDER BY PLACA_POD DESC;

-- 7. Dla każdego pracownika podaj jego nazwisko, płacę podstawową oraz różnicę między jego płacą
podstawową a średnią płacą podstawową w zespole, do którego pracownik należy. Zaproponuj dwa
rozwiązania, wykorzystujące: (1) podzapytanie w klauzuli SELECT (2) podzapytanie w klauzuli
FROM. 
SELECT 
    NAZWISKO, 
    PLACA_POD, 
    PLACA_POD - (
        SELECT AVG(PLACA_POD)
        FROM PRACOWNICY P2
        WHERE P2.ID_ZESP = P1.ID_ZESP
    ) AS ROZNICA
FROM PRACOWNICY P1;

SELECT 
    P2.NAZWISKO, 
    P2.PLACA_POD, 
    P2.PLACA_POD - P1.SREDNIA AS ROZNICA
FROM
    (SELECT ID_ZESP, AVG(PLACA_POD) AS SREDNIA
     FROM PRACOWNICY
     GROUP BY ID_ZESP) P1
JOIN
    PRACOWNICY P2 
ON 
    P1.ID_ZESP = P2.ID_ZESP
ORDER BY P2.NAZWISKO;

-- 8. Ogranicz poprzedni zbiór tylko do tych pracowników, którzy zarabiają więcej niż średnia w ich
zespole (czyli mających dodatnią wartość różnicy między ich płacą podstawową a średnią płacą w
ich zespole). Modyfikacji poddaj oba rozwiązania z poprzedniego punktu. 
SELECT 
    NAZWISKO, 
    PLACA_POD, 
    PLACA_POD - (
        SELECT AVG(PLACA_POD)
        FROM PRACOWNICY P2
        WHERE P2.ID_ZESP = P1.ID_ZESP
    ) AS ROZNICA
FROM PRACOWNICY P1
WHERE PLACA_POD - (
        SELECT AVG(PLACA_POD)
        FROM PRACOWNICY P2
        WHERE P2.ID_ZESP = P1.ID_ZESP
    ) > 0
ORDER BY NAZWISKO;

SELECT 
    P2.NAZWISKO, 
    P2.PLACA_POD, 
    P2.PLACA_POD - P1.SREDNIA AS ROZNICA
FROM
    (SELECT ID_ZESP, AVG(PLACA_POD) AS SREDNIA
     FROM PRACOWNICY
     GROUP BY ID_ZESP) P1
JOIN
    PRACOWNICY P2 
ON 
    P1.ID_ZESP = P2.ID_ZESP
WHERE
    P2.PLACA_POD - P1.SREDNIA > 0
ORDER BY P2.NAZWISKO;

-- 9. Wyświetl nazwiska profesorów, zatrudnionych na Piotrowie, wraz liczbą ich podwładnych. Wynik
uporządkuj wg liczby podwładnych w porządku malejącym. Zastosuj podzapytanie w klauzuli
SELECT. 
SELECT  
    NAZWISKO,
    (SELECT COUNT(*) FROM PRACOWNICY P WHERE P.ID_SZEFA=S.ID_PRAC) AS PODWLADNI
FROM
    PRACOWNICY S
JOIN
    ZESPOLY Z ON S.ID_ZESP=Z.ID_ZESP 
WHERE 
    ETAT = 'PROFESOR' AND ADRES='PIOTROWO 3A'

-- 10. . Dla każdego zespołu wylicz średnią płacę jego pracowników. Następnie porównaj średnią w zespole
z ogólną średnią płac i odpowiednio oznacz nastroje w zespole: umieść :) jeśli średnia w zespole jest
wyższa lub równa średniej ogólnej i :( w przeciwnym wypadku. Jeśli zespół nie ma pracowników,
nastrój oznacz jako nieokreślony używając ???.
SELECT  
    NAZWA, 
    (SELECT AVG(PLACA_POD) FROM PRACOWNICY P WHERE P.ID_ZESP = Z.ID_ZESP) AS SREDNIA_W_ZESPOLE,
    ROUND((SELECT AVG(PLACA_POD) FROM PRACOWNICY), 2) AS SREDNIA_OGOLNA,
    CASE 
        WHEN (SELECT AVG(PLACA_POD) FROM PRACOWNICY P WHERE P.ID_ZESP = Z.ID_ZESP)-ROUND((SELECT AVG(PLACA_POD) FROM PRACOWNICY), 2)>0 THEN ':)'
        WHEN (SELECT COUNT(*) FROM PRACOWNICY WHERE ID_ZESP=Z.ID_ZESP) = 0 THEN '???'
        ELSE ':('
    END AS NASTROJE
FROM 
    ZESPOLY Z
ORDER BY 
    NAZWA

-- 11.  Wyświetl wszystkie informacje o etatach z tabeli Etaty. Wynik zaprezentuj w porządku malejącym,
ustalonym przez liczbę pracowników, zatrudnionych na poszczególnych etatach. Jeśli na dwóch lub
więcej etatach pracowałoby tylu samo pracowników, uporządkuj etaty wg ich nazw. Posłuż się
podzapytaniem w klauzuli ORDER BY.
SELECT  
    NAZWA,  PLACA_MIN, PLACA_MAX
FROM
    ETATY E
ORDER BY
    (SELECT COUNT(*) FROM PRACOWNICY WHERE ETAT = E.NAZWA) DESC, NAZWA;

