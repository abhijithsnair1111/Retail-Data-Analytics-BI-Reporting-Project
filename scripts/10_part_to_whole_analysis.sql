/*
---------------------------------------------------------------------
Part-To-Whole Analysis
---------------------------------------------------------------------

Script Purpose:
	Calculate the proportion of a metric in a given category
	compared to the whole aggragated value

Method:
	Use SUM to aggregate a measure as a CTE and use Window functions
	to find the fraction of the originl measure to the total value

---------------------------------------------------------------------
*/


-- Find out which category contribute the most to the overall business
WITH total_sales AS
(
SELECT
	p.category,
	SUM(s.sales) AS total_sales
FROM
	gold.fact_sales s
LEFT JOIN
	gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS sum_total_sales,
	CONCAT(ROUND((CAST (total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage
FROM total_sales
ORDER BY total_sales DESC
;
