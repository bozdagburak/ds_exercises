USE [BikeStores]
GO

/****** Object:  Table [dbo].[PERSON]    Script Date: 10/10/2020 19:15:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PERSON](
	[FIRSTNAME] [varchar](50) NULL,
	[GENDER] [varchar](1) NULL,
	[BIRTHDATE] [smalldatetime] NULL,
	[HEIGHT] [smallint] NULL,
	[WEIGHT] [smallint] NULL
) ON [PRIMARY]
GO


select * from [dbo].[FAMILY]

/* Example #2 */
 --Spin thru FAMILY table starting at PARENT_KEY IS NULL and give item at which level is.
 WITH RSFC(child_k,parent_k,[level]) AS (
   SELECT CHILD_KEY,PARENT_KEY,0 as [level]
    FROM FAMILY
    WHERE PARENT_KEY IS NULL
   UNION ALL
   SELECT CHILD_KEY,PARENT_KEY,[level]+1
    FROM RSFC R INNER JOIN FAMILY F
    ON R.child_k = F.PARENT_KEY
  )
  SELECT *
   FROM RSFC

--Spin thru COMPANY table starting at MANAGER_ID=3
 select *  from [dbo].[COMPANY]

 WITH COMP(empid,ename,mgrid,lvl) AS (
 --anchor query
 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,
        MANAGER_ID,0 as lvl
  FROM COMPANY
  WHERE MANAGER_ID=3
 
 UNION ALL
 
 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,
        MANAGER_ID,lvl+1
  FROM COMP R INNER JOIN COMPANY C
  ON C.MANAGER_ID = R.empid
)
SELECT *
 FROM COMP

-- Adding in the manager's name 
WITH COMP(empid,ename,mgrid,lvl) AS (
 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,MANAGER_ID,0 as lvl
  FROM COMPANY
  WHERE MANAGER_ID=3
 
 UNION ALL
 
 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,MANAGER_ID,lvl+1
  FROM COMP R INNER JOIN COMPANY F
  ON F.MANAGER_ID = R.empid
)
SELECT A.EMPID,A.ENAME,A.MGRID,A.LVL,
       B.EMPLOYEE_NAME AS MGR_NAME
 FROM COMP A LEFT JOIN COMPANY B
 ON A.MGRID=B.EMPLOYEE_ID
 ORDER BY A.LVL,A.EMPID
 ---------------------------------------

 --fact(n)= n*fact(n-1) 5!= 5*4!=5*4*3!
 WITH RSFC(ITERATION,RUNNING_FACTORIAL) AS (
  SELECT NUM AS ITERATION,
         1 AS RUNNING_FACTORIAL
   FROM NUMBERS
   WHERE NUM = 1
  UNION ALL
  SELECT R.ITERATION+1,
         R.RUNNING_FACTORIAL * B.NUM
   FROM RSFC R INNER JOIN NUMBERS B
   ON (R.ITERATION+1) = B.NUM
 )
 SELECT ITERATION,RUNNING_FACTORIAL
  FROM RSFC
  OPTION (MAXRECURSION 2)
---------------------------------------
--SQL Server PIVOT
SELECT 
    category_name, 
    COUNT(product_id) product_count
FROM 
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id
GROUP BY 
    category_name;

--Introduction to SQL Server PIVOT operator
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;
-------------------------------------------------
--adding model year
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;
--------------------------------------------
--Dynamic pivot tabl

--Generating column values
DECLARE 
    @columns NVARCHAR(MAX) = '',
	@sql     NVARCHAR(MAX) = '';

SELECT 
    @columns += QUOTENAME(category_name) + ','
FROM 
    production.categories
ORDER BY 
    category_name;

SET @columns = LEFT(@columns, LEN(@columns) - 1);

PRINT @columns;
-----------------------------------

-- construct dynamic SQL 

SET @sql ='
SELECT * FROM   
(
    SELECT 
        category_name, 
        model_year,
        product_id 
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN ('+ @columns +')
) AS pivot_table;';

print @sql;

-- execute the dynamic SQL
EXECUTE sp_executesql @sql;

--Homework: make an UNPIVOT example query

--Why learn the MERGE Statement?
--Allows you to perform INSERTs, UPDATEs and DELETEs in one SQL statement
--Can add additional criteria using AND or WHERE to ensure
--appropriate data is being affected
--Useful for DBAs
--Useful for Master/Reference Data Management
DROP TABLE PERSON;
CREATE TABLE PERSON(FIRSTNAME VARCHAR(50),GENDER VARCHAR(1),BIRTHDATE SMALLDATETIME,HEIGHT SMALLINT,WEIGHT SMALLINT);
INSERT INTO PERSON VALUES('ROSEMARY','F','2000-05-08',35,123);     
INSERT INTO PERSON VALUES('LAUREN','F','2000-06-10',54,876);     
INSERT INTO PERSON VALUES('ALBERT','M','2000-08-02',45,150);     
INSERT INTO PERSON VALUES('BUDDY','M','1998-10-02',45,189);   
INSERT INTO PERSON VALUES('FARQUAR','M','1998-11-05',76,198);     
INSERT INTO PERSON VALUES('TOMMY','M','1998-12-11',78,167);     
INSERT INTO PERSON VALUES('SIMON','M','1999-01-03',87,256);

--Table: CHANGES 
DROP TABLE CHANGES;
CREATE TABLE CHANGES(FIRSTNAME VARCHAR(50),GENDER VARCHAR(1),BIRTHDATE SMALLDATETIME,HEIGHT SMALLINT,WEIGHT SMALLINT);
INSERT INTO CHANGES VALUES('BOB','M','2010-06-12',55,125); -- INSERT 
INSERT INTO CHANGES VALUES('LAUREN',NULL,NULL,NULL,850); --UPDATE

-- Update PERSON using CHANGES table
MERGE
 INTO PERSON A
 USING CHANGES B
 ON (A.FIRSTNAME=B.FIRSTNAME)
 WHEN MATCHED THEN
  UPDATE SET A.WEIGHT=B.WEIGHT
 WHEN NOT MATCHED THEN
  INSERT(FIRSTNAME,GENDER,BIRTHDATE,HEIGHT,WEIGHT) 
  VALUES(B.FIRSTNAME,B.GENDER,B.BIRTHDATE,B.HEIGHT,B.WEIGHT);

  select * from PERSON
  --DELETE SIMON at the same time! 