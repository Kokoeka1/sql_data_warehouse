/*
===============================================================================
Data Quality Validation
===============================================================================
Script Purpose:
    This script executes a series of validation checks on the Silver layer to
    ensure the data is clean, consistent, and ready for downstream
    transformations. The checks include:
    - Detecting null or duplicate values in primary key columns.
    - Identifying leading and trailing whitespace in text fields.
    - Verifying data standardization and consistency across records.
    - Validating date values and chronological order.
    - Confirming consistency between related attributes.

Usage Notes:
    - Run this script after the Silver layer has been loaded and transformed.
    - Review the results and resolve any data quality issues before creating
      the Gold layer.
===============================================================================
*/
-- ============================================================================
-- Validate: silver.silver_crm_cust_info
-- ============================================================================
-- Check for NULL or duplicate values in the primary key.
-- Expected result: 0 rows returned.
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.silver_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- Check for leading or trailing whitespace.
-- Expected result: 0 rows returned.
SELECT
    cst_key
FROM silver.silver_crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Review data standardization and consistency.
SELECT DISTINCT
    cst_marital_status
FROM silver.silver_crm_cust_info;

-- ============================================================================
-- Validate: silver.silver_crm_prd_info
-- ============================================================================
-- Check for NULL or duplicate values in the primary key.
-- Expected result: 0 rows returned.
SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.silver_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- Check for leading or trailing whitespace.
-- Expected result: 0 rows returned.
SELECT
    prd_nm
FROM silver.silver_crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Check for NULL or negative product costs.
-- Expected result: 0 rows returned.
SELECT
    prd_cost
FROM silver.silver_crm_prd_info
WHERE prd_cost < 0
   OR prd_cost IS NULL;

-- Review data standardization and consistency.
SELECT DISTINCT
    prd_line
FROM silver.silver_crm_prd_info;

-- Check for invalid date ranges.
-- Expected result: 0 rows returned.
SELECT
    *
FROM silver.silver_crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ============================================================================
-- Validate: silver.silver_crm_sales_details
-- ============================================================================

-- Check for invalid date values.
-- Expected result: 0 rows returned.
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM silver.silver_crm_sales_details
WHERE sls_due_dt <= 0
   OR LENGTH(sls_due_dt::text) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Check for invalid date order.
-- Expected result: 0 rows returned.
SELECT
    *
FROM silver.silver_crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Verify sales amount consistency.
-- Expected result: 0 rows returned.
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.silver_crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;


-- ============================================================================
-- Validate: silver.silver_erp_cust_az12
-- ============================================================================

-- Check for out-of-range birthdates.
-- Expected result: Birthdates between 1924-01-01 and today.
SELECT DISTINCT
    bdate
FROM silver.silver_erp_cust_az12
WHERE bdate < DATE '1924-01-01'
   OR bdate > CURRENT_DATE;

-- Review data standardization and consistency.
SELECT DISTINCT
    gen
FROM silver.silver_erp_cust_az12;


-- ============================================================================
-- Validate: silver.silver_erp_loc_a101
-- ============================================================================

-- Review data standardization and consistency.
SELECT DISTINCT
    cntry
FROM silver.silver_erp_loc_a101
ORDER BY
    cntry;


-- ============================================================================
-- Validate: silver.silver_erp_px_cat_g1v2
-- ============================================================================

-- Check for leading or trailing whitespace.
-- Expected result: 0 rows returned.
SELECT
    *
FROM silver.silver_erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- Review data standardization and consistency.
SELECT DISTINCT
    maintenance
FROM silver.silver_erp_px_cat_g1v2;

