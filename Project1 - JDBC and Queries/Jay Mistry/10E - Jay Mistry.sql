--Jay Mistry
--23859979
--CSCI 331 10:45 Group 10E


/*
Problem 1: Using AdventureWorks2017, list the top 10 paid employees' 
		   job title, gender and salary in descending order of their salary. 
		   This query will be used to examine the top paid employees and see
		   if there is a wage gap among different genders.
*/
USE AdventureWorks2017;
SELECT TOP 10 E.JobTitle as [Job Title], E.Gender, (P.Rate * P.PayFrequency) as Salary
FROM HumanResources.Employee as E
	INNER JOIN HumanResources.EmployeePayHistory as P
		ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY Salary DESC;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Top10 Paid Employees:'), INCLUDE_NULL_VALUES;



/*
Problem 2: Using AdventureWorksDW2017, list all the single male 
           customers' full name from British Columbia in order of
		   their last name. This query will be used to determine 
		   the number of single male customers in British Columbia.
*/
USE AdventureWorksDW2017;
SELECT C.FirstName as [First Name], C.LastName as [Last Name]
FROM dbo.DimCustomer as C
	 INNER JOIN dbo.DimGeography as G
		ON C.GeographyKey = G.GeographyKey
WHERE C.gender = N'M' and C.MaritalStatus = N'S' 
	  and G.StateProvinceName = N'British Columbia'
ORDER BY C.LastName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Male Customers in British Columbia: '), INCLUDE_NULL_VALUES;



/*
Problem 3: Using Northwinds2022TSQLV7, list the names and order id of customers
	       who ordered from the UK in 2016. This query will be used to count how 
		   many orders were sent to the UK in 2016.
*/
USE Northwinds2022TSQLV7;
SELECT C.CustomerCompanyName as [Name], O.orderid as [Order ID]
FROM Sales.[Order] as O
	INNER JOIN Sales.[Customer] as C
		ON O.CustomerId = C.CustomerId
WHERE O.ShipToCountry = N'UK' AND O.orderdate >= '20160101' AND O.orderdate < '20170101'
GROUP BY C.CustomerCompanyName, O.orderid
ORDER BY C.CustomerCompanyName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Orders sent to UK in 2016:'), INCLUDE_NULL_VALUES;



/*
Problem 4: Using WideWorldImporters, list distinct customer names who
		   have a credit limit, their expected delivery date in the second 
		   half of 2016 and their credit limit. Order by credit limit. This 
		   query can be used to determine the customers who have a credit limit 
		   and had a delivered order in January or February 2016.
*/
USE WideWorldImporters;
SELECT DISTINCT C.CustomerName as [Customer Name], C.CreditLimit as [Credit Limit]
FROM Sales.Customers as C
	INNER JOIN Sales.Orders as O
		ON C.CustomerId = O.CustomerId
WHERE C.CreditLimit is not NULL and O.ExpectedDeliveryDate >= '20160601'
	 AND O.ExpectedDeliveryDate < '20170101'
ORDER BY C.CreditLimit;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Customers with credit limit and delivery date:'), INCLUDE_NULL_VALUES;



/*
 Problem 5: Using WideWorldImportersDW, list the name of all the customers
			who have brought a 'DBA joke mug - mind if I join you? (Black)' mug 
			and the quantity they brought in descending order. This query can be used 
			to figure out how popular the mugs were.
*/
USE WideWorldImportersDW;
SELECT C.[Primary Contact] as [Customer], COUNT(C.[Primary Contact]) as [Number of Mugs]
FROM Fact.[Order] as O
	INNER JOIN Dimension.Customer as C
		ON C.[Customer Key] = O.[Customer Key]
WHERE C.[Customer Key] != 0 
	  and O.[Description]  LIKE N'%DBA joke mug - mind if I join you? (Black)%'
GROUP BY C.[Primary Contact]
ORDER BY COUNT(C.[Primary Contact]) DESC;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Popularity of Mugs:'), INCLUDE_NULL_VALUES;



