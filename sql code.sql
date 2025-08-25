-- find top 10 highest revenue generating products 
SELECT product_id,SUM(sale_price) AS 'sales' FROM orders
GROUP BY product_id
ORDER BY sales DESC LIMIT 10


-- find top 5 highest selling products in each region
WITH cte AS (
SELECT product_id,region,SUM(sale_price) AS 'highest_sales' FROM orders
GROUP BY product_id,region
ORDER BY region,highest_sales DESC)

SELECT * from(SELECT *,
				ROW_NUMBER() OVER(PARTITION BY region ORDER BY highest_sales DESC) AS 'rn' 
                FROM cte)t
WHERE rn <= 5


-- find month over month growth comparison for 2022 and 2023 sales eg: jan 2022 vs jan 2023
WITH cte AS (
SELECT 
	YEAR(order_date) AS 'year',
	MONTH(order_date) AS 'month',
    SUM(sale_price) AS 'sales'
FROM orders
GROUP BY YEAR(order_date),MONTH(order_date))

SELECT 
	month,
	SUM(CASE WHEN year = 2022 THEN sales ELSE 0 END) AS 'sales_2022',
    SUM(CASE WHEN year = 2023 THEN sales ELSE 0 END) AS 'sales_2023'
FROM cte
GROUP BY month
ORDER BY month


-- for each category which month had highest sales
WITH cte AS (
SELECT category,DATE_FORMAT(order_date,'%y%M') AS 'order_year_month',SUM(sale_price) AS 'sales' FROM orders
GROUP BY category,order_year_month
)

SELECT * 
FROM(SELECT *,
		ROW_NUMBER() OVER(PARTITION BY category ORDER BY sales DESC) AS 'rn'
	 FROM cte)t
WHERE rn = 1


-- which category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
SELECT sub_category,
	YEAR(order_date) AS 'year',
    SUM(sale_price) AS 'sales'
FROM orders
GROUP BY sub_category,YEAR(order_date)
),
cte2 AS (
SELECT 
	sub_category,
	SUM(CASE WHEN year = 2022 THEN sales ELSE 0 END) AS 'sales_2022',
    SUM(CASE WHEN year = 2023 THEN sales ELSE 0 END) AS 'sales_2023'
FROM cte
GROUP BY sub_category
ORDER BY sub_category
)
SELECT *,(sales_2023 - sales_2022) AS 'highest_growth' FROM cte2
ORDER BY highest_growth DESC LIMIT 1
