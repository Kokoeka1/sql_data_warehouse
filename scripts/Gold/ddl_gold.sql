/*
===============================================================================
DDL Script: Create Gold Layer Views
===============================================================================
Script Purpose:
    This script creates the views that make up the Gold layer of the data
    warehouse.
    The Gold layer contains the final dimension and fact tables organized
    according to a star schema. These views transform, integrate, and enrich
    data from the Silver layer to provide a business-ready dataset for
    reporting, analytics, and decision-making.

Usage:
    - Execute this script after the Silver layer has been created and populated.
    - Query these views directly for dashboards, reporting, and analytical
      workloads.
===============================================================================
*/

===============================================================================
-- Create Dimension: gold.dim_customers
--===============================================================================
create view gold.dim_customers as
select
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a'then ci.cst_gndr
	else coalesce(ca.gen, 'n/a')
end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
from silver.silver_crm_cust_info as ci
left join silver.silver_erp_cust_az12 as ca
on ci.cst_key = ca.cid
left join silver.silver_erp_loc_a101 as la
on ci.cst_key = la.cid

===============================================================================
-- Create Dimension: gold.dim_products
--===============================================================================
create view gold.dim_products as 
select 
row_number() over (order by pn.prd_start_dt, pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.mainteanance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
from silver.silver_crm_prd_info as pn
left join silver.silver_erp_px_cat_g1v2 as pc
on pn.cat_id = pc.id

===============================================================================
-- Create Fact Table: gold.fact_sales
--===============================================================================
create view gold.fact_sales as 
select 
sd.sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.silver_crm_sales_details as sd
left join gold.dim_products as pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers as cu
on sd.sls_cust_id = cu.customer_id
