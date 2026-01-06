/*
---------------------------------------------------------------------
Data Segmentation
---------------------------------------------------------------------

Script Purpose:
	Group data into meaningful categories based on a specific metric

Method:
	Use SUM function to aggregate a measure as CTE and use
	CASE Statements to segment them based on a criteria

---------------------------------------------------------------------
*/


-- Group the customers based on the spending behaviour
--	1. VIP - Customers with at least 12 months of purchase history and spend more than or equal to $5000
--  2. Regular - Customers with at least 12 months of purchase history and spend less than $5000
--  3. New - Customers with less than 12 months of purchase history
-- Find the total number of customers by each group

WITH customer_lifespan AS
(
SELECT
	c.customer_key,
	SUM(s.sales) AS total_sales,
	MIN(s.order_date) AS first_order,
	MAX(s.order_date) AS last_order,
	DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) as lifespan
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_segments,
	COUNT(customer_key) AS total_customers
FROM
(
	SELECT
		customer_key,
		total_sales,
		lifespan,
		CASE WHEN lifespan >= 12 AND total_sales >= 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
			 ELSE 'New'
		END customer_segments
	FROM customer_lifespan
)t
GROUP BY customer_segments
ORDER BY total_customers
;
