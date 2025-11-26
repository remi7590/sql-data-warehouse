

SELECT 
    CustomerID,
    LTRIM(RTRIM(FullName))           AS CustomerName,
    LOWER(LTRIM(RTRIM(Email)))       AS Email,
    REPLACE(Phone, ' ', '')          AS Phone,
    UPPER(LTRIM(RTRIM(Country)))     AS Country,
    CAST(CreatedDate AS date)        AS CreatedDate
INTO gold.dim_customer
FROM Silver_Customers;

select * from gold.dim_customer


SELECT
    o.OrderID,
    o.CustomerID,
    CAST(o.OrderDate AS date)              AS OrderDate,
    CAST(o.Amount AS decimal(18,2))        AS OrderAmount,
    UPPER(LTRIM(RTRIM(o.PaymentMode)))     AS PaymentMode,
    UPPER(LTRIM(RTRIM(o.Status)))          AS OrderStatus
INTO gold.fact_orders
FROM Silver_orders AS o;   

Select * from gold.fact_orders

SELECT
    PaymentID,
    OrderID,
    CAST(Amount AS decimal(18,2))          AS PaymentAmount,
    CAST(PaymentDate AS date)              AS PaymentDate,
    UPPER(LTRIM(RTRIM(PaymentMode)))       AS PaymentMode,
    UPPER(LTRIM(RTRIM(PaymentStatus)))     AS PaymentStatus
INTO gold.fact_payments
FROM Silver_Payments;

Drop table gold.fact_inventory
SELECT
    InventoryID,
    ProductID,
    CASE 
        WHEN Stock IS NULL
             OR LTRIM(RTRIM(Stock)) = ''
             OR UPPER(LTRIM(RTRIM(Stock))) = 'NA'
        THEN 0
        ELSE CAST(Stock AS int)
    END AS Stock,
    CAST(UpdatedDate AS date)              AS UpdatedDate,
    UPPER(LTRIM(RTRIM(Location)))          AS Location
INTO gold.fact_inventory
FROM Silver_Inventory;

SELECT
    InventoryID,
    ProductID,
    CASE 
        WHEN Stock IS NULL
             OR LTRIM(RTRIM(Stock)) = ''
             OR UPPER(LTRIM(RTRIM(Stock))) = 'NA'
        THEN 0
        ELSE CAST(Stock AS int)
    END AS Stock,
    CAST(UpdatedDate AS date)              AS UpdatedDate,
    UPPER(LTRIM(RTRIM(Location)))          AS Location
INTO gold.fact_inventory
FROM Silver_Inventory;


INSERT INTO gold.fact_inventory (
    InventoryID,
    ProductID,
    Stock,
    UpdatedDate,
    Location
)
SELECT
    InventoryID,
    ProductID,
    CASE 
        WHEN Stock IS NULL
             OR LTRIM(RTRIM(Stock)) = ''
             OR UPPER(LTRIM(RTRIM(Stock))) = 'NA'
        THEN 0
        ELSE CAST(Stock AS int)
    END AS Stock,
    CAST(UpdatedDate AS date)              AS UpdatedDate,
    UPPER(LTRIM(RTRIM(Location)))          AS Location
FROM Silver_Inventory;

select * from gold.fact_inventory



SELECT 
    c.Country,
    SUM(o.OrderAmount) AS TotalSales
FROM gold.fact_orders o
JOIN gold.dim_customer c 
    ON o.CustomerID = c.CustomerID
GROUP BY c.Country
ORDER BY TotalSales DESC;

SELECT 
    OrderDate,
    SUM(OrderAmount) AS DailySales
FROM gold.fact_orders
WHERE OrderDate >= DATEADD(DAY, -500, CAST(GETDATE() AS date))
GROUP BY OrderDate
ORDER BY OrderDate;


SELECT 
    PaymentStatus,
    COUNT(*) AS TotalPayments
FROM gold.fact_payments
GROUP BY PaymentStatus;

SELECT 
    Location,
    SUM(Stock) AS TotalStock
FROM gold.fact_inventory
GROUP BY Location
ORDER BY TotalStock DESC;


SELECT 
    FORMAT(CreatedDate, 'yyyy-MM') AS Month,
    COUNT(*) AS NewCustomers
FROM gold.dim_customer
GROUP BY FORMAT(CreatedDate, 'yyyy-MM')
ORDER BY Month;
