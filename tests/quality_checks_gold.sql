/*
===============================================================================
Data Quality Validation
===============================================================================

Script Purpose:
    This script runs a series of data quality checks on the Gold layer to
    verify that the data is complete, consistent, and suitable for reporting
    and analytics. The validation includes:
    - Confirming the uniqueness of surrogate keys in dimension views.
    - Verifying referential integrity between fact and dimension views.
    - Ensuring relationships within the star schema are accurate and complete.

Usage Notes:
    - Review the results of each validation query.
    - Investigate and correct any issues before using the Gold layer for
      reporting or business analysis.

===============================================================================
*/

-- ============================================================================
-- Validate: gold.dim_customers
-- ============================================================================

-- Check that customer_key values are unique.
-- Expected result: 0 rows returned.
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- Validate: gold.dim_products
-- ============================================================================

-- Check that product_key values are unique.
-- Expected result: 0 rows returned.
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- Validate: gold.fact_sales
-- ============================================================================

-- Verify referential integrity between the fact table and dimension tables.
-- Expected result: 0 rows returned.
SELECT
    *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;
