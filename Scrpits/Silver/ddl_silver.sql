NSERT INTO silver_Customers (
    CustomerID,
    FullName,
    Email,
    Phone,
    Country,
    CreatedDate
)
SELECT
    -- CUSTOMER ID
    CASE
        WHEN LTRIM(RTRIM(CustomerID)) = '' THEN -1
        ELSE TRY_CONVERT(INT, REPLACE(LTRIM(RTRIM(CustomerID)), ' ', ''))
    END AS CustomerID,

    -- FULL NAME in lowercase, empty → 'unknown'
    upper(trim(FullName)),

    -- EMAIL lowercase
    LOWER(LTRIM(RTRIM(Email))) AS Email,

    -- PHONE with fallback
    CASE
        WHEN LEN(REPLACE(LTRIM(RTRIM(Phone)), ' ', '')) = 10
             AND ISNUMERIC(REPLACE(LTRIM(RTRIM(Phone)), ' ', '')) = 1
        THEN REPLACE(LTRIM(RTRIM(Phone)), ' ', '')
        ELSE '0000000000'
    END AS Phone,

    -- COUNTRY uppercase, empty → 'UNKNOWN'
    CASE 
        WHEN Country IS NULL OR LTRIM(RTRIM(Country)) = '' 
            THEN 'UNKNOWN'
        ELSE UPPER(LTRIM(RTRIM(Country)))
    END AS Country,

    -- DATE fallback
    CASE
        WHEN TRY_CONVERT(DATE, LTRIM(RTRIM(CreatedDate))) IS NULL 
            THEN '1900-01-01'
        ELSE TRY_CONVERT(DATE, LTRIM(RTRIM(CreatedDate)))
    END AS CreatedDate

FROM bronze_Customers;



select * from Silver_Customers


SELECT * FROM bronze_Customers;




TRUNCATE TABLE silver_Orders;

INSERT INTO silver_Orders (
    OrderID,
    CustomerID,
    OrderDate,
    Amount,
    PaymentMode,
    Status
)
SELECT
    TRY_CONVERT(INT, REPLACE(OrderID, ' ', '')) AS OrderID,
    TRY_CONVERT(INT, REPLACE(CustomerID, ' ', '')) AS CustomerID,
    TRY_CONVERT(DATE, LTRIM(RTRIM(OrderDate))) AS OrderDate,
    TRY_CONVERT(DECIMAL(18,2), REPLACE(Amount, ' ', '')) AS Amount,

    CASE 
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%UPI%'       THEN 'UPI'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%CARD%'      THEN 'CARD'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%NETBANK%'   THEN 'NETBANKING'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%WALLET%'    THEN 'WALLET'
        ELSE UPPER(LTRIM(RTRIM(PaymentMode)))
    END AS PaymentMode,

    UPPER(LTRIM(RTRIM(Status))) AS Status
FROM bronze_Orders;

select * from Silver_orders

TRUNCATE TABLE silver_Products;

INSERT INTO silver_Products (
    ProductID,
    ProductName,
    Category,
    Price,
    CreatedDate
)
SELECT
    TRY_CONVERT(INT, REPLACE(ProductID,' ','')) AS ProductID,

    CASE 
        WHEN ProductName IS NULL OR LTRIM(RTRIM(ProductName)) = '' 
            THEN 'unknown'
        ELSE upper(LTRIM(RTRIM(ProductName)))
    END AS ProductName,

    CASE
        WHEN UPPER(Category) LIKE '%ELECTR%' THEN 'ELECTRONICS'
        WHEN UPPER(Category) LIKE '%CLOTH%'  THEN 'CLOTHING'
        WHEN UPPER(Category) LIKE '%GROC%'   THEN 'GROCERY'
        WHEN UPPER(Category) LIKE '%SPORT%'  THEN 'SPORTS'
        WHEN UPPER(Category) LIKE '%HOME%'   THEN 'HOME'
        ELSE UPPER(LTRIM(RTRIM(Category)))
    END AS Category,

    TRY_CONVERT(DECIMAL(18,2), REPLACE(Price,' ','')) AS Price,

    TRY_CONVERT(DATE, LTRIM(RTRIM(CreatedDate))) AS CreatedDate
