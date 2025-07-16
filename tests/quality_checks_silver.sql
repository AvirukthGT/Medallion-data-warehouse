select * from  silver.crm_cust_feedback

-- Check for NULLs or Duplicates in Primary Key
SELECT 
    feedback_id,
    COUNT(*) as count
FROM silver.crm_cust_feedback
GROUP BY feedback_id
HAVING COUNT(*) > 1 OR feedback_id IS NULL;

SELECT 
    cst_id,
    COUNT(*) as count
FROM silver.crm_cust_feedback
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


SELECT 
    feedback_test 
FROM silver.crm_cust_feedback
WHERE feedback_test != TRIM(feedback_test);

--miissing date values
select 
	feedback_date,count(*) as count
	from silver.crm_cust_feedback 
	where feedback_date is null
	group by feedback_date


select 
	rating,count(*) as count
	from silver.crm_cust_feedback 
	group by rating
	
-- ====================================================================
-- Checking 'silver.crm_cust_segments'
-- ====================================================================

select * from  silver.crm_cust_segments

SELECT segment_id, segment_name
FROM silver.crm_cust_segments
WHERE segment_name NOT IN ('Regular', 'Silver', 'Gold', 'Platinum')
   OR segment_name IS NULL;


SELECT segment_id, discount_percent
FROM silver.crm_cust_segments
WHERE discount_percent < 0;

SELECT segment_id
FROM silver.crm_cust_segments
WHERE segment_name IS NULL;


-- ====================================================================
-- Checking 'silver.crm_customers'
-- ====================================================================

select * from silver.crm_customers

SELECT 
    cst_id,
    COUNT(*) as count
FROM silver.crm_customers
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT 
    cst_firstname 
FROM silver.crm_customers
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
    cst_lastname
FROM silver.crm_customers
WHERE cst_lastname != TRIM(cst_lastname);

SELECT 
    cst_firstname,cst_lastname
FROM silver.crm_customers
WHERE cst_firstname is NULL or cst_lastname is NULL;

SELECT 
    cst_id,cst_firstname,cst_email
FROM silver.crm_customers
WHERE cst_email is NULL;

select cst_phone from silver.crm_customers

select  cst_id,cst_phone from silver.crm_customers
where cst_phone = 'INVALID'

select cst_create_date from silver.crm_customers
where cst_create_date = '0000-00-00'

select cst_create_date from silver.crm_customers
where cst_create_date = 'NA' or cst_create_date is NULL


select segment_id,count(*) from silver.crm_customers
group by segment_id

-- ====================================================================
-- Checking 'silver.erp_prod_category'
-- ====================================================================

select * from silver.erp_prod_category

-- Test 1: Null category names
SELECT * 
FROM silver.erp_prod_category
WHERE category_name IS NULL;

-- Test 2: Invalid margin values (negative or zero)
SELECT * 
FROM silver.erp_prod_category
WHERE margin_percent IS NULL OR margin_percent <= 0;

-- Test 3: Duplicate category IDs
SELECT category_id, COUNT(*) AS count
FROM silver.erp_prod_category
GROUP BY category_id
HAVING COUNT(*) > 1;



-- ====================================================================
-- Checking 'silver.erp_products'
-- ====================================================================

select * from silver.erp_products

select prd_id,count(*) as count from silver.erp_products 
group by prd_id
having count(*)>1

SELECT 
    prd_name
FROM silver.erp_products
WHERE prd_name != TRIM(prd_name);

SELECT 
    prd_name
FROM silver.erp_products
WHERE prd_name is NULL or prd_name=' '

SELECT 
    prd_category
FROM silver.erp_products
WHERE prd_category != TRIM(prd_category);

SELECT 
    prd_category
FROM silver.erp_products
WHERE prd_category is NULL or prd_category=' '


SELECT 
    prd_id,prd_price
FROM silver.erp_products
WHERE prd_price='FREE' 

SELECT 
    prd_id,prd_create_date
FROM silver.erp_products
WHERE prd_create_date is NULL 


-- ====================================================================
-- Checking 'silver.erp_prod_sales'
-- ====================================================================

select * from silver.erp_prod_sales

-- Null checks
SELECT COUNT(*) AS null_cst_id FROM silver.erp_prod_sales WHERE cst_id IS NULL;
SELECT COUNT(*) AS null_prd_id FROM silver.erp_prod_sales WHERE prd_id IS NULL;
SELECT COUNT(*) AS null_quantity FROM silver.erp_prod_sales WHERE quantity IS NULL;
SELECT COUNT(*) AS negative_quantity FROM silver.erp_prod_sales WHERE quantity < 0;
SELECT COUNT(*) AS null_unit_price FROM silver.erp_prod_sales WHERE unit_price IS NULL;
SELECT COUNT(*) AS null_sale_amount FROM silver.erp_prod_sales WHERE sale_amount IS NULL;
SELECT COUNT(*) AS null_channel FROM silver.erp_prod_sales WHERE channel IS NULL;

-- Sale date issues
SELECT DISTINCT sale_date 
FROM silver.erp_prod_sales 
WHERE TRY_CONVERT(DATE, sale_date, 105) IS NULL;

-- Invalid channels
SELECT DISTINCT channel 
FROM silver.erp_prod_sales;