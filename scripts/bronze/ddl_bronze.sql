/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist. Run this script to re-define the DDL structure of 
    'bronze' tables.

Script Type: Data Definition Language (DDL)
Target Schema: bronze
Database Layer: Bronze (Raw/Source Data Layer)

Execution Notes:
    - Script will drop and recreate all tables (CAUTION: Data loss will occur)
    - Execute with appropriate database permissions (db_owner or DDL_ADMIN)
    - Verify backups are in place before execution in production environments
    - All tables are created without constraints or indexes (raw layer design)
===============================================================================
*/

/*
===============================================================================
TABLE: bronze.crm_cust_info
===============================================================================
Description: 
    Customer information sourced from CRM system. Stores core customer master 
    data including identification, demographics, and account creation details.

Source System: CRM
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - cst_id: Unique customer identifier (primary key candidate)
    - cst_key: Business key for customer reference
    - cst_firstname: Customer first name
    - cst_lastname: Customer last name
    - cst_marital_status: Customer marital status
    - cst_gndr: Customer gender code
    - cst_create_date: Account creation date
===============================================================================
*/
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(70),
    cst_firstname       NVARCHAR(70),
    cst_lastname        NVARCHAR(70),
    cst_marital_status  NVARCHAR(70),
    cst_gndr            NVARCHAR(70),
    cst_create_date     DATE
);
GO

/*
===============================================================================
TABLE: bronze.crm_prd_info
===============================================================================
Description:
    Product information sourced from CRM system. Contains product master data
    including identifiers, descriptions, pricing, and product line assignments
    with effective date ranges.

Source System: CRM
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - prd_id: Unique product identifier (primary key candidate)
    - prd_key: Business key for product reference
    - prd_nm: Product name/description
    - prd_cost: Product cost (NOTE: Verify currency and precision requirements)
    - prd_line: Product line assignment/category
    - prd_start_dt: Product availability start date
    - prd_end_dt: Product availability end date (NULL = active)
===============================================================================
*/
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(70),
    prd_nm       NVARCHAR(70),
    prd_cost     INT,
    prd_line     NVARCHAR(70),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

/*
===============================================================================
TABLE: bronze.crm_sales_details
===============================================================================
Description:
    Sales transaction details sourced from CRM system. Contains granular sales
    order information including order line items, customer references, and
    fulfillment metrics (order, ship, and due dates).

Source System: CRM
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - sls_ord_num: Sales order number (order identifier)
    - sls_prd_key: Product key reference (links to crm_prd_info)
    - sls_cust_id: Customer ID reference (links to crm_cust_info)
    - sls_order_dt: Order date (NOTE: Stored as INT - verify if date conversion needed)
    - sls_ship_dt: Shipment date (NOTE: Stored as INT - verify if date conversion needed)
    - sls_due_dt: Due/Expected delivery date (NOTE: Stored as INT - verify if date conversion needed)
    - sls_sales: Sales amount in currency units
    - sls_quantity: Number of units sold
    - sls_price: Unit price (NOTE: Verify calculation: sls_sales / sls_quantity)
===============================================================================
*/
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(70),
    sls_prd_key  NVARCHAR(70),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

/*
===============================================================================
TABLE: bronze.erp_loc_a101
===============================================================================
Description:
    Location/Geography information sourced from ERP system. Contains country
    and location master data, keyed by customer ID or entity ID.

Source System: ERP (Module: A101)
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - cid: Customer or entity ID (reference key)
    - cntry: Country code or country name
===============================================================================
*/
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(70),
    cntry  NVARCHAR(70)
);
GO

/*
===============================================================================
TABLE: bronze.erp_cust_az12
===============================================================================
Description:
    Customer demographic information sourced from ERP system. Stores additional
    customer attributes including birth date and gender, identified by customer ID.

Source System: ERP (Module: AZ12)
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - cid: Customer ID (reference key - should link to crm_cust_info.cst_id)
    - bdate: Customer birth date
    - gen: Gender code (NOTE: Verify consistency with crm_cust_info.cst_gndr)
===============================================================================
*/
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(70),
    bdate  DATE,
    gen    NVARCHAR(70)
);
GO

/*
===============================================================================
TABLE: bronze.erp_px_cat_g1v2
===============================================================================
Description:
    Product categorization and pricing information sourced from ERP system.
    Contains product hierarchy (categories and subcategories) and maintenance
    indicators, version 2 of the G1 product catalog schema.

Source System: ERP (Module: PX, Catalog: G1, Version: 2)
Data Refresh: [Frequency to be specified]
Last Modified: [Date to be specified]
Owner: [Data Owner/Team to be specified]

Columns:
    - id: Product ID (reference key - should link to crm_prd_info.prd_id)
    - cat: Product category classification
    - subcat: Product subcategory classification
    - maintenance: Maintenance flag or maintenance type indicator
===============================================================================
*/
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(70),
    cat          NVARCHAR(70),
    subcat       NVARCHAR(70),
    maintenance  NVARCHAR(70)
);
GO
