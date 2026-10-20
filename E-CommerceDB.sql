USE E_CommerceDB;
GO
/*CREATE DATABASE E_CommerceDB;
USE E_CommerceDB;
GO*/
/*CREATE TABLE Customers (
    CustomerID INT IDENTITY (1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE Products (
    ProductID INT IDENTITY (1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50),
    UnitPrice DECIMAL(10,2) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
); 

CREATE TABLE Orders (
    OrderID INT IDENTITY (1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    OrderStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_CustomerOrder
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
); 

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY (1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderItem_Order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItem_Product
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT IDENTITY (1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    PaymentMethod NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Payment_Order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
); */


-- Check the current database context
/*SELECT DB_NAME() AS DatabaseName;
USE E_CommerceDB;
GO*/


--EXEC sp_help 'Products';

-- List all columns in the Products table
/*SELECT Column_Name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';*/

--(Core JOINS)Orders with customer and total line value per item
/*SELECT 
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS LineTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
ORDER BY o.OrderDate DESC, o.OrderID DESC;*/

--ANALYTICS QUERIES: Total revenue per ORDER
/*SELECT 
    o.OrderID,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
    FROM Orders AS o
    JOIN Customers AS c ON o.CustomerID = c.CustomerID
    JOIN OrderItems  AS oi ON o.OrderID = oi.OrderID
    GROUP BY o.OrderID, c.FirstName, c.LastName
    ORDER BY OrderTotal DESC;*/

--Revenue By PRODUCT
/*SELECT
    p.ProductName,
    SUM(oi.Quantity) AS TotalUnitsSold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM Products AS p
JOIN OrderItems AS oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;*/

--Customer Lifetime Value (CLV)-Total spend per customer
/*SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.UnitPrice) AS LifetimeValue
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderItems AS oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY LifetimeValue DESC;*/

--View:
/*CREATE VIEW vw_OrderSummary AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.UNitPrice) AS OrderTotal
    FROM ORders AS o
    JOIN Customers AS c ON o.CustomerID = c.CustomerID
    JOIN OrderItems AS oi ON o.OrderID = oi.OrderID
    GROUP BY 
         o.OrderID, o.OrderDate, 
         o.OrderStatus, c.FirstName, c.LastName;*/ 

--Average Customer Spending
/*SELECT 
    AVG(CustomerTotal) AS AverageCustomerSpending
FROM (
    SELECT 
        c.CustomerID,
        SUM(oi.Quantity * p.UnitPrice) AS CustomerTotal
    FROM Customers c
    JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi 
        ON o.OrderID = oi.OrderID
    JOIN Products p 
        ON oi.ProductID = p.ProductID
    GROUP BY c.CustomerID
) AS SpendingPerCustomer;*/

--Average Order Value (AOV)
/*SELECT 
    AVG (OrderTotal) AS AverageOrderValue
FROM (
    SELECT
        o.OrderID,
        SUM(oi.Quantity * p.UnitPrice) AS OrderTotal
    FROM Orders o
    JOIN OrderItems oi 
        ON o.OrderID = oi.OrderID
    JOIN Products p 
        ON oi.ProductID = p.ProductID
    GROUP BY o.OrderID
) AS OrderTotals;*/

--Average Spending of Active Customers (those with at least one order)
/*SELECT 
    AVG(CustomerTotal) AS AverageSpendingActiveCustomers
FROM (
    SELECT 
        o.CustomerID,
        SUM(oi.Quantity * p.UnitPrice) AS CustomerTotal
    FROM Orders o
    JOIN OrderItems oi 
        ON o.OrderID = oi.OrderID
    JOIN Products p 
        ON oi.ProductID = p.ProductID
    GROUP BY o.CustomerID
) AS Spending;*/


--Stored Procedure: Get orders by customer
/*CREATE PROCEDURE sp_GetOrdersByCustomer
    @CustomerEmail NVARCHAR(100)
    AS
    BEGIN
        SELECT 
            o.OrderID, 
            o.OrderDate,
            o.OrderStatus,
            SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
            FROM Customers AS C 
            JOIN Orders AS o ON c.CustomerID = o.CustomerID 
            JOIN OrderItems AS oi ON o.OrderID = oi.OrderID
            WHERE c.Email = @CustomerEmail 
            GROUP BY o.OrderID, o.OrderDate, o.OrderStatus
            ORDER BY o.OrderDate DESC;
    END;
GO*/

--Example Usage:
--SELECT DB_NAME();
-- EXEC sp_GetOrdersByCustomer @CustomerEmail = 'Hassan@example.com';

/*SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'E_CommerceDB';*/

--ALTER TABLE Customers
--ADD PhoneNumber NVARCHAR(20);

--SELECT  * FROM Customers;

--UPDATE Customers
--SET PhoneNumber = '070-456-7890'
--WHERE CustomerID = 1;

/*CREATE TABLE Customers_New (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    DateOfBirth DATE,
    createdAt DATETIME DEFAULT GETDATE()
);

SET IDENTITY_INSERT Customers_New ON;

INSERT INTO Customers_New (CustomerID, FirstName, LastName, Email, PhoneNumber, DateOfBirth, createdAt)
SELECT CustomerID, FirstName, LastName, Email, PhoneNumber, NULL, createdAt
FROM Customers;

SET IDENTITY_INSERT Customers_New OFF;

DROP TABLE Customers;
EXEC sp_rename 'Customers_New', 'Customers';*/

/*SELECT
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
    JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
    JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
    JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE tr.name = 'Customers';*/

/*ALTER TABLE Orders
DROP CONSTRAINT FK_CustomerOrder;*/

--DROP TABLE Customers;

--EXEC sp_rename 'Customers_New', 'Customers';

/*ALTER TABLE Orders
ADD CONSTRAINT FK_CustomerOrder
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);*/

/*SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'E_CommerceDB';*/

--rename column IsAtcicve to IsActive in Products table
--EXEC sp_rename 'Products.IsAticve', 'IsActive', 'COLUMN';

--Update the category of PlayStation 5 to Gaming
/*UPDATE Products
SET Category = 'Gaming'
WHERE ProductID = 7;*/

--SELECT * FROM Products;

/*SELECT * FROM Products
WHERE Category = 'Gaming'
ORDER BY UnitPrice DESC;*/

--SELECT * FROM Customers;

/*ALTER TABLE Customers
ADD Gender VARCHAR(20);

ALTER TABLE Customers
ADD Country VARCHAR(100);*/


    --SELECT * FROM Orders;



--select * from Payments

--This is the Schema for the new Shipments tables added to database
/*CREATE TABLE Shipments (
    SHipmentID INT IDENTITY (1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ShipmentDate DATETIME NOT NULL,
    DeliveryDate DATETIME NULL,
    Carrier VARCHAR (50) NOT NULL,
    TrackingNumber VARCHAR (100) NULL,
    ShipmentStatus VARCHAR (20) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);*/

--SELECT * FROM Shipments;

/*CREATE TABLE Returns
(
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ReturnDate DATETIME NOT NULL,
    RefundAmount DECIMAL(10,2) NOT NULL,
    ReturnReason VARCHAR(200) NOT NULL,
    ReturnStatus VARCHAR(20) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);*/



/*SELECT
    c.name AS ColumnName,
    t.name AS DataType,
    c.precision,
    c.scale
FROM sys.columns c
    JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Payments');*/

/*SELECT OrderID, OrderDate
FROM Orders
WHERE TRY_CONVERT(datetime2(7), OrderDate) IS NULL;*/

--How to check date formats:
--DBCC USEROPTIONS;
--SET DATEFORMAT ymd;
--EXEC sp_rename  'Shipments.SHipmentID', 'ShipmentID', 'COLUMN';

