/*
---------------------------------------------------------------------
Performance Analysis (Year Over Year / Month Or Month)
---------------------------------------------------------------------

Script Purpose:
	Calculate the Performace of a metrics by itself over time.
	Year Over Year analysis

Method:
	Use SUM function to aggregate the measure as a CTE,
	use the Window function to query the aggregate for multiple
	comparisons with the same aggregate from a different date

---------------------------------------------------------------------
*/


-- Analyse the yearly performance of the product by comparing the sales to the average yearly sales
-- Analyse the yearly performance of the product by comparing the sales to the previous year sales
WITH yearly_sales AS
(
	SELECT
		YEAR(s.order_date) AS order_year,
		p.product_name,
		SUM(s.sales) AS total_sales
	FROM
		gold.fact_sales s
	LEFT JOIN
		gold.dim_products p
	ON s.product_key = p.product_key
	WHERE YEAR(s.order_date) IS NOT NULL
	GROUP BY
		YEAR(s.order_date),
		p.product_name
)

SELECT
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS avg_sales,
	total_sales - AVG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS avg_diff,
	CASE
		WHEN (total_sales - AVG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Above Average'
		WHEN (total_sales - AVG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Below Average'
		ELSE 'No Change'
	END AS avg_change,
	LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS prv_diff,
	CASE
		WHEN (total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Increased Sale'
		WHEN (total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Decreased Sale'
		ELSE 'No Change'
	END AS avg_change
FROM yearly_sales
;