-- Medium Problems: 2 - 3 tables joined with built-in SQL functions
/*
 Problem 6: Using AdventureWorks2017, sum up the number of sick leave hours
			by gender and the average rate if their rate was greater than $20. 
			Group by their gender. This query can be used to determine if there's a 
			rate sick hour difference amongst gender and its impact on rate.
*/
USE AdventureWorks2017;
SELECT E.Gender, SUM(E.SickLeaveHours) as [Sick Leave Hours], AVG(P.Rate) as Rate
FROM HumanResources.Employee as E
	INNER JOIN HumanResources.EmployeePayHistory as P
		ON E.BusinessEntityID = P.BusinessEntityID
WHERE P.Rate > 20
GROUP BY E.Gender;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Number of Sick Leave hours:'), INCLUDE_NULL_VALUES;



/*
 Problem 7: Using AdventureWorksDW2017, list the number of parents in each
		    of the countries in ascending order of number of parents. This 
			query can be used for census purposes.
*/
USE AdventureWorksDW2017;
SELECT G.EnglishCountryRegionName as [Country],
	   COUNT(G.EnglishCountryRegionName) as [Number of Parents in the Region]
FROM dbo.DimCustomer as C
	 INNER JOIN dbo.DimGeography as G
		ON C.GeographyKey = G.GeographyKey
WHERE C.TotalChildren > 0
GROUP BY G.EnglishCountryRegionName
ORDER BY COUNT(G.EnglishCountryRegionName);
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Number of Parents:'), INCLUDE_NULL_VALUES;



/*
 Problem 8: Using Northwinds2022TSQLV7, list the name of customers who had a difference 
			of at least 30 days between order date and shipped date along with their 
			order id and date difference in ascending order. This query can be used 
			to evaluate shipping efficiencies.
*/
USE Northwinds2022TSQLV7;
SELECT C.CustomerCompanyName as [Name], O.orderid as [Order ID], 
	   DATEDIFF(day, O.orderdate, O.ShipToDate) as [Date Difference]
FROM Sales.[Order] as O
	INNER JOIN Sales.[Customer] as C
		ON O.CustomerId = C.CustomerId
WHERE DATEDIFF(day, O.orderdate, O.ShipToDate) >= 30
ORDER BY DATEDIFF(day, O.orderdate, O.ShipToDate), C.CustomerCompanyName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Name of Customers:'), INCLUDE_NULL_VALUES;



/*
 Problem 9: Using WideWorldImporters, find individual customers (not toy stores)
			who ordered in 2013 and waited more than a day for their order to be delivered. 
			This query can be used to examine delivery efficiency.
*/
USE WideWorldImporters;
SELECT C.CustomerName as [Customer Name], O.ExpectedDeliveryDate as [Expected Delivery Date]
FROM Sales.Customers as C
	INNER JOIN Sales.Orders as O
		ON C.CustomerId = O.CustomerId
WHERE DATEDIFF(day, O.orderdate, O.ExpectedDeliveryDate) > 1 
		and O.orderdate >= '20130101' and O.orderdate < '20130201'
		and C.CustomerName not LIKE '%toys%'
ORDER BY O.ExpectedDeliveryDate;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of Customers:'), INCLUDE_NULL_VALUES;



/*
 Problem 10: Using WideWorldImportersDW, list the different "The Gu" red shirts
			 bought at the Belgreen, AL location of Tailspin Toys, the quantity 
			 brought and the sum of sales accumulated in ascending order. This query 
			 can be used to determine which size is most profitable.
*/
USE WideWorldImportersDW;
SELECT O.[Description], COUNT(O.[Description]) as [Quantity],
	   SUM(O.[Total Including Tax]) as [Sum of Sales]
FROM Fact.[Order] as O
	INNER JOIN Dimension.Customer as C
		ON C.[Customer Key] = O.[Customer Key]