--SELECT OrderID, TotalAmount
--FROM Orders;
--EXEC sp_help 'Returns'

--ALTER TABLE Orders
--ADD TotalAmount DECIMAL(10,2);

/*UPDATE o
SET o.TotalAmount = totals.SumLineTotal
FROM Orders o
    JOIN (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS SumLineTotal
    FROM OrderItems
    GROUP BY OrderID
) totals
    ON o.OrderID = totals.OrderID;*/

--SELECT *
--FROM Orders
--WHERE TotalAmount IS NOT NULL;

/*UPDATE o
SET o.TotalAmount = totals.SumLineTotal
FROM Orders o
    JOIN (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS SumLineTotal
    FROM OrderItems
    GROUP BY OrderID
) totals*/
    
--SELECT * FROM OrderItems;
--SELECT TOP 7 * FROM Customers;

--UPDATE Customers
--SET Email = 'hassan.hassan@yahoo.com'
--WHERE CustomerID = 7


--EXEC sp_help 'OrderItems';

--DBCC CHECKIDENT ('OrderItems', NORESEED); 

/*UPDATE o
SET o.TotalAmount = totals.SumLineTotal
FROM Orders o
    JOIN (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS SumLineTotal
    FROM OrderItems
    GROUP BY OrderID
) totals
    ON o.OrderID = totals.OrderID;*/

/*SELECT OrderID, TotalAmount
FROM Orders
WHERE TotalAmount IS NOT NULL;*/

/*SELECT OBJECT_NAME(object_id) AS TableName
FROM sys.identity_columns
WHERE is_identity = 1 AND OBJECTPROPERTY(object_id, 'TableHasIdentityInsert') = 1;*/

/*SELECT OrderItemID
FROM OrderItems
WHERE OrderItemID >= 1059
ORDER BY OrderItemID;*/


/*SELECT
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS CustomerName,
    Orders.OrderID,
    Orders.OrderDate,
    SUM(OrderItems.Quantity) AS ItemCount,
    Orders.TotalAmount
FROM Orders
    JOIN Customers ON Orders.CustomerID = Customers.CustomerID
    JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
GROUP BY
    Customers.FirstName,
    Customers.LastName,
    Orders.OrderID,
    Orders.OrderDate,
    Orders.TotalAmount
ORDER BY Orders.OrderDate DESC;*/

/*SELECT
    Orders.OrderID
    CONCAT(Customers.FirstName,' ', Customers.LastName) AS CustomerName,
    Orders.OrderDate
    FROM Orders
    JOIN Customers ON Orders.CustomerID = Customers.CustomerID
    ORDER BY Orders.OrderDate DESC*/

--SELECT TOP 50 PERCENT * FROM Customers;

--SELECT TOP 7 * FROM Customers
--ORDER BY LastName ASC;

--SELECT * FROM Orders;

--can also use 'Min' as Function
/*SELECT Max(UnitPrice) AS LargestPrice, ProductID
FROM Products
GROUP BY ProductID
HAVING SUM(UnitPrice) > 50.00*/

/*SELECT COUNT (*) AS TotalNumberOfRecords, Category
FROM Products
GROUP BY Category;*/

/*SELECT COUNT(DISTINCT UnitPrice) AS Unique_Prices
FROM Products;*/

--SELECT * FROM Customers;

-- SELECT SUM(Quantity) AS [Total_Number_Of_Items_Ordered], ProductID, OrderID, OrderItemID
-- FROM OrderItems
-- GROUP BY  ProductID, OrderID, OrderItemID;

-- WITH dataset_Summery AS (
--     SELECT
--         COUNT(*) AS Total_records,
--         COUNT(DISTINCT CustomerID) AS Unique_Customers,
--         COUNT(OrderID) AS Unique_Orders,
--         MIN(OrderDate) AS First_Order,
--         MAX(OrderDate) AS Last_Order,
--         SUM(TotalAMount) AS Total_revenue
--     FROM Orders
-- )
-- SELECT * FROM dataset_Summery;

/*SELECT OrderID,
    COUNT(*) AS Order_Count,
    SUM(TotalAmount) AS Total_revenue,
    ROUND(AVG(TotalAmount), 2) AS AVG_Order_Value,
    ROUND(SUM(TotalAmount) * 100.0/SUM(SUM(TotalAmount)) OVER (), 2) AS Revenue_Percentage
FROM Orders
GROUP BY OrderID
ORDER BY Total_revenue DESC;*/

--SELECT * FROM Orders
--WHERE TotalAmount = 349.89 AND TotalAMount <> 350;

--SELECT * FROM Orders
--WHERE TotalAmount BETWEEN 300 AND 350;

--SELECT SUM(TotalAmount) --AS Total_Revenue
--FROM Orders
--WHERE OrderID = 1;

/*SELECT
    Products.ProductName,
    OrderItems.UnitPrice,
    Orders.OrderID,
    Orders.OrderDate
FROM OrderItems
    JOIN Products ON OrderItems.ProductID = Products.ProductID
    JOIN Orders ON OrderItems.OrderID = Orders.OrderID
WHERE OrderItems.UnitPrice = 1000;*/

--query for all products sold at the same price more than once
/*SELECT
    Products.ProductName,
    OrderItems.UnitPrice,
    COUNT(*) AS TimesSold
FROM OrderItems
    JOIN Products ON OrderItems.ProductID = Products.ProductID
GROUP BY Products.ProductName, OrderItems.UnitPrice
HAVING COUNT(*) > 1;*/

--Query for products sold with a different prices, its lowest and highest
/*SELECT 
    Products.ProductName,
    MIN(OrderItems.Unitprice) AS Lowest_Price,
    MAX(OrderItems.UnitPrice) AS Highest_Price
FROM OrderItems
JOIN Products ON OrderItems.ProductID = Products.ProductID
GROUP BY Products.ProductName;*/

--Query for products that changed price over time
/*SELECT 
    Products.ProductName, 
    COUNT(DISTINCT OrderItems.UnitPrice) AS NumberOfDifferentPrices
    FROM OrderItems
    JOIN Products ON OrderItems.ProductID = Products.ProductID
    GROUP BY Products.ProductName
    HAVING COUNT(DISTINCT OrderItems.UnitPrice) > 1*/

--TOP 5 Products by total revenue genereated
/*SELECT TOP 5
    Products.ProductName,
    SUM(Quantity) AS TotalUnitsSold,
    SUM(OrderItems.Quantity * OrderItems.UnitPrice) AS TotalRevenue
FROM OrderItems
JOIN Products ON OrderItems.ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY TotalRevenue DESC;*/

--Query for calculation of average prices
/*SELECT AVG(UnitPrice) AS Average_Price, ProductName, Category, UnitPrice
FROM Products
GROUP BY ProductName, Category, UnitPrice;*/

--Query For returining higher than average price
--SELECT * FROM Products
--WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

--SQL 'LIKE' Opertor & Wildcards. 
--SELECT * FROM Customers
--WHERE FirstName LIKE 'A%';

-- two Percent signs '%%' Wildcard returns any names that contains that letters in side it.

--SELECT * FROM Customers
--WHERE COuntry LIKE '%A%';

--Return all customers from a Country that starts with 'l' followed by one wildcard character, then 'nd' and then two wildcard characters:

--SELECT * FROM Customers
--WHERE Country LIKE 'I_A__';

--Return all Customers that starts with 'Ca'
--SELECT * FROM Customers
--WHERE FirstName LIKE 'Ca%';

--Return all customers that s starts with 'a' or starts with 'b'
--SELECT * FROM Customers
--WHERE FirstName LIKE 'D%';

