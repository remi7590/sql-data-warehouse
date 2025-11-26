-- BRONZE: raw landing table (all as text)
CREATE TABLE bronze_Customers (
    CustomerID   VARCHAR(20),
    FullName     VARCHAR(200),
    Email        VARCHAR(200),
    Phone        VARCHAR(50),
    Country      VARCHAR(100),
    CreatedDate  VARCHAR(20)
);

BULK INSERT bronze_Customers
FROM 'C:\Users\Remi Billgates\Downloads\Customer.csv' 
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

CREATE TABLE Bronze_orders (
    OrderID      VARCHAR(20),
    CustomerID   VARCHAR(20),
    OrderDate    VARCHAR(20),
    Amount       VARCHAR(50),
    PaymentMode  VARCHAR(100),
    Status       VARCHAR(100)
);

BULK INSERT bronze_Orders
FROM 'C:\Users\Remi Billgates\Downloads\order.csv'
WITH (
    FIRSTROW = 2,    
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

select top (50) * from bronze_Orders;


CREATE TABLE bronze_Inventory (
    InventoryID  VARCHAR(20),
    ProductID    VARCHAR(20),
    Stock        VARCHAR(50),
    UpdatedDate  VARCHAR(20),
    Location     VARCHAR(100)
);

BULK INSERT bronze_Inventory
FROM 'C:\Users\Remi Billgates\Downloads\inventery.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

 CREATE TABLE bronze_Payments (
    PaymentID      VARCHAR(20),
    OrderID        VARCHAR(20),
    Amount         VARCHAR(50),
    PaymentDate    VARCHAR(20),
    PaymentMode    VARCHAR(100),
    PaymentStatus  VARCHAR(100)
);

BULK INSERT bronze_Payments
FROM 'C:\Users\Remi Billgates\Downloads\payments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

select * from bronze_Payments

CREATE TABLE bronze_Products (
    ProductID    VARCHAR(20),
    ProductName  VARCHAR(200),
    Category     VARCHAR(100),
    Price        VARCHAR(50),
    CreatedDate  VARCHAR(20)
);

BULK INSERT bronze_Products
FROM 'C:\Users\Remi Billgates\Downloads\products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);


