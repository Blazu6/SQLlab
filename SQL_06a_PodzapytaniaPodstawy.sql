-- 1. Wyświetl nazwiska i etaty pracowników pracujących w tym samym zespole co pracownik o
nazwisku Brzeziński. Wynik uporządkuj wg nazwisk pracowników. 
SELECT 
    NAZWISKO, ETAT, ID_ZESP
FROM 
    PRACOWNICY
WHERE 
    ID_ZESP = (SELECT ID_ZESP FROM PRACOWNICY WHERE NAZWISKO = 'BRZEZINSKI')
ORDER BY 
    NAZWISKO;

-- 2. Zmodyfikuj treść poprzedniego zapytania w taki sposób, aby zamiast identyfikatora zespołu pojawiła
się jego nazwa. 
SELECT 
    NAZWISKO, ETAT, NAZWA
FROM 
    PRACOWNICY P
JOIN 
    ZESPOLY Z ON P.ID_ZESP=Z.ID_ZESP
WHERE 
    P.ID_ZESP = (SELECT ID_ZESP FROM PRACOWNICY WHERE NAZWISKO = 'BRZEZINSKI')
ORDER BY 
    NAZWISKO;

-- 3. Wstaw „na chwilę” asystenta nieprzypisanego do żadnego zespołu, zatrudnionego 1 lipca 1968 r.
Osiągniesz to poniższym poleceniem:
INSERT INTO pracownicy(id_prac, nazwisko, etat, zatrudniony)
VALUES ((SELECT max(id_prac) + 1 FROM pracownicy),
 'WOLNY', 'ASYSTENT', DATE '1968-07-01');
Następnie wyświetl nazwisko, etat i datę zatrudnienia najdłużej zatrudnionego profesora. 
SELECT
    NAZWISKO, ETAT, ZATRUDNIONY
FROM    
    PRACOWNICY  
WHERE
    ZATRUDNIONY = (SELECT MIN(ZATRUDNIONY) FROM PRACOWNICY WHERE ETAT='PROFESOR') AND ETAT = 'PROFESOR'

-- 4. Wyświetl najkrócej pracujących pracowników każdego zespołu. Uszereguj wyniki zgodnie
z kolejnością zatrudnienia.
SELECT 
    NAZWISKO, ZATRUDNIONY, ID_ZESP
FROM 
    PRACOWNICY
WHERE   
    (ZATRUDNIONY, ID_ZESP) IN (SELECT 
                        MAX(ZATRUDNIONY), ID_ZESP 
                    FROM 
                        PRACOWNICY
                    GROUP BY
                        ID_ZESP
                    )
ORDER BY
    NAZWISKO

-- 5. Wyświetl informacje o zespołach, które nie zatrudniają pracowników
SELECT
    ID_ZESP, NAZWA, ADRES
FROM
    ZESPOLY
WHERE ID_ZESP NOT IN (SELECT ID_ZESP FROM PRACOWNICY WHERE ID_ZESP IS NOT NULL);

-- 6. Usuń dodanego w punkcie 3. pracownika poniższym poleceniem.
DELETE FROM pracownicy
WHERE nazwisko = 'WOLNY';
Wyświetl nazwiska tych profesorów, którzy wśród swoich podwładnych nie mają żadnych
stażystów. 
SELECT 
    NAZWISKO
FROM 
    PRACOWNICY
WHERE 
    ETAT = 'PROFESOR' AND ID_PRAC NOT IN (SELECT ID_SZEFA FROM PRACOWNICY WHERE ETAT = 'STAZYSTA' )

-- 7. Wyświetl numer zespołu wypłacającego miesięcznie swoim pracownikom najwięcej pieniędzy
SELECT  
    ID_ZESP, SUM(PLACA_POD) AS SUMA_PLAC
FROM 
    PRACOWNICY
GROUP BY
    ID_ZESP
HAVING
    SUM(PLACA_POD) = (SELECT
                        MAX(SUM(PLACA_POD)) 
                        FROM PRACOWNICY
                        GROUP BY ID_ZESP
                    )

-- 8. Zmodyfikuj poprzednie zapytanie w taki sposób, aby zamiast numeru zespołu wyświetlona została
jego nazwa. 
SELECT  
    NAZWA, SUM(PLACA_POD) AS SUMA_PLAC
FROM 
    ZESPOLY Z
JOIN
    PRACOWNICY P ON Z.ID_ZESP=P.ID_ZESP
GROUP BY
    P.ID_ZESP, NAZWA
HAVING
    SUM(PLACA_POD) = (SELECT
                        MAX(SUM(PLACA_POD)) 
                        FROM PRACOWNICY
                        GROUP BY ID_ZESP
                    )

-- 9. Znajdź zespoły zatrudniające więcej pracowników niż zespół ADMINISTRACJA. Wynik posortuj wg
nazw zespołów.
SELECT
    Z.NAZWA, COUNT(P.ID_PRAC) AS ILU_PRACOWNIKOW
FROM 
    ZESPOLY Z 
JOIN
    PRACOWNICY P ON  Z.ID_ZESP = P.ID_ZESP
GROUP BY
    Z.NAZWA
HAVING 
    COUNT(P.ID_PRAC) > (SELECT COUNT(P.ID_PRAC)
                        FROM PRACOWNICY P JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
                        WHERE Z.NAZWA = 'ADMINISTRACJA'
                        )

-- 10. Znajdź etat (etaty), który jest najliczniej reprezentowany w zbiorze pracowników. 
SELECT
    ETAT 
FROM
    PRACOWNICY
GROUP BY 
    ETAT
HAVING 
    COUNT(*) = (SELECT MAX(COUNT(*))
                FROM PRACOWNICY
                GROUP BY ETAT)
ORDER BY   
    ETAT

-- 11. Uzupełnij wynik poprzedniego zapytania o listę nazwisk pracowników na znalezionych etatach
SELECT
    ETAT, 
    LISTAGG(NAZWISKO || ',') WITHIN GROUP (ORDER BY NAZWISKO) AS PRACOWNICY
FROM
    PRACOWNICY
GROUP BY 
    ETAT
HAVING 
    COUNT(*) = (SELECT MAX(COUNT(*))
                FROM PRACOWNICY
                GROUP BY ETAT)
ORDER BY   
    ETAT

-- 12. Znajdź parę: pracownik – szef, dla której różnica między płacą pracownika a płacą jego szefa jest
najniższa. 
SELECT 
    P1.NAZWISKO AS PRACOWNIK, P2.NAZWISKO AS SZEF
FROM 
    PRACOWNICY P1
JOIN 
    PRACOWNICY P2
ON 
    P1.ID_SZEFA = P2.ID_PRAC
WHERE ABS(P1.PLACA_POD-P2.PLACA_POD) = (SELECT MIN(ABS(P1.PLACA_POD-P2.PLACA_POD))
                                        FROM PRACOWNICY P1
                                        JOIN PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC)
