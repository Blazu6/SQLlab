-- 1. Wstaw „na chwilę” pracownika nieprzypisanego do żadnego zespołu. Osiągniesz to poniższym
poleceniem:
INSERT INTO pracownicy(id_prac, nazwisko)
VALUES ((SELECT max(id_prac) + 1 FROM pracownicy), 'WOLNY');
Następnie skonstruuj zapytanie, które wyświetli nazwiska, numery zespołów i nazwy zespołów
wszystkich pracowników. W zbiorze wynikowym mają pojawić się również pracownicy, którzy nie
należą do żadnego zespołu. Wynik uporządkuj wg nazwisk pracowników. 
SELECT
    NAZWISKO, P.ID_ZESP, NAZWA 
FROM    
    PRACOWNICY P LEFT JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP
ORDER BY
    NAZWISKO;

-- 2. Tym razem wyświetl nazwy wszystkich zespołów. Jeśli w zespole pracują pracownicy, wyświetl ich
nazwiska. Dla zespołów, które nie mają pracowników, wyświetl tekst „brak pracowników”.
Uporządkuj wynik według nazw zespołów i nazwisk pracowników.
SELECT 
    Z.NAZWA, 
    Z.ID_ZESP, 
    CASE
        WHEN P.NAZWISKO IS NULL THEN 'BRAK PRACOWNIKOW'
        ELSE P.NAZWISKO
    END AS PRACOWNIK
FROM 
    ZESPOLY Z
LEFT JOIN 
    PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
ORDER BY 
    Z.NAZWA, 
    P.NAZWISKO;

-- 3. Połącz wyniki dwóch poprzednich zapytań w jeden wynik. Dla pracowników pracujących w
zespołach wyświetl nazwisko pracownika i nazwę zespołu. Dla pracowników bez zespołów wyświetl
w miejscu nazwy zespołu tekst „brak zespołu”. Dla zespołów, które nie mają pracowników, wyświetl
tekst „brak pracowników”. Uporządkuj wynik według nazw zespołów i nazwisk pracowników.
Nazwiska pracowników bez zespołów powinny znaleźć się na końcu raportu, posortowane
w porządku rosnącym. 
SELECT  
    COALESCE(NAZWA, 'BRAK ZESPOLU') AS ZESPOL, COALESCE(NAZWISKO, 'BRAK PRACOWNIKOW') AS PRACOWNIK
FROM
    ZESPOLY Z 
FULL JOIN 
    PRACOWNICY P ON Z.ID_ZESP=P.ID_ZESP
ORDER BY
    NAZWA NULLS LAST, NAZWISKO;

-- 4. Dla każdego zespołu znajdź liczbę pracowników, których zatrudnia oraz sumę ich płac. W zbiorze
wynikowym uwzględnij również zespoły bez pracowników. 
SELECT  
    NAZWA AS ZESPOL, COUNT(ID_PRAC), SUM(PLACA_POD)
FROM 
    ZESPOLY Z
LEFT JOIN 
    PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY 
    NAZWA
ORDER BY
    NAZWA

-- 5. Wyświetl nazwy zespołów, które nie zatrudniają pracowników. Wynik posortuj wg nazw zespołów. 
SELECT  
    NAZWA AS ZESPOL
FROM 
    ZESPOLY Z
LEFT JOIN 
    PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
GROUP BY 
    NAZWA
HAVING 
    COUNT(ID_PRAC) = 0
ORDER BY
    NAZWA

SELECT 
    Z.NAZWA AS ZESPOL
FROM 
    ZESPOLY Z
LEFT JOIN 
    PRACOWNICY P ON Z.ID_ZESP = P.ID_ZESP
WHERE 
    P.ID_ZESP IS NULL
ORDER BY 
    Z.NAZWA;

-- 6. Wyświetl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów. Wynik
posortuj wg nazwisk pracowników. W zbiorze wynikowym mają się pojawić również ci pracownicy,
którzy nie mają szefów.
SELECT 
    P1.NAZWISKO AS PRACOWNIK, P1.ID_PRAC, P2.NAZWISKO AS SZEF, P2.ID_PRAC AS ID_SZEFA
FROM 
    PRACOWNICY P1
LEFT JOIN
    PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
ORDER BY
    PRACOWNIK;

