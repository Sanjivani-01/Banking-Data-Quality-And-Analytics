-- ============================================================
-- PART 1: DATA VALIDATION
-- ============================================================

-- 1. Duplicate Customer IDs
-- Expected: 0 rows

SELECT
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- 2. Duplicate Account IDs
-- Expected: 0 rows

SELECT
    AccountID,
    COUNT(*) AS DuplicateCount
FROM Accounts
GROUP BY AccountID
HAVING COUNT(*) > 1;


-- 3. Duplicate Transaction IDs
-- Expected: 0 rows

SELECT
    TransactionID,
    COUNT(*) AS DuplicateCount
FROM Transactions
GROUP BY TransactionID
HAVING COUNT(*) > 1;


-- 4. Duplicate Branch IDs
-- Expected: 0 rows

SELECT
    BranchID,
    COUNT(*) AS DuplicateCount
FROM Branches
GROUP BY BranchID
HAVING COUNT(*) > 1;


-- ============================================================
-- 5. Missing values - Customers
-- ============================================================

SELECT
    SUM(CustomerID IS NULL) AS Missing_CustomerID,
    SUM(FirstName IS NULL) AS Missing_FirstName,
    SUM(LastName IS NULL) AS Missing_LastName,
    SUM(DateOfBirth IS NULL) AS Missing_DateOfBirth,
    SUM(AddressID IS NULL) AS Missing_AddressID,
    SUM(CustomerTypeID IS NULL) AS Missing_CustomerTypeID
FROM Customers;


-- ============================================================
-- 6. Missing values - Accounts
-- ============================================================

SELECT
    SUM(AccountID IS NULL) AS Missing_AccountID,
    SUM(CustomerID IS NULL) AS Missing_CustomerID,
    SUM(AccountTypeID IS NULL) AS Missing_AccountTypeID,
    SUM(AccountStatusID IS NULL) AS Missing_AccountStatusID,
    SUM(Balance IS NULL) AS Missing_Balance,
    SUM(OpeningDate IS NULL) AS Missing_OpeningDate
FROM Accounts;


-- ============================================================
-- 7. Missing values - Transactions
-- ============================================================

SELECT
    SUM(TransactionID IS NULL) AS Missing_TransactionID,
    SUM(AccountOriginID IS NULL) AS Missing_AccountOriginID,
    SUM(AccountDestinationID IS NULL) AS Missing_AccountDestinationID,
    SUM(TransactionTypeID IS NULL) AS Missing_TransactionTypeID,
    SUM(Amount IS NULL) AS Missing_Amount,
    SUM(TransactionDate IS NULL) AS Missing_TransactionDate,
    SUM(BranchID IS NULL) AS Missing_BranchID,
    SUM(Description IS NULL) AS Missing_Description
FROM Transactions;


-- ============================================================
-- 8. Missing values - Branches
-- ============================================================

SELECT
    SUM(BranchID IS NULL) AS Missing_BranchID,
    SUM(BranchName IS NULL) AS Missing_BranchName,
    SUM(AddressID IS NULL) AS Missing_AddressID
FROM Branches;


-- ============================================================
-- 9. Accounts without a valid customer
-- ============================================================

SELECT
    a.AccountID,
    a.CustomerID
FROM Accounts a
LEFT JOIN Customers c
    ON a.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- ============================================================
-- 10. Transactions without a valid origin account
-- ============================================================

SELECT
    t.TransactionID,
    t.AccountOriginID
FROM Transactions t
LEFT JOIN Accounts a
    ON t.AccountOriginID = a.AccountID
WHERE a.AccountID IS NULL;


-- ============================================================
-- 11. Transactions without a valid destination account
-- ============================================================

SELECT
    t.TransactionID,
    t.AccountDestinationID
FROM Transactions t
LEFT JOIN Accounts a
    ON t.AccountDestinationID = a.AccountID
WHERE a.AccountID IS NULL;


-- ============================================================
-- 12. Transactions without a valid branch
-- ============================================================

SELECT
    t.TransactionID,
    t.BranchID
FROM Transactions t
LEFT JOIN Branches b
    ON t.BranchID = b.BranchID
WHERE b.BranchID IS NULL;


-- ============================================================
-- 13. Invalid transaction amounts
-- ============================================================

SELECT *
FROM Transactions
WHERE Amount <= 0;


-- ============================================================
-- 14. Negative account balances
-- These are flagged for business review, not automatically errors.
-- ============================================================

SELECT
    AccountID,
    CustomerID,
    Balance
FROM Accounts
WHERE Balance < 0
ORDER BY Balance ASC;


-- ============================================================
-- 15. Missing transaction dates
-- ============================================================

SELECT
    COUNT(*) AS Missing_Transaction_Dates
FROM Transactions
WHERE TransactionDate IS NULL;


-- ============================================================
-- 16. Missing account opening dates
-- ============================================================

SELECT
    COUNT(*) AS Missing_Opening_Dates
FROM Accounts
WHERE OpeningDate IS NULL;


-- ============================================================
-- 17. Same origin and destination account
-- These records should be reviewed as potential anomalies.
-- ============================================================

SELECT
    TransactionID,
    AccountOriginID,
    AccountDestinationID
FROM Transactions
WHERE AccountOriginID = AccountDestinationID;


-- ============================================================
-- PART 2: BUSINESS ANALYSIS
-- ============================================================

-- 18. Customers with multiple accounts

SELECT
    CustomerID,
    COUNT(*) AS Account_Count
FROM Accounts
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY Account_Count DESC;


