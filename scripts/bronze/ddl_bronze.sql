/*==============================================================================
  Script      : Create Bronze Tables
  Project     : Data Warehouse with PostgreSQL
  Schema      : bronze

  Description :
      This script creates the tables for the Bronze layer of the data warehouse.
      The Bronze layer stores raw CRM and ERP data exactly as it is received
      from the source files, with no transformations applied.

  Purpose :
      - Create all Bronze layer tables.
      - Define the structure of each table using PostgreSQL data types.
      - Prepare the database for loading raw data using the COPY command.

  Notes :
      - Existing tables are dropped before being recreated to ensure a clean setup.
      - Execute this script before running the data loading script.

==============================================================================*/

CREATE TABLE IF NOT EXISTS bronze.bronze_crm_cust_info
(
    cst_id integer,
    cst_key varchar(50),
    cst_firstname varchar(50),
    cst_lastname varchar(50),
    cst_marital_status varchar(50),
    cst_gndr varchar(50),
    cst_create_date date
)

CREATE TABLE IF NOT EXISTS bronze.bronze_crm_prd_info
(
    prd_id integer,
    prd_key varchar(50),
    prd_nm varchar(50), 
    prd_cost integer,
    prd_line varchar(50),
    prd_start_dt timestamp
    prd_end_dt timestamp 
)

CREATE TABLE IF NOT EXISTS bronze.bronze_crm_sales_details
(
    sls_ord_num varchar(50),
    sls_prd_key varchar(50),
    sls_cust_id integer,
    sls_order_dt integer,
    sls_ship_dt integer,
    sls_due_dt integer,
    sls_sales integer,
    sls_quantity integer,
    sls_price integer
)

CREATE TABLE IF NOT EXISTS bronze.bronze_erp_loc_a101
(
    cid varchar(50),
    cntry varchar(50)
)

CREATE TABLE IF NOT EXISTS bronze.bronze_erp_cust_az12
(
    cid varchar(50),
    bdate date,
    gen varchar(50)
)

CREATE TABLE IF NOT EXISTS bronze.bronze_erp_px_cat_g1v2
(
    id varchar(50),
    cat varchar(50),
    subcat varchar(50),
    mainteanance varchar(50)
)
