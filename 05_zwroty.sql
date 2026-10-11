WITH sprzedaz_i_zwroty as (
  select
    round(sum(case when Quantity > 0 then Quantity*Price else 0 end),2) as sprzedaz_brutto,
    round(ABS(sum(case when Quantity < 0 then Quantity*Price else 0 end)),2) as wartosc_zwrotow
  from
    `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
  where
    UPPER(StockCode) NOT IN ('POST','DOT','M','C2','D','S','BANK CHARGES','ADJUST','ADJUST2','AMAZONFEE','CRUK','B','TEST001','TEST002')
)
select
  sprzedaz_brutto,
  wartosc_zwrotow,
  round((wartosc_zwrotow/sprzedaz_brutto),4) as procent_zwrotow
from
  sprzedaz_i_zwroty
;