use Northwind;
/*
select o.ShipCountry, od.ProductID, sum(od.Quantity) as TotalQuantity
from (select o.OrderID, o.ShipCountry from Orders o
	where o.EmployeeID = 2) o
join [Order Details] od on o.OrderID=od.OrderID
group by o.ShipCountry, od.ProductID;
*/

/*
select e.FirstName, e.LastName, tq.TotalQuantity from Employees e
join (select a.EmployeeID, sum(Quantity) as TotalQuantity from Orders a
	join [Order Details] od on a.OrderId=od.OrderID
	group by a.EmployeeID) tq on e.EmployeeID=tq.EmployeeID
where exists (select o.OrderID, o.EmployeeID
	from (select * from Orders o
		where year(OrderDate) = 1998) o
	join (select od.OrderID, od.Quantity from [Order Details] od
		join (select p.ProductID from Products p
			where p.ProductName='Chocolade') p on od.ProductId=p.ProductId) p
	on o.OrderID=p.OrderId
	where p.Quantity>=100
	and o.EmployeeID=e.EmployeeID);
	*/

/*
select cu.CustomerID, x.ProductID, x.ProductName, count(x.ProductID) as iloscZam from Products x
join [Order Details] ods on ods.ProductID=x.ProductID
join Orders ord on ord.OrderID=ods.OrderID
join Customers cu on cu.CustomerID=ord.CustomerID
where exists (select c.CustomerID, p.ProductID, avg(od.Quantity) as avgQual from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	where c.Country='Italy' and p.ProductID=x.ProductID
	and c.CustomerID=cu.CustomerID
	group by c.CustomerID, p.ProductID
	having avg(od.Quantity) >=20)
group by cu.CustomerID, x.ProductID, x.ProductName
order by count(x.ProductID) desc;
*/

/*
select c.CompanyName, p.ProductName, o.OrderDate, od.Quantity from Customers c
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on o.OrderID=od.OrderID
join Products p on od.ProductID=p.ProductID
where c.City='Berlin'
order by c.CompanyName, p.ProductName, o.OrderDate;
*/
/*
select distinct p.ProductName from Customers c
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on o.OrderID=od.OrderID
join Products p on od.ProductID=p.ProductID
where o.ShipCountry='France'
and year(o.OrderDate) = 1998;
*/
/*
select distinct c.CompanyName from Customers c
join Orders o on c.CustomerID=o.CustomerID
--where not exists (select distinct ord.CustomerID from Products x
	join [Order Details] ods on ods.ProductID=x.ProductID
	join Orders ord on ord.OrderID=ods.OrderID
	where x.ProductName like 'Ravioli%'
	and c.CustomerID=ord.CustomerID)
group by c.CompanyName
having count(o.OrderID) >=2;
*/
/*
select o.OrderID, c.CompanyName, count(od.ProductID) as ProductCount from Orders o 
join [Order Details] od on o.OrderID=od.OrderID
join Customers c on o.CustomerID=c.CustomerID
where c.Country='France'
group by o.OrderID, c.CompanyName
having count(od.ProductID) >= 4;
*/
/*
select x.CompanyName from 
(
	select c.CompanyName, o.ShipCountry, count(o.OrderID) as iloZam from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	group by c.CompanyName, o.ShipCountry
	having (count(o.OrderID) >=5 and o.ShipCountry='France') or (count(o.OrderID) <=2 and o.ShipCountry='Belgium')
) as x
group by x.CompanyName
having count(x.ShipCountry) = 2;
*/

select p.ProductName, c.CompanyName, max(od.Quantity) as maxQua from Customers c
join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on o.OrderID=od.OrderID
join Products p on od.ProductID=p.ProductID
group by p.ProductName, c.CompanyName;

select * from (
	select p.ProductName, c.CompanyName, p.ProductID, max(od.Quantity) as maxQua from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	group by p.ProductName, c.CompanyName, p.ProductID
) as x
join (
	select od.ProductID, max(od.Quantity) as maxZamP from [Order Details] od
	group by od.ProductID
) as m on x.ProductID=m.ProductID


select od.ProductID, max(od.Quantity) as maxZamP from [Order Details] od
group by od.ProductID;


