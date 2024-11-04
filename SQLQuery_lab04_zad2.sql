use Northwind;

select (select c.CompanyName from Customers c where c.CustomerID=o.CustomerID) as CustomerName,  o.OrderID, p.ProductName, p.Quantity, 
p.UnitPrice, p.TotalPrice,  datediff(day, o.OrderDate, o.ShippedDate) as TimeDiff
from Orders o
join (select p.ProductName, od.Quantity, od.UnitPrice, (od.UnitPrice*od.Quantity*(1-od.Discount)) as TotalPrice, od.OrderID
from [Order Details] od
join Products p on od.ProductID=p.ProductID) p on o.OrderID=p.OrderID
order by o.OrderID

