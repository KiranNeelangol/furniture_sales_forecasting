# furniture_sales_forecasting
This SQL project is used to analyze business performance, identify sales trends, seasonal trends, profit impacts and forecast future sales to boost the business revenue.

Overview
This project demonstrates an end-to-end SQL workflow using PostgreSQL to analyze and extract insights from a retail sales dataset.
The goal is to explore business trends, identify sales trends, clean and structure the data, and run analytical queries to answer real-world business questions.
It showcases skills in data loading, EDA, data cleaning, query optimization, and insight generation and future forecasting using SQL.

Dataset
Name: store_sales_forecasting.csv
Source: Kaggle
Rows: 2121 transaction records
Description: Each record represents a customer order with details such as region, segment, category, sub-category, sales, profit, quantity, and discount.

Key Columns:
Column	Description
Order ID	Order identifier
Order Date	Date when the order was placed
Region	Geographic location of the order
Category / Sub-Category	Product classification
Sales	Total revenue from the transaction
Profit	Profit generated
Discount	Discount percentage applied
Quantity	Units sold

Steps
1. Load Data into PostgreSQL
   Created a new database and table schema
   Imported CSV data using COPY command
   Validated data types and ensured referential integrity

2. Perform EDA (Exploratory Data Analysis)
   Inspected row counts, null values, and duplicates
   Summarized key metrics (sales, profit, discount distributions)
 
3. Run Analytical SQL Queries
   Executed a range of SQL queries to extract insights, including:
   Total Sales and Profit by Region, Category, and Year
   Month-over-Month and Year-over-Year growth analysis
   Correlation between Discount and Profit
   Top-selling and least profitable products
   Seasonal and regional sales trends

Results
1. Identified regions and categories driving highest profit growth
2. Found a negative correlation between discounts and profit margins
3. Higher discount tends to decrease profit
4. Discovered strong seasonality in Q4 sales and stable performance in Q2
5. Provided actionable insights for pricing and inventory decisions for future sales forecasting
