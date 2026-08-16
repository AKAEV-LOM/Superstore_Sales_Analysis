-- Total sales
SELECT 
    ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM superstore_cleaned;  

-- Sales by state
SELECT 
    "State",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM superstore_cleaned
GROUP BY "State"
ORDER BY total_sales DESC;

-- Sales by category
SELECT 
    "Category",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM superstore_cleaned
GROUP BY "Category"
ORDER BY total_sales DESC;

-- Top 10 customers
SELECT 
    "Customer ID",
    "Customer Name",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM superstore_cleaned
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 products
SELECT 
    "Product Name",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales
FROM superstore_cleaned
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 10;

-- Sales by month
SELECT 
    DATE_TRUNC('month', "Order Date"::timestamp) AS month,
    ROUND(SUM("Sales")::numeric, 2) AS monthly_sales
FROM superstore_cleaned
GROUP BY month
ORDER BY month;

-- Average order value by segment
WITH order_totals AS (
    SELECT
        "Order ID",
        "Segment",
        SUM("Sales") AS order_sales
    FROM superstore_cleaned
    GROUP BY "Order ID", "Segment"
)

SELECT
    "Segment",
    ROUND(AVG(order_sales)::numeric, 2) AS average_order_value
FROM order_totals
GROUP BY "Segment"
ORDER BY average_order_value DESC;

-- Running total of sales
WITH daily_sales AS (
    SELECT
        "Order Date"::date AS order_date,
        SUM("Sales") AS daily_sales
    FROM superstore_cleaned
    GROUP BY "Order Date"::date
)

SELECT
    order_date,
    ROUND(daily_sales::numeric, 2) AS daily_sales,
    ROUND(
        SUM(daily_sales) OVER (ORDER BY order_date)::numeric,
        2
    ) AS running_total
FROM daily_sales
ORDER BY order_date;

-- Customer retention
WITH customer_orders AS (
    SELECT
        "Customer ID",
        COUNT(DISTINCT "Order ID") AS order_count
    FROM superstore_cleaned
    GROUP BY "Customer ID"
)

SELECT
    CASE
        WHEN order_count = 1 THEN 'Single Purchase'
        WHEN order_count BETWEEN 2 AND 5 THEN 'Repeat Customer'
        ELSE 'Loyal Customer'
    END AS customer_segment,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_orders
GROUP BY 1
ORDER BY total_customers DESC;
	
