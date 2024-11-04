SELECT
  *
FROM
  SYSOBJECTS
WHERE
  xtype = 'U';
GO


/*TASK 1*/
select ProductId, ShipCountry, SUM(Quantity) as TotalQuantity​ from Orders as o
join [Order Details] on o.OrderID=[Order Details].OrderID
where o.EmployeeID=2
Group By ProductId, ShipCountry;
GO

/*TASK 2*/
select emp.FirstName,emp.LastName,sum(OD.Quantity) from Orders as o
Join [Order Details] as OD on OD.OrderID=o.OrderID
join [Products] as p ON OD.ProductID=p.ProductID
join Employees as emp on o.EmployeeID=emp.EmployeeID
where ProductName='Chocolade' and Year(o.OrderDate)=1998
GROUP by emp.EmployeeID, emp.FirstName,emp.LastName
HAVING sum(OD.Quantity)>=100;
GO


/*TASK 3*/
SELECT p.ProductName, avg(Quantity) as [Average quantity], count(O.OrderID)  FROM Orders as o
JOIN Customers as c ON o.CustomerID=c.CustomerID
JOIN [Order Details] as OD ON o.OrderID=OD.OrderID
JOIN Products as p ON OD.ProductID=p.ProductID
WHERE c.Country='Italy'
GROUP BY o.OrderID, p.ProductID, p.ProductName
HAVING avg(Quantity)>=20
order by count(O.OrderID) DESC;
GO

/*
TASK 4
*/
select c.CompanyName as CustomerName, p.ProductName, OrderDate, sum(Quantity) as Quantity from Orders as o
JOIN Customers as c ON o.CustomerID=c.CustomerID
JOIN [Order Details] as OD ON o.OrderID=OD.OrderID
JOIN Products as p ON OD.ProductID=p.ProductID
Where c.City='Berlin'
GROUP By c.CompanyName, p.ProductName, OrderDate;
GO

/*
TASK 5
*/
SELECT DISTINCT p.ProductName FROM Orders as o
JOIN [Order Details] as OD ON o.OrderID=OD.OrderID
JOIN Products as p ON OD.ProductID=p.ProductID
WHERE o.ShipCountry='France' and year(ShippedDate)=1998;
GO

/*TASK 6*/
select distinct c.CompanyName from Customers as c
join  Orders as o on o.CustomerID=c.CustomerID
where c.CustomerID not in 
    (select distinct CustomerID from products as p
    join [Order Details] as od on p.ProductID=od.ProductID
    join Orders as o on o.OrderID=od.OrderID
    where ProductName like 'Ravioli%')
Group by c.CompanyName
Having count(OrderID)>=2;
GO


/*TASK 7*/
select * from Orders
where OrderID in (select OrderID from [Order Details]
                    group by OrderID
                    having count(ProductID) >= 4
                    )
    and 
    CustomerID in (select CustomerID from Customers where Country='France');
GO

/*TASK 8*/
select c.CompanyName  FROM orders o
join Customers c ON c.CustomerID =o.CustomerID 
where ShipCountry = 'France'
and c.CustomerID in (select c1.CustomerID  FROM orders o1
						join Customers c1 ON c1.CustomerID =o1.CustomerID 
						where ShipCountry = 'Belgium'
						group by OrderID, c1.CustomerID
						having count(OrderID) <2)
group by OrderID, c.CustomerID, c.CompanyName 
having count(OrderID) >=5

/*TASK 9*/
with 
res as (
    select od.ProductID, MAX(od.Quantity) as MaxQuantity
    from [Order Details] od
    group by od.ProductID
),
sub_res as (
    select od.ProductID, o.CustomerID, od.Quantity
    from [Order Details] od
    join Orders o on od.OrderID=o.OrderID
    join res on od.ProductID=res.ProductID
    WHERE od.Quantity = res.MaxQuantity
)
   
select p.ProductName,c.CompanyName, sub_res.Quantity as MaxQuantity
from sub_res
join Products p  on sub_res.ProductID = p.ProductID
join Customers c on sub_res.CustomerID = c.CustomerID
order by p.ProductName,c.CompanyName; 
   
   
/*TASK 10*/
with 
count_orders as (
	select e.EmployeeID, count(O.OrderID) as CountOrder
	from Employees e
	join Orders o on e.EmployeeID = o.EmployeeID
    group by e.EmployeeID
),
avg_orders as (
    select avg(CountOrder) * 1.2 as Threshold
    from count_orders
)

select concat(e.FirstName, ' ', e.LastName), co.CountOrder
from Employees e
join count_orders co on e.EmployeeID = co.EmployeeID
cross join avg_orders ao
where co.CountOrder > ao.Threshold
order by e.LastName, e.FirstName;

/*TASK 11*/
select top 5 o.OrderID, count(od.ProductID) ProductCount from Orders o 
join [Order Details] od on o.OrderID = od.OrderID 
group by o.OrderID 
order by count(od.ProductID) desc

/*TASK 12*/
with 
res (ProductName, TotalQuantityIn1996, TotalQuantityIn1997) as (
	select p.ProductName,
			sum(case year(o.OrderDate) WHEN 1996 THEN 
	                    od.Quantity ELSE 0 END),
	        sum(case year(o.OrderDate) WHEN 1997 THEN 
	                    od.Quantity ELSE 0 END)
	from Orders o 
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on p.ProductID = od.ProductID 
	group by p.ProductID, p.ProductName
)
select * from res
where TotalQuantityIn1996 < TotalQuantityIn1997
order by ProductName;


/*TASK 13*/

with 
res (ProductName, NumberOfOrdersIn1996, NumberOfOrdersIn1997) as (
	select p.ProductName,
			sum(case year(o.OrderDate) WHEN 1996 THEN 
	                    1 ELSE 0 END),
	        sum(case year(o.OrderDate) WHEN 1997 THEN 
	                    1 ELSE 0 END)
	from Orders o 
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on p.ProductID = od.ProductID 
	group by p.ProductID, p.ProductName
)
select * from res
where NumberOfOrdersIn1996 < NumberOfOrdersIn1997
order by ProductName;



/*COMMON TASK*/
SELECT      YEAR(ord.OrderDate) YEAR,  
            SUM(CASE prod.CategoryID WHEN 1 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) Beverages, 
            SUM(CASE prod.CategoryID WHEN 2 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) Condiments, 
            SUM(CASE prod.CategoryID WHEN 3 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) Confections, 
            SUM(CASE prod.CategoryID WHEN 4 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) [Dairy Products], 
            SUM(CASE prod.CategoryID WHEN 5 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) [Grains/Cereals], 
            SUM(CASE prod.CategoryID WHEN 6 THEN    
                    det.UnitPrice * det.Quantity ELSE 0 END) [Meat/Poultry], 
            SUM(CASE prod.CategoryID WHEN 7 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) Produce, 
            SUM(CASE prod.CategoryID WHEN 8 THEN 
                    det.UnitPrice * det.Quantity ELSE 0 END) Seafood 
 
FROM        Orders ord 
 
INNER JOIN  [Order Details] det 
ON          det.OrderID = ord.OrderID 
 
INNER JOIN  Products prod 
ON          prod.ProductID = det.ProductID 
 
GROUP BY    YEAR(ord.OrderDate) 
 
ORDER BY    YEAR(ord.OrderDate)