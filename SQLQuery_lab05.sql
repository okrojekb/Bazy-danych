use Northwind;

select * from Products
where JSON_VALUE(DietaryRestrictions, '$.Vegan') = 'false';

select * from Products
where JSON_VALUE(DietaryRestrictions, '$.Vegan') = 'true'
and JSON_VALUE(DietaryRestrictions, '$.DairyFree') = 'true';

