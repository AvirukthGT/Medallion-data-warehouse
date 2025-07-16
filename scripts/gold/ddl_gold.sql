/*
===============================================================================
DDL Script: Create Gold Views (Star Schema for Analytics)
===============================================================================
Purpose:
    These views define the Gold layer of the Medallion architecture, transforming
    cleaned Silver-level tables into analytics-ready dimension and fact views.

    Includes:
        - Dimension views for Customers and Products
        - Fact views for Sales and Feedback
        - Aggregated metrics for customer feedback

Usage:
    These views can be queried directly for reporting, dashboards, and analysis.
===============================================================================
*/


-- =============================================================================
-- Dimension: gold.dim_customers
-- Description: Surrogate-keyed customer dimension with segment attributes
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.cst_id) AS customer_key, -- Surrogate key
    c.cst_id,                        -- Natural business key
    c.cst_firstname,
    c.cst_lastname,
    c.cst_email,
    c.cst_phone,
    c.cst_create_date,
    s.segment_name,
    s.discount_percent
FROM silver.crm_customers c
LEFT JOIN silver.crm_cust_segments s
    ON c.segment_id = s.segment_id;
GO


-- =============================================================================
-- Dimension: gold.dim_products
-- Description: Product dimension combining product and category metadata
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.prd_id) AS product_key, -- Surrogate key
    p.prd_id,                          -- Natural product ID
    p.prd_name,
    p.prd_category,
    p.prd_price,
    p.prd_create_date,
    c.category_name,
    c.margin_percent
FROM silver.erp_products p
LEFT JOIN silver.erp_prod_category c
    ON p.prd_category = c.category_name;
GO


-- =============================================================================
-- Fact Table: gold.fact_sales
-- Description: Sales fact table linked to customer and product dimensions
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    s.sale_id,
    dc.customer_key, -- FK to gold.dim_customers
    dp.product_key,  -- FK to gold.dim_products
    s.sale_date,
    s.quantity,
    s.unit_price,
    s.sale_amount,
    s.channel
FROM silver.erp_prod_sales s
LEFT JOIN gold.dim_customers dc
    ON s.cst_id = dc.cst_id
LEFT JOIN gold.dim_products dp
    ON s.prd_id = dp.prd_id;
GO


-- =============================================================================
-- Fact Table: gold.fact_feedback
-- Description: Feedback fact table joined with customer dimension
-- =============================================================================
IF OBJECT_ID('gold.fact_feedback', 'V') IS NOT NULL
    DROP VIEW gold.fact_feedback;
GO

CREATE VIEW gold.fact_feedback AS
SELECT
    f.feedback_id,
    dc.customer_key, -- FK to gold.dim_customers
    f.feedback_test,
    f.feedback_date,
    f.rating
FROM silver.crm_cust_feedback f
LEFT JOIN gold.dim_customers dc
    ON f.cst_id = dc.cst_id;
GO


-- =============================================================================
-- Aggregated Metrics: gold.agg_feedback_metrics
-- Description: Summary of feedback ratings per customer
-- =============================================================================
IF OBJECT_ID('gold.agg_feedback_metrics', 'V') IS NOT NULL
    DROP VIEW gold.agg_feedback_metrics;
GO

CREATE VIEW gold.agg_feedback_metrics AS
SELECT
    dc.customer_key,
    COUNT(f.feedback_id) AS feedback_count,
    AVG(CAST(f.rating AS FLOAT)) AS avg_rating
FROM silver.crm_cust_feedback f
JOIN gold.dim_customers dc
    ON f.cst_id = dc.cst_id
GROUP BY dc.customer_key;
GO
