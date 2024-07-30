-- 1
select t.Name , inv.Total  from chinook.track t 
join chinook.invoiceline invl on  invl.TrackId = t.TrackId
join chinook.invoice inv on  inv.InvoiceId = invl.InvoiceId
ORDER BY Total  DESC
limit 10;
;



-- 2

select g.GenreId , g.Name , sum(inv.Total) Total$ , count(invl.InvoiceLineId) MusicCounts from chinook.track t 
join chinook.genre g on t.GenreId = g.GenreId
join chinook.invoiceline invl on t.TrackId = invl.TrackId
join chinook.invoice inv on invl.InvoiceId = inv.InvoiceId
group by g.GenreId
ORDER BY Total$  DESC
;

-- 3 

select c.CustomerId ,c.FirstName , c.LastName from chinook.customer c 
where c.CustomerId not in (select chinook.invoice.CustomerId from chinook.invoice)
;

-- 4

select al.AlbumId , count(t.TrackId) , sum(t.Milliseconds) , sum(t.Milliseconds)/(count(t.TrackId)*60000) mean_Minute from chinook.track t
join chinook.albums al on al.AlbumId = t.AlbumId 
group by al.AlbumId
;

-- 5 

select e.EmployeeId , e.FirstName , e.LastName , count(inv.InvoiceId) NumOfOrders  from chinook.employee e 
join chinook.customer c on c.SupportRepId = e.EmployeeId 
join chinook.invoice inv on c.CustomerId = inv.CustomerId
group by e.EmployeeId
ORDER BY NumOfOrders  DESC
;

-- 6 
select c.CustomerId , c.FirstName , c.LastName , count( distinct t.GenreId) NumOfGeners from chinook.customer c 
join chinook.invoice inv on c.CustomerId = inv.CustomerId
join chinook.invoiceline invl on inv.InvoiceId = invl.InvoiceId
join chinook.track t on invl.TrackId = t.TrackId
group by c.CustomerId 
order by NumOfGeners desc
;

-- 7 

select g.GenreId , g.Name , t.Name , count(inv.InvoiceId) , sum(inv.Total) from chinook.genre g 
join chinook.track t on g.GenreId = t.GenreId
join chinook.invoiceline invl on invl.TrackId = t.TrackId
join chinook.invoice inv on invl.InvoiceId = inv.InvoiceId
group by g.GenreId, g.Name, t.Name
;
 
 
 -- 7 
 WITH TrackSales AS (
    SELECT g.GenreId, g.Name AS GenreName, t.TrackId, t.Name AS TrackName,SUM(inv.Total) AS TotalSales FROM chinook.genre g 
    JOIN chinook.track t ON g.GenreId = t.GenreId
    JOIN chinook.invoiceline invl ON invl.TrackId = t.TrackId
    JOIN chinook.invoice inv ON invl.InvoiceId = inv.InvoiceId
    GROUP BY g.GenreId, g.Name, t.TrackId, t.Name
),
RankedTracks AS (
    SELECT GenreId, GenreName, TrackId, TrackName, TotalSales,
        ROW_NUMBER() OVER (PARTITION BY GenreId ORDER BY TotalSales DESC) AS TrackRank FROM TrackSales
)
SELECT GenreId, GenreName, TrackId, TrackName, TotalSales FROM RankedTracks
WHERE TrackRank <= 3
ORDER BY GenreId, TrackRank;


-- 8 
 -- makin a new column for the year 
ALTER TABLE chinook.invoice ADD COLUMN invoiceYear INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE chinook.invoice SET invoiceYear = SUBSTR(InvoiceDate, 1, 4);
 SET SQL_SAFE_UPDATES = 1;
 
 select inv.invoiceYear year , count(invl.InvoiceLineId) CountOfSalesTracks from chinook.invoice inv
 join chinook.invoiceline invl on inv.InvoiceId = invl.InvoiceId
 group by inv.invoiceYear
 order by count(invl.InvoiceLineId) desc
  ;
  
-- 9 
WITH TotalSales AS (
    SELECT SUM(inv.Total) AS total_sales
    FROM chinook.invoice inv
),
MeanSales AS (
    SELECT total_sales / (SELECT COUNT(DISTINCT CustomerId) FROM chinook.invoice) AS mean_sales
    FROM TotalSales
)
SELECT c.CustomerId, c.LastName, SUM(inv.Total) AS customer_total
FROM chinook.customer c
JOIN chinook.invoice inv ON inv.CustomerId = c.CustomerId
GROUP BY c.CustomerId, c.LastName
HAVING SUM(inv.Total) > (SELECT mean_sales FROM MeanSales)
order by customer_total desc
;





















