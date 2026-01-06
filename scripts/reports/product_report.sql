/*
---------------------------------------------------------------------
Product Report
---------------------------------------------------------------------

Script Purpose:
	Create a report for the productds by summerizing all the key
	metrics from Sales table and Products table into one table

Hightlights
	-Includes all the key product valus like
		1. Product Key
		2. Product Number
		3. Product Name
		4. Category
		5. Subcategory
		6. Cost

	- Segments products based on
		1. Product Performance

	- Aggregated product details 
		1. Total Orders
		2. Total Sales
		3. Toal Quantity
		4. Total Customers
		5. Average Selling Price

	- Calculated KPIs
		1. Recency (Months since last order)
		2. Average Order Revenue
		3. Average Monthly Revenue

---------------------------------------------------------------------
*/


---------------------------------------------------------------------
-- Create Report: gold.product_report as View
---------------------------------------------------------------------
IF OBJECT_ID('gold.product_report', 'V') IS NOT NULL
	DROP VIEW gold.product_report
;
GO

CREATE VIEW gold.product_report AS

WITH base_query AS
---------------------------------------------------------------------
-- Base Query: Extract all the core columns for analysis
---------------------------------------------------------------------
(
SELECT
	s.order_number,
	s.customer_key,
	s.order_date,
	s.sales,
	s.quantity,
	p.product_key,
	p.product_number,
	p.product_name,
	p.category,
	p.subcategory,
	P.cost
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
)

,product_aggregations AS
---------------------------------------------------------------------
-- Aggragate Query: Aggregate core columns for analysis
---------------------------------------------------------------------
(
SELECT
	product_key,
	product_number,
	product_name,
	category,
	subcategory,
	cost,
	MAX(order_date) AS last_sale_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
FROM base_query
GROUP BY
	product_key,
	product_number,
	product_name,
	category,
	subcategory,
	cost
)

---------------------------------------------------------------------
-- Main Query: Create Report based on Base and Aggregate Queries
---------------------------------------------------------------------
SELECT
	product_key,
	product_number,
	product_name,
	category,
	subcategory,
	cost,
	CASE
		-- Product Segments based on Sales
		WHEN total_sales >= 50000 THEN 'High Performer'
		WHEN total_sales >= 10000 THEN 'Mid Performer'
		ELSE 'Low Performer'
	END AS product_segments,
	lifespan,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months, -- Months since last order
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue
	CASE
		WHEN total_quantity = 0 THEN 0
		ELSE total_sales / total_quantity
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregations
;
