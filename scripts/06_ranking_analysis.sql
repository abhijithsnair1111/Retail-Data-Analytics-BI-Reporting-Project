/*
---------------------------------------------------------------------
Ranking Analysis
---------------------------------------------------------------------

Script Purpose:
	To rank different dimensions according to various measures.
	Find out the top or bottom performers

Method:
	USE SUM to aggregate a measure, group by a dimension and
	order by the same aggregation in ascending or descending order

---------------------------------------------------------------------
*/


-- Find the top five products generating the highest revenue
SELECT TOP 5
	p.product_name,
	SUM(s.sales) as total_revenue
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(sales) DESC
;

-- Find the top five products generating the lowest revenues
SELECT TOP 5
	p.product_name,
	SUM(s.sales) as total_revenue
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(sales) ASC
;

-- Find the top five customers generating the highest revenue
SELECT TOP 5
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales) as total_revenue
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY SUM(sales) DESC
;

-- Find the top five customers generating the lowest revenue
SELECT TOP 5
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales) as total_revenue
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY SUM(sales) ASC
;
