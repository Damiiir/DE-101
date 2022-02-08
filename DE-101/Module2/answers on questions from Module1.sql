use DemoSSIS_SourceA
go

--------------Total Sales-------------------

select floor(sum(sales)) as total_sales
from [dbo].[orders];

--------------Total Profit------------------

select floor(sum(profit)) as total_profit
from [dbo].[orders];

--------------Profit Ratio-------------------

select left(round((floor(sum(sales))-floor(sum(profit)))/floor(sum(sales)), 2),4) as profit_ratio
from [dbo].[orders];

-------------Profit per Order------------------

select left(round(floor(sum(profit))/count(order_id),2),4) as profit_per_order
from [dbo].[orders];

-------------Sales per Customer----------------

select left(round(floor(sum(sales))/count(distinct(customer_id)),2),6) as sales_per_customer
from [dbo].[orders];

------------Avg. Discount---------------------

select left(round(avg(discount),2),4) as average_discount
from [dbo].[orders];

------------Monthly Sales by Segment -----------

select 
		  distinct(month(order_date)) as [month]
		, segment
		, floor(sum(sales) over(partition by segment)) as sum_sales
from [dbo].[orders]
order by [month]

------------Monthly Sales by Product Category------------

select 
		  distinct(month(order_date)) as [month]
		, category
		, floor(sum(sales) over(partition by category order by category)) as sum_sales
from [dbo].[orders]
order by [month]

--------------Sales by Product Category over time-----------------


select 
		  distinct(category)
		, floor(sum(sales) over(partition by category)) as sum_sales
from [dbo].[orders]


-------------Customer Analysis---------------------

select 
		  distinct top 10(customer_id)
		, floor(sum(sales) over(partition by customer_id)) as sum_sales
from dbo.orders
order by sum_sales desc



-----Sales and Profit by Customer-------------

select 
		  distinct top 10(customer_id)
		, floor(sum(sales) over(partition by customer_id)) as sum_sales
		, floor(sum(profit) over(partition by customer_id)) as sum_profit
from dbo.orders
order by sum_profit desc


-----------Customer Ranking-------------

;with cte as 
(
select 
		  distinct top 50(customer_id)
		, floor(sum(sales) over(partition by customer_id)) as sum_sales
		, floor(sum(profit) over(partition by customer_id)) as sum_profit
from dbo.orders

)
select	
		  customer_id
		, sum_profit
		, row_number() over(order by sum_profit desc) as rank
from cte


--------sales per region----------

select 
		  distinct(region)
		, floor(sum(sales) over(partition by region)) as sum_sales
from dbo.orders
order by sum_sales desc


------------finish----------------