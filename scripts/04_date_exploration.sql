/*
---------------------------------------------------------------------
Date Exploration
---------------------------------------------------------------------

Script Purpose:
	Explore the Date range of several important date values.

Method:
	Use MIN and MAX function to get first and last date value then
	use DATEDIFF to get the range between them

---------------------------------------------------------------------
*/


-- Find the first and last date of order details and find the difference in months (eg: Order Date)
SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales
;

-- Find the oldest and youngest customers based on birthdate
SELECT
	MIN(birthdate) AS oldest_birth_date,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age,
	MAX(birthdate) AS youngest_birth_date,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers
;
