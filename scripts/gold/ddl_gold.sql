/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
-- Drop the view first if it already exists, so the script can be re-run safely
-- without throwing an "object already exists" error.
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

-- This view builds the customer dimension by combining CRM customer master
-- data with supplementary demographic and location attributes from the ERP
-- system, producing a single, conformed view of each customer.
CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id                          AS customer_id,
    ci.cst_key                         AS customer_number,
    ci.cst_firstname                   AS first_name,
    ci.cst_lastname                    AS last_name,
    la.cntry                           AS country,
    ci.cst_marital_status              AS marital_status,
    -- Gender is sourced from two systems; CRM is treated as the authoritative
    -- source, and we only fall back to the ERP-supplied value when the CRM
    -- value is unknown ('n/a'), defaulting to 'n/a' if neither has a value.
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data
    END                                AS gender,
    ca.bdate                           AS birthdate,
    ci.cst_create_date                 AS create_date
-- Base table: cleansed CRM customer records from the Silver layer.
FROM silver.crm_cust_info ci
-- Enrich with ERP demographic data (birthdate, gender) matched on customer key.
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
-- Enrich with ERP location data (country) matched on customer key.
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
-- Drop the view first if it already exists, so the script can be re-run safely
-- without throwing an "object already exists" error.
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

-- This view builds the product dimension by combining CRM product master
-- data with category, subcategory, and maintenance attributes from the ERP
-- system, restricted to only the current (non-historical) product records.
CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
-- Base table: cleansed CRM product records from the Silver layer.
FROM silver.crm_prd_info pn
-- Enrich with ERP category, subcategory, and maintenance attributes, matched
-- on category id.
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
-- Only include the current version of each product; a non-null end date
-- indicates the record has been superseded by a newer version.
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
-- Drop the view first if it already exists, so the script can be re-run safely
-- without throwing an "object already exists" error.
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

-- This view builds the sales fact table by taking cleansed CRM sales
-- transaction details and resolving them against the product and customer
-- dimensions, so each sales record carries the surrogate keys needed for
-- star-schema joins in reporting and analytics.
CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
-- Base table: cleansed CRM sales transaction details from the Silver layer.
FROM silver.crm_sales_details sd
-- Resolve the natural product key to the product dimension's surrogate key.
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
-- Resolve the natural customer id to the customer dimension's surrogate key.
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
