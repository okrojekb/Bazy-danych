with OrderDetails as (
select o.OrderID, ProductID, Quantity, UnitPrice, Quantity*UnitPrice as 
TotalCost from orders o
join [Order Details] od on o.OrderID=od.OrderID),

CustomerNames as (
select c.CustomerID, CompanyName, OrderID, DATEDIFF(day, OrderDate, ShippedDate) as 
TimeDiff from orders o
join Customers c on o.CustomerID=c.CustomerID),

TotalSpending as (select c.CustomerID, sum(TotalCost) as CustomerTotalSpending from CustomerNames c 
join OrderDetails od on c.OrderID=od.OrderID
group by c.CustomerID)



select CustomerID, CustomerTotalSpending, (max(CustomerTotalSpending) - min(CustomerTotalSpending))/4 as divide from TotalSpending
/*
select CustomerID, CustomerTotalSpending, (max(CustomerTotalSpending) - min(CustomerTotalSpending))/4 as divide, CASE
        WHEN CustomerTotalSpending < divide THEN 'A'
        WHEN CustomerTotalSpending >= divide AND CustomerTotalSpending < divide*2 THEN 'B'
        WHEN CustomerTotalSpending >= divide*2 AND CustomerTotalSpending < divide*3 THEN 'C'
        ELSE 'D'
    END AS Category from TotalSpending*/