-- ============================================================
-- 19. Top 10 customers by number of accounts
-- ============================================================

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(a.AccountID) AS Account_Count
FROM Customers c
JOIN Accounts a
    ON c.CustomerID = a.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY Account_Count DESC
LIMIT 10;


-- ============================================================
-- 20. Accounts by account type
-- ============================================================

SELECT
    AccountTypeID,
    COUNT(*) AS Account_Count
FROM Accounts
GROUP BY AccountTypeID
ORDER BY Account_Count DESC;


-- ============================================================
-- 21. Accounts by account status
-- ============================================================

SELECT
    AccountStatusID,
    COUNT(*) AS Account_Count
FROM Accounts
GROUP BY AccountStatusID
ORDER BY Account_Count DESC;


-- ============================================================
-- 22. Balance by account type
-- ============================================================

SELECT
    AccountTypeID,
    COUNT(*) AS Account_Count,
    SUM(Balance) AS Total_Balance,
    AVG(Balance) AS Average_Balance
FROM Accounts
GROUP BY AccountTypeID
ORDER BY Total_Balance DESC;


-- ============================================================
-- 23. Total balance by customer
-- ============================================================

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(a.AccountID) AS Account_Count,
    SUM(a.Balance) AS Total_Balance
FROM Customers c
JOIN Accounts a
    ON c.CustomerID = a.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY Total_Balance DESC;


-- ============================================================
-- 24. Transaction volume by branch
-- ============================================================

SELECT
    b.BranchID,
    b.BranchName,
    COUNT(t.TransactionID) AS Transaction_Count
FROM Branches b
LEFT JOIN Transactions t
    ON b.BranchID = t.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
ORDER BY Transaction_Count DESC;


-- ============================================================
-- 25. Total transaction amount by branch
-- ============================================================

SELECT
    b.BranchID,
    b.BranchName,
    COUNT(t.TransactionID) AS Transaction_Count,
    COALESCE(SUM(t.Amount), 0) AS Total_Transaction_Amount,
    COALESCE(AVG(t.Amount), 0) AS Average_Transaction_Amount
FROM Branches b
LEFT JOIN Transactions t
    ON b.BranchID = t.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
ORDER BY Total_Transaction_Amount DESC;


-- ============================================================
-- 26. Top 10 most active branches
-- ============================================================

SELECT
    b.BranchID,
    b.BranchName,
    COUNT(t.TransactionID) AS Transaction_Count
FROM Branches b
JOIN Transactions t
    ON b.BranchID = t.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
ORDER BY Transaction_Count DESC
LIMIT 10;


-- ============================================================
-- 27. Transaction analysis by transaction type
-- ============================================================

SELECT
    TransactionTypeID,
    COUNT(*) AS Transaction_Count,
    SUM(Amount) AS Total_Amount,
    AVG(Amount) AS Average_Amount
FROM Transactions
GROUP BY TransactionTypeID
ORDER BY Transaction_Count DESC;


-- ============================================================
-- 28. Top 10 largest transactions
-- ============================================================

SELECT
    TransactionID,
    AccountOriginID,
    AccountDestinationID,
    TransactionTypeID,
    Amount,
    TransactionDate,
    BranchID
FROM Transactions
ORDER BY Amount DESC
LIMIT 10;


-- ============================================================
-- 29. Monthly transaction trend
-- ============================================================

SELECT
    YEAR(TransactionDate) AS Transaction_Year,
    MONTH(TransactionDate) AS Transaction_Month,
    COUNT(*) AS Transaction_Count,
    SUM(Amount) AS Total_Amount,
    AVG(Amount) AS Average_Amount
FROM Transactions
WHERE TransactionDate IS NOT NULL
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Transaction_Year,
    Transaction_Month;


-- ============================================================
-- 30. Customer transaction activity
-- ============================================================

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(DISTINCT a.AccountID) AS Account_Count,
    COUNT(t.TransactionID) AS Transaction_Count,
    COALESCE(SUM(t.Amount), 0) AS Total_Transaction_Amount
FROM Customers c
LEFT JOIN Accounts a
    ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t
    ON a.AccountID = t.AccountOriginID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY Transaction_Count DESC
LIMIT 20;


-- ============================================================
-- 31. Accounts with no outgoing transactions
-- ============================================================

SELECT
    a.AccountID,
    a.CustomerID,
    a.Balance
FROM Accounts a
LEFT JOIN Transactions t
    ON a.AccountID = t.AccountOriginID
WHERE t.TransactionID IS NULL
ORDER BY a.AccountID;


-- ============================================================
-- 32. Customers with no accounts
-- ============================================================

SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Customers c
LEFT JOIN Accounts a
    ON c.CustomerID = a.CustomerID
WHERE a.AccountID IS NULL
ORDER BY c.CustomerID;


-- ============================================================
-- 33. Overall banking dataset summary
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Accounts) AS Total_Accounts,
    (SELECT COUNT(*) FROM Transactions) AS Total_Transactions,
    (SELECT COUNT(*) FROM Branches) AS Total_Branches;


-- ============================================================
-- 34. Overall transaction summary
-- ============================================================

SELECT
    COUNT(*) AS Total_Transactions,
    SUM(Amount) AS Total_Transaction_Value,
    AVG(Amount) AS Average_Transaction_Value,
    MIN(Amount) AS Minimum_Transaction_Value,
    MAX(Amount) AS Maximum_Transaction_Value
FROM Transactions;


-- ============================================================
-- END
-- ============================================================
