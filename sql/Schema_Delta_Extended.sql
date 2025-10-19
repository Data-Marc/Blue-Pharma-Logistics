-- =====================================================
-- Blue Pharma Logistics - Extended SQL Schema (SQL Server)
-- =====================================================

CREATE DATABASE BluePharmaLogistics_Extended;
GO

USE BluePharmaLogistics_Extended;
GO

-- 🧾 Orders_v2
CREATE TABLE Orders_v2 (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    WarehouseID INT,
    TransportID INT,
    OrderDate DATE,
    DeliveryDate DATE,
    Quantity INT,
    Status NVARCHAR(50),
    OTIF BIT
);
GO

-- 🚚 Transportation_v2
CREATE TABLE Transportation_v2 (
    TransportID INT IDENTITY(1,1) PRIMARY KEY,
    CarrierName NVARCHAR(100),
    Mode NVARCHAR(50),
    Cost DECIMAL(10,2),
    TransitTime INT,
    PerformanceScore DECIMAL(5,2)
);
GO

-- 📦 Inventory
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    ProductID INT,
    StockQuantity INT,
    StockRotation DECIMAL(10,2),
    Stockout BIT,
    ExpirationDate DATE
);
GO

-- 💊 Products_v2
CREATE TABLE Products_v2 (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(100),
    SubCategory NVARCHAR(100),
    SupplierID INT,
    TemperatureRange NVARCHAR(50)
);
GO

-- 👥 Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Country NVARCHAR(100),
    Region NVARCHAR(50)
);
GO

-- 🏭 Suppliers
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100),
    Country NVARCHAR(100),
    Certification NVARCHAR(50)
);
GO

-- 🏢 Warehouses
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(100),
    Country NVARCHAR(100),
    Capacity INT,
    TemperatureControlled BIT
);
GO

-- 📈 ForecastWeekly
CREATE TABLE ForecastWeekly (
    ForecastID INT IDENTITY(1,1) PRIMARY KEY,
    WeekStart DATE,
    ProductID INT,
    ForecastQty INT
);
GO

-- 🌱 Sustainability
CREATE TABLE Sustainability (
    SustainabilityID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    CO2_Emissions DECIMAL(12,2),
    EnergyUsage DECIMAL(12,2),
    RecycledPackagingPct DECIMAL(5,2)
);
GO

-- 💰 WarehouseCosts
CREATE TABLE WarehouseCosts (
    CostID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT,
    FixedCost DECIMAL(12,2),
    VariableCost DECIMAL(12,2),
    LogisticCost DECIMAL(12,2)
);
GO

-- 📅 Date Table
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

-- Populate Date Table (2020–2030)
;WITH DateSequence AS (
    SELECT CAST('2020-01-01' AS DATE) AS [Date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [Date])
    FROM DateSequence
    WHERE [Date] < '2030-12-31'
)
INSERT INTO [Date] ([Date],[Year],[Month],[MonthName],[Quarter],[Week],[Day],[DayName],[IsWeekend])
SELECT
    [Date],
    YEAR([Date]),
    MONTH([Date]),
    DATENAME(MONTH, [Date]),
    DATEPART(QUARTER, [Date]),
    DATEPART(WEEK, [Date]),
    DAY([Date]),
    DATENAME(WEEKDAY, [Date]),
    CASE WHEN DATENAME(WEEKDAY, [Date]) IN ('Saturday','Sunday') THEN 1 ELSE 0 END
FROM DateSequence
OPTION (MAXRECURSION 0);
GO

-- 🔗 RELATIONSHIPS
ALTER TABLE Orders_v2 ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
ALTER TABLE Orders_v2 ADD CONSTRAINT FK_Orders_Products FOREIGN KEY (ProductID) REFERENCES Products_v2(ProductID);
ALTER TABLE Orders_v2 ADD CONSTRAINT FK_Orders_Warehouses FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID);
ALTER TABLE Orders_v2 ADD CONSTRAINT FK_Orders_Transport FOREIGN KEY (TransportID) REFERENCES Transportation_v2(TransportID);
ALTER TABLE Products_v2 ADD CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);
ALTER TABLE Inventory ADD CONSTRAINT FK_Inventory_Warehouses FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID);
ALTER TABLE Inventory ADD CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES Products_v2(ProductID);
ALTER TABLE ForecastWeekly ADD CONSTRAINT FK_Forecast_Products FOREIGN KEY (ProductID) REFERENCES Products_v2(ProductID);
ALTER TABLE Sustainability ADD CONSTRAINT FK_Sustainability_Warehouse FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID);
ALTER TABLE WarehouseCosts ADD CONSTRAINT FK_Costs_Warehouse FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID);
GO

-- ⚡ Indexes
CREATE INDEX IX_Orders_Date ON Orders_v2(OrderDate);
CREATE INDEX IX_Transportation_Mode ON Transportation_v2(Mode);
CREATE INDEX IX_Inventory_Stockout ON Inventory(Stockout);
CREATE INDEX IX_Forecast_Product ON ForecastWeekly(ProductID);
CREATE INDEX IX_Sustainability_CO2 ON Sustainability(CO2_Emissions);
CREATE INDEX IX_WarehouseCosts_Warehouse ON WarehouseCosts(WarehouseID);
GO

PRINT '✅ Blue Pharma Logistics Extended Schema created successfully.';