--Returns all customers that end with 'a'
--SELECT * FROM Customers
--WHERE FirstName LIKE '%A';

--combine 'start' with and 'end' with
--SELECT * FROM Customers
--WHERE FIrstName LIKE 'L%A';

--Return all Customers that contain the phrase 'or' as example, or it could be any phrase
--SELECT * FROM Customers
--WHERE Country LIKE '%EG%';

--Combine Wildcards: Return all customers that start with "a" and are at least 3 characters in length
--SELECT * FROM Customers
--WHERE FirstName LIKE 'a__%';

--Return all customers that have "R" in the second position:
--SELECT * FROM Customers
--WHERE FirstName LIKE '_R%';

--Without Wildcards: return all customers from 'United Kingdom
--SELECT * FROM Customers
--WHERE Country LIKE 'United Kingdom'; 

--Using the underscore _Wildcard. The underscore _ wildcard represents a single character.
--It can be any character or number, but each _ represents one, and only one, character.

--Example: Return all customers with a Country starting with any char, followed "nmark":
--SELECT * FROM Customers
--WHERE Country LIKE '___ada';

--Using the Square Bracket [] Wildcard. The '[]' Wildcard returns a result if any of the character inside gets a match.

--Example: all customers starting with either "b", "s", "P":
--SELECT * FROM Customers
--WHERE FirstName LIKE '[ech]%';

--Using the - Dash Wildcard allows you to specify a range of characters inside the square brakets '[]'
--Example: Return all customers starting with "a", "b", "c", "d":
--SELECT * FROM Customers
--WHERE FirstName LIKE '[a-f]%';

--First letters of country or personal names is NOT an 'a', 'c', or 'f'
--SELECT * FROM Customers
--WHERE FirstName LIKE '[!acf]%';

--SELECT FirstName
--FROM Customers
--WHERE FirstName NOT LIKE 'acf%';

--SELECT TotalAmount, AVG(UnitPrice) AS Average_Spenditure
--FROM Orders
--GROUP BY TotalAmount;

--SELECT AVG(TotalAmount) AS Average_Spenditure
--FROM Orders; 

--IN allows us to specify multiple values we want to select for when using the WHERE command.

--SELECT FirstName 
--FROM Customers
--WHERE FirstName IN ('Alice', '|Bob', 'David', 'Carol', 'Eve');

--The SQL IN Operator is used in the WHERE clause to check if a specific column's value matches any value within a provided list

--SELECT * FROM Customers
--WHERE Country IN ('Germany', 'France', 'United Kingdom', 'United --States', 'Canada');

--The NOT IN Operator is used to return all records that are NOT any of the values in the list

-- SELECT * FROM Customers
-- WHERE Country NOT IN ('Germany', 'France', 'United Kingdom', 'United States', 'Canada');

-- IN (SELECT) can also be used within subquery in WHERE clause

-- SELECT * FROM Customers
-- WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- NOT IN (SELECT) this will return all customers who did not have an order in the orders table if there is any

-- SELECT * FROM Customers
-- WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- the OR Operateor is used here and its similar to the IN Operator but, longer code
-- SELECT * FROM Customers
-- WHERE Country = 'France' OR Country = 'Germnay' OR Country = 'United Kingdom';

-- SQL Between Operator is used in a WHERE clause to select values within a specified range. the range is inclusive, start & end are added in result

-- SELECT * FROM Products
-- WHERE UnitPrice BETWEEN 14.99 AND 200.00; 

-- the NOT BETWEENT opertor is used in a WHERE clause to select a specified range

-- SELECT * FROM Products
-- WHERE UnitPrice NOT BETWEEN 20.00 AND 200.00

-- BETWEEN with IN: SQL will return all products with any price tag, in addition ProductID Must be 1,2,3... 

-- SELECT * FROM Products
-- WHERE UnitPrice BETWEEN 10.00 AND 300.00 
-- AND ProductID IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

-- BETWEEN Text Values: this SQL selects all productName alphabetically between 'office chair' and 'desk lamp'  
-- SELECT * FROM Products
-- WHERE ProductName BETWEEN 'Bluetooth Headphones' AND 'Wireless Mouse'
-- ORDER BY ProductName;

-- NOT BETWEEN Text Values
-- SELECT * FROM Products 
-- WHERE ProductName NOT BETWEEN 'BLuetooth Headphones' AND 'Wireless Mouse'
-- ORDER BY ProductName;

-- BETWEEN Dates is useful for filtering records within a specific date or time peroiod.
-- SELECT * FROM Orders 
-- WHERE OrderDate BETWEEN '2026-02-01' AND '2026-02-28'

-- SQL Aliases are used to give columns or tables a temporary name and it is created with AS Keyword.

-- SELECT CustomerID AS ID, FirstName AS Customer
-- FROM Customers;

-- SELECT ProductName AS [My Great Product]
-- FROM Products;
-- OR
-- SELECT ProductName AS "My great Products"
-- FROM Products;

-- SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName,
-- Email As ContactEmail, 
-- PhoneNumber AS ContactNumber
-- FROM Customers;

-- SELECT LastName + ', ' + FirstName AS Fullname
-- FROM Customers; 

-- SELECT * FROM Customers AS Persons;

-- SELECT c.FirstName, o.OrderID
-- FROM Customers AS C
-- JOIN Orders AS o ON c.CustomerID = o.CustomerID;

/*SELECT 
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName, 
    Email,
    PhoneNumber,
    Gender,
    Country,
    CreatedAt AS REgisterationDate
FROM Customers;*/

/*SELECT 
    CONCAT( FirstName, ' ', LastName) AS CustomerName,
    FORMAT(DateOfBirth, 'dd MMM yyyy') AS DOB,
    Country 
FROM Customers;*/

/*SELECT 
    CONCAT(CustomerID, ' - ', FirstName, ' ', LastName, ' (', Country, ')') AS Customerlabel
FROM Customers;*/

/*SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    CONCAT(Email, ', ', PhoneNumber, ', ', Country) AS ContactSummery
FROM Customers;*/

/*SELECT 
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    CONCAT(Email, ' | ', PhoneNumber, ' | ', Country) AS ContactSummery,
    CONCAT('Registered on: ', FORMAT(CreatedAt, 'dd MMM yyyy')) AS RegistrationInfo
FROM Customers;*/

/*SELECT 
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    CONCAT(Email, ' | ', PhoneNumber, ' | ', Country) AS ContactSummery,
    DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Customers;*/

/*SELECT 
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    CONCAT(Email, ' | ', PhoneNumber, ' | ', Country) AS ContactSummery,
    DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Customers
WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) <= 30
ORDER BY Age DESC;*/

/*SELECT 
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    CONCAT(Email, ' | ', PhoneNumber, ' | ', Country) AS ContactSummery,
    FORMAT(CreatedAT, 'dd MMM yyyy') AS CustomerSince
FROM Customers
ORDER BY CreatedAt DESC;*/

-- Query for joining Customers and Orders tables to get customer name, order ID, order date, and total amount for each order
/*SELECT 
    Customers.CustomerID,
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS Customername,
    Orders.OrderID,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers 
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;*/

-- Query for joining Orders and OrderItems tables to get order ID, order date, product ID, quantity, and unit price for each item in the order
/*SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    OrderItems.ProductID,
    OrderItems.Quantity,
    OrderItems.UnitPrice
FROM Orders
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID;*/

--Query for joining Customers, Orders, OrderItems, and Products tables to get customer name, order ID, product ID, quantity, and unit price for each item in the order
/*SELECT 
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS CustomerName,
    Orders.OrderID,
    Products.ProductID,
    OrderItems.Quantity,
    OrderItems.UnitPrice
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN Products ON OrderItems.ProductID = Products.ProductID;*/

--Query for joining Customers and Orders tables to get customer name, order ID, total amount, and country for each order
/*SELECT
    CONCAT(Customers.FirstName, ' ', Customers.LastName) AS CustomerName,
    Orders.OrderID,
    Orders.TotalAmount,
    Customers.Country
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;*/

--Query for joining Customers and Orders tables to get customer name, order ID, total amount, and country for each order, ordered by total amount using aliases for tables.
/*SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderID,
    o.TotalAmount,
    c.Country
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID;*/

--Query for joining Customers, Orders, OrderItems, and Products tables to get customer name, order ID, product name, quantity, and unit price for each item in the order, ordered by order date using aliases for tables.
/*SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderItems AS oi ON o.OrderID = oi.OrderID
JOIN Products AS p ON oi.ProductID = p.ProductID;*/

--Query for joining Customers and Orders tables to get customer name and total amount spent by each customer, ordered by total amount spent in descending order using aliases and GROUP BY for tables.
/*SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSpent DESC;*/

--Query for joining Customers and Orders tables to get customer name, number of orders, and total amount spent by each customer, ordered by total amount spent in descending order using aliases and GROUP BY for tables.
/*SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;*/

--Query for joining Products and OrderItems tables to get product name and total units sold for each product, ordered by total units sold in descending order using aliases and GROUP BY for tables.
/*SELECT 
    P.ProductName AS ProductName,
    SUM(oi.Quantity) AS TotalUnitsSold
FROM Products AS P
JOIN OrderItems AS oi ON P.ProductID = oi.ProductID
GROUP BY P.ProductName
ORDER BY TotalUnitsSold DESC;*/ 

-- SELECT * FROM Customers;

--Query for joining Products and OrderItems tables to get product name and total revenue generated for each product, ordered by total revenue in descending order using aliases and GROUP BY for tables.
/*SELECT 
    p.ProductName AS ProductName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM Products AS p
JOIN OrderItems AS oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;*/

--Query for joining Customers, Orders, OrderItems, and Products tables to get customer name, product name, category, average unit price, total units sold, and total revenue for each product ordered by each customer, ordered by total revenue in descending order using aliases, GROUP BY and Aggregate functions for tables.
/*SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    p.ProductName AS ProductName,
    p.Category AS Category,
    AVG(oi.UnitPrice) AS AverageUnitPrice,
    SUM(oi.Quantity) AS TotalUnitsSold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
    FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderItems AS oi ON o.OrderID = oi.OrderID
JOIN Products AS p ON oi.ProductID = p.ProductID
GROUP BY c.FirstName, c.LastName, p.ProductName, p.Category
ORDER BY TotalRevenue DESC;*/

--Using INNER JOIN to get customer name and order ID for all customers who have placed an order, ordered by order date in descending order using aliases for tables.
/*SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName)AS CustomerName,
    o.OrderID
FROM Customers AS c
 INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID;*/

--useful for finding all customers and their orders, including those who have not placed any orders, using LEFT JOINs and aliases for tables.
-- SELECT 
--     c.CustomerID,
--     CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
--     o.OrderID
-- FROM Customers AS C  
-- LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID
-- WHERE o.OrderID IS NULL;

--useful for finding all orders and their customers, including those orders that do not have a corresponding customer record (if any), using RIGHT JOINs and aliases for tables. Usful for data quality checks to find any orders that might be missing customer information.
/*SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderID
FROM Customers AS c
RIGHT JOIN Orders AS o ON c.CustomerID = o.CustomerID;*/

--useful for finding all customers and all orders, including those customers who have not placed any orders and those orders that do not have a corresponding customer record (if any), using FULL OUTER JOINs and aliases for tables. This can be useful for comprehensive data analysis to understand the complete picture of customer and order relationships, as well as to identify any discrepancies or missing data in either table.
/* SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS Customername,
    o.OrderID
FROM Customers AS c 
FULL OUTER JOIN Orders AS o ON c.CustomerID = o.CustomerID;*/

--Query for joining Customers table to itself to find pairs of customers from the same country, ordered by country using aliases for tables. also greater than condition can be used at the same time or individualy to avoid duplicate pairs and self-joins. like this <> or just < or this >. This can be useful for analyzing customer demographics and identifying potential regional trends or patterns in customer behavior based on their country of residence.
/*SELECT 
    CONCAT(c1.FirstName, ' ', c1.LastName) AS CustomerName1,
    CONCAT(c2.FirstName, ' ', c2.LastName) AS CustomerName2,
    c1.Country
FROM Customers AS c1
JOIN Customers AS c2 
    ON c1.Country = c2.Country
    AND c1.CustomerID < c2.CustomerID
ORDER BY c1.Country;*/

--Query for joining Customers table to itself to find pairs of customers with the same email address, ordered by email using aliases for tables. This can be useful for identifying potential duplicate customer records based on email addresses, which are often used as unique identifiers in customer databases.
/*SELECT 
    c1.Email,
    CONCAT(c1.FirstName, ' ', c1.LastName) AS CustomerName1,
    CONCAT(c2.FirstName, ' ', c2.LastName) AS CustomerName2
FROM Customers AS c1
JOIN Customers AS c2
    ON c1.Email =c2.Email
    AND c1.CustomerID < c2.CustomerID;*/

--Query for joining Customers table to itself to find pairs of customers with the same date of birth, ordered by date of birth using aliases for tables. This can be useful for identifying potential duplicate customer records based on date of birth, which can be a common attribute used to identify individuals in customer databases, especially when combined with other attributes like name or email address.
/*SELECT
    CONCAT(c1.FirstName, ' ', c1.LastName) AS CustomerName1,
    CONCAT(c2.FirstName, ' ', c2.LastName) AS CustomerName2,
    c1.DateOfBirth
FROM Customers AS c1
JOIN Customers AS c2
    ON c1.DateOfBirth = c2.DateOfBirth
    AND c1.CustomerID <> c2.CustomerID
ORDER BY c1.DateOfBirth;*/

--Query for joining Orders and Shipments tables to get order ID, order date, shipment ID, shipment date, delivery date, carrier, and shipment status for each order, ordered by order date in descending order using aliases for tables. This can be useful for analyzing the shipping and delivery performance of orders, as well as understanding the relationship between order dates and shipment dates to identify any potential delays or issues in the fulfillment process.
/*SELECT 
    o.OrderID,
    o.OrderDate,
    s.ShipmentID,
    s.ShipmentDate,
    s.DeliveryDate,
    s.Carrier,
    s.ShipmentStatus
FROM Orders AS o
JOIN Shipments AS s ON o.OrderID = s.OrderID;*/

--Query for joining Orders and Shipments tables to get order ID, order date, shipment date, delivery date, carrier, and shipment status for each order, ordered by shipment date in descending order using aliases for tables. This can be useful for analyzing the shipping and delivery performance of orders, as well as understanding the relationship between order dates and shipment dates to identify any potential delays or issues in the fulfillment process.
/*SELECT OrderID, OrderDate AS EventDate, 'Order Placed' AS EventType
FROM Orders
UNION ALL
SELECT OrderID, ShipmentDate AS EventDate, 'Shipped' AS EventType
FROM Shipments
UNION ALL 
SELECT OrderID, DeliveryDate AS EventDate, 'Delivered' AS EventType
FROM Shipments
WHERE DeliveryDate IS NOT NULL
ORDER BY EventDate;*/

