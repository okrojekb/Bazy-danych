use Northwind
--Wyświetlenie danych wszystkich zamówień
--select * from orders 

--Wyświetlenie danych wszystkich zamówień dostarczonych do Meksyku (Mexico), Niemiec (Germany) lub Brazylii (Brazil)
--select * from orders where ShipCountry in ('Brazil','Mexico','Germany')

--Wyświetlenie nazw miast w Niemczech, do których dostarczono produkty
--select distinct ShipCity from orders where ShipCountry='Germany'

--Wyświetlenie danych zamówień złożonych w lipcu 1996
--select * from orders where Month(OrderDate)=7 and Year(OrderDate)=1996

--Wyświetlenie pierwszych 10 znaków nazw firm, po konwersji do dużych znaków
--select left(UPPER(CompanyName), 10) as CompanyNameFirst10 from customers

--Wyświetlenie danych wszystkich zamówień złożonych przez klientów z Francji
/*
select o.* from orders o
join Customers c on o.CustomerID=c.CustomerID
where c.Country='France'
*/

--Wyświetlenie wszystkich krajów dostawy dla zamówień złożonych przez klientów z Niemiec
/*
select distinct ShipCountry from orders o
join customers c on o.CustomerID=c.CustomerID
where Country='Germany'
*/

--Znalezienie wszystkich zamówień dostarczonych do innego kraju niż kraj, z którego pochodził klient
/*
select OrderID from orders o
join Customers c on o.CustomerID=c.CustomerID
where ShipCountry!=Country
*/

--Znalezienie wszystkich klientów, którzy nigdy nie złożyli żadnych zamówień
/*
select c.CustomerID from Customers c
left join orders o on c.CustomerID=o.CustomerID
where OrderID is null
lub
select * from customers c where not exists (select * from
orders o where o.customerid=c.customerid)
*/

--Znalezienie wszystkich klientów, którzy nigdy nie zamówili produktu Chocolade
/*
SELECT CustomerId
FROM Customers a
WHERE NOT EXISTS (
    SELECT c.CustomerID
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.ProductName = 'Chocolade' 
	AND a.CustomerID=c.CustomerID
);
lub
SELECT CustomerId
FROM customers c
WHERE NOT EXISTS (
    SELECT *
    FROM orders o
    WHERE o.customerid = c.customerid
    AND EXISTS (
        SELECT *
        FROM [order details] od
        JOIN products p ON p.productid = od.productid
        WHERE od.orderid = o.orderid
        AND p.productname = 'Chocolade'
    )
);
*/

--Znalezienie wszystkich klientów, którzy kiedykolwiek zamówili Scottish Longbreads
/*
SELECT distinct c.CustomerID
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.ProductName = 'Scottish Longbreads'
lub
select * from customers c where exists (select * from
orders o join [order details] od on od.orderid=o.orderid
join products p on p.productid=od.productid where
p.productname='Scottish Longbreads' and
o.customerid=c.customerid)
*/

--Znalezienie zamówień, które zawierają Scottish Longbreads, ale nie zawierają Chocolade
/*
SELECT o.OrderID
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Scottish Longbreads'
    AND NOT EXISTS (
        SELECT x.OrderID
        FROM Orders x
        JOIN [Order Details] od ON x.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE p.ProductName = 'Chocolade'
            AND o.OrderID = x.OrderID
    );
lub
SELECT *
FROM orders o
WHERE EXISTS (
    SELECT *
    FROM [order details] od
    JOIN products p ON p.productid = od.productid
    WHERE productname = 'Scottish Longbreads'
        AND od.orderid = o.orderid
)
AND NOT EXISTS (
    SELECT *
    FROM [order details] od
    JOIN products p ON p.productid = od.productid
    WHERE productname = 'Chocolade'
        AND od.orderid = o.orderid
);
*/

--Znalezienie danych wszystkich pracowników, którzy obsługiwali zamówienia klienta ALFKI Oczekiwany format wyniku: Imię i nazwisko pracownika 
/*
Select distinct e.FirstName, e.LastName from Orders o
join Employees e on o.EmployeeID=e.EmployeeID
where o.CustomerID='ALFKI'
lub
select firstname, lastname from employees e where exists
(select * from orders o
where customerid='ALFKI' and
e.employeeid=o.employeeid)
*/

--Przygotowanie raportu zawierającego następujące dane: imię pracownika, nazwisko pracownika, data zamówienia, 
--informacja, czy zamówienie zawierało Chocolate (0/1). W raporcie należy uwzględnić każdego pracownika
/*
select e.FirstName, e.LastName, o.OrderDate,max(case
when c.OrderID is not null then 1
else 0
end) as IncludesChocolade
from Employees e
left join Orders o on e.EmployeeID=o.EmployeeID
left join [Order Details] od on o.OrderID=od.OrderID
left join (select distinct od.OrderID from [Order Details] od
join Products p on od.ProductID=p.ProductID
where p.ProductName = 'Chocolade') c on o.OrderID=c.OrderID
Group by  o. OrderID, e.FirstName, e.LastName, o.OrderDate
lub
select firstname, lastname,companyname, orderdate,
(case when od.orderid is null then 0 else 1 end) as status
from employees e
left join orders o on o.employeeid=e.employeeid
left join [order details] od on o.orderid=od.orderid and
od.productid=(select productid from products where
productname='Chocolade')
left join customers c on c.customerid=o.customerid
*/

--Przygotowanie raportu zawierającego następujące dane: nazwa produktu, kraj dostawy, numer zamówienia, rok zamówienia, miesiąc zamówienia,
--data zamówienia posortowanego w malejącej kolejności dat zamówienia. W raporcie należy uwzględnić tylko zamówienia złożone przez klientów z
--Niemiec i produkty o nazwach rozpoczynających się na literę z przedziału [c-s]
/*
select p.ProductName, o.ShipCountry, o.OrderID, year(o.OrderDate) as OrderYear, month(o.OrderDate) as OrderMonth, o.OrderDate from Orders o
join (select od.OrderID, p.ProductName from [Order Details] od
join (select p.ProductID, p.ProductName from Products p
where p.ProductName like '[c-s]%') p on od.ProductID=p.ProductID) p on o.OrderID=p.OrderID
where exists (select c.CustomerID, c.Country from Customers c
where c.Country='Germany' and c.CustomerID=o.CustomerID)
order by o.OrderDate desc
lub
SELECT P.ProductName, O.ShipCountry, O.OrderId, YEAR(orderdate) as rok,
MONTH(orderdate) as miesiac, orderDate from Customers c join orders o on
o.customerid=c.customerid
join [order details] od on od.orderid=o.orderid
join products p on od.productid=p.productid
where c.country='Germany' and p.productname like '[c-s]%' order by
orderdate desc
*/