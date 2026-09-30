/*
================================================================================
PROCEDURE: bronze.load_bronze
================================================================================
PURPOSE:
    Loads raw data from source systems (CRM and ERP) into the Bronze layer
    of the data warehouse. This is the initial data ingestion step that
    performs truncate-and-load operations for all source tables.

USAGE:
    EXEC bronze.load_bronze

DEPENDENCIES:
    - Bronze schema and tables must exist
    - CSV source files must be accessible at specified paths
    - Service account must have appropriate file system and database permissions

AUTHOR:          [Author Name]
    CREATED:         [YYYY-MM-DD]
    LAST MODIFIED:   [YYYY-MM-DD]
    VERSION:         1.0

CHANGE LOG:
    - v1.0: Initial creation of Bronze layer load procedure

================================================================================
*/

EXEC bronze.load_bronze
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    
    BEGIN TRY 
        SET @batch_start_time = GETDATE();
        PRINT '=================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=================================================';

        -- =========================================================================
        -- CRM DATA INGESTION
        -- =========================================================================
        -- Load customer information, product information, and sales details
        -- from the CRM source system
        
        PRINT '-------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-------------------------------------------------';
        
        -- Load CRM Customer Information
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
    
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,           -- Skip header row
            FIELDTERMINATOR = ',',  -- CSV delimiter
            TABLOCK                 -- Enable parallel inserts for performance
        );  
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- Load CRM Product Information
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        ); 
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- Load CRM Sales Details
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- =========================================================================
        -- ERP DATA INGESTION
        -- =========================================================================
        -- Load location, customer, and product category data from the ERP 
        -- source system
       
        PRINT '-------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-------------------------------------------------';
       
        -- Load ERP Location Data (A101)
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- Load ERP Customer Data (AZ12)
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- Load ERP Product Category Data (G1V2)
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\USER\OneDrive - IU International University of Applied Sciences\Documents\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> ---------------';

        -- =========================================================================
        -- COMPLETION REPORTING
        -- =========================================================================
        SET @batch_end_time = GETDATE();
        PRINT '-----------------------------'
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'; 
        PRINT '==============================='
        
    END TRY
    BEGIN CATCH 
        -- =========================================================================
        -- ERROR HANDLING
        -- =========================================================================
        -- Log error details for troubleshooting and alerting
        PRINT '========================================'
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '========================================'
    END CATCH
END
GO