WHERE C.Customer LIKE '%Belgreen%' and O.[Description]  LIKE N'"The Gu%'
GROUP BY O.[Description]
ORDER BY SUM(O.[Total Including Tax]) DESC;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of different shirts:'), INCLUDE_NULL_VALUES;



/*
 Problem 11: Using AdventureWorks2017, list the SalesYTD rounded to the 
			 thousandths for each of the salesperson, ordered by SalesYTD 
			 and last name. This query can be used to determine who is making 
			 the most sale.
*/
USE AdventureWorks2017;
SELECT CONCAT(P.FirstName, ' ',P.LastName) as [Name], ROUND(T.SalesYTD,-3) as [SalesYTD]
FROM Sales.SalesPerson as S
	INNER JOIN Person.Person as P
		ON S.BusinessEntityID = P.BusinessEntityID
	INNER JOIN Sales.SalesTerritory as T
		ON S.TerritoryID = T.TerritoryID
GROUP BY P.LastName, P.FirstName, T.SalesYTD
ORDER BY T.SalesYTD, P.LastName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('SalesYTD:'), INCLUDE_NULL_VALUES;



/*
 Problem 12: Using AdventureWorksDW2017, list the number of non-American
			 professionals who own 3 or more cars by country in ascending order.
			 This query can be used for car data census.
*/
USE AdventureWorksDW2017;
SELECT G.EnglishCountryRegionName as [Country],
       COUNT(C.EnglishOccupation) as [Number of Professionals]
FROM dbo.DimCustomer as C
	 INNER JOIN dbo.DimGeography as G
		ON C.GeographyKey = G.GeographyKey
WHERE G.EnglishCountryRegionName != N'United States' 
		and C.EnglishOccupation = N'Professional'
		and C.NumberCarsOwned >= 3
GROUP BY G.EnglishCountryRegionName, C.EnglishOccupation
ORDER BY G.EnglishCountryRegionName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Car data census:'), INCLUDE_NULL_VALUES;



/*
 Problem 13: Using Northwinds2022TSQLV7, list the customers who placed at least 20 orders
             and the number of orders. This query can be used to indicate who is making the 
			 most orders.
*/
USE Northwinds2022TSQLV7;
SELECT C.CustomerContactName AS [Name], COUNT(O.OrderId) AS [Number of Orders]
FROM Sales.[Customer] AS C
	INNER JOIN Sales.[Order] AS O
		ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerContactName
HAVING COUNT(O.orderid) >= 20
ORDER BY COUNT(O.orderid), C.CustomerContactName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of Customers:'), INCLUDE_NULL_VALUES;



/*
 Problem 14: Using WideWorldImporters, list the non toy store customers who
             have ordered in the first two months of 2014 and had an average transaction
			 less than -3000 in the time frame in ascending order. This query can determine 
			 who is making the most purchase in the first two months of 2014.
*/
USE WideWorldImporters;
SELECT C.CustomerName as [Customer Name], AVG(T.TransactionAmount) as [Avg. Transaction]
FROM Sales.Customers as C
	INNER JOIN Sales.Orders as O
		ON C.CustomerId = O.CustomerId
	INNER JOIN Sales.CustomerTransactions as T
		ON C.CustomerId = T.CustomerId
WHERE T.TaxAmount = 0 and O.OrderDate >= '20140101' and O.Orderdate < '20140301'
	  and C.CustomerName NOT LIKE N'Wingtip%' and C.CustomerName NOT LIKE N'Tailspin%'
GROUP BY C.CustomerName
HAVING AVG(T.TransactionAmount) < -3000
ORDER BY AVG(T.TransactionAmount);
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of non toy store customers:'), INCLUDE_NULL_VALUES;



