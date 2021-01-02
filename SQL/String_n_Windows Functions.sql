--String and Windows Functions 4 Ekim
--SQL Server CONCAT()
SELECT 
    'John' + ' ' + 'Doe' AS full_name;
--Using CONCAT() function with NULL
SELECT 
    CONCAT(
        CHAR(13),
        CONCAT(first_name,' ',last_name),
        CHAR(13),
        phone,
        CHAR(13),
        CONCAT(city,' ',[state]),
        CHAR(13),
        zip_code
    ) customer_address
FROM
    sales.customers
ORDER BY 
    first_name,
    last_name;
-----
 --Strings and Collations
 SELECT CASE WHEN 'A'<>'a' collate Latin1_General_CI_AI 
                   THEN 'Different' ELSE 'Same' END

SELECT CASE WHEN 'A'<>'a' collate Latin1_General_CS_AI 
                   THEN 'Different' ELSE 'Same' END
--LEN
SELECT LEN('Who            ')
SELECT LEN('                                       ...than this')--51

--REPLACE
SELECT REPLACE('This string has trailing spaces','S','/')
SELECT LEN(REPLACE('                                       ...than this',' ',''))--51

--PATINDEX
SELECT PATINDEX('%ern%', 'SQL Pattern Index') pos

/*
This example finds the position of the first occurrence of 
the pattern 2018  in values of the product_name column in the production.products
*/
select *
from [production].[products]

select [product_name],PATINDEX('%2018%', [product_name]) pos
from [production].[products]
where  [product_name] like '%2018%'
order by [product_name]

--HOMEWROK:stripping out unwanted extra spaces from a column would have
SELECT  REPLACE(
              REPLACE(
                  REPLACE(
                'this         has            too                          many                               spaces',
           CHAR(32), CHAR(32) + CHAR(160)),
        CHAR(160) + CHAR(32), ''),
     CHAR(160), '')

/*
The STUFF() function deletes a part of a string and 
then inserts a substring into the string, beginning at a specified position.

STUFF (input_string , start_position , length, replace_with_substring)
*/
SELECT STUFF('SQL Tutorial', 1 , 3, 'SQLLL Server') result;

--REPLICATE() function
--function repeats a string a specified number of times
SELECT REPLICATE('z',13) result;

--How to mask a credit card number. It reveals only the last four character
declare @cardnumber varchar(20)='4882584254460197'

select stuff(@cardnumber,1,len(@cardnumber)-4,REPLICATE('X',len(@cardnumber)-4))
[credit card number]

SELECT RIGHT('HELLO WORLD', 3);
SELECT LEFT('HELLO WORLD', 3);
SELECT CHARINDEX('-','Hello- World') pos

--SUBSTRING()
--SUBSTRING() extracts a substring with a specified length starting from a location in an input string.
--SUBSTRING(input_string, start, length);
SELECT SUBSTRING('SQL Server SUBSTRING', 12, Len('SQL Server SUBSTRING')) result;

--How to extract domain names from email addresses of customers @
select [email],SUBSTRING([email],CHARINDEX('@',[email])+1,len([email]))
from [sales].[customers]

SELECT 
    email, 
    SUBSTRING(
        email, 
        CHARINDEX('@', email)+1, 
        LEN(email)-CHARINDEX('@', email)
    ) domain
FROM 
    sales.customers
ORDER BY 
    email;

--homework:How to count the number of emails per domain, you can use the following


--REVERSE
SELECT REVERSE('evil ot sah eh') --palindrom