FROM bronze_Products;

select * from Silver_Products


TRUNCATE TABLE silver_Inventory;

INSERT INTO silver_Inventory (
    InventoryID,
    ProductID,
    Stock,
    UpdatedDate,
    Location
)
SELECT
    TRY_CONVERT(INT, REPLACE(InventoryID,' ','')) AS InventoryID,
    TRY_CONVERT(INT, REPLACE(ProductID,' ',''))   AS ProductID,

     CASE 
        WHEN UPPER(LTRIM(RTRIM(Stock))) IN ('NA','N A') THEN 'NA'
        WHEN TRY_CONVERT(INT, REPLACE(Stock,' ','')) IS NULL THEN 'NA'
        WHEN TRY_CONVERT(INT, REPLACE(Stock,' ','')) < 0 THEN 'NA'
        ELSE REPLACE(Stock, ' ', '')
    END AS Stock,

    TRY_CONVERT(DATE, LTRIM(RTRIM(UpdatedDate))) AS UpdatedDate,

    CASE
        WHEN UPPER(Location) LIKE '%CHENNAI%'   THEN 'CHENNAI'
        WHEN UPPER(Location) LIKE '%BANG%'      THEN 'BANGALORE'
        WHEN UPPER(Location) LIKE '%DEL%'       THEN 'DELHI'
        WHEN UPPER(Location) LIKE '%MUM%'       THEN 'MUMBAI'
        WHEN UPPER(Location) LIKE '%HYD%'       THEN 'HYDERABAD'
        ELSE UPPER(LTRIM(RTRIM(Location)))
    END AS Location
FROM bronze_Inventory;

select * from Silver_Inventory

select * from Silver_Payments

TRUNCATE TABLE silver_Payments;

INSERT INTO silver_Payments (
    PaymentID,
    OrderID,
    Amount,
    PaymentDate,
    PaymentMode,
    PaymentStatus
)
SELECT
    TRY_CONVERT(INT, REPLACE(PaymentID,' ','')) AS PaymentID,
    TRY_CONVERT(INT, REPLACE(OrderID,' ',''))   AS OrderID,

    CASE 
        WHEN UPPER(LTRIM(RTRIM(Amount))) IN ('NA','NAN') THEN 0.00
        ELSE TRY_CONVERT(DECIMAL(18,2), REPLACE(Amount,' ','')) 
    END AS Amount,

    TRY_CONVERT(DATE, LTRIM(RTRIM(PaymentDate))) AS PaymentDate,

    CASE 
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%UPI%'       THEN 'UPI'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%CARD%'      THEN 'CARD'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%NETBANK%'   THEN 'NETBANKING'
        WHEN UPPER(REPLACE(PaymentMode,' ','')) LIKE '%WALLET%'    THEN 'WALLET'
        ELSE UPPER(LTRIM(RTRIM(PaymentMode)))
    END AS PaymentMode,

    CASE 
        WHEN UPPER(PaymentStatus) LIKE '%SUCC%'   THEN 'SUCCESS'
        WHEN UPPER(PaymentStatus) LIKE '%FAIL%'   THEN 'FAILED'
        WHEN UPPER(PaymentStatus) LIKE '%PEND%'   THEN 'PENDING'
        WHEN UPPER(PaymentStatus) LIKE '%REFUND%' THEN 'REFUNDED'
        WHEN UPPER(PaymentStatus) LIKE '%CANCEL%' THEN 'CANCELLED'
        ELSE UPPER(LTRIM(RTRIM(PaymentStatus)))
    END AS PaymentStatus
FROM bronze_Payments;