/*
 Problem 15: Using WideWorldImportersDW, list the customers who brought a medium
			 blue jacket in July and the quantity as well as the salesperson associated.
			 This query can be used to determine which salesperson is making an effort to sell
			 a jacket in the summer.
*/
USE WideWorldImportersDW;
SELECT S.[SalesPerson Key] as [Salesperson Key], C.[Customer],  O.Quantity, O.[Order Date Key]
FROM Fact.[Order] as O
	INNER JOIN Dimension.Customer as C
		ON C.[Customer Key] = O.[Customer Key]
	INNER JOIN Fact.Sale as S
		ON S.[SalesPerson Key] = O.[SalesPerson Key]
WHERE C.[Customer Key] != 0 and O.[Description] LIKE N'%jacket (Blue) M%' 
      and MONTH(O.[Order Date Key]) = 7
GROUP BY S.[SalesPerson Key], C.[Customer], O.Quantity, O.[Order Date Key]
ORDER BY S.[SalesPerson Key], O.[Order Date Key];
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of Customers and the salesperson:'), INCLUDE_NULL_VALUES;



-- Complex Problems
/*
 Problem 16: Construct a function that will take in a date and return the 
			 number of years in between then and the current date. Using this function
			 and AdventureWorks2017, list the name, rate and number of years worked by each
			 Human Resources employee up to the present day in order of number of years.
			 This query can be used to determine which employees were here for the longest time
			 and if there's a wage difference amongst people who been in the company longer than those
			 who been in the company for a shorter time.
*/
USE AdventureWorks2017;

IF OBJECT_ID (N'dbo.YearsAtWork', N'FN') IS NOT NULL
	DROP FUNCTION YearsAtWork
GO
CREATE FUNCTION dbo.YearsAtWork(@originaldate date)
RETURNS INT 
AS
BEGIN
	DECLARE @years int;
	SELECT @years = DATEDIFF(year, @originaldate, GETDATE())
	FROM HumanResources.Employee
	WHERE HireDate = @originaldate
	RETURN @years;
END;
GO

SELECT CONCAT(P.FirstName, ' ', P.LastName) as [Name], H.Rate, 
       dbo.YearsAtWork(E.HireDate) as [Years at Company]
FROM HumanResources.Employee as E
INNER JOIN Person.Person as P
	ON E.BusinessEntityID = P.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory as H
	ON E.BusinessEntityID = H.BusinessEntityID
ORDER BY dbo.YearsAtWork(E.HireDate), H.Rate, P.LastName;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('List of HR Employees:'), INCLUDE_NULL_VALUES;



/*
 Problem 17: Construct a function to create and populate a table with products
			 purchased, the quantity, and average price a single parent has brought.
			 Using the function and AdventureWorksDW2017, display the products, price and 
			 quantity where the latter two are in ascending order. This query can be used to 
			 determine the popularity of products single parents buy.
*/
USE AdventureWorksDW2017;

DROP TABLE IF EXISTS dbo.SingleParentPurchases;
CREATE TABLE dbo.SingleParentPurchases(
	ProductName nvarchar(50) not null,
	Quantity int not null,
	Price float not null
	CONSTRAINT productname_pk PRIMARY KEY (ProductName)
);

INSERT INTO dbo.SingleParentPurchases(ProductName,Quantity,Price)
SELECT  P.EnglishProductName as [Product Name], COUNT(P.EnglishProductName) as Quantity, 
        AVG(I.SalesAmount) as Price
FROM dbo.FactInternetSales as I
	INNER JOIN dbo.DimCustomer as C
		ON I.CustomerKey = C.CustomerKey
	INNER JOIN dbo.DimProduct as P
		ON I.ProductKey = P.ProductKey
WHERE C.MaritalStatus = N'S' and C.TotalChildren > 0
GROUP BY P.EnglishProductName; 

SELECT ProductName as [Product], Quantity, Price
FROM dbo.SingleParentPurchases
ORDER BY Price, Quantity;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Popularity of Products:'), INCLUDE_NULL_VALUES;



