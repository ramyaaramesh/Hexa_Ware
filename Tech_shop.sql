
CREATE DATABASE TechShop1;
GO

USE TechShop1;
GO


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255)
);
GO


CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL
);
GO


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO


CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO


CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    QuantityInStock INT NOT NULL,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO


INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Ramya', 'Sree', 'ramya@example.com', '9998887771', '11 Tech Street'),
('Badri', 'Kumar', 'badri@example.com', '9998887772', '22 Silicon Road'),
('Jaya', 'Lakshmi', 'jaya@example.com', '9998887773', '33 Code Lane'),
('Sona', 'Reddy', 'sona@example.com', '9998887774', '44 Pixel Park'),
('Ramesh', 'Varma', 'ramesh@example.com', '9998887775', '55 Byte Blvd'),
('Robert', 'Brown', 'robert@example.com', '6547893210', '789 Oak St'),
('Emily', 'Clark', 'emily@example.com', '3216549870', '101 Pine St'),
('Michael', 'Green', 'michael@example.com', '9871234560', '202 Maple Ave'),
('Linda', 'White', 'linda@example.com', '6543217890', '303 Cedar St'),
('David', 'Black', 'david@example.com', '7418529630', '404 Walnut St');
GO


INSERT INTO Products (ProductName, Description, Price) VALUES
('Smartphone', 'Android-based phone', 399.99),
('Laptop', '15-inch display, 8GB RAM', 799.99),
('Tablet', '10-inch screen, Wi-Fi', 299.99),
('Headphones', 'Wireless Bluetooth headset', 99.99),
('Smartwatch', 'Fitness tracking, waterproof', 149.99),
('Camera', 'Digital SLR with 24MP', 499.99),
('Printer', 'Laser printer', 129.99),
('Monitor', '24-inch HD display', 179.99),
('Keyboard', 'Mechanical keyboard', 59.99),
('Mouse', 'Wireless optical mouse', 29.99);
GO


INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-04-01', 499.99),
(2, '2024-04-02', 799.99),
(3, '2024-04-03', 129.99),
(4, '2024-04-04', 299.99),
(5, '2024-04-05', 199.99),
(6, '2024-04-06', 399.99),
(7, '2024-04-07', 449.99),
(8, '2024-04-08', 149.99),
(9, '2024-04-09', 109.99),
(10, '2024-04-10', 89.99);
GO


INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 2, 1),
(2, 1, 2),
(3, 7, 1),
(4, 3, 1),
(5, 4, 2),
(6, 5, 1),
(7, 6, 1),
(8, 8, 2),
(9, 9, 3),
(10, 10, 1);
GO


INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 50, '2024-04-01'),
(2, 30, '2024-04-02'),
(3, 40, '2024-04-03'),
(4, 100, '2024-04-04'),
(5, 60, '2024-04-05'),
(6, 25, '2024-04-06'),
(7, 35, '2024-04-07'),
(8, 45, '2024-04-08'),
(9, 70, '2024-04-09'),
(10, 80, '2024-04-10');
GO





-- Task 2
-- Retrieve the names and emails of all customers
SELECT FirstName + ' ' + LastName AS FullName, Email FROM Customers;
GO

--  List all orders with their order dates and corresponding customer names
SELECT O.OrderID, O.OrderDate, C.FirstName + ' ' + C.LastName AS CustomerName
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID;
GO

--  Insert a new customer record
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES ('Aarav', 'Mehta', 'aarav@example.com', '9991234567', '66 Gadget Street');
GO

-- Increase prices of all products by 10%
UPDATE Products
SET Price = Price * 1.10;
GO

-- Delete a specific order and its associated order details (Example OrderID = 3)
DELETE FROM OrderDetails WHERE OrderID = 3;
DELETE FROM Orders WHERE OrderID = 3;
GO

--  Insert a new order
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES (1, GETDATE(), 799.99);
GO

--  Update contact information of a customer (Example: CustomerID = 2)
UPDATE Customers
SET Email = 'updated_badri@example.com', Address = 'New Silicon Valley Road'
WHERE CustomerID = 2;
GO

--  Recalculate and update total cost of each order (with NULL check)
UPDATE Orders
SET TotalAmount = ISNULL((
    SELECT SUM(OD.Quantity * P.Price)
    FROM OrderDetails OD
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE OD.OrderID = Orders.OrderID
), 0);
GO


