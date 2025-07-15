CREATE OR ALTER PROCEDURE bronze.load_bronze_crm_erp AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze CRM & ERP Tables';
        PRINT '================================================';

        -------------------------------
        -- CRM SECTION
        -------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.crm_cust_feedback';
        TRUNCATE TABLE bronze.crm_cust_feedback;
        PRINT '>> Inserting: bronze.crm_cust_feedback';
        BULK INSERT bronze.crm_cust_feedback 
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\CRM_CustomerFeedback.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.crm_customers';
        TRUNCATE TABLE bronze.crm_customers;
        PRINT '>> Inserting: bronze.crm_customers';
        BULK INSERT bronze.crm_customers 
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\CRM_Customers.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.crm_cust_segments';
        TRUNCATE TABLE bronze.crm_cust_segments;
        PRINT '>> Inserting: bronze.crm_cust_segments';
        BULK INSERT bronze.crm_cust_segments 
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\CRM_CustomerSegments.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        -------------------------------
        -- ERP SECTION
        -------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.erp_prod_category';
        TRUNCATE TABLE bronze.erp_prod_category;
        PRINT '>> Inserting: bronze.erp_prod_category';
        BULK INSERT bronze.erp_prod_category
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\ERP_ProductCategories.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.erp_products';
        TRUNCATE TABLE bronze.erp_products;
        PRINT '>> Inserting: bronze.erp_products';
        BULK INSERT bronze.erp_products
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\ERP_Products.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        SET @start_time = GETDATE();
        PRINT '>> Truncating: bronze.erp_prod_sales';
        TRUNCATE TABLE bronze.erp_prod_sales;
        PRINT '>> Inserting: bronze.erp_prod_sales';
        BULK INSERT bronze.erp_prod_sales
        FROM 'C:\Users\agtbe\OneDrive\Desktop\Projects\Medallion-data-warehouse\Datasets\ERP_Sales.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';

        -------------------------------
        -- Done
        -------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Bronze CRM & ERP Load Completed';
        PRINT '   - Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR DURING BRONZE CRM & ERP LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;
