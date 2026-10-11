# Online Retail II – analiza sprzedaży (BigQuery + Power BI)

Analiza ok. dwóch lat transakcji (grudzień 2009 – grudzień 2011) brytyjskiego sklepu internetowego z drobnymi artykułami dekoracyjnymi i prezentowymi. Dane czyściłem i agregowałem w SQL (BigQuery), a wyniki zwizualizowałem w dwustronicowym dashboardzie Power BI.

## Najważniejsze wnioski

- **Sezonowość.** Przychód rośnie jesienią i szczytuje w listopadzie (np. wrzesień → grudzień 2010: ok. +38%). Grudzień 2011 w danych jest niepełny (do 9.12), więc spadek na wykresie nie jest realnym spadkiem.
- **Rozproszony asortyment.** Top 10 produktów to ok. 7,6% całkowitego przychodu – sprzedaż nie zależy od kilku hitów.
- **Klienci powracający.** Stanowią 75,41% klientów, ale generują 97,64% przychodu (z klientów z przypisanym Customer ID). Hipoteza (niezweryfikowana): duża część to hurtownicy.
- **Geografia.** Wielka Brytania to ok. 85,6% przychodu; trzy największe kraje poza UK (EIRE, Niderlandy, Niemcy) to ok. 55% przychodu poza UK. Silna zależność od jednego rynku.
- **Zwroty.** Ok. 3,61% sprzedaży brutto „znika" przez zwroty – niska wartość jak na sklep z tanimi produktami.

## Dashboard

**Strona „Przegląd"**
![Przegląd](dashboard/dashboard_przeglad.png)

**Strona „Geografia"**
![Geografia](dashboard/dashboard_geografia.png)

## Narzędzia i dane

- Google BigQuery (SQL), Power BI Desktop (Power Query, wizualizacje)
- Dane: [Online Retail II (UCI / Kaggle)](https://archive.ics.uci.edu/dataset/502/online+retail+ii). Surowych danych nie umieszczam w repozytorium – pobierz je z linku powyżej (sprawdź licencję źródła).

## Pytania biznesowe i zapytania

| # | Pytanie | Plik |
|---|---------|------|
| 1 | Jak wygląda miesięczny przychód, czy widać trend/sezonowość? | `sql/01_trend_miesieczny.sql` |
| 2 | Top 10 produktów wg przychodu i ich udział w całości | `sql/02_top10_produktow.sql` |
| 3 | Jaki % klientów wraca i ile przychodu generują? | `sql/03_klienci_powracajacy.sql` |
| 4 | Które kraje generują największy przychód (UK vs reszta)? | `sql/04_geografia.sql` |
| 5 | Jaki % sprzedaży brutto to zwroty? | `sql/05_zwroty.sql` |

Użyte techniki: CTE, `GROUP BY`, `DATE_TRUNC`, funkcje okna (`SUM() OVER ()`, `ROW_NUMBER`), `CASE WHEN`, `COUNT(DISTINCT)`, `JOIN`.

## Decyzje dotyczące danych

- **Przychód netto** = `SUM(Quantity * Price)`; zwroty mają ujemną ilość, więc się netują.
- **Kody administracyjne** (POST, DOT, M/Manual, C2, D, S, BANK CHARGES, ADJUST, ADJUST2, AMAZONFEE, CRUK, B, TEST001, TEST002) wykluczone – to nie sprzedaż produktów. Użyto `UPPER(StockCode)`, bo ta sama wartość występuje wielkimi i małymi literami.
- **Opisy produktów**: ten sam StockCode ma różne opisy – wybieram najczęstszy (`ROW_NUMBER`, nie `RANK`, by remis nie dublował produktu).
- **Brak Customer ID** – transakcje pominięte tylko w pytaniu 3 (bez ID nie da się ocenić powrotów).
- **Bony podarunkowe** pozostawione jako przychód.
- **Kraje**: „Unspecified" i „European Community" nie są krajami (pominięte w interpretacji); Nigeria ma ujemny przychód przy bardzo małej próbce.
- **Grudzień 2011** niepełny – oznaczony adnotacją na wykresie.
- **Mianownik zwrotów**: sprzedaż brutto, bo zwrot odnosi się do sprzedaży już w niej ujętej.

## Decyzje projektowe (Power BI)

- Wyniki zapytań eksportowane do CSV i wczytane ręcznie (dane są statyczne; chciałem pokazać pracę z importem CSV – połączenie na żywo z BigQuery znam jako alternatywę).
- Mapa: osobne zapytanie `LIMIT 4` (UK + top 3); wartości w tooltipie.
- Brak miar DAX i relacji – dane zagregowane już w SQL.
- Procenty z SQL zapisuję jako ułamki z `ROUND(..., 4)`, a w Power BI używam typu Percentage (lekcja: `ROUND(…, 2)` dawał 75%/98%).

## Ograniczenia i co dalej

- Model danych to płaskie tabele wynikowe – w kolejnym projekcie: model gwiazdy, relacje 1:N, tabela dat, miary DAX.
- Zwroty nie są rozbite na produkty ani okresy.
- Brak weryfikacji hipotezy o hurtownikach (np. analiza średniej wartości zamówienia).
