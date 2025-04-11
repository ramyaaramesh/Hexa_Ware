-------Tak1
CREATE DATABASE HMBank;
GO

USE HMBank;
GO



---Create Tables
---a. Customers Table

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    DOB DATE,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(255)
);

---b. Accounts Table

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50), -- 'savings', 'current', 'zero_balance'
    balance DECIMAL(12, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

---c. Transactions Table

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(50), -- 'deposit', 'withdrawal', 'transfer'
    amount DECIMAL(12, 2),
    transaction_date DATETIME,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);






---------------Task 2

---1. Insert Sample Records (minimum 10 per table)
---1. Customers

INSERT INTO Customers VALUES
(1, 'Alice', 'Johnson', '1990-05-12', 'alice.johnson@example.com', '1234567890', 'Chennai'),
(2, 'Bob', 'Williams', '1985-09-30', 'bob.w@example.com', '9876543210', 'Mumbai'),
(3, 'Charlie', 'Smith', '1993-03-15', 'charlie.smith@example.com', '4445556666', 'Delhi');

---Accounts

INSERT INTO Accounts VALUES
(101, 1, 'savings', 15000.00),
(102, 2, 'current', 2500.00),
(103, 1, 'current', 1800.00);

----Transactions

INSERT INTO Transactions VALUES
(1001, 101, 'deposit', 5000.00, '2025-04-10'),
(1002, 102, 'withdrawal', 1000.00, '2025-04-11'),
(1003, 103, 'transfer', 800.00, '2025-04-11');



----2. SQL Queries
---1. Name, account type and email of all customers

SELECT c.first_name, c.last_name, a.account_type, c.email
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

---2. All transactions with customer info
SELECT c.first_name, c.last_name, t.transaction_type, t.amount, t.transaction_date
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id;

---3. Increase balance of an account
UPDATE Accounts
SET balance = balance + 1000
WHERE account_id = 101;

---4. Combine first and last name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM Customers;

---5. Delete savings accounts with zero balance
DELETE FROM Accounts
WHERE account_type = 'savings' AND balance = 0;

---6. Customers from a specific city (e.g., Chennai)
SELECT * FROM Customers
WHERE address LIKE '%Chennai%';

---7. Account balance of a specific account
SELECT balance FROM Accounts
WHERE account_id = 101;

---8. Current accounts with balance > 1000
SELECT * FROM Accounts
WHERE account_type = 'current' AND balance > 1000;

---9. All transactions for a specific account
SELECT * FROM Transactions
WHERE account_id = 101;

---10. Calculate interest on savings accounts (assume 4.5%)
SELECT account_id, balance, balance * 0.045 AS interest
FROM Accounts
WHERE account_type = 'savings';

---11. Accounts with balance < overdraft limit (e.g., 500)
SELECT * FROM Accounts
WHERE balance < 500;

---12. Customers not in a specific city (e.g., not Mumbai)
SELECT * FROM Customers
WHERE address NOT LIKE '%Mumbai%';










------Task 3 – SQL Queries

---1. Find the average account balance for all customers
SELECT AVG(balance) AS average_balance
FROM Accounts;

--- 2. Retrieve the top 10 highest account balances
SELECT account_id, balance
FROM Accounts
ORDER BY balance DESC
LIMIT 10;

---Use TOP 10 instead of LIMIT 10 for SQL Server:
SELECT TOP 10 account_id, balance
FROM Accounts
ORDER BY balance DESC;


-----3. Calculate total deposits for all customers on a specific date
SELECT SUM(amount) AS total_deposits
FROM Transactions
WHERE transaction_type = 'deposit'
  AND CAST(transaction_date AS DATE) = '2025-04-10';


 ----4. Find the oldest and newest customers

-- Oldest (by DOB)
SELECT * FROM Customers
ORDER BY DOB ASC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

-- Newest
SELECT * FROM Customers
ORDER BY DOB DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

---5. Retrieve transaction details with account type
SELECT t.transaction_id, t.account_id, a.account_type, t.transaction_type, t.amount, t.transaction_date
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id;

---6. List customers along with their account details
SELECT c.first_name, c.last_name, a.account_id, a.account_type, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

---7. Transaction details with customer info for a specific account (e.g., 101)
SELECT c.first_name, c.last_name, t.*
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
WHERE a.account_id = 101;

---8. Customers who have more than one account
SELECT customer_id, COUNT(account_id) AS account_count
FROM Accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1;

---9. Difference in total deposits and withdrawals
SELECT 
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) AS total_deposit,
    SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS total_withdrawal,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) - 
    SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS difference
FROM Transactions;

---10. Average daily balance for each account over a date range
---Assuming daily balance not tracked, we'll simulate by averaging the balance:

SELECT account_id, AVG(balance) AS avg_balance
FROM Accounts
GROUP BY account_id;
---If balance changes daily are stored, we’d need a balance history table.

---11. Total balance per account type
SELECT account_type, SUM(balance) AS total_balance
FROM Accounts
GROUP BY account_type;

---12. Accounts with the highest number of transactions (descending)
SELECT a.account_id, COUNT(t.transaction_id) AS transaction_count
FROM Accounts a
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id
ORDER BY transaction_count DESC;

---13. Customers with high aggregate balances and their account types
SELECT c.customer_id, c.first_name, c.last_name, a.account_type, SUM(a.balance) AS total_balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.account_type
HAVING SUM(a.balance) > 10000; 

--- 14. Duplicate transactions (same amount, date, and account)
SELECT account_id, amount, CAST(transaction_date AS DATE) AS txn_date, COUNT(*) AS duplicate_count
FROM Transactions
GROUP BY account_id, amount, CAST(transaction_date AS DATE)
HAVING COUNT(*) > 1;
















-----Task 4 – Subqueries
---1. Customer(s) with the highest account balance
SELECT c.customer_id, c.first_name, c.last_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance = (
    SELECT MAX(balance) FROM Accounts
);


---2. Average account balance for customers with more than one account
SELECT AVG(avg_balance) AS average_balance
FROM (
    SELECT customer_id, AVG(balance) AS avg_balance
    FROM Accounts
    GROUP BY customer_id
    HAVING COUNT(account_id) > 1
) AS multi_acc;

---3. Accounts with transactions above average transaction amount
SELECT DISTINCT account_id
FROM Transactions
WHERE amount > (
    SELECT AVG(amount) FROM Transactions
);

---4. Customers with no recorded transactions
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

--- 5. Total balance of accounts with no transactions
SELECT SUM(a.balance) AS total_unused_balance
FROM Accounts a
LEFT JOIN Transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;

---6. Transactions for accounts with the lowest balance
SELECT * FROM Transactions
WHERE account_id IN (
    SELECT account_id FROM Accounts
    WHERE balance = (SELECT MIN(balance) FROM Accounts)
);

---7. Customers with accounts of multiple types
SELECT customer_id
FROM Accounts
GROUP BY customer_id
HAVING COUNT(DISTINCT account_type) > 1;

---8. Percentage of each account type
SELECT account_type,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Accounts) AS percentage
FROM Accounts
GROUP BY account_type;

---9. All transactions for a specific customer (e.g., customer_id = 1)
SELECT t.*
FROM Transactions t
WHERE t.account_id IN (
    SELECT account_id FROM Accounts WHERE customer_id = 1
);

---10. Total balance per account type using subquery in SELECT clause
SELECT DISTINCT account_type,
       (SELECT SUM(balance) FROM Accounts AS a2 WHERE a2.account_type = a1.account_type) AS total_balance
FROM Accounts AS a1;