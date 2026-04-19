-- Total sales
select 
SUM("Sales") as total_sales
from superstore_cleaned sc

--Sales by state
select 
"State",
count("Order ID") as total_orders, 
round(sum("Sales")::numeric,2) as total_sales
from superstore_cleaned sc 
group by "State" 
order by total_sales desc

--Sales by category
select 
"Category",
count("Order ID") as total_orders, 
round(sum("Sales")::numeric,2) as total_sales
from superstore_cleaned sc 
group by "Category"
order by total_sales desc

--Top 10 customers
select 
"Customer Name",
count("Order ID") as total_orders, 
round(sum("Sales")::numeric,2) as total_sales
from superstore_cleaned sc 
group by "Customer Name" 
order by total_sales desc
limit 10

--Top 10 products
select 
"Product Name",
count("Order ID") as total_orders, 
round(sum("Sales")::numeric,2) as total_sales
from superstore_cleaned sc 
group by "Product Name" 
order by total_sales desc
limit 10

--Sales by month
select 
date_trunc('month', "Order Date"::timestamp) as month,
round(sum("Sales")::numeric,2) as monthly_sales
from superstore_cleaned sc 
group by month
order by month

--Average order value
select "Segment",
round(avg("Sales")::numeric, 2) as avg_order_value
from superstore_cleaned sc 
group by "Segment" 
order by avg_order_value 

--Window Functions 
select 
"Order Date",
"Sales",
sum("Sales") over (order by "Order Date") as "running_total"
from superstore_cleaned

--Retention 
with customer_orders as (
	select "Customer ID",
	count(distinct "Order ID") as order_count
	from superstore_cleaned sc 
	group by "Customer ID"
	)
select 
	case 
		when order_count=1 then 'Single Purchase'
		when order_count between 2 and 5 then 'Repeat Customer'
		else 'Loyal Customer'
		end as customer_segment,
	count(*) as total_customers,
	round(count(*) * 100 /sum(count(*)) over(), 2) as percentage 
	from customer_orders 
	group by 1
	order by 2 desc
	
