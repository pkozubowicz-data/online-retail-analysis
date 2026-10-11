select
  round(sum(Quantity * Price),2) as revenue,
  DATE_TRUNC(InvoiceDate, MONTH) as miesiac
from
  `online-retail-ii-uci-kaggle.Online_Retail_II_UCI_Kaggle.Online_Retail_II_UCI_Kaggle2`
where
  UPPER(StockCode) NOT IN ('POST','DOT','M','C2','D','S','BANK CHARGES','ADJUST','ADJUST2','AMAZONFEE','CRUK','B','TEST001','TEST002')
group by
  miesiac
order by
  miesiac ASC;