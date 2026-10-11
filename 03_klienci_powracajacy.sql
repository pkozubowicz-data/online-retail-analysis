with klienci_zamowienia as(
  select
    `Customer ID`,
    count(distinct Invoice) as Liczba_zamowien,
    round(sum(quantity*price),4) as Revenue_klient
  from
    `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
  where
    `Customer ID` is not null
  group by
    `Customer ID`
),
klienci_typ as (
  select
    `Customer ID`,
    Revenue_klient,
    case 
      when liczba_zamowien > 1 then 'Powracający'
      else 'Jednorazowy'
    end as typ_klienta
  from
    klienci_zamowienia
),
podsumowanie_grup as(
  select
    COUNT(*) as liczba_klientow,
    typ_klienta,
    sum(revenue_klient) as suma
  from
    klienci_typ
  group by
    typ_klienta
)
select
  typ_klienta,
  liczba_klientow,
  round((suma),4) as suma,
  round((liczba_klientow / sum(liczba_klientow) over()),4) as `% klientów`,
  round((suma / sum(suma) over()),4) as `% revenue`
from
  podsumowanie_grup
;