/*
 Problem 18: Write a function that computes the total amount of money a customer
			 spent. Using the function and Northwinds2022TSQLV7, list the top 5 buyers
			 rounded to the thousandths, the total amount they spent in descending order and
			 their shipping city. This query can be used to determine who is spending the most 
			 money at a store and how much they're spending
*/
USE Northwinds2022TSQLV7;

IF OBJECT_ID (N'dbo.TotalMoneySpent', N'FN') IS NOT NULL
	DROP FUNCTION TotalMoneySpent
GO
CREATE FUNCTION dbo.TotalMoneySpent(@name VARCHAR(50)) 
RETURNS FLOAT
AS
BEGIN
	DECLARE @total float
	SELECT @total = SUM(OD.unitprice * OD.Quantity)
	FROM Sales.[Order] as O
	INNER JOIN Sales.[OrderDetail] as OD
		ON O.orderid = OD.orderid
	INNER JOIN Sales.[Customer] as C
		ON O.CustomerId = C.CustomerId
	WHERE C.CustomerContactName = @name
	RETURN @total;
END;
GO
SELECT TOP 5 C.CustomerContactName as [Name], 
       ROUND(dbo.TotalMoneySpent(C.CustomerContactName),-3) as [Total Spent], O.ShipToCity as City
FROM Sales.[Order] as O
	INNER JOIN Sales.[OrderDetail] as OD
		ON O.orderid = OD.orderid
	INNER JOIN Sales.[Customer] as C
		ON O.CustomerId = C.CustomerId
GROUP BY C.CustomerContactName, O.ShipToCity
ORDER BY dbo.TotalMoneySpent(C.CustomerContactName) DESC;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Total amount spent by a Customer:'), INCLUDE_NULL_VALUES;



/*
 Problem 20: Write a function that will create and populate a table of customers
			 who do not go over their credit limit, their category name and shop number.
			 Use the function and WideWorldImporters to create the table and then display it.
			 This query can be used to indicator who is in good standings with their credit limit.
*/
USE WideWorldImporters;

DROP TABLE IF EXISTS dbo.RecentGoodStandings;
CREATE TABLE dbo.RecentGoodStandings(
	CustomerName nvarchar(100) not null,
	CustomerCategoryName nvarchar(50) not null,
	ShopNumber nvarchar(50) not null
	CONSTRAINT customername_pk PRIMARY KEY (CustomerName)
);

INSERT INTO dbo.RecentGoodStandings(CustomerName,CustomerCategoryName,ShopNumber)
SELECT DISTINCT C.CustomerName as CustomerName, 
				CC.CustomerCategoryName as CustomerCategoryName, 
				C.DeliveryAddressLine1 as ShopNumber
FROM Sales.CustomerTransactions as CT
	INNER JOIN Sales.Customers as C
		ON C.CustomerID = CT.CustomerID
	INNER JOIN Sales.CustomerCategories as CC
		ON C.CustomerCategoryID = CC.CustomerCategoryID
WHERE C.CreditLimit is not NULL and CT.TransactionAmount >=0 
		and CT.TransactionAmount < C.CreditLimit
		and DATEDIFF(year, C.AccountOpenedDate,GETDATE()) <= 2
ORDER BY C.CustomerName;

SELECT CustomerName as [Name], CustomerCategoryName as [Store Type],
	   ShopNumber as [Shop Number]
FROM dbo.RecentGoodStandings;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Credit Limit:'), INCLUDE_NULL_VALUES;



/*
 Problem 20: Construct a function that will compute the difference in retail
			 price and unit price for a certain product. Using the function and
			 WideWorldImportersDW, list the products that differ in less than $1 from its retail
			 and unit price and its quantity in the city Astor Park. Order by the difference.
			 This query can be used to determine which goods are not expected to be elevated in price.
*/

USE WideWorldImportersDW;

IF OBJECT_ID (N'dbo.DifferenceInPrice', N'FN') IS NOT NULL
	DROP FUNCTION DifferenceInPrice
