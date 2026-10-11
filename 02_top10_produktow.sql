with opisy_z_liczba as (
  select
    StockCode,
    description,
    count(*) as ilosc_wystepowania
  from
    `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
  group by
    StockCode,
    Description
  ),
ranking_opisow as (
  select
    StockCode,
    Description,
    row_number() over(partition by StockCode order by ilosc_wystepowania DESC) as ranking
  from
    opisy_z_liczba
),
ranking_1_miejsce as (
  select
    StockCode,
    Description
  from
    ranking_opisow
  where 
    ranking = 1
),
revenue_per_produkt as(
  select
    StockCode,
    round(sum(Quantity * Price),2) as Revenue
  from
    `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
  where
    UPPER(StockCode) NOT IN ('POST','DOT','M','C2','D','S','BANK CHARGES','ADJUST','ADJUST2','AMAZONFEE','CRUK','B','TEST001','TEST002')
  group by
    StockCode
  order by
    StockCode ASC
),
revenue_z_procentem as(
  select
    StockCode,
    Revenue,
    round(sum(revenue) over(),2) as Revenue_total
  from
    revenue_per_produkt
)
select
  ran.StockCode,
  ran.Description,
  rev.Revenue,
  (rev.Revenue/rev.Revenue_Total) as `Revenue_%`
from
  revenue_z_procentem rev
inner join
  ranking_1_miejsce ran
on
  rev.StockCode = ran.StockCode
order by
  revenue desc
limit
  10
;