SELECT REPLACE(REVERSE(
    'evil ot sah eh|hcihw ni|pmaws a ylno sa|nam a fo skniht|mreg a tub|
    nem ot elbanoitcejbo|yrev era smreg'),'|','
    ')

SELECT RIGHT(URL, CHARINDEX('/',REVERSE(URL) +'/')-1)
    FROM 
     (
     SELECT
     [URL]='http://www.simple-talk.com/content/article.aspx?article=495'
)f

/*
Intro Windows Functions
These functions are part of the ANSI SQL 2003 Standards and, 
in the case of SQL Server, are T-SQL functions used to write queries. 

They have nothing to do with the Windows operating system or any API calls. 
Other database systems, such as Oracle, 
have also included these as part of their own SQL language.
These functions perform a calculation over a set of rows.
The window is defined by the OVER clause which determines 
if the rows are partitioned into smaller sets and if 
they are ordered. 

if you use a window function you will always use an OVER clause. 
The OVER clause may contain a PARTITION BY option. 
This breaks the rows into smaller sets.
It is not is the same as GROUP BY clause
GROUP BY clause: one row per unique group is returned
PARTITION BY: all of the detail rows are returned along with the calculations
*/

--OVER and PARTITION BY clause

CREATE TABLE PERSON
(FIRSTNAME VARCHAR(50)
,GENDER VARCHAR(1)
,BIRTHDATE SMALLDATETIME
,HEIGHT SMALLINT
,[WEIGHT] SMALLINT);

INSERT INTO PERSON VALUES('ROSEMARY','F','2000-05-08',35,123);     
INSERT INTO PERSON VALUES('LAUREN','F','2000-06-10',54,876);     
INSERT INTO PERSON VALUES('ALBERT','M','2000-08-02',45,150);     
INSERT INTO PERSON VALUES('BUDDY','M','1998-10-02',45,189);   
INSERT INTO PERSON VALUES('FARQUAR','M','1998-11-05',76,198);     
INSERT INTO PERSON VALUES('TOMMY','M','1998-12-11',78,167);     
INSERT INTO PERSON VALUES('SIMON','M','1999-01-03',87,256);

select * from [dbo].[PERSON]

--Create a column containing row counts within gender 
/*
FIRSTNAME	GENDER	BIRTHDATE	HEIGHT	WEIGHT	GENDER_COUNTS
ROSEMARY	F		2000-05-08 	35		123			2
LAUREN		F		2000-06-10 	54		876			2
---------------------------------------------------------
ALBERT		M		2000-08-02 	45		150			5
BUDDY		M		1998-10-02  45		189			5
FARQUAR		M		1998-11-05  76		198			5
TOMMY		M		1998-12-11 	78		167			5
SIMON		M		1999-01-03 	87		256			5
*/

--select into 
select GENDER, count(*) [gender count]
into PERSON_COUNT_BY_GENDER
from  PERSON
group by gender

select * from [PERSON_COUNT_BY_GENDER]

--Now need to merge this data against PERSON data
select p.*,pg.[gender count]
from [dbo].[PERSON] p
inner join [dbo].[PERSON_COUNT_BY_GENDER] pg
on pg.GENDER=p.GENDER

--Do this using Windows Functions (Analytic Function)
--no inner join and no creation of a table
select p.*, count(*) over (partition by p.gender)[gender count]
from [dbo].[PERSON] p

--Calculate running totals of weight by gender
/*
GENDER FIRSTNAME	WEIGHT WT_RUN
F		ROSEMARY	123		123
F		LAUREN		876		999
-------------------------------
M		ALBERT		150		150
M		TOMMY		167		317
M		BUDDY		189		506
M		FARQUAR		198		704
M		SIMON		256		960

*/
select p.GENDER,p.FIRSTNAME,p.[WEIGHT] 
	   ,sum(p.[WEIGHT]) over(partition by p.gender order by p.[WEIGHT]) [WEIGHT RUN]
from [dbo].[PERSON] p
--order by p.GENDER,p.[WEIGHT]
/*
 How does PARTITION BY Clause work?
-Also called Query Partition Clause
-Similar to the GROUP BY Clause
-Breaks up data into chunks (or partitions)
-Separated by partition boundary
-Function performed within partitions
-Re-initialized when crossing partition boundary
Syntax function(…) OVER (PARTITION BY col1,col2,…)
Functions such as COUNT(), SUM(), MIN(), MAX(), etc.
New functions ROW_NUMBER(), RATIO_TO_REPORT()
*/

--creata a column containing gender birthdate year
select p.[FIRSTNAME],[GENDER],year([BIRTHDATE]) [BIRTHDATE],[HEIGHT],[WEIGHT]
,count(*) over(PARTITION BY p.gender, year([BIRTHDATE])) [gender count by birthdate]
from [dbo].[PERSON] p

--ozet
/*
-PARTITION BY Clause breaks rows into chunks
-Allows for within-chunk computations
-No reduction in data! 7 in, 7 out
*/