GO
CREATE FUNCTION dbo.DifferenceInPrice(@product varchar(50)) 
RETURNS float
AS
BEGIN
	DECLARE @difference float
	SELECT @difference = [Recommended Retail Price] - [Unit Price]
	FROM Dimension.[Stock Item] 
	WHERE [Stock Item] = @product
	RETURN @difference;
END;
GO

SELECT SI.[Stock Item], dbo.DifferenceInPrice([Stock Item]) as [Difference in Price],
 	   O.Quantity
FROM Dimension.[Stock Item] as SI
	INNER JOIN Fact.[Order] as O
		ON SI.[Stock Item Key] = O.[Stock Item Key]
	INNER JOIN Dimension.City as C
		ON O.[City Key] = C.[City Key]
WHERE dbo.DifferenceInPrice([Stock Item]) < 1.00 and C.city = N'Astor Park'
ORDER BY dbo.DifferenceInPrice([Stock Item]), O.Quantity;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Difference in price:'), INCLUDE_NULL_VALUES;



/*
 Problem 21: Write a query that returns for each order the number of days that past
			 since the same customer’s previous order. To determine recency among orders,
             use orderdate as the primary sort element and orderid as the tiebreaker.
             Tables involved: Northwinds2022TSQLV7 database, Sales.[Order] table
*/
USE Northwinds2022TSQLV7

SELECT CustomerId, orderdate, orderid,
  (SELECT TOP (1) O2.orderdate
   FROM Sales.[Order] AS O2
   WHERE O2.CustomerId = O1.CustomerId
     AND (    O2.orderdate = O1.orderdate AND O2.orderid < O1.orderid
           OR O2.orderdate < O1.orderdate )
   ORDER BY O2.orderdate DESC, O2.orderid DESC) AS prevdate
FROM Sales.[Order] AS O1
ORDER BY CustomerId, orderdate, orderid;

SELECT CustomerId, orderdate, orderid,
  DATEDIFF(day,
    (SELECT TOP (1) O2.orderdate
     FROM Sales.[Order] AS O2
     WHERE O2.CustomerId = O1.CustomerId
       AND (    O2.orderdate = O1.orderdate AND O2.orderid < O1.orderid
             OR O2.orderdate < O1.orderdate )
     ORDER BY O2.orderdate DESC, O2.orderid DESC),
    orderdate) AS diff
FROM Sales.[Order] AS O1
ORDER BY CustomerId, orderdate, orderid;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Recency among Orders:'), INCLUDE_NULL_VALUES;



/*
Problem 22: Create a view that returns the total quantity
			for each employee and year
			Tables involved: Sales.Order and Sales.OrderDetail
			Write a query against Sales.VEmpOrders
			that returns the running qty for each employee and year using subqueries
			Tables involved: Northwinds2022TSQLV7 database, Sales.VEmpOrders view
*/
USE Northwinds2022TSQLV7;
DROP VIEW IF EXISTS Sales.VEmpOrders;
GO
CREATE VIEW  Sales.VEmpOrders
AS

SELECT
  EmployeeId,
  YEAR(orderdate) AS orderyear,
  SUM(Quantity) AS qty
FROM Sales.[Order] AS O
  INNER JOIN Sales.[OrderDetail] AS OD
    ON O.orderid = OD.orderid
GROUP BY
  EmployeeId,
  YEAR(orderdate);
GO

SELECT EmployeeId, orderyear, qty,
  (SELECT SUM(qty)
   FROM  Sales.VEmpOrders AS V2
   WHERE V2.EmployeeId = V1.EmployeeId
     AND V2.orderyear <= V1.orderyear) AS runqty
FROM  Sales.VEmpOrders AS V1
ORDER BY EmployeeId, orderyear;
--Uncomment below to get the JSON Output
--FOR JSON PATH, ROOT('Total Quantity for each Employee:'), INCLUDE_NULL_VALUES;