-- 7. Dla każdego pracownika wyświetl liczbę jego bezpośrednich podwładnych. 
SELECT 
    P2.NAZWISKO AS PRACOWNIK, COUNT(P1.ID_PRAC) AS LICZBA_PODWLADNYCH
FROM 
    PRACOWNICY P1
RIGHT JOIN
    PRACOWNICY P2 ON P1.ID_SZEFA = P2.ID_PRAC
GROUP BY 
    P2.NAZWISKO
ORDER BY
    PRACOWNIK;

SELECT 
    P.NAZWISKO AS PRACOWNIK,
    COUNT(POD.ID_PRAC) AS LICZBA_PODWLADNYCH
FROM 
    PRACOWNICY P
LEFT JOIN 
    PRACOWNICY POD ON P.ID_PRAC = POD.ID_SZEFA
GROUP BY 
    P.NAZWISKO
ORDER BY 
    P.NAZWISKO;

-- 8. Wyświetl następujące informacje o każdym pracowniku: nazwisko, etat, płaca podstawowa, nazwa
zespołu, do którego należy oraz nazwisko szefa. Wynik uporządkuj wg nazwisk pracowników. Weź
pod uwagę, że pracownik może nie mieć szefa i może nie być zatrudniony w żadnym zespole.
SELECT
    P.NAZWISKO, P.ETAT, P.PLACA_POD, Z.NAZWA, S.NAZWISKO AS SZEF
FROM 
    PRACOWNICY P
LEFT JOIN 
    PRACOWNICY S ON P.ID_SZEFA = S.ID_PRAC
JOIN
    ZESPOLY Z ON P.ID_ZESP=Z.ID_ZESP
ORDER BY 
    P.NAZWISKO

-- 9. Wygeneruj iloczyn kartezjański relacji Pracownicy i Zespoly. W zbiorze wynikowym umieść jedynie
wartości kolumn nazwisko i nazwa.
SELECT 
    NAZWISKO, NAZWA
FROM
    PRACOWNICY P
CROSS JOIN
    ZESPOLY Z
ORDER BY
    NAZWISKO, NAZWA;

-- 10. Policz, ile rekordów będzie zawierał iloczyn kartezjański trzech relacji: Etaty, Pracownicy i Zespoły
SELECT 
    COUNT(*)
FROM
    PRACOWNICY
CROSS JOIN
    ZESPOLY
CROSS JOIN
    ETATY

-- 11. Wyświetl nazwy etatów, na które przyjęto pracowników zarówno w 1992 jak i 1993 roku. Wynik
posortuj wg nazw etatów. 
SELECT
    ETAT
FROM 
    PRACOWNICY 
WHERE 
    EXTRACT(YEAR FROM ZATRUDNIONY) = 1992
INTERSECT
SELECT
    ETAT
FROM 
    PRACOWNICY 
WHERE 
    EXTRACT(YEAR FROM ZATRUDNIONY) = 1993
ORDER BY
    ETAT;

-- 12. Wyświetl numer zespołu który nie zatrudnia żadnych pracowników. WYBIERAMY WSZYSTKIE ID Z TABELI ZESPOLY CZYLI WSZYSTKIE ZEPSPOLY
A POTEM Z TABELI PRACOWNICY GDZIE MAMY PRZYPISANYCH PRACOWNIKOW DO ZESPOLOW WYBIERAMY TE ID_ZESP. JESLI NIE MA PRACOWNIKOW 
TO ID_ZESP Z TABELI PRACOWNICY NIE ZSOTANIE WYBRANE A EXTRACT DZIALA JAK (-) ZESPOLY.ID_ZESP - PRACOWNICY.ID_ZESP W ZBIORACH OF COURSE
SELECT ID_ZESP
FROM ZESPOLY
EXCEPT
SELECT ID_ZESP
FROM PRACOWNICY;

-- 13. Zmień powyższe zapytanie w taki sposób, aby oprócz numeru poznać również nazwę zespołu bez
pracowników
SELECT Z.ID_ZESP, Z.NAZWA
FROM ZESPOLY Z
EXCEPT
SELECT P.ID_ZESP, Z.NAZWA
FROM PRACOWNICY P
JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP;

-- 14. Wyświetl poniższy raport. Nie używaj wyrażenia CASE. 


