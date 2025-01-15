-- 1. Wyświetl nazwiska, etaty, numery zespołów i nazwy zespołów wszystkich pracowników. Wynik
uporządkuj wg nazwisk pracowników.
SELECT NAZWISKO, ETAT, P.ID_ZESP, NAZWA FROM PRACOWNICY P JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP ORDER BY NAZWISKO;

-- 2. Ogranicz wynik poprzedniego zapytania do tych pracowników, którzy pracują w zespołach
zlokalizowanych przy ul. Piotrowo 3a. 
SELECT NAZWISKO, ETAT, P.ID_ZESP, NAZWA FROM PRACOWNICY P JOIN ZESPOLY Z ON P.ID_ZESP = Z.ID_ZESP WHERE ADRES='PIOTROWO 3A' ORDER BY NAZWISKO;

-- 3. Znajdź nazwiska, etaty i pensje podstawowe pracowników. Wyświetl również minimalne
i maksymalne pensje dla etatów, na których pracują pracownicy (użyj tabeli Etaty). Wynik posortuj
wg nazw etatów i nazwisk pracowników.
SELECT NAZWISKO, ETAT, PLACA_POD, PLACA_MIN, PLACA_MAX FROM PRACOWNICY JOIN ETATY ON ETAT=NAZWA ORDER BY ETAT, NAZWISKO

-- 4. Zmień poprzednie zapytanie w taki sposób, aby w zbiorze wynikowym pojawiła się kolumna
czy_pensja_ok. Ma w niej pojawić wartość „OK” jeśli płaca podstawowa pracownika zawiera się
w przedziale wyznaczonym przez płace: minimalną i maksymalną dla etatu, na którym pracownik
pracuje lub wartość „NIE” w przeciwnym wypadku.
SELECT NAZWISKO, ETAT, PLACA_POD, PLACA_MIN, PLACA_MAX, 
CASE
    WHEN PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX THEN 'OK'
    ELSE 'NIE'
END AS CZY_PENSJA_OK    
FROM PRACOWNICY JOIN ETATY ON ETAT=NAZWA ORDER BY ETAT, NAZWISKO

-- 5. Wykorzystaj dodaną w p. 4. kolumnę aby znaleźć pracowników, którzy zarabiają więcej lub mniej
niż to jest przewidziane dla etatów, na których pracują. 
SELECT NAZWISKO, ETAT, PLACA_POD, PLACA_MIN, PLACA_MAX, 
CASE
    WHEN PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX THEN 'OK'
    ELSE 'NIE'
END AS CZY_PENSJA_OK    
FROM PRACOWNICY JOIN ETATY ON ETAT=NAZWA WHERE PLACA_POD NOT BETWEEN PLACA_MIN AND PLACA_MAX ORDER BY ETAT, NAZWISKO

-- 6. Dla każdego pracownika wyświetl jego nazwisko, płacę podstawową, etat, kategorię płacową
i widełki płacowe, w jakich mieści się pensja pracownika. Kategoria płacowa to nazwa etatu (z tabeli
Etaty), do którego pasuje płaca podstawowa pracownika (zawiera się w przedziale płac dla etatu).
Wynik posortuj wg nazwisk i kategorii płacowych pracowników. 
SELECT NAZWISKO, PLACA_POD, ETAT, NAZWA AS KAT_PLAC, PLACA_MIN, PLACA_MAX FROM PRACOWNICY JOIN ETATY ON PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX ORDER BY NAZWISKO, KAT_PLAC;

-- 7. Powyższy zbiór ogranicz do tych pracowników, których rzeczywiste zarobki odpowiadają widełkom
płacowym przewidzianym dla sekretarek. Wynik posortuj wg nazwisk pracowników.
SELECT NAZWISKO, PLACA_POD, ETAT, NAZWA AS KAT_PLAC, PLACA_MIN, PLACA_MAX FROM PRACOWNICY JOIN ETATY ON PLACA_POD BETWEEN PLACA_MIN AND PLACA_MAX WHERE NAZWA = 'SEKRETARKA' ORDER BY NAZWISKO, KAT_PLAC;

-- 8. Wyświetl nazwiska i numery pracowników wraz z numerami i nazwiskami ich szefów. Wynik
posortuj wg nazwisk pracowników. W zbiorze wynikowym mają się pojawić tylko ci pracownicy,
którzy mają szefów. 
SELECT 
    P1.NAZWISKO AS PRACOWNIK, 
    P1.ID_PRAC AS PRACOWNIK_ID, 
    P2.NAZWISKO AS SZEF, 
    P2.ID_PRAC AS SZEFA_ID
FROM 
    PRACOWNICY P1 
JOIN 
    PRACOWNICY P2 
ON 
    P1.ID_SZEFA = P2.ID_PRAC 
ORDER BY 
    P1.NAZWISKO;

-- 9. Wyświetl nazwiska i daty zatrudnienia pracowników, którzy zostali zatrudnieni nie później niż 10 lat
po swoich przełożonych. Wynik uporządkuj wg dat zatrudnienia i nazwisk pracowników.
