/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
-- A surrogate key must uniquely identify each row in the dimension; any
-- customer_key appearing more than once indicates a flaw upstream in the
-- surrogate key generation (e.g. a non-unique ordering column) or a
-- duplicate source record that was not deduplicated before loading.
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
-- Same uniqueness check as above, applied to the product dimension's
-- surrogate key, to confirm each product is represented by exactly one row.
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Confirms referential integrity: every fact row should successfully match
-- a row in both the customer and product dimensions. Using LEFT JOINs and
-- filtering for NULL keys surfaces any "orphaned" fact records whose
-- customer_key or product_key could not be resolved against the
-- dimensions — these indicate missing dimension records or a broken join
-- key that would otherwise silently drop rows from star-schema reporting.
-- Expectation: No results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
