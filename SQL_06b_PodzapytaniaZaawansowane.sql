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

