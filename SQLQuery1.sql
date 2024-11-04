use AdventureWorks2019;
/*
select * from Person.Address
*/
--select * from Person.Address
--select * from Person.Address where StateProvinceID >80 order by StateProvinceID, 


select count(*) as numberOfAddressesFromProvince, StateProvinceID from Person.Address where StateProvinceID >80 group by StateProvinceID  order by numberOfAddressesFromProvince DESC, StateProvinceID