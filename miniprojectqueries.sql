USE miniproject_mysql;
SHOW TABLES FROM miniproject_mysql;

SELECT * FROM Customers;
 -- Get the total number of bank clients :
SELECT COUNT( DISTINCT CustomerId) FROM Customers;

SELECT * FROM Branches;
SELECT COUNT(DISTINCT BranchId) FROM Branches;

SELECT * FROM Employees;
SELECT COUNT(DISTINCT StaffId) FROM Employees;

SELECT * FROM Cards;
SELECT COUNT(*) FROM Cards;

SELECT * FROM Transactions;
SELECT COUNT(*) FROM Transactions;

SELECT * FROM Accounts;
SELECT COUNT(*) FROM Accounts;
SELECT DISTINCT Accountname FROM Accounts;

 -- Join Tables Customers, Accounts, and Cards
SELECT c.*, a.AccountId, a.AccountName, a.Balance,  cd.CardId, cd.CardLimit, cd.Debt 
FROM Customers c
JOIN Accounts a ON c.CustomerId = a.CustomerId 
JOIN Cards cd ON c.CustomerId = cd.CustomerId; 
    
  -- calculate the share percentage of each AccountName based on the number of customers that use it  
SELECT a.AccountName, COUNT(DISTINCT c.CustomerId) 
AS NumberOfCustomersUsingAccount,100.0 * COUNT(DISTINCT c.CustomerId) / SUM(COUNT(DISTINCT c.CustomerId)) OVER () AS SharePercentage
FROM Customers c
JOIN Accounts a ON c.CustomerId = a.CustomerId
GROUP BY a.AccountName
ORDER BY SharePercentage DESC;

-- Calculating the TOTAL balance for each account name
SELECT a.Accountname, FLOOR(AVG(a.Balance)) AS AvgBalance  
FROM Customers c
JOIN Accounts a ON c.CustomerId = a.CustomerId
GROUP BY a.Accountname
ORDER BY AvgBalance DESC;

-- Calculating the AVG balance for each account name
SELECT 
    a.Accountname,
    SUM(a.Balance) AS SumBalance  
FROM Customers c
JOIN Accounts a ON c.CustomerId = a.CustomerId
GROUP BY a.Accountname
ORDER BY SUMBalance DESC;

-- To find out how many accounts each customer has
SELECT 
    CustomerId, 
    COUNT(AccountId) AS NumberOfAccounts
FROM 
    Accounts
GROUP BY 
    CustomerId
HAVING COUNT(AccountId) > 1
ORDER BY 
    NumberOfAccounts DESC;
    
-- query to determine which accounts each customer has.    
SELECT 
    c.CustomerId,
    c.Firstname,
    c.Lastname,
    c.Email,
    a.AccountId,
    a.Accountname,
    a.Balance
FROM 
    Customers c
JOIN 
    Accounts a ON c.CustomerId = a.CustomerId
ORDER BY 
    c.CustomerId, a.Accountname;
    
-- checking if the balance of each 'Credit Card Account' for each customer is equal to the 'Debt' column in the 'Cards' table (ANSWER: not equal)
SELECT 
    a.CustomerId,
    a.Accountname,
    a.Balance,  
    c.Debt
FROM Accounts a
JOIN Cards c ON a.CustomerId = c.CustomerId
WHERE a.Accountname = 'Credit Card Account'
  AND a.Balance = c.Debt;
  
-- To explore the correlation between 'CardLimit' and 'Debt' in the 'Cards' table (ANSWER:  there is no correlation)
SELECT
    (COUNT(*) * SUM(c.CardLimit * c.Debt) - SUM(c.CardLimit) * SUM(c.Debt)) /
    (SQRT(COUNT(*) * SUM(c.CardLimit * c.CardLimit) - SUM(c.CardLimit) * SUM(c.CardLimit)) *
     SQRT(COUNT(*) * SUM(c.Debt * c.Debt) - SUM(c.Debt) * SUM(c.Debt))) AS Correlation_Coefficient
FROM Cards c;



-- #To analyze the top 100 most risky customers based on high credit card debt and low balance on debit accounts. 
WITH DebitBalances AS (
    SELECT CustomerId, SUM(Balance) AS TotalBalance
    FROM Accounts
    WHERE AccountName IN 
    ('Checking Account', 'Savings Account', 
    'Money Market Account', 'Investment Account')
    GROUP BY CustomerId
),
CreditDebt AS (
    SELECT CustomerId, SUM(Debt) AS TotalDebt
    FROM Cards
    GROUP BY CustomerId
)
SELECT 
    db.CustomerId, 
    db.TotalBalance, 
    cd.TotalDebt, 
    (cd.TotalDebt / NULLIF(db.TotalBalance, 0)) 
    AS DebtToBalanceRatio
FROM DebitBalances db
JOIN CreditDebt cd ON db.CustomerId = cd.CustomerId
ORDER BY DebtToBalanceRatio DESC
LIMIT 100;



    
    

    
    
