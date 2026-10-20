USE E_CommerceDB;
--GO
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
    IsAticve BIT NOT NULL DEFAULT 1
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

/*INSERT INTO Customers (FirstName, LastName, Email) 
VALUES 
('Alice', 'Smith', 'alice@example.com'),
('Bob', 'Jones', 'bob@example.com'),
('Carol', 'Lee', 'carol@example.com'),
('David', 'Brown', 'david@example.com'),
('Eve', 'Davis', 'eve@example.com'),
('Frank', 'Wilson', 'frank@example.com'),
('Hassan', 'Hassan', 'hassan@example.com');*/

/*INSERT INTO Products (ProductName, Category, UnitPrice)
VALUES
('Wireless Mouse', 'Electronics', 19.99),
('Mechanical Keyboard', 'Electronics', 79.99),
('Office Chair', 'Furniture', 149.99),
('Notebook Pack', 'Stationery', 5.49),
('Desk Lamp', 'Furniture', 24.99),
('MacBook Laptop', 'Electronics', 549.99),
('PlayStation 5', 'Electronics', 399.99);*/

/*INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) 
VALUES 
(1, DATEADD(DAY, -5, SYSDATETIME()), 'Completed'),
(2, DATEADD(DAY, -2, SYSDATETIME()), 'Completed'),
(3, DATEADD(DAY, -1, SYSDATETIME()), 'Shipped'),
(4, DATEADD(DAY, -3, SYSDATETIME()), 'Pending'),
(5, DATEADD(DAY, -4, SYSDATETIME()), 'Cancelled'),
(6, DATEADD(DAY, -6, SYSDATETIME()), 'Completed'),
(7, DATEADD(DAY, -7, SYSDATETIME()), 'Pending');*/
/*UPDATE Orders
SET OrderStatus = 'Completed'
WHERE CustomerID IN (3);*/

/*INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 2, 19.99),
(1, 2, 1, 79.99),
(2, 3, 1, 149.99),
(3, 4, 5, 5.49),
(4, 5, 2, 24.99),
(5, 6, 1, 549.99),
(6, 7, 1, 399.99),
(7, 7, 2, 399.99);*/
/*UPDATE OrderItems
SET UnitPrice = 399.99
WHERE ProductID IN (7);*/
-- SELECT * FROM OrderItems;
-- WHERE OrderID IN (1, 2, 3, 4, 5, 6);

/*INSERT INTO Payments (OrderID, Amount, PaymentMethod)
VALUES
(1, 119.97, 'Card'),
(2, 149.99, 'PayPal'),
(3, 5.49, 'Credit'),
(4, 49.98, 'Card'),
(5, 549.99, 'PayPal'),
(6, 549.99, 'Credit'),
(7, 399.99, 'PayPal');*/
/*UPDATE Payments
SET Amount = 19.99
WHERE OrderID IN (1);*/

-- SELECT * FROM Orders;

-- Check the current database context
/*SELECT DB_NAME() AS DatabaseName;
USE E_CommerceDB;
GO*/


--EXEC sp_help 'Products';

-- List all columns in the Products table
/*SELECT Column_Name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';*/

--(Core JOINS)Orders wuth customer and total line value per item
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
--EXEC sp_GetOrdersByCustomer @CustomerEmail = 'Hassan@example.com';

/*SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'E_CommerceDB';*/

-- SELECT TOP 3 *
-- FROM Customers;