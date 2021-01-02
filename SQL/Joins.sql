-- SQL JOIN

SELECT [product_id], [model_year], [list_price], [category_name]
FROM [production].[products] AS p 
INNER JOIN [production].[categories] AS c
ON c.category_id = p.category_id

SELECT [product_id], [model_year], [list_price], [category_name]
FROM [production].[products] AS p 
LEFT JOIN [production].[categories] AS c
ON c.category_id = p.category_id

-- TRIPLE JOIN

SELECT [product_id], [model_year], [list_price], [category_name],[brand_name]
FROM [production].[products] AS p 
INNER JOIN [production].[categories] AS c
ON c.category_id = p.category_id
INNER JOIN [production].[brands] AS b
ON b.brand_id = p.brand_id
ORDER BY brand_name DESC;

SELECT [product_id], [model_year], [list_price], [category_name], [brand_name]
FROM [production].[products] AS p 
INNER JOIN [production].[categories] AS c
ON c.category_id = p.category_id
INNER JOIN [production].[brands] AS b
ON b.brand_id = p.brand_id
WHERE c.category_id = 5
ORDER BY brand_name DESC;

SELECT *                                               -- first join
FROM [production].[products] AS p 
INNER JOIN [production].[categories] AS c
ON c.category_id = p.category_id

SELECT *
FROM [production].[products] AS p                      -- second join on first join = triple join
INNER JOIN [production].[categories] AS c
ON c.category_id = p.category_id
INNER JOIN [production].[brands] AS b
ON b.brand_id = p.brand_id

-- INSERT

INSERT INTO table_name (column_list)
VALUES (value_list)

INSERT INTO table_name (a, b, c)
VALUES (001, 'John', 'Bush')

-- CREATE

CREATE TABLE sales.promotions
(promotion_id INT PRIMARY KEY IDENTITY(1,1),                -- start from 1 and goes 1+1+1
promotion_name VARCHAR (30) NOT NULL,                       -- it's len can be 30 max.
discount SMALLINT DEFAULT 0,
[start_date] DATE NOT NULL,
expire_date DATE NOT NULL,
)

SELECT *
FROM [sales].[promotions]

-- INSERT

INSERT INTO [sales].[promotions] ([promotion_name], [discount], [start_date], [expire_date])
VALUES ('2020 Summer Promo', 0.25, '20201001', '20201231')

-- DROP

DROP TABLE [sales].[promotions]

CREATE TABLE sales.promotions
(promotion_id INT PRIMARY KEY IDENTITY(1,1),                -- start from 1 and goes 1+1+1
promotion_name VARCHAR (30) NOT NULL,                       -- it's len can be 30 max.
discount DECIMAL(3,2) DEFAULT 0,                            -- 3 char. 2 after zero
[start_date] DATE NOT NULL,
expire_date DATE NOT NULL,
)

SELECT *
FROM [sales].[promotions]

INSERT INTO [sales].[promotions] ([promotion_name], [discount], [start_date], [expire_date])
VALUES ('2020 Summer Promo', 0.25, '20201001', '20201231')

INSERT INTO [sales].[promotions] ([promotion_name], [start_date], [expire_date])
VALUES ('2020 Summer Super Promo', '20201001', '20201231')

SELECT *
FROM [sales].[promotions]

-- UPDATE

UPDATE table_name
set column1 = 'abc', column2 = 25 ....
WHERE ...........

SELECT *
FROM [sales].[promotions]
WHERE promotion_name = '2020 Summer Promo'

UPDATE [sales].[promotions]
SET discount = 0.10                          -- update value 0.25 to 0.10
WHERE promotion_name = '2020 Summer Promo'

SELECT *
FROM [sales].[promotions]
WHERE promotion_name = '2020 Summer Promo'

SELECT *                                     -- control with WHERE clause before update
FROM [sales].[promotions]
WHERE promotion_name = '2020 Summer Super Promo'


UPDATE [sales].[promotions]
SET discount = 0.05                          -- update value 0.00 to 0.05
WHERE promotion_name = '2020 Summer Super Promo'

SELECT *                                     -- control with WHERE clause after update
FROM [sales].[promotions]
WHERE promotion_name = '2020 Summer Super Promo'

SELECT * 
FROM [sales].[promotions]

-- MULTIPLE COLUMN UPDATE

UPDATE [sales].[promotions]
SET discount = 0.45,
promotion_name = '2020 Damping'
WHERE promotion_name = '2020 Summer Promo'

SELECT * 
FROM [sales].[promotions]

UPDATE [sales].[promotions]
SET discount = 0.55,
expire_date = '20301231'
WHERE promotion_name = '2020 Damping'

SELECT * 
FROM [sales].[promotions]

-- DELETE

SELECT *                                -- control before delete
FROM [sales].[promotions]
WHERE promotion_name = '2020 Damping'

DELETE FROM [sales].[promotions]
WHERE promotion_name = '2020 Damping'

SELECT * 
FROM [sales].[promotions]

-- DELETE FROM [sales].[promotions]         -- it deletes all data. it takes log.

-- TRUNCATE TABLE                           -- it deletes all data in the table. it doesn't take log.
