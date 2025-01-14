-- 1. Wyświetl najniższą i najwyższą pensję w firmie. Wyświetl informację o różnicy dzielącej najlepiej i najgorzej
zarabiających pracowników.
SELECT MIN(PLACA_POD) AS MINIMUM, MAX(PLACA_POD) AS MAKSIMUM, MAX(PLACA_POD)-MIN(PLACA_POD) AS ROZNICA FROM PRACOWNICY;

-- 2. Wyświetl średnie pensje dla wszystkich etatów. Wyniki uporządkuj wg malejącej średniej pensji.
SELECT ETAT, AVG(PLACA_POD) AS SREDNIA FROM PRACOWNICY GROUP BY ETAT ORDER BY SREDNIA DESC

-- 3. Wyświetl liczbę profesorów zatrudnionych w Instytucie
SELECT COUNT(*) AS PROFESOROWIE FROM PRACOWNICY WHERE ETAT='PROFESOR' 
SELECT COUNT(*) AS PROFESOROWIE FROM PRACOWNICY GROUP BY ETAT HAVING ETAT='PROFESOR' 

-- 4. Znajdź sumaryczne miesięczne płace dla każdego zespołu. Nie zapomnij o płacach dodatkowych.
SELECT ID_ZESP, SUM(PLACA_POD+COALESCE(PLACA_DOD, 0)) FROM PRACOWNICY GROUP BY ID_ZESP ORDER BY ID_ZESP;

-- 5. Zmodyfikuj zapytanie z zadania poprzedniego w taki sposób, aby jego wynikiem była sumaryczna miesięczna płaca w
zespole, który wypłaca swoim pracownikom najwięcej pieniędzy.
SELECT MAX(SUM(PLACA_POD+COALESCE(PLACA_DOD, 0))) AS MAKS_SUM_PLACA FROM PRACOWNICY GROUP BY ID_ZESP ORDER BY ID_ZESP;

-- 6. Dla każdego pracownika, który posiada podwładnych, wyświetl pensję najgorzej zarabiającego podwładnego. Wyniki
uporządkuj wg malejącej pensji.
SELECT ID_SZEFA,  MIN(PLACA_POD) AS MINIMALNA FROM PRACOWNICY WHERE ID_SZEFA IS NOT NULL GROUP BY ID_SZEFA ORDER BY MINIMALNA DESC

-- 7. Wyświetl numery zespołów wraz z liczbą pracowników w każdym zespole. Wyniki uporządkuj wg malejącej liczby
pracowników.
SELECT ID_ZESP, COUNT(*) AS ILU_PRACUJE FROM PRACOWNICY GROUP BY ID_ZESP ORDER BY ILU_PRACUJE DESC

-- 8. Zmodyfikuj zapytanie z zadania poprzedniego, aby wyświetlić numery tylko tych zespołów, które zatrudniają więcej niż
3 pracowników.
SELECT ID_ZESP, COUNT(*) AS ILU_PRACUJE FROM PRACOWNICY GROUP BY ID_ZESP HAVING COUNT(*) > 3 ORDER BY ILU_PRACUJE DESC

-- 9. Sprawdź, czy identyfikatory pracowników są unikalne. Wyświetl zdublowane wartości identyfikatorów.
SELECT ID_PRAC FROM PRACOWNICY GROUP BY ID_PRAC HAVING COUNT(*) > 1

-- 10. Wyświetl średnie pensje wypłacane w ramach poszczególnych etatów i liczbę zatrudnionych na danym etacie. Pomiń
pracowników zatrudnionych po 1990 roku.
SELECT ETAT, AVG(PLACA_POD) AS SREDNIA, COUNT(*) AS LICZBA FROM PRACOWNICY WHERE ZATRUDNIONY < DATE '1990-12-31' GROUP BY ETAT

-- 11. Zbuduj zapytanie, które wyświetli średnie i maksymalne pensje asystentów i profesorów w poszczególnych zespołach
(weź pod uwagę zarówno płace podstawowe jak i dodatkowe). Dokonaj zaokrąglenia pensji do wartości całkowitych.
Wynik zapytania posortuj wg identyfikatorów zespołów i nazw etatów.
SELECT ID_ZESP, ETAT, 
    ROUND(AVG(PLACA_POD + COALESCE(PLACA_DOD, 0)), 0) AS SREDNIA, 
    ROUND(MAX(PLACA_POD + COALESCE(PLACA_DOD, 0)), 0) AS MAKSYMALNA 
FROM PRACOWNICY 
WHERE ETAT IN ('ASYSTENT', 'PROFESOR') 
GROUP BY ID_ZESP, ETAT 
ORDER BY ID_ZESP, ETAT;

-- 12. Zbuduj zapytanie, które wyświetli, ilu pracowników zostało zatrudnionych w poszczególnych latach. Wynik posortuj
rosnąco ze względu na rok zatrudnienia.
SELECT TO_CHAR(ZATRUDNIONY, 'YYYY') AS ROK, COUNT (*) AS ILU_PRACOWNIKOW FROM PRACOWNICY GROUP BY TO_CHAR(ZATRUDNIONY, 'YYYY') ORDER BY ROK

-- 13. Zbuduj zapytanie, które policzy liczbę liter w nazwiskach pracowników i wyświetli liczbę nazwisk z daną liczbą liter.
Wynik zapytania posortuj rosnąco wg liczby liter w nazwiskach.
SELECT LENGTH(NAZWISKO) AS ILE_LITER, COUNT(*) AS W_ILU_NAZWISKACH FROM PRACOWNICY GROUP BY LENGTH(NAZWISKO) ORDER BY ILE_LITER

-- 14. Zbuduj zapytanie, które wyliczy, ilu pracowników w swoim nazwisku posiada chociaż jedną literę „a” lub „A”. 
SELECT COUNT(*) AS ILE_NAZWISK_Z_A FROM PRACOWNICY WHERE INSTR(NAZWISKO, 'A', 1, 1) > 0 OR INSTR(NAZWISKO, 'A', 1, 1) > 0

-- 15. Zmień poprzednie zapytanie w taki sposób, aby oprócz kolumny, pokazującej ilu pracowników w swoim nazwisku
posiada chociaż jedną literę „a” lub „A”, pojawiła się kolumna pokazująca liczbę pracowników z chociaż jedną literą „e”
lub „E” w nazwisku.
SELECT 
    SUM(CASE WHEN INSTR(NAZWISKO, 'A', 1, 1) > 0 OR INSTR(NAZWISKO, 'a', 1, 1) > 0 THEN 1 END) AS ILE_NAZWISK_Z_A,
    SUM(CASE WHEN INSTR(NAZWISKO, 'E', 1, 1) > 0 OR INSTR(NAZWISKO, 'e', 1, 1) > 0 THEN 1 END) AS ILE_NAZWISK_Z_E
FROM PRACOWNICY;

-- 16. Dla każdego zespołu wyświetl jego identyfikator, sumę płac pracowników w nim zatrudnionych oraz listę pracowników
w formie: nazwisko:podstawowa płaca pracownika. Dane pracowników na liście mają zostać oddzielone średnikami.
Wynik posortuj wg identyfikatorów zespołów.
SELECT 
    ID_ZESP,
    SUM(PLACA_POD) AS SUMA_PLAC,
    LISTAGG(NAZWISKO || ':' || PLACA_POD, '; ') WITHIN GROUP (ORDER BY NAZWISKO) AS PRACOWNICY
FROM PRACOWNICY
GROUP BY ID_ZESP
ORDER BY ID_ZESP;

  
