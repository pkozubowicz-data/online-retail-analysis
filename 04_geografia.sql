with revenue_per_kraj as (
  select
    Country,
    round(sum(Quantity*Price),2) as Revenue
  from
    `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
  where
    UPPER(StockCode) NOT IN ('POST','DOT','M','C2','D','S','BANK CHARGES','ADJUST','ADJUST2','AMAZONFEE','CRUK','B','TEST001','TEST002')
  group by
    Country
),
revenue_z_procentem as(
  select
    Country,
    Revenue,
    round(sum(revenue) over(),2) as Revenue_total
  from
    revenue_per_kraj
)
select
  Country,
  Revenue,
  (Revenue/Revenue_total) as `% całkowitego revenue`
from
  revenue_z_procentem
order by
  revenue DESC
LIMIT 4;