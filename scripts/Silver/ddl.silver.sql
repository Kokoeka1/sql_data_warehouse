/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================

Script Purpose:
    This script creates the tables for the Silver layer of the data warehouse.
    Existing tables are dropped and recreated to ensure the schema is up to date.

    Execute this script to define or refresh the table structure for the
    'silver' schema before loading or transforming data.

===============================================================================
*/

CREATE TABLE IF NOT EXISTS silver.silver_crm_cust_info
(
    cst_id integer,
    cst_key varchar(50),
    cst_firstname varchar(50),
    cst_lastname varchar(50),
    cst_marital_status varchar(50),
    cst_gndr varchar(50), 
    cst_create_date date,
    dwh_create_date timestamp 
)

CREATE TABLE IF NOT EXISTS silver.silver_crm_prd_info
(
    prd_id integer,
    cat_id varchar(50),
    prd_key varchar(50),
    prd_nm varchar(50),
    prd_cost integer,
    prd_line character varying(50)
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date timestamp 
)

CREATE TABLE IF NOT EXISTS silver.silver_crm_sales_details
(
    sls_ord_num varchar(50)
    sls_prd_key varchar(50),
    sls_cust_id integer,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales integer,
    sls_quantity integer,
    sls_price integer,
    dwh_create_date timestamp 
)

CREATE TABLE IF NOT EXISTS silver.silver_erp_cust_az12
(
    cid varchar(50),
    bdate date,
    gen varchar(20),
    dwh_create_date timestamp 
)

CREATE TABLE IF NOT EXISTS silver.silver_erp_loc_a101
(
    cid varchar(50)
    cntry varchar(50),
    dwh_create_date timestamp 
)

CREATE TABLE IF NOT EXISTS silver.silver_erp_px_cat_g1v2
(
    id character varying(50),
    cat character varying(50),
    subcat character varying(50),
    mainteanance character varying(20),
    dwh_create_date timestamp
)
