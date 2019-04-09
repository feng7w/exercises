use world;

# 根据countrycode将三张表进行组合，计算出left join 的数据条数
select count(*) from city 
left join country 
on city.CountryCode = country.Code 
left join countrylanguage 
on city.CountryCode = countrylanguage.CountryCode;

# 根据countrycode将三张表进行组合，计算出full outer join 的数据条数 
# 左连接 union 右连接
create table if not exists full_outer as (
select ID,city.Name as city_Name ,city.CountryCode as city_CountryCode,District,city.Population as city_Population,country.* from city
left join country 
on city.CountryCode = country.Code 
union
(select ID,city.Name as city_Name ,city.CountryCode as city_CountryCode,District,city.Population as city_Population,country.* from city
right join country
on city.CountryCode = country.Code));

create table if not exists full_outer2 as (
select * from full_outer 
left join countrylanguage
on full_outer.city_CountryCode = countrylanguage.CountryCode
union
(select * from full_outer
right join countrylanguage
on full_outer.city_CountryCode = countrylanguage.CountryCode));

select count(*) from full_outer2;

# 根据countrycode将三张表进行组合，计算出inner join 的数据条数
select * from city 
inner join country on city.CountryCode = country.Code 
inner join countrylanguage 
on city.CountryCode = countrylanguage.CountryCode;

# 将上题 inner join 筛选结果插入到一张临时表中，注意：该表不可以有重复的字段。
create table if not exists linshibiao as select
ID,a.Name as city_Name ,a.CountryCode as city_CountryCode,District,a.Population as city_Population,
Code,b.Name as country_Name,Continent,Region,SurfaceArea,IndepYear,b.Population as country_Population,LifeExpectancy,GNP,GNPOld,LocalName,GovernmentForm,HeadOfState,Capital,Code2,
c.CountryCode as countrylanguage_CountryCode,Language,IsOfficial,Percentage 
from city as a
inner join country as b 
on a.CountryCode = b.Code 
inner join countrylanguage as c
on a.CountryCode = c.CountryCode;

# 在country表中，对region进行分组，筛选出分组内数据条数大于5的数据，对于满足条件的组计算population的平均数,GNP的平均数
select Region,avg(Population)as avg_Pop,avg(GNP) as avg_GNP,count(Region) as count_Region from country group by Region having count(Region) > 5;