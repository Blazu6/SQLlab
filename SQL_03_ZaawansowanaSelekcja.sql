-- 1. Dla każdego pracownika wygeneruj kod składający się z dwóch pierwszych liter jego etatu i jego numeru identyfikacyjnego
SELECT NAZWISKO, SUBSTR(ETAT, 1, 2) || ID_PRAC AS KOD FROM PRACOWNICY;

-- 2. Wydaj wojnę literom „K”, „L”, „M” zamieniając je wszystkie na literę „X” w nazwiskach pracowników. 
SELECT NAZWISKO, TRANSLATE(NAZWISKO, 'KLM', 'XXX') AS WOJNA_LITEROM FROM PRACOWNICY;

-- 3. Wyświetl nazwiska pracowników którzy posiadają literę „L” w pierwszej połowie swojego nazwiska. 
SELECT NAZWISKO FROM PRACOWNICY WHERE INSTR(SUBSTR(NAZWISKO, 1, LENGTH(NAZWISKO)/2), 'L', 1, 1) > 0;

-- 4. Wyświetl nazwiska i płace pracowników powiększone o 15% i zaokrąglone do liczb całkowitych. 
SELECT NAZWISKO, ROUND(PLACA_POD*1.15, 0) AS PODWYZKA FROM PRACOWNICY;

-- 5. Każdy pracownik odłożył 20% swoich miesięcznych zarobków na 10-letnią lokatę oprocentowaną 10% w skali roku i kapitalizowaną co roku. Wyświetl informację o tym, jaki zysk będzie miał każdy pracownik po zamknięciu lokaty. 
SELECT NAZWISKO, PLACA_POD, PLACA_POD*0.2 AS INWESTYCJA, PLACA_POD*0.2*POWER(1+0.1, 10) AS KAPITAL, PLACA_POD*0.2*POWER(1+0.1, 10)-PLACA_POD*0.2 AS ZYSK FROM PRACOWNICY
  
-- 6. Policz, jaki staż miał każdy pracownik 1 stycznia 2000 roku. DATE '2000-01-01' MUSI BYC TAK BO ORACLE NARZUCA FORMAT DATY ROK-MIESIAC-DZIEN
SELECT NAZWISKO, ZATRUDNIONY, FLOOR((DATE '2000-01-01' - ZATRUDNIONY)/365) AS STAZ_W_2000 FROM PRACOWNICY

-- 7. Wyświetl poniższe informacje o datach przyjęcia pracowników zespołu 20. 
SELECT NAZWISKO, TO_CHAR(ZATRUDNIONY, 'MONTH, DD YYYY', 'NLS_DATE_LANGUAGE=POLISH') AS DATA_ZATRUDNIENIA FROM PRACOWNICY WHERE ID_ZESP = 20;

-- 8. Sprawdź, jaki mamy dziś dzień tygodnia.
SELECT TO_CHAR(CURRENT_DATE, 'DAY', 'NLS_DATE_LANGUAGE=POLISH') AS DZIS FROM DUAL;

-- 9. Przyjmij, że Mielżyńskiego i Strzelecka należą do dzielnicy Stare Miasto, Piotrowo należy do dzielnicy Nowe Miasto a Włodkowica należy do dzielnicy Grunwald. Wyświetl poniższy raport (skorzystaj z wyrażenia CASE).
SELECT NAZWA, ADRES,
    CASE 
        WHEN ADRES = 'PIOTROWO 3A' THEN 'NOWE MIASTO'
        WHEN ADRES = 'WLODKOWICA 16' THEN 'GRUNWALD'
        WHEN ADRES IN ('MIELZYNSKIEGO 30', 'STRZELECKA 14') THEN 'STARE MIASTO'
    END AS DZIELNICA
FROM ZESPOLY;

-- 10. Dla każdego pracownika wyświetl informację o tym, czy jego pensja jest mniejsza niż, równa lub większa niż 480 złotych (skorzystaj z wyrażenia CASE). 
SELECT NAZWISKO, PLACA_POD,
    CASE 
        WHEN PLACA_POD < 480 THEN 'PONIZEJ 480'
        WHEN PLACA_POD = 480 THEN 'DOKLADNIE 480'
        WHEN PLACA_POD > 480 THEN 'POWYZEJ 480'
    END AS PROG
FROM PRACOWNICY;

-- 11. W poniższej tabelce przedstawiono średnie płace w poszczególnych zespołach (nie brano pod uwagę płac dodatkowych). 
Zbuduj zapytanie, które wyświetli nazwiska, numery zespołów i płace podstawowe tych pracowników, którzy
w swoich zespołach zarabiają więcej lub dokładnie tyle ile wynosi średnia płaca w ich zespole. W zapytaniu użyj
danych z powyższej tabelki. Wynik posortuj wg identyfikatorów zespołów i płac podstawowych. Skorzystaj
z wyrażenia CASE.
SELECT NAZWISKO, ID_ZESP, PLACA_POD FROM PRACOWNICY 
WHERE PLACA_POD >= CASE
    WHEN ID_ZESP = 10 THEN 1070.10
    WHEN ID_ZESP = 20 THEN 616.6
    WHEN ID_ZESP = 30 THEN 502
    WHEN ID_ZESP = 40 THEN 1350
END
ORDER BY ID_ZESP, PLACA_POD;

-- 12. Wyświetl nazwiska i etaty pracowników oraz staże pracy (w latach): na dzień 1 stycznia 2000 r. (dla profesorów
i dyrektorów), na dzień 1 stycznia 2010 r. (dla adiunktów i asystentów), na dzień 1 stycznia 2020 r. (dla stażystów
i sekretarek). Wynik posortuj wg następujących zasad:
 profesorowie i dyrektorzy powinni zostać posortowani wg stażu na dzień 1 stycznia 2000 r.,
 adiunkci i asystenci powinni zostać posortowani wg stażu na dzień 1 stycznia 2010 r.,
 pozostali (stażyści i sekretarki) powinni zostać posortowani wg stażu na dzień 1 stycznia 2020 r.,
Użyj konstrukcji CASE. 
SELECT NAZWISKO, ETAT, 
    CASE
        WHEN ETAT IN ('PROFESOR','DYREKTOR') THEN FLOOR((DATE '2000-01-01' - ZATRUDNIONY)/365)
    END AS STAZ_W_2000,
    CASE
        WHEN ETAT IN ('ADIUNKT','ASYSTENT') THEN FLOOR((DATE '2010-01-01' - ZATRUDNIONY)/365)
    END AS STAZ_W_2010,
    CASE
        WHEN ETAT IN ('STAZYSTA','SEKRETARKA') THEN FLOOR((DATE '2020-01-01' - ZATRUDNIONY)/365)
    END AS STAZ_W_2020
FROM PRACOWNICY
ORDER BY STAZ_W_2000, STAZ_W_2010, STAZ_W_2020;
  