--UNION simply stacks the results of two or more SELECT statements on top of each other, while UNION ALL does the same but includes duplicate rows in the result set. The choice between UNION and UNION ALL depends on whether you want to eliminate duplicates (UNION) or include all rows (UNION ALL) in the final result.
-- SELECT
--     CONCAT(FirstName, ' ', LastName) AS Value
-- FROM Customers
-- UNION 
-- SELECT Carrier AS Value
-- FROM Shipments;

/*SELECT Country AS VALUE
FROM Customers
UNION
SELECT ShipmentStatus AS VALUE
FROM Shipments;*/

-- SELECT CUstomerID AS Value
-- FROM Customers
-- UNION
-- SELECT ShipmentID AS Value 
-- FROM Shipments;

--Query for counting the total number of customers from each country, ordered by country using GROUP BY and aliases for tables. This can be useful for understanding the geographic distribution of customers and identifying potential regional trends or patterns in customer demographics.
-- SELECT Country, COUNT(CustomerID) AS [Total_Customers_from_each_Country]
-- FROM Customers
-- GROUP BY Country;

--Query for counting the total number of customers from each country, ordered by the total number of customers in descending order using GROUP BY and aliases for tables. This can be useful for understanding the geographic distribution of customers and identifying potential regional trends or patterns in customer demographics, as well as prioritizing marketing efforts or resource allocation based on the concentration of customers in different countries.
-- SELECT Country, COUNT(CustomerID) AS [Total_Customers_from_each_Country]
-- FROM Customers
-- GROUP BY Country
-- ORDER BY COUNT(CustomerID) DESC;

--Query for counting the total number of orders shipped by each carrier, ordered by carrier using GROUP BY and aliases for tables. This can be useful for analyzing the shipping performance of different carriers and identifying any potential issues or trends in the fulfillment process based on the carriers used for shipping orders.
-- SELECT Shipments.Carrier, COUNT(Orders.OrderID) AS Total_Shipments
-- FROM Orders
-- LEFT JOIN Shipments
-- ON Orders.OrderID = Shipments.OrderID
-- GROUP BY Shipments.Carrier;

--Using the HAVING clause to filter the results of a GROUP BY query based on aggregate conditions. This can be useful for identifying specific groups that meet certain criteria after the aggregation has been performed, such as finding countries with a certain number of customers or products with a certain level of sales.
-- SELECT Country, COUNT(CustomerID) AS [Total_Customers]
-- FROM Customers
-- GROUP BY Country
-- HAVING COUNT(CustomerID) > 4
-- ORDER BY COUNT(CustomerID) DESC;

--Query for counting the total number of orders placed by customers with the same last name, ordered by last name using GROUP BY and aliases for tables, and filtering to include only those last names that have more than one order using the HAVING clause. This can be useful for identifying potential family groups or common last names among customers who have placed multiple orders, which may indicate repeat customers or family members making purchases together.

-- SELECT LastName, COUNT(Orders.OrderID) AS Total_Orders
-- FROM Orders
-- INNER JOIN Customers ON Orders.OrderID = Customers.CustomerID
-- GROUP BY LastName 
-- HAVING COUNT(Orders.OrderID) > 1;

--the HAVING clause is used to filter the results of a GROUP BY query based on aggregate conditions, and in this case, it is used to find customers with the same last name who have placed more than one order. This can be useful for identifying potential family groups or common last names among customers who have placed multiple orders, which may indicate repeat customers or family members making purchases together. The query filters the results to include only those last names that have more than one order, and it is ordered by last name for better readability.
-- SELECT LastName, COUNT(Orders.OrderID) AS Total_Orders
-- FROM Orders
-- INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
-- WHERE LastName = 'Abdi' OR LastName = 'Johnson'
-- GROUP BY LastName
-- HAVING COUNT(Orders.OrderID) > 1;

--SQL EXISTS operator is used in WHERE clauses to check for the existence of any record in a subquery. It returns true if the subquery returns one or more records, and false if the subquery returns no records. This can be useful for filtering results based on the presence of related records in another table, such as finding customers who have placed orders or products that have been ordered by customers.
-- SELECT ProductName
-- FROM Products
-- WHERE EXISTS (
--     SELECT ProductName
--     FROM Products
--     WHERE Products.ProductID = Products.ProductID AND UnitPrice < 10
-- );
 
-- SELECT ProductName
-- FROM Products
-- WHERE EXISTS (
--     SELECT ProductName
--     FROM Products
--     WHERE Products.ProductID = Products.ProductID AND UnitPrice = 22.99
-- );

--SQL ANY Operator is used to compare a value to every value returned by a subquery. It returns true if the comparison is true for any of the values returned by the subquery. This can be useful for filtering results based on comparisons with a set of values from another table, such as finding products that have a unit price greater than any of the prices in a specific category.

-- SELECT ProductName
-- FROM Products
-- WHERE ProductID = ANY (
--     SELECT ProductID
--     FROM OrderItems
--     WHERE Quantity = 2
-- );

-- the SQL ALL Operator is used to compare a value to every value returned by a subquery. It returns true if the comparison is true for all of the values returned by the subquery. This can be useful for filtering results based on comparisons with a set of values from another table, such as finding products that have a unit price less than all of the prices in a specific category.

-- SELECT ProductName
-- FROM Products
-- WHERE ProductID  = ALL(
--     SELECT ProductID 
--     FROM OrderItems
--     WHERE Quantity = 5
-- );

-- The SQL SELECT INTO statement creates a new table and inserts the selected data into it. The new table will have the same structure as the source table(s) from which the data is being selected, including column names and data types. If the new table already exists, the SELECT INTO statement will fail with an error.

-- THE SQL INSERT INTO SELECT statement is used to insert data into an existing table by selecting data from one or more source tables. The target table must already exist, and the columns being inserted must match the structure of the target table in terms of column names and data types.

-- The SQL CASE statement is used to create conditional logic in SQL queries. It allows you to return different values based on specified conditions. The CASE statement can be used in SELECT, UPDATE, DELETE, and other SQL statements to perform conditional operations on data.

-- SELECT 
--     ProductName,
--     UnitPrice,
--     CASE 
--         WHEN UnitPrice < 20.99 THEN 'Low'
--         WHEN UnitPrice BETWEEN 20.99 AND 100.99 THEN 'Medium'
--         ELSE 'High'
--     END AS PriceCategory
--     FROM Products;

-- the SQL COALESCE function is used to return the first non-null value from a list of expressions. It can be useful for handling null values in queries and providing default values when data is missing or incomplete. In this example, if the Email or PhoneNumber fields are null for a customer, the COALESCE function will return 'No Email' or 'No Phone Number' respectively instead of returning a null value in the result set.

-- SELECT 
--     CONCAT(FirstName, ' ', LastName) AS CustomerName,
--     COALESCE(Email, 'No Email') AS ContactEmail,
--     COALESCE(PhoneNumber, 'No Phone Number') AS ContactNumber
-- FROM Customers;

-- SELECT CustomerID, FirstName, LastName, Email 
-- FROM Customers
-- WHERE CustomerID >= 110;


-- this query will return all customers whose date of birth is greater than the current date, which means they are born in the future. This can be useful for identifying potential data quality issues or errors in the DateOfBirth field, as it is unlikely for customers to have a date of birth in the future. It may require further investigation or cleanup to ensure accurate analysis and reporting of customer demographics.
-- SELECT * FROM Customers 
-- WHERE DateOfBirth > GETDATE();

-- SELECT
--     s.ShipmentID,
--     s.OrderID,
--     COALESCE(
--         CONVERT(VARCHAR(10), s.DeliveryDate, 120),
--         'Not delivered yet'
--     ) AS DeliveryStatus
--     FROM Shipments AS s;