--  Delete all orders and order details for a specific customer (Example: CustomerID = 5)
DELETE FROM OrderDetails WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = 5);
DELETE FROM Orders WHERE CustomerID = 5;
GO

--  Insert a new electronic gadget product
INSERT INTO Products (ProductName, Description, Price)
VALUES ('Gaming Console', 'High-end console with 4K gaming support', 599.99);
GO

--  Add a new column 'Status' to Orders table and update its value
ALTER TABLE Orders ADD Status VARCHAR(20);
GO
UPDATE Orders
SET Status = 'Shipped'
WHERE OrderID = 4;
GO

--  Add a new column 'OrderCount' to Customers table and update it
ALTER TABLE Customers ADD OrderCount INT DEFAULT 0;
GO
UPDATE Customers
SET OrderCount = (
    SELECT COUNT(*) FROM Orders WHERE Orders.CustomerID = Customers.CustomerID
);
GO

Select * from Orders;

-- Task 3

--  List all orders along with customer names
SELECT O.OrderID, C.FirstName + ' ' + C.LastName AS CustomerName, O.OrderDate, O.TotalAmount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID;
GO

-- Total revenue generated by each product
SELECT P.ProductName, SUM(OD.Quantity * P.Price) AS TotalRevenue
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName;
GO

--  List all customers who have made at least one purchase
SELECT DISTINCT C.CustomerID, C.FirstName + ' ' + C.LastName AS CustomerName, C.Email, C.Phone
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID;
GO


--  Most popular product (highest total quantity ordered)
SELECT TOP 1 P.ProductName, SUM(OD.Quantity) AS TotalOrdered
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalOrdered DESC;
GO

--  List electronic gadgets with their descriptions
SELECT ProductName, Description FROM Products;
GO

--  Average order value per customer
SELECT C.FirstName + ' ' + C.LastName AS CustomerName,
       AVG(O.TotalAmount) AS AvgOrderValue
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;
GO

--  Order with the highest total revenue
SELECT TOP 1 O.OrderID, C.FirstName + ' ' + C.LastName AS CustomerName, O.TotalAmount
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
ORDER BY O.TotalAmount DESC;
GO

--  Products and number of times ordered
SELECT P.ProductName, COUNT(OD.OrderDetailID) AS TimesOrdered
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName;
GO

--  Customers who purchased a specific product (e.g., 'Smartphone')
SELECT DISTINCT C.FirstName + ' ' + C.LastName AS CustomerName
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
WHERE P.ProductName = 'Smartphone';
GO

--  Total revenue between two dates (parameters: start and end)
DECLARE @StartDate DATE = '2024-04-01';
DECLARE @EndDate DATE = '2024-04-30';
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE OrderDate BETWEEN @StartDate AND @EndDate;
GO

-- Task 4

--  Customers who have not placed any orders
SELECT FirstName + ' ' + LastName AS CustomerName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);
GO

--  Total number of products available for sale
SELECT COUNT(*) AS TotalProducts FROM Products;
GO

--  Total revenue generated by TechShop
SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders;
GO

-- Average quantity ordered for products in a specific category
-- (Assuming category is in Description for now, e.g., 'Tablet')
SELECT AVG(OD.Quantity) AS AvgQuantity
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
WHERE P.Description LIKE '%Tablet%';
GO






































































-- Total revenue generated by a specific customer (CustomerID = 1)
SELECT SUM(TotalAmount) AS CustomerRevenue
FROM Orders
WHERE CustomerID = 1;
GO

--  Customers who placed the most orders
SELECT TOP 1 C.FirstName + ' ' + C.LastName AS CustomerName, COUNT(O.OrderID) AS OrderCount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY OrderCount DESC;
GO

-- Most popular product category (based on Description field)

SELECT TOP 1 CAST(P.Description AS VARCHAR(255)) AS Description, SUM(OD.Quantity) AS TotalOrdered
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY CAST(P.Description AS VARCHAR(255))
ORDER BY TotalOrdered DESC;
GO















































-- 8. Customer who spent the most money
SELECT TOP 1 C.FirstName + ' ' + C.LastName AS CustomerName, SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY TotalSpent DESC;
GO

--  Average order value for all customers
SELECT AVG(TotalAmount) AS AvgOrderValue FROM Orders;
GO

--  Total number of orders per customer
SELECT C.FirstName + ' ' + C.LastName AS CustomerName, COUNT(O.OrderID) AS OrderCount
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;
GO





