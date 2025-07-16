-- =============================================================================
-- DDL Script: Create Silver Tables (Generated: 2025-07-16)
-- =============================================================================

-- Customer Feedback
IF OBJECT_ID('silver.crm_cust_feedback', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_feedback;
GO

CREATE TABLE silver.crm_cust_feedback (
    feedback_id     INT PRIMARY KEY,
    cst_id          INT NOT NULL,
    feedback_test   NVARCHAR(255),
    feedback_date   DATE,
    rating          INT CHECK (rating BETWEEN 0 AND 5),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Customers
IF OBJECT_ID('silver.crm_customers', 'U') IS NOT NULL
    DROP TABLE silver.crm_customers;
GO

CREATE TABLE silver.crm_customers (
    cst_id           INT,
    cst_firstname    NVARCHAR(50),
    cst_lastname     NVARCHAR(50),
    cst_email        NVARCHAR(80),
    cst_phone        NVARCHAR(100),
    cst_create_date  DATE,
    segment_id       INT,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- Customer Segments
IF OBJECT_ID('silver.crm_cust_segments', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_segments;
GO

CREATE TABLE silver.crm_cust_segments (
    segment_id        INT,
    segment_name      NVARCHAR(30),
    discount_percent  INT,
    dwh_create_date   DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP Product Category
IF OBJECT_ID('silver.erp_prod_category', 'U') IS NOT NULL
    DROP TABLE silver.erp_prod_category;
GO

CREATE TABLE silver.erp_prod_category (
    category_id      INT,
    category_name    NVARCHAR(30),
    margin_percent   FLOAT,  -- Corrected column name typo
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP Products
IF OBJECT_ID('silver.erp_products', 'U') IS NOT NULL
    DROP TABLE silver.erp_products;
GO

CREATE TABLE silver.erp_products (
    prd_id           INT,
    prd_name         NVARCHAR(200),
    prd_category     NVARCHAR(100),
    prd_price        FLOAT,
    prd_create_date  DATE,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

-- ERP Product Sales
IF OBJECT_ID('silver.erp_prod_sales', 'U') IS NOT NULL
    DROP TABLE silver.erp_prod_sales;
GO

CREATE TABLE silver.erp_prod_sales (
    sale_id         INT,
    cst_id          INT,
    prd_id          INT,
    sale_date       DATE,
    quantity        INT,
    unit_price      FLOAT,
    sale_amount     FLOAT,
    channel         NVARCHAR(100),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