-- SELECT 
--     oi.OrderItemID,
--     oi.ProductID,
--     oi.Quantity,
--     COALESCE(oi.Discount, 0) AS DiscountApllied
-- FROM OrderItems AS oi;

-- SELECT 
--     p.ProductName,
--     SUM(oi.Quantity * COALESCE(oi.UnitPrice, 0)) AS TotalRevenue
-- FROM Products AS p
-- JOIN OrderItems AS oi ON p.ProductID = oi.ProductID
-- GROUP BY p.ProductName;

-- SELECT 
--     ShipmentID,
--     COALESCE(ShipmentStatus, 'Pending') AS Status
-- FROM Shipments;

-- fallback value for the preferred contact method, if both email and phone number are null, it will return 'No Contact Info' instead of returning a null value in the result set.
-- SELECT 
--     CONCAT(FirstName,  ' ', LastName) AS CustomerName,
--     COALESCE(Email, PhoneNumber, 'No Contact Info') AS PreferredContact
-- FROM Customers;

-- SELECT 
--     ShipmentID,
--     Carrier,
--     COALESCE(ShipmentStatus, 'Unknown') AS ShipmentStatus,
--     COALESCE(CONVERT(VARCHAR(10), DeliveryDate, 120), 'Not Delivered yet') AS DeliveryStatus
-- FROM Shipments;

-- Find duplicate orders by customer and date using GROUP BY and HAVING clause to filter for duplicates. This can be useful for identifying potential data quality issues or duplicate records in the Orders table, which may require further investigation or cleanup to ensure accurate analysis and reporting of order data.
-- SELECT CustomerID, Orderdate, COUNT(*) DuplicateOrders
-- FROM Orders
-- GROUP BY CustomerID, OrderDate
-- HAVING COUNT(*) > 1;

-- SELECT *
-- FROM Shipments
-- WHERE DeliveryDate < ShipmentDate;

-- SELECT Email, COUNT(*) AS DuplicateEmails
-- FROM Customers
-- GROUP BY Email
-- HAVING COUNT(*) > 1;




-- SELECT * from Returns
-- WHERE ReturnReason = 'Wrong Item';

-- calculation of age based on date of birth using DATEDIFF function and adjusting for whether the birthday has occurred yet this year to get an accurate age calculation. This can be useful for analyzing customer demographics and understanding the age distribution of customers in the database.
-- SELECT 
-- FirstName,
-- LastName,
--     DATEDIFF(YEAR, DateOfBirth, GETDATE()) -
-- CASE
-- WHEN (MONTH(DateOfBirth) > MONTH(GETDATE())) OR
--         (MONTH(DateOfBirth) = MONTH(GETDATE()) AND DAY(DateOfBirth) > DAY(GETDATE()))
-- THEN 1
-- ELSE 0
-- END AS Age
-- FROM Customers;

-- SELECT 
--     Firstname,
--     LastName,
--     DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
-- FROM Customers
-- WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 30
-- ORDER BY Age DESC;

-- SELECT 
--    CONCAT(FirstName, ' ', LastName) AS FUll_Name,
--    DateOfBirth 
-- FROM Customers
-- WHERE DateOfBirth <> '1990-06-03'
-- ORDER BY DateOfBirth DESC;

-- SELECT 
--     CONCAT(FirstName, ' ', LastName) AS FUll_Name,
--     Country,
--     DateOfBirth
-- FROM Customers
-- WHERE Country = 'Russia';

-- Dirty data can refer to inaccurate, incomplete, inconsistent, or outdated data that can lead to incorrect analysis and decision-making. It can arise from various sources such as human error during data entry, system glitches, or integration issues between different data sources. Dirty data can include misspelled names, incorrect dates, missing values, duplicate records, and inconsistent formatting. It is important to identify and clean dirty data to ensure the accuracy and reliability of data analysis and reporting.
-- INSERT INTO Customers
--     (FirstName, LastName, Email, PhoneNumber, DateOfBirth, createdAt, Gender, Country)
-- VALUES
--     -- 108
--     ('  hassan  ', 'Ali', NULL, ' 07123 998221 ', '1990-05-10', '2024-01-01', 'male', 'united kingdom'),

--     -- 109 (FIXED: invalid DOB replaced with NULL)
--     ('Sarah', 'Jones', 'sarah.jones@gmail.com', 'ABC123', NULL, '2023-12-01', 'Unknown', 'U.K.'),

--     -- 110
--     ('Alice', 'Smith', 'alice.smith@gmail.com', '070-456-7890', '1990-08-07', '2024-02-15', 'FEMALE', 'United States'),

--     -- 111
--     ('John', 'Brown', 'john.brown@example.com', '555-8888', '2050-01-01', '2024-02-15', 'Male', 'uk'),

--     -- 112
--     ('Emily', 'Clark', 'emily.clark@example.com', NULL, '1995-07-20', '2024-01-20', 'female', NULL),

--     -- 113
--     ('   michael   ', 'O''Connor', 'michael.oconnor@gmail.com', '  020 1234 5678 ', NULL, '2024-01-10', 'MaLe', 'United Kingdom'),

--     -- 114
--     ('Laura', 'White', 'laura.white.gmail.com', '555-2222', '1992-11-11', '2099-12-31', 'Female', 'England'),

--     -- 115
--     ('Hassan', 'Hassan', 'hassan.hassan@yahoo.com', '077-674-2178', '2002-09-02', '2026-02-16 16:10:46.313', 'MALE', 'United Kingdom'),

--     -- 116
--     ('Tom', 'Hardy', NULL, NULL, NULL, NULL, NULL, NULL),

--     -- 117
--     ('Aisha', 'O''Connor', 'aisha.oconnor@outlook.com', '+44-??-??', '1995-12-11', '2024-11-09', 'Female', 'Britain');

-- Query to find customers with invalid date of birth values that cannot be converted to a valid date format using TRY_CONVERT function. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that date of birth values are accurate and consistent for analysis and reporting purposes.

-- SELECT *
-- FROM Customers
-- WHERE TRY_CONVERT(DATE, DateOfBirth) IS NULL;

-- Query to find customers with missing or empty email addresses using IS NULL and empty string checks. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that contact information is complete and accurate for analysis and reporting purposes.

-- SELECT *
-- FROM Customers
-- WHERE Email IS NULL OR Email = '';

-- Query to find customers with missing or empty phone numbers using IS NULL and empty string checks. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that contact information is complete and accurate for analysis and reporting purposes.

-- SELECT *
-- FROM Customers
-- WHERE PhoneNUmber IS NULL OR PhoneNUmber = '';

-- Query to find customers with missing date of birth values using IS NULL check. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that date of birth values are complete and accurate for analysis and reporting purposes.

-- SELECT *
-- FROM Customers 
-- WHERE DateOfBirth IS NULL;

-- Query to find customers with invalid email addresses that do not contain the '@' symbol or a valid domain format using NOT LIKE operator. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that email addresses are accurate and consistent for analysis and reporting purposes.

-- SELECT *
-- FROM Customers 
-- WHERE Email NOT LIKE '%@%' AND Email IS NOT NULL;

-- Query to find customers with leading or trailing spaces in their first name or last name using the LIKE operator with wildcard characters. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that names are accurate and consistent for analysis and reporting purposes.

-- SELECT *
-- FROM Customers 
-- WHERE FirstName LIKE ' %' 
--     OR FirstName LIKE '% '
--     OR LastName LIKE ' %'
--     OR LastName LIKE '% '
--     OR PhoneNumber LIKE ' %'
--     OR PhoneNumber LIKE '% ';

-- Query to find Customers with the wrong gender values that do not match the expected values of 'Male', 'Female', or NULL using NOT IN operator. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that gender values are accurate and consistent for analysis and reporting purposes.

