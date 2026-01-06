/*
---------------------------------------------------------------------
Cumulative Analysis
---------------------------------------------------------------------

Script Purpose:
	Calculate Running Totals ans Moving Averages of key values.
	Performance over time cumulatively

Method:
	Use the SUM, AVG or COUNT function to aggregate the value and
	use Window function like cumulate the aggregate value

---------------------------------------------------------------------
*/


-- Calculate the Running Total for the sales by each year
-- Calculate the Moving Average for the price by each year
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales,
	average_price,
	AVG(average_price) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS moving_average_price
FROM(
	SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales) AS                   total_sales,
		AVG(price) AS                   average_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
)t
;
