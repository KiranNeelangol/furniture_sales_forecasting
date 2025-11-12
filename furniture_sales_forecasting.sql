DROP TABLE IF EXISTS sales_forecasting;

CREATE TABLE sales_forecasting(
	"Row ID" integer,
	"Order ID" varchar(120) PRIMARY KEY,
	"Order Date" date,
	"Ship Date" date,
	"Ship Mode" varchar(120),
	"Customer ID" varchar(120),
	"Customer Name" varchar(120),
	"Segment" varchar(120),
	"Country" varchar(120),
	"City" varchar(120),
	"State" varchar(120),
	"Postal Code" integer,
	"Region" varchar(120),
	"Product ID" varchar(120),
	"Category" varchar(120),
	"Sub-Category" varchar(120),
	"Product Name" varchar(120),
	"Sales" numeric(8,2),
	"Quantity" integer,
	"Discount" integer,
	"Profit" float
)

Select * from sales_forecasting
limit 5;

Select count(*) from sales_forecasting;

-- Renaming column names to sql standards --
Alter Table sales_forecasting Rename "Row ID" to row_id;
Alter Table sales_forecasting Rename "Order ID" to order_id;
Alter Table sales_forecasting Rename "Order Date" to order_date;
Alter Table sales_forecasting Rename "Ship Date" to ship_date;
Alter Table sales_forecasting Rename "Ship Mode" to ship_mode;
Alter Table sales_forecasting Rename "Customer ID" to customer_id;
Alter Table sales_forecasting Rename "Customer Name" to Customer_name;
Alter Table sales_forecasting Rename "Segment" to segment;
Alter Table sales_forecasting Rename "Country" to country;
Alter Table sales_forecasting Rename "City" to city;
Alter Table sales_forecasting Rename "State" to state;
Alter Table sales_forecasting Rename "Postal Code" to postal_code;
Alter Table sales_forecasting Rename "Region" to region;
Alter Table sales_forecasting Rename "Product ID" to product_id;
Alter Table sales_forecasting Rename "Category" to category;
Alter Table sales_forecasting Rename "Sub-Category" to sub_category;
Alter Table sales_forecasting Rename "Product Name" to product_name;
Alter Table sales_forecasting Rename "Sales" to sales;
Alter Table sales_forecasting Rename "Quantity" to quantity;
Alter Table sales_forecasting Rename "Discount" to discount;
Alter Table sales_forecasting Rename "Profit" to profit;

-- Checking if null values exist --
select * from sales_forecasting
where row_id is null or
	  order_id is null or
	  order_date is null or
	  ship_date is null or
	  ship_mode is null or
	  customer_id is null or
	  customer_name is null or
	  segment is null or
	  country is null or
	  city is null or
	  state is null or
	  postal_code is null or
	  region is null or
	  product_id is null or
	  category is null or
	  sub_category is null or
	  product_name is null or
	  sales is null or
	  quantity is null or
	  discount is null or
	  profit is null;

select distinct country from sales_forecasting;
-- Deleting country column as it only contains U.S --
Alter Table sales_forecasting Drop column country;

select distinct category from sales_forecasting;
-- Same for category as it only contains Furniture --
Alter Table sales_forecasting Drop column category;


-- List of customers ranking with total sales 
select customer_name, sum(sales) as total_sales
from sales_forecasting
group by customer_name
order by total_sales desc;

-- Ranking sub_category total sales based on region --
select region, sub_category, sum(sales) as total_sales 
from sales_forecasting
group by region, sub_category
order by region, total_sales desc;
-- Chairs has the highest amount of total sales whereas Furnishings has the lowest out of all regions.

-- Average discount of each product sold --
select sub_category , product_name, round(avg(discount),2) as avg_discount
from sales_forecasting
group by sub_category, product_name
order by avg_discount;

-- Total sales based on each region --
select region, sum(sales) as total_sales
from sales_forecasting
group by region
order by total_sales desc;

-- Calculating avg_profit of all sub_category --
select sub_category, round(avg(profit),2) as avg_profit
from sales_forecasting
group by sub_category
order by avg_profit desc;

-- Which mode is widely used for shipping?
select ship_mode, count(*) as total_products
from sales_forecasting
group by ship_mode
order by total_products desc;

-- Which segment has the most orders --
select segment, count(*) as total_count
from sales_forecasting
group by segment
order by total_count desc;

-- Which sub_category shows the potential for future growth --
select sub_category, sum(sales) as total_sales
from sales_forecasting
group by sub_category
order by total_sales desc;


-- Which state made the highest to lowest orders --
select state, count(order_id) as total_orders
from sales_forecasting
group by state
order by total_orders desc;

-- Monthly order through out the years -- 
select extract(year from order_date) as year, 
	   extract(month from order_date) as month, count(distinct order_id) as total_orders
from sales_forecasting
group by year, month
order by year, month;

-- Monthly sales and profit trends over the years --
select extract(year from order_date) as year,
	   extract(month from order_date) as month,
	   sum(sales) as total_sales,
	   sum(profit) as total_profit
from sales_forecasting
group by year, month
order by year, month;
-- Through out all the years; Sept, Nov, Dec showed the highest sales months --


-- All years total sales --
select Extract(Year from order_date) as years, sum(sales) as total_sales
from sales_forecasting
group by years
order by years;

-- Year over Year growth analysis --
select Extract(year from order_date) as years, sum(sales) as total_sales,
		lag(sum(sales)) over (order by extract(year from order_date)) as per_yr_sales,
		round(((sum(sales) - lag(sum(sales)) over (order by extract(year from order_date)))/
				lag(sum(sales)) over (order by extract(year from order_date))) * 100, 2) as YoY_pct
from sales_forecasting
group by years
order by years;

select corr(discount, profit)
from sales_forecasting;

-- Relation between discount and profit based on discount_range --
select case when discount between 0 and 0.1 then '0 to 10%'
			when discount between 0.1 and 0.2 then '10 to 20%'
			when discount between 0.2 and 0.3 then '20 to 30%'
			when discount between 0.3 and 0.4 then '30 to 40%'
			when discount between 0.4 and 0.5 then '40 to 50%'
			else 'Above 50%'
			end as discount_range,
round(avg(profit),2) as avg_profit
from sales_forecasting
group by discount_range
order by discount_range;
-- 30% to 50% showed massive loss in profit out of all bracket --

-- Whats the total sales and and its profits of sub_category throughout the years --
select sub_category, extract(year from order_date) as year, sum(sales) as total_sales,
	   sum(profit) as total_profit
from sales_forecasting
group by sub_category, year
order by  sub_category, year;

-- Which products should be prioritized of dropped based on profit to discount ratio
-- and sales velocity --
select product_name, sub_category, total_sales, total_profit, avg_discount, total_orders,
	   round(case when avg_discount > 0 then total_profit / avg_discount else null end, 2) as prof_to_dis_ratio,
	   round(total_sales / total_orders, 2) as sales_velocity
from (
 	select product_name, sub_category, sum(sales) as total_sales, sum(profit) as total_profit,
	   round(avg(discount), 2) as avg_discount, count(order_id) as total_orders
from sales_forecasting
group by product_name, sub_category
);

