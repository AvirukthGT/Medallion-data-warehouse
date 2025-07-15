/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables.
===============================================================================
*/

-- ============================================================================
-- Table: bronze.crm_cust_feedback
-- Purpose: Stores customer feedback records
-- ============================================================================
IF OBJECT_ID('bronze.crm_cust_feedback', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_feedback;
GO

CREATE TABLE bronze.crm_cust_feedback (
    feedback_id     INT,                    -- Unique feedback identifier
    cst_id          INT,                    -- Foreign key to customers table
    feedback_test   NVARCHAR(255),          -- Text of the feedback
    feedback_date   DATE,                   -- Date feedback was given
    rating          INT                     -- Customer rating (e.g., 1-5)
);
GO

-- ============================================================================
-- Table: bronze.crm_customers
-- Purpose: Stores customer master data
-- ============================================================================
IF OBJECT_ID('bronze.crm_customers', 'U') IS NOT NULL
    DROP TABLE bronze.crm_customers;
GO

CREATE TABLE bronze.crm_customers (
    cst_id           INT,                   -- Customer ID (primary key)
    cst_firstname    NVARCHAR(50),          -- Customer first name
    cst_lastname     NVARCHAR(50),          -- Customer last name
    cst_email        NVARCHAR(80),          -- Email address
    cst_phone        NVARCHAR(50),          -- Contact phone number
    cst_create_date  DATE,                  -- Account creation date
    segment_id       INT                    -- Foreign key to customer segment
);
GO

-- ============================================================================
-- Table: bronze.crm_cust_segments
-- Purpose: Defines customer segmentation with associated discounts
-- ============================================================================
IF OBJECT_ID('bronze.crm_cust_segments', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_segments;
GO

CREATE TABLE bronze.crm_cust_segments (
    segment_id        INT,                  -- Segment ID (primary key)
    segment_name      NVARCHAR(30),         -- Name of the segment (e.g., Gold)
    discount_percent  INT                   -- Discount % for this segment
);
GO

-- ============================================================================
-- Table: bronze.erp_prod_category
-- Purpose: Contains product category definitions
-- ============================================================================
IF OBJECT_ID('bronze.erp_prod_category', 'U') IS NOT NULL
    DROP TABLE bronze.erp_prod_category;
GO

CREATE TABLE bronze.erp_prod_category (
    category_id      INT,                   -- Category ID (primary key)
    category_name    NVARCHAR(30),          -- Name of the category
    maargin_percent  FLOAT                  -- Expected profit margin (has typo)
);
GO

-- ============================================================================
-- Table: bronze.erp_products
-- Purpose: Stores product catalog with category and pricing info
-- ============================================================================
IF OBJECT_ID('bronze.erp_products', 'U') IS NOT NULL
    DROP TABLE bronze.erp_products;
GO

CREATE TABLE bronze.erp_products (
    prd_id           INT,                   -- Product ID (primary key)
    prd_name         NVARCHAR(200),         -- Name of the product
    prd_category     NVARCHAR(100),         -- Category name (denormalized)
    prd_price        FLOAT,                 -- Retail price
    prd_create_date  DATE                   -- Date product was added
);
GO

-- ============================================================================
-- Table: bronze.erp_prod_sales
-- Purpose: Captures individual sales transactions
-- ============================================================================
IF OBJECT_ID('bronze.erp_prod_sales', 'U') IS NOT NULL
    DROP TABLE bronze.erp_prod_sales;
GO

CREATE TABLE bronze.erp_prod_sales (
    sale_id      INT,                       -- Unique sale transaction ID
    cst_id       INT,                       -- Customer who made the purchase
    prd_id       INT,                       -- Product sold
    sale_date    DATE,                      -- Date of transaction
    quantity     INT,                       -- Units sold
    unit_price   FLOAT,                     -- Price per unit at sale time
    sale_amount  FLOAT,                     -- Total amount = quantity * unit_price
    channel      NVARCHAR(100)              -- Sales channel (e.g., Online, In-Store)
);
GO