-- SELECT * 
-- FROM Customers 
-- WHERE Gender NOT IN ('Male', 'Female') OR Gender IS NULL;


-- Query to find customers with date of birth values in the future using GETDATE() function. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that date of birth values are accurate and consistent for analysis and reporting purposes.

-- SELECT * 
-- FROM Customers
-- WHERE DateOfBirth > GETDATE();

-- Query to find customers with duplicate email addresses using GROUP BY and HAVING clause to filter for duplicates. This can be useful for identifying potential data quality issues or duplicate records in the Customers table, which may require further investigation or cleanup to ensure accurate analysis and reporting of customer data.

-- SELECT Email, COUNT(*) AS CountEmails
-- FROM Customers 
-- GROUP BY Email
-- HAVING COUNT(*) > 1;

--showing actual duplicate records with the same email address.
-- SELECT * 
-- FROM Customers
-- WHERE Email IN (
--     SELECT Email
--     FROM Customers
--     GROUP BY Email
--     HAVING COUNT(*) > 1
-- );

-- Query to find customers with missing email domain names that do not contain the '@' symbol or a valid domain format using NOT LIKE operator. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that email addresses are accurate and consistent for analysis and reporting purposes.

-- SELECT * 
-- FROM Customers
-- WHERE Email LIKE '%@%' AND Email NOT LIKE '%_%';

-- Query to find customers with missing or null values in critical fields such as email, phone number, date of birth, gender, or country using IS NULL checks. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that critical information is complete and accurate for analysis and reporting purposes.

-- SELECT *
-- FROM Customers
-- WHERE Email IS NULL
-- OR PhoneNumber IS NULL
-- OR DateOfBirth IS NULL
-- OR Gender IS NULL
-- OR COuntry IS NULL; 

-- Query to find customers with inconsistent Gender values that may indicate data quality issues, such as variations in gender names or misspellings, using GROUP BY and HAVING clause to filter for inconsistencies. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that gender values are accurate and consistent for analysis and reporting purposes.

-- SELECT DISTINCT Gender 
-- FROM Customers;

-- Query to find customers with inconsistent Country values that may indicate data quality issues, such as variations in country names or misspellings, using DISTINCT to filter for unique country values. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that country values are accurate and consistent for analysis and reporting purposes.

-- SELECT DISTINCT Country
-- FROM Customers
-- ORDER BY Country;

-- Query to find customers with phone numbers that contain non-numeric characters using the LIKE operator with a pattern that checks for any characters that are not digits or the plus sign. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that phone number values are accurate and consistent for analysis and reporting purposes.

-- SELECT *
-- FROM Customers
-- WHERE PhoneNumber LIKE '%[^0-9+]%';

-- Query to find customers with phone numbers that are too short to be valid after removing spaces and plus signs using the LEN function and REPLACE function to clean the phone number values. This can be useful for identifying and cleaning dirty data in the Customers table, as well as ensuring that phone number values are accurate and consistent for analysis and reporting purposes.

-- SELECT PhoneNUmber AS InvalidPhoneNumber
-- FROM Customers
-- WHERE LEN(REPLACE(REPLACE(PhoneNumber, ' ', ''), '+', '')) < 10;

-- A comprehensive query to count various types of dirty data in the Customers table, including null values, invalid formats, duplicates, and inconsistencies across multiple fields. This can be useful for getting an overview of the data quality issues present in the Customers table and prioritizing data cleaning efforts to improve the accuracy and reliability of customer data for analysis and reporting purposes.

-- SELECT 
--     (SELECT COUNT(*) FROM Customers WHERE Email IS NULL) AS NullEmails,
--     (SELECT COUNT(*) FROM Customers WHERE PhoneNumber IS NULL) AS NullPhoneNumbers,
--     (SELECT COUNT(*) FROM Customers WHERE TRY_CONVERT(DATE, DateOfBirth) IS NULL AND DateOfBirth IS NOT NULL) AS InvalidDOBs,
--     (SELECT COUNT(*) FROM Customers WHERE DateOfBirth > GETDATE()) AS FutureDOBs,
--     (SELECT COUNT(*) FROM Customers WHERE Email IN (SELECT Email FROM Customers GROUP BY Email HAVING COUNT(*) > 1)) AS DuplicateEmails,
--     (SELECT COUNT(*) FROM Customers WHERE PhoneNumber LIKE '%[^0-9+]%') AS InvalidPhoneFormats,
--     (SELECT COUNT(*) FROM Customers WHERE createdAt > GETDATE()) AS FutureCreatedAt,
--     (SELECT COUNT(*) FROM Customers WHERE Gender NOT IN ('Male','Female')) AS InvalidGenders,
--     (SELECT COUNT(*) FROM Customers WHERE Country IN ('U.K.', 'uk', 'United Kingdom', 'England', 'Britain')) AS InconsistentCountryNames;




-- Query for counting the total number of orders placed by customers with the same first and last name, ordered by customer name using GROUP BY and aliases for tables, and filtering to include only those names that have more than one order using the HAVING clause. This can be useful for identifying potential duplicate customer records or common names among customers who have placed multiple orders, which may indicate repeat customers or individuals with common names making purchases together.
-- SELECT 
--     CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
--     COUNT(o.OrderID) AS Total_Orders
-- FROM Customers AS c
-- JOIN Orders AS o ON c.CustomerID = o.CustomerID
-- GROUP BY c.FirstName, c.LastName
-- HAVING COUNT(o.OrderID) > 1;


-- Delivery performance by carrier.
-- SELECT 
--     s.Carrier,
--     COUNT(*) AS ShipmentCount,
--     AVG(DATEDIFF(DAY, s.ShipmentDate, s.DeliveryDate)) AS AvgDeliveryDays
-- FROM Shipments s 
-- GROUP BY s.Carrier
-- ORDER BY AvgDeliveryDays;

-- SELECT TOP (5) WITH TIES OrderID, CustomerID, OrderDate, TotalAmount
-- FROM Orders
-- ORDER BY OrderDate DESC;

--This query will return the top 5 most recent orders, but if there are multiple orders with the same OrderDate as the 5th order, it will include all of those orders as well due to the WITH TIES clause. The results will be ordered by OrderDate in descending order, and if there are ties in OrderDate, they will be further ordered by OrderID in descending order to ensure a consistent order of results.
-- SELECT TOP (5) WITH TIES OrderID, CustomerID, OrderDate, TotalAmount
-- FROM Orders
-- ORDER BY ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, OrderID DESC);

-- SELECT Country 
-- FROM Customers
-- WHERE Country = 'Japan';

-- SELECT COUNT(*) AS Total_Orders_In
-- FROM Orders 

-- SELECT * FROM Customers; 

--SELECT COUNT(DISTINCT OrderDate) AS Unique_Orders_Dates
--FROM Orders;

--SELECT * FROM Orders
--WHERE OrderDate <= '2025-02-09';

--SELECT * FROM Orders;

--SELECT Country
--FROM Customers;

--Query to find the first customer from each country using ROW_NUMBER() function with PARTITION BY clause to assign a unique row number to each customer within their respective country, and then filtering for the first customer (RowNum = 1) for each country. This can be useful for identifying a representative customer from each country for analysis or reporting purposes, as well as understanding the geographic distribution of customers in the database.
-- WITH CTE AS (
-- SELECT Country, CustomerID,
-- ROW_NUMBER() OVER (PARTITION BY Country ORDER BY CustomerID) AS RowNum
-- FROM Customers
-- WHERE Country IS NOT NULL
-- ) 
-- SELECT Country, CustomerID
-- FROM CTE;

--SELECT * FROM Orders;

