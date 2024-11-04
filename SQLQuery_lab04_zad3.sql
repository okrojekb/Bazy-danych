WITH OrderDetails AS (
    SELECT
        o.OrderID,
        ProductID,
        Quantity,
        UnitPrice,
        Quantity * UnitPrice AS TotalCost
    FROM
        orders o
    JOIN
        [Order Details] od ON o.OrderID = od.OrderID
),
CustomerNames AS (
    SELECT
        c.CustomerID,
        CompanyName,
        OrderID,
        DATEDIFF(day, OrderDate, ShippedDate) AS TimeDiff
    FROM
        orders o
    JOIN
        Customers c ON o.CustomerID = c.CustomerID
),
MinMAx as (SELECT MIN(CustomerTotalSpending) AS NajniższeWynagrodzenie,
		MAX(CustomerTotalSpending) AS NajwyzszeWynagrodzenie
     FROM (
         SELECT
             c.CustomerID,
             SUM(TotalCost) AS CustomerTotalSpending
         FROM
             CustomerNames c
         JOIN
             OrderDetails od ON c.OrderID = od.OrderID
         GROUP BY
             c.CustomerID) AS AggregatedData2),

Div as (Select ((NajniższeWynagrodzenie+NajwyzszeWynagrodzenie)/4) as div from MinMAx),

TotalSpending AS (
    SELECT
        c.CustomerID,
        SUM(TotalCost) AS CustomerTotalSpending,
		(Select (NajniższeWynagrodzenie+NajwyzszeWynagrodzenie)/4 as div from MinMAx) as div
    FROM
        CustomerNames c
    JOIN
        OrderDetails od ON c.OrderID = od.OrderID
    GROUP BY
        c.CustomerID
)

select distinct c.CustomerID,
        CompanyName,
		--CustomerTotalSpending,
		--div,
		CASE
        WHEN CustomerTotalSpending < div THEN 'A'
        WHEN CustomerTotalSpending >= div AND CustomerTotalSpending < div*2 THEN 'B'
        WHEN CustomerTotalSpending >= div*2 AND CustomerTotalSpending < div*3 THEN 'C'
        ELSE 'D'
    END AS Category
		from CustomerNames c
join TotalSpending t on c.CustomerID=t.CustomerID
--order by CustomerTotalSpending