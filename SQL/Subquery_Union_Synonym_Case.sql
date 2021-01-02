--subquery, union, synonom, case
use [BikeStores]
--Select all customers (first name, lastname, order date) 
--in NY who made at least one order
select c.,o.[order_date]

where c.customer_id
in
(
--subquery: all customers in NY
select
	c.[first_name],c.[last_name],o.order_date,c.city
	,count(o.[order_date]) [number of orders]
from [sales].[customers] c
inner join [sales].[orders] o
on o.customer_id=c.customer_id
--where [city]='New York'

group by c.[first_name],c.[last_name]
,o.[order_date],c.city
order by 5 desc

SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY order_date DESC;

--nested queries
-- select all products where list price is grester than
-- average list price of  and Trek
select[product_name],[list_price]  from [production].[products]
where [list_price]>
(
select avg([list_price])from [production].[products]
where [brand_id] in
(
select [brand_id]
from [production].[brands]
where [brand_name] in ('Strider','Trek'))
--[brand_name] ='Strider' or [brand_name]='Trek')
)
order by 2 desc

----Show the difference between the product 
----price and the average product price

select [product_name]
		,[list_price] - 
		(select avg(list_price) 
		from [production].[products]) [Avg Difference]
from [production].[products]

--home work
--Show the list price compared to the average for that category. 

/*
In place of an expression
With IN or NOT IN
With ANY or ALL
With EXISTS or NOT EXISTS
In UPDATE, DELETE, or INSERT statement
In the FROM clause
*/

--exists in subquery 
 -- select year([order_date]) from [sales].[orders]

select [first_name],[last_name]
,[email],[city]
from [sales].[customers]
where exists (
select 
c.[customer_id]
from [sales].[customers] c
inner join [sales].[orders] s
on s.customer_id=c.customer_id
where  year([order_date]) =2017
)

--en fazla ortalama siparis yapan personel listesi
 select t.[full name],max(t.order_count) [max order by person]
 from
(
 SELECT 
	[first_name] +' '+[last_name] [full name]
	,COUNT(order_id) [order_count]
    FROM sales.orders o 
	inner join [sales].[staffs] s
	on s.staff_id=o.staff_id
    GROUP BY [first_name] +' '+[last_name]
) t
group by t.[full name]
order by 2 desc
----------------------------------end of subquery--------

-- union
select [first_name]+' '+[last_name] [name], 'staff' [type]
from  [sales].[staffs] 
union all
select [first_name]+' '+[last_name] [name], 'customer' [type]
from [sales].[customers]
order by 1

---Synonym
create SYNONYM [orders] for [sales].[orders]

select * from orders

--create database
create database food
on
(
Name=FoodData1,
FileName='C:\FoodData1.mdf',
size=10MB, --KB, MB,GB,TB
maxsize=unlimited,
filegrowth= 1GB
)
log on
(
Name=FoodLog,
FileName='C:\FoodLog1.ldf',
size=10MB, --KB, MB, GB,TB
maxsize=unlimited,
filegrowth= 1024MB 
)

create table snack
( [snack name] varchar(50),
   [amount] int,
   [calories] int
)

--data types
-- char(10) 'Cat       ' --total 10 chars
--varchar(10) 'Cat'

use food
select * from dbo.[snack]

insert [snack]
select 'Cholote Raisins',10,100

insert [snack]
select 'Honeycomb',10,15

create database food2
use food2
create synonym snack for food.dbo.snack

select * from snack
---------------------------------
--SQL Server CASE
/*
CASE input   
    WHEN e1 THEN r1
    WHEN e2 THEN r2
    ...
    WHEN en THEN rn
    [ ELSE re ]   
END  
*/

select  distinct [order_status] from [sales].[orders]
--1: Pending
--2: Processing
--3: Rejected
--4: Completed
 
 SELECT
 CASE [order_status]   
    WHEN 1 THEN 'Pending'
    WHEN 2 THEN 'Processing'
    WHEN 3 THEN 'Rejected'
    ELSE 'Completed'
END [order_status]
,COUNT([order_id]) [order count]
FROM [sales].[orders]
WHERE YEAR([order_date])=2017
GROUP BY [order_status]
order by 2 desc
--------------------------------------

--SQL Server Date Functions
