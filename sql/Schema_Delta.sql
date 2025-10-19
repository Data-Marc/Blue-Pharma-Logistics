-- =====================================================
-- Blue Pharma Logistics - SQL Schema (SQL Server)
-- =====================================================

CREATE DATABASE BluePharmaLogistics;
GO

USE BluePharmaLogistics;
GO

-- 🧱 TABLE: Deliveries
CREATE TABLE Deliveries (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NULL,
    ProductID INT NULL,
    CarrierID INT NULL,
    Origin NVARCHAR(100),
    Destination NVARCHAR(100),
    DepartureDate DATE,
    ArrivalDate DATE,
    OnTime BIT,
    Cost DECIMAL(10,2)
);
GO

-- 🧾 TABLE: Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,
    OrderDate DATE,
    Status NVARCHAR(50)
);
GO

-- 📦 TABLE: Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(100),
    TemperatureRange NVARCHAR(50)
);
GO

-- 🧍 TABLE: Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Country NVARCHAR(100)
);
GO

-- 🚛 TABLE: Carriers
CREATE TABLE Carriers (
    CarrierID INT IDENTITY(1,1) PRIMARY KEY,
    CarrierName NVARCHAR(100),
    Mode NVARCHAR(50) -- e.g., Air, Sea, Road
);
GO

-- 📅 TABLE: Date (Calendar)
CREATE TABLE [Date] (
    [Date] DATE PRIMARY KEY,
    [Year] INT,
    [Month] INT,
    [MonthName] NVARCHAR(20),
    [Quarter] INT,
    [Week] INT,
    [Day] INT,
    [DayName] NVARCHAR(20),
    [IsWeekend] BIT
);
GO

-- Populate Date table (example: 2020–2030)
;WITH DateSequence AS (
    SELECT CAST('2020-01-01' AS DATE) AS [Date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [Date])
    FROM DateSequence
    WHERE [Date] < '2030-12-31'
)
INSERT INTO [Date] ([Date], [Year], [Month], [MonthName], [Quarter], [Week], [Day], [DayName], [IsWeekend])
SELECT
    [Date],
    YEAR([Date]) AS [Year],
    MONTH([Date]) AS [Month],
    DATENAME(MONTH, [Date]) AS [MonthName],
    DATEPART(QUARTER, [Date]) AS [Quarter],
    DATEPART(WEEK, [Date]) AS [Week],
    DAY([Date]) AS [Day],
    DATENAME(WEEKDAY, [Date]) AS [DayName],
    CASE WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END AS [IsWeekend]
FROM DateSequence
OPTION (MAXRECURSION 0);
GO

-- 🔗 RELATIONSHIPS (Foreign Keys)
ALTER TABLE Deliveries ADD CONSTRAINT FK_Deliveries_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);
ALTER TABLE Deliveries ADD CONSTRAINT FK_Deliveries_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID);
ALTER TABLE Deliveries ADD CONSTRAINT FK_Deliveries_Carriers FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID);
ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

-- ⚡ INDEXES FOR PERFORMANCE
CREATE INDEX IX_Deliveries_OnTime ON Deliveries(OnTime);
CREATE INDEX IX_Deliveries_DepartureDate ON Deliveries(DepartureDate);
CREATE INDEX IX_Orders_Status ON Orders(Status);
GO

PRINT '✅ Blue Pharma Logistics schema successfully created.';
