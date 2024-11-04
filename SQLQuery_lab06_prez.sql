use Northwind;

--select ProductID, ProductName, CategoryID, Products.DietaryRestrictions
--into newProducts
--from Products
--where ProductID < 5; # nie kopiuje kluczy obcych i głównych i relacji;

--select ProductID, ProductName, CategoryID, Products.DietaryRestrictions
--into newProducts
--from Products
--where 0=1; # nie kopiuje kluczy obcych i głównych i relacji; # skopiuje strukturę, ale bez danych

--EXEC sp_columns newProducts;

--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'newProducts';

EXEC sp_help [Order Details];
