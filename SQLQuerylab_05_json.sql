use Northwind;
ALTER TABLE Products
ADD DietaryRestrictions NVARCHAR(MAX);

DECLARE @json1 NVARCHAR(MAX) = N'{
    "GlutenFree": false,
    "Vegan": true,
    "DairyFree": true
}';

DECLARE @json2 NVARCHAR(MAX) = N'{
    "GlutenFree": true,
    "Vegan": false,
    "DairyFree": true
}';

DECLARE @json3 NVARCHAR(MAX) = N'{
    "GlutenFree": true,
    "Vegan": true,
    "DairyFree": false
}';

DECLARE @json4 NVARCHAR(MAX) = N'{
    "GlutenFree": true,
    "Vegan": true,
    "DairyFree": true
}';

DECLARE @json5 NVARCHAR(MAX) = N'{
    "GlutenFree": false,
    "Vegan": true,
    "DairyFree": false
}';

DECLARE @json6 NVARCHAR(MAX) = N'{
    "GlutenFree": true,
    "Vegan": false,
    "DairyFree": false
}';

DECLARE @json7 NVARCHAR(MAX) = N'{
    "GlutenFree": false,
    "Vegan": false,
    "DairyFree": true
}';


UPDATE Products
SET DietaryRestrictions = @json1
WHERE ProductID between 1 and 20;

UPDATE Products
SET DietaryRestrictions = @json2
WHERE ProductID between 21 and 30;

UPDATE Products
SET DietaryRestrictions = @json3
WHERE ProductID between 31 and 40;

UPDATE Products
SET DietaryRestrictions = @json4
WHERE ProductID between 41 and 50;

UPDATE Products
SET DietaryRestrictions = @json5
WHERE ProductID between 51 and 60;

UPDATE Products
SET DietaryRestrictions = @json6
WHERE ProductID between 61 and 70;

UPDATE Products
SET DietaryRestrictions = @json7
WHERE ProductID between 71 and 80;