use Northwind;
with ProductNames as (
select ProductName, od.ProductID from [Order Details] od
join Products p on od.ProductID=p.ProductID),

OrderDetails as (
select o.OrderID, ProductID, Quantity, UnitPrice, Quantity*UnitPrice as 
TotalCost from orders o
join [Order Details] od on o.OrderID=od.OrderID),

CustomerNames as (
select CompanyName, OrderID, DATEDIFF(day, OrderDate, ShippedDate) as 
TimeDiff from orders o
join Customers c on o.CustomerID=c.CustomerID),

CustomerOrderDetail as (
select CompanyName, c.OrderID, TimeDiff, ProductID, Quantity, UnitPrice, 
TotalCost from CustomerNames c 
join OrderDetails od on c.OrderID=od.OrderID)

select CompanyName, c.OrderID, ProductName, Quantity, UnitPrice, TotalCost, 
TimeDiff from CustomerOrderDetail c 
join ProductNames p on c.ProductID=p.ProductID
order by OrderID