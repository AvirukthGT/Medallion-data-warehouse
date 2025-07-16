CREATE OR ALTER PROCEDURE load_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start DATETIME2 = SYSDATETIME();
    DECLARE @now DATETIME2;

    PRINT 'Starting silver layer load at ' + CONVERT(VARCHAR, @start, 121);

    -- --------------------------
    -- crm_cust_feedback
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.crm_cust_feedback... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.crm_cust_feedback;

    INSERT INTO silver.crm_cust_feedback (
        feedback_id,
        cst_id,
        feedback_test,
        feedback_date,
        rating,
        dwh_create_date
    )
    SELECT
        feedback_id,
        cst_id,
        feedback_test,
        TRY_CONVERT(DATE,
            LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(feedback_date, CHAR(13), ''), CHAR(10), ''), CHAR(160), ''), '–', '-')))
        , 105),
        CASE 
            WHEN rating > 5 THEN 5
            WHEN rating < 0 THEN 0
            ELSE rating
        END,
        GETDATE()
    FROM bronze.crm_cust_feedback
    WHERE 
        cst_id IS NOT NULL
        AND LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(feedback_date, CHAR(13), ''), CHAR(10), ''), CHAR(160), ''), '–', '-'))) NOT IN ('NA', '')
        AND TRY_CONVERT(DATE,
            LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(feedback_date, CHAR(13), ''), CHAR(10), ''), CHAR(160), ''), '–', '-')))
        , 105) IS NOT NULL;

    -- --------------------------
    -- crm_cust_segments
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.crm_cust_segments... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.crm_cust_segments;

    INSERT INTO silver.crm_cust_segments (
        segment_id,
        segment_name,
        discount_percent,
        dwh_create_date
    )
    SELECT
        segment_id,
        CASE 
            WHEN segment_name = 'Silvver' THEN 'Silver'
            WHEN segment_name IS NULL THEN 'Unknown'
            ELSE segment_name
        END,
        CASE 
            WHEN discount_percent < 0 THEN 0
            ELSE discount_percent
        END,
        GETDATE()
    FROM bronze.crm_cust_segments;

    -- --------------------------
    -- crm_customers
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.crm_customers... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.crm_customers;

    INSERT INTO silver.crm_customers (
        cst_id,
        cst_firstname,
        cst_lastname,
        cst_email,
        cst_phone,
        cst_create_date,
        segment_id,
        dwh_create_date
    )
    SELECT
        cst_id,
        LTRIM(RTRIM(cst_firstname)),
        LTRIM(RTRIM(cst_lastname)),
        NULLIF(LTRIM(RTRIM(cst_email)), ''),
        CASE 
            WHEN cst_phone IS NULL OR cst_phone LIKE '%INVALID%' THEN NULL
            ELSE 
                CASE 
                    WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cst_phone, '(', ''), ')', ''), '-', ''), '.', ''), '+', ''), ' ', ''), 'x', '')) >= 10 THEN
                        CASE 
                            WHEN CHARINDEX('x', cst_phone) > 0 THEN
                                LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cst_phone, '(', ''), ')', ''), '-', ''), '.', ''), '+', ''), ' ', ''), CHARINDEX('x', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cst_phone, '(', ''), ')', ''), '-', ''), '.', ''), '+', ''), ' ', '')) - 1)
                            ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cst_phone, '(', ''), ')', ''), '-', ''), '.', ''), '+', ''), ' ', '')
                        END
                    ELSE NULL
                END
        END,
        TRY_CONVERT(DATE, NULLIF(cst_create_date, '0000-00-00'), 105),
        ISNULL(segment_id, 99),
        GETDATE()
    FROM bronze.crm_customers
    WHERE TRY_CONVERT(DATE, NULLIF(cst_create_date, '0000-00-00'), 105) IS NOT NULL;

    -- --------------------------
    -- erp_prod_category
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.erp_prod_category... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.erp_prod_category;

    INSERT INTO silver.erp_prod_category (
        category_id,
        category_name,
        margin_percent,
        dwh_create_date
    )
    SELECT 
        category_id,
        category_name,
        maargin_percent,
        GETDATE()
    FROM bronze.erp_prod_category
    WHERE category_name IS NOT NULL
      AND maargin_percent > 0;

    -- --------------------------
    -- erp_products
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.erp_products... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.erp_products;

    INSERT INTO silver.erp_products (
        prd_id,
        prd_name,
        prd_category,
        prd_price,
        prd_create_date,
        dwh_create_date
    )
    SELECT 
        prd_id,
        prd_name,
        ISNULL(prd_category, 'Unknown'),
        CASE 
            WHEN UPPER(LTRIM(RTRIM(prd_price))) = 'FREE' THEN 0.0
            WHEN ISNUMERIC(REPLACE(prd_price, '.', '')) = 1 THEN CAST(prd_price AS FLOAT)
            ELSE NULL
        END,
        TRY_CONVERT(DATE, prd_create_date, 105),
        GETDATE()
    FROM bronze.erp_products
    WHERE 
        UPPER(LTRIM(RTRIM(prd_price))) = 'FREE' 
        OR ISNUMERIC(REPLACE(prd_price, '.', '')) = 1;

    -- --------------------------
    -- erp_prod_sales
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Loading silver.erp_prod_sales... ' + CONVERT(VARCHAR, @now, 121);

    TRUNCATE TABLE silver.erp_prod_sales;

    INSERT INTO silver.erp_prod_sales (
        sale_id,
        cst_id,
        prd_id,
        sale_date,
        quantity,
        unit_price,
        sale_amount,
        channel,
        dwh_create_date
    )
    SELECT
        sale_id,
        TRY_CAST(cst_id AS INT),
        TRY_CAST(prd_id AS INT),
        TRY_CONVERT(DATE, sale_date, 105),
        CASE 
            WHEN quantity IS NOT NULL AND quantity >= 0 THEN quantity
            ELSE NULL 
        END,
        TRY_CAST(NULLIF(unit_price, 'NaN') AS FLOAT),
        CASE 
            WHEN quantity >= 0 AND ISNUMERIC(unit_price) = 1 THEN 
                quantity * TRY_CAST(unit_price AS FLOAT)
            ELSE NULL 
        END,
        NULLIF(channel, 'Unknown'),
        GETDATE()
    FROM bronze.erp_prod_sales
    WHERE unit_price IS NOT NULL AND ISNUMERIC(unit_price) = 1;

    -- --------------------------
    -- Completion Message
    -- --------------------------
    SET @now = SYSDATETIME();
    PRINT 'Completed silver layer load at ' + CONVERT(VARCHAR, @now, 121);
    PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @start, @now) AS VARCHAR) + ' seconds';
END;
GO