-- WITH stats AS (
--     SELECT 
--         COUNT(*) AS TotalOrders,
--         SUM(TotalAmount) AS TotalRevenue,
--         MIN(OrderDate) AS FirstOrderDate,
--         MAX(OrderDate) AS LastOrderDate,
--         AVG(TotalAmount) AS AverageOrderAmount
--     FROM Orders
--     )
-- SELECT * FROM stats;

-- SELECT TotalAmount,
--     AVG(TotalAmount) OVER (PARTITION BY CustomerID) AS AverageOrderAmountPerCustomer
-- FROM Orders;

-- Query to find the top 5 customers based on total spending using Common Table Expressions (CTEs) to calculate total spending for each customer and then rank them using the RANK() function, filtering for the top 5 customers based on their spending rank. This can be useful for identifying the most valuable customers in terms of revenue generated, which can inform marketing strategies, customer retention efforts, and overall business analysis.
-- WITH Step_1 AS (
--     SELECT CustomerID,
--     SUM(TotalAmount) AS TotalSpent
--     FROM Orders
--     GROUP BY CustomerID 
-- ),
-- step_2 AS (
--     SELECT CustomerID,
--     TotalSpent,
--     RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank
--     FROM Step_1
-- )
-- SELECT CustomerID, TotalSpent, SpendingRank
-- FROM Step_2
-- WHERE SpendingRank <= 5
-- ORDER BY SpendingRank;

-- Query to find customers who have spent more than a certain amount (e.g., 1000) using Common Table Expressions (CTEs) to calculate total spending for each customer and then filtering for those customers whose total spending exceeds the specified threshold. This can be useful for identifying high-value customers who may be eligible for special promotions, loyalty programs, or targeted marketing campaigns based on their spending behavior.
-- WITH step_1 AS (
--     SELECT 
--         CustomerID,
--         SUM(TotalAmount) AS Total
--     FROM Orders
--     GROUP BY CustomerID
-- ),
-- step_2 AS (
--     SELECT * FROM step_1
--     WHERE Total > 1000 
-- )
-- SELECT * FROM step_2
-- ORDER BY Total DESC;

-- Query to find the second highest total amount spent on an order using a subquery to find the maximum total amount and then filtering for orders that have a total amount less than the maximum, and finally selecting the maximum total amount from that filtered set. This can be useful for identifying the second highest spending on an order, which may provide insights into customer purchasing behavior and help inform pricing strategies or promotional efforts.
-- SELECT 
--     MAX(TotalAmount) AS SecondHighestTotalAmount
-- FROM Orders
-- WHERE TotalAmount < (
--     SELECT MAX(TotalAmount)
--     FROM Orders
-- );

--SELECT * FROM Products;


-- SELECT * FROM (
--     SELECT ProductName, Category, UnitPrice,
--         ROW_NUMBER() OVER (
--             PARTITION BY Category
--             ORDER BY UnitPrice DESC
--         ) AS rank 
--     FROM Products 
-- ) ranked
-- WHERE rank <= 3;

--SELECT * FROM orders;

-- this query will return all orders that do not have a corresponding customer record in the Customers table. The NOT EXISTS clause is used to check for the absence of a matching CustomerID in the Customers table for each order in the Orders table. This can be useful for identifying potential data integrity issues or orphaned records in the Orders table that may require further investigation or cleanup to ensure accurate analysis and reporting of order data.
-- SELECT *
-- FROM Orders o  
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM Customers c  
--     WHERE c.CustomerID = o.CustomerID
-- );

-- sorting customers by continent based on their country of residence using a CASE statement to categorize countries into continents. This can be useful for analyzing customer demographics and identifying potential regional trends or patterns in customer behavior based on their geographic location.

-- SELECT Country,

--     CASE 
-- 			WHEN Country IN ( 'United States', 'Canada', 'Mexico') THEN 'North America'
-- 			WHEN Country IN ( 'United Kingdom', 'Germany', 'Russia', 'Serbia', 'Poland', 
-- 			'Switzerland', 'Romania', 'Croatia', 'Sweden', 'Spain', 'Denmark', 'Italy', 'France', 'Greece', 
-- 			'Portugal', 'Slovakia', 'Ireland', 'Bulgaria') THEN 'Europe'
-- 			WHEN Country IN ('India', 'Pakistan', 'China', 'Japan', 'South Korea', 'Bangladesh', 'Afghanistan', 'Turkey') THEN 'Asia'
-- 			WHEN Country IN ('Colombia', 'Brazil', 'Argentina', 'Chile') THEN 'South America'
-- 			WHEN Country IN ('UAE', 'Saudi Arabia', 'Iran', 'Lebanon', 'Oman', 'Jordan') THEN 'Middle East'
-- 			WHEN Country IN ('Egypt', 'Ghana', 'South Africa', 'Kenya', 'Mali', 'Morocco', 'Nigeria') THEN 'Africa'
-- 			ELSE 'Unknown'
-- 	 END AS Continent

-- FROM Customers
-- ORDER BY Continent ASC;

-- Counting the total number of customers from each country using GROUP BY clause to group the results by country and COUNT() function to count the number of customers in each group. This can be useful for understanding the geographic distribution of customers and identifying potential regional trends or patterns in customer demographics.
-- SELECT Country, 
-- COUNT (Country) AS Total_customers_from_Country
-- FROM Customers
-- GROUP BY Country;

-- Counting the total number of customers from each country using COUNT() function with OVER() clause to calculate the total number of customers from each country without grouping the results. This can be useful for understanding the geographic distribution of customers and identifying potential regional trends or patterns in customer demographics, while still retaining individual customer records in the result set.
-- SELECT 
--     FirstName, 
--     LastName, 
--     Country,
-- COUNT(*) OVER (PARTITION BY Country) AS Total_Customer_from_Country
-- FROM Customers
-- ORDER BY Total_Customer_from_Country DESC;

--SELECT * 
--FROM (
--	SELECT *, 
--		ROW_NUMBER() OVER (
--			PARTITION BY Country
--			ORDER BY Country 
--		) AS RN
--	FROM Customers
--) ranked 
--WHERE RN <=3

-- SELECT *
-- FROM (
-- 	SELECT *, 
-- 		ROW_NUMBER() OVER (
-- 			--PARTITION BY PaymentID
-- 			ORDER BY Amount
-- 		) AS RN 
-- 	FROM Payments 
-- ) ranked 
-- WHERE RN <=3 

-- SELECT *
-- FROM   (SELECT *,
--                ROW_NUMBER() OVER (PARTITION BY PaymentMethod ORDER BY Amount DESC) AS RN
--         FROM   Payments) AS ranked
-- WHERE  RN <= 3;

-- SELECT *
-- FROM   (SELECT *,
--                ROW_NUMBER() OVER (PARTITION BY PaymentMethod ORDER BY Amount DESC) AS RN
--         FROM   Payments
--         WHERE  PaymentMethod = 'BankTransfer') AS ranked
-- WHERE  RN <= 3;

--Create Index IX_Payment_Method_Amount
--on Payments(PaymentMethod, Amount DESC)
--Include (PaymentID, OrderID); 

-- SELECT PaymentMethod,
--        PaymentID,
--        OrderID,
--        Amount,
--        PaymentRank
-- FROM   (SELECT *,
--                DENSE_RANK() OVER (PARTITION BY PaymentMethod ORDER BY Amount DESC) AS PaymentRank
--         FROM   Payments
--         WHERE  PaymentMethod = 'paypal') AS RankedPayments
-- WHERE  PaymentRank <= 3;

--SELECT TOP 10 * FROM Orders;

-- SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
-- FROM information_schema.columns

SELECT * FROM Customers;