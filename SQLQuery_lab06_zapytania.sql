use Northwind;

/* #1
update Orders set
EmployeeID = 4 where EmployeeID = 1;
*/
/* #2
begin transaction
update [Order Details] set
[Order Details].Quantity = round(0.8* Quantity, 0) where ProductId in (
	select p.ProductID from Products p
	where p.ProductName='Ikura')
and exists (
	select o.OrderID from Orders o
	where o.OrderDate > '1997-05-15'
	and o.OrderID=[Order Details].OrderID);
*/
/* #3
select p.ProductID from Products p
where p.ProductName='Chocolade';

select max(o.OrderDate) as ostZam from Orders o
join [Order Details] od on o.OrderID=od.OrderID
where o.CustomerID='ALFKI'
and od.ProductID != (
	select p.ProductID from Products p
	where p.ProductName='Chocolade')
group by CustomerID;


begin transaction
insert into [Order Details]
values
((select x.OrderID from Orders x
where x.CustomerID='ALFKI'
and OrderDate = (
	select max(o.OrderDate) as ostZam from Orders o
	where o.CustomerID='ALFKI'
	group by CustomerID)), (select p.ProductID from Products p
where p.ProductName='Chocolade'), 12.75, 1, 0);
*/