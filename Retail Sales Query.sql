

--													SQL PROJECT: Retail Sales Analysis.
-- 1) Database Setup: A table named retail_sales is created to store the sales data. 
-- The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

CREATE DATABASE db_Retail_Sales

-- CREATE  TABLE
IF OBJECT_ID('Retail_Sales', 'U') IS NOT NULL
    DROP TABLE Retail_Sales;

CREATE TABLE Retail_Sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

	----										2) DATA CLEANING & EXPLORATION: 

--					Null Value Check: Check for any null values in the dataset and delete records with missing data:

SELECT *
FROM Retail_Sales
WHERE transactions_id IS null
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
				
DELETE FROM Retail_Sales
WHERE transactions_id IS null
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Record Count: Determine the total number of records in the dataset:

SELECT COUNT (*) 
FROM Retail_Sales;

-- Customer Count: Find out how many unique customers are in the dataset:

SELECT COUNT(DISTINCT customer_id)
FROM Retail_Sales;

-- Category Count: Identify all unique product categories in the dataset:

SELECT COUNT(DISTINCT category)
FROM Retail_Sales;

--												3) DATA ANALYSIS & FINDINGS:

----						 The following SQL queries were developed to answer specific business questions:

-- SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * 
FROM Retail_Sales
WHERE sale_date = '2022-11-05' ;

-- SQL query to Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM Retail_Sales
WHERE category = 'Clothing' 
	AND quantity >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'

-- SQL query to calculate the average sale for each month. Find out best selling month in each year:

WITH MonthlySales AS (
    SELECT YEAR(sale_date) AS Year, 
        MONTH(sale_date) AS Month, 
        AVG(total_sale) AS Average_Sales
    FROM Retail_Sales
    GROUP BY YEAR(sale_date), 
        MONTH(sale_date) 
		),

RankedSales AS (
    SELECT Year, 
        Month, 
        Average_Sales,
        RANK() OVER (PARTITION BY Year ORDER BY Average_Sales DESC) AS Rank
    FROM 
        MonthlySales
		)
SELECT Year, 
       Month, 
    Average_Sales AS Best_Selling_Month_Average
FROM RankedSales
WHERE Rank = 1
ORDER BY Year, Month;

-- SQL query to calculate the total sales (total_sale) for each category.:

SELECT category, COUNT(*) Total_orders, SUM(total_sale) Total_sales
FROM Retail_Sales
GROUP BY category;

-- SQL query to find the average age of customers who purchased items from the 'Beauty' category:

SELECT category, AVG(age) Average_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY category

-- SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT 
    Time_of_Day, 
    COUNT(*) AS number_of_orders
FROM ( SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Time_of_Day
    FROM Retail_Sales
) AS Subquery
GROUP BY Time_of_Day;

-- SQL query to find all transactions where the total_sale is greater than 1000:

SELECT * 
FROM Retail_Sales
WHERE total_sale > 1000

-- SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT gender, category, COUNT(*) Total_tranactions
FROM Retail_Sales
GROUP BY gender, category
ORDER BY gender, category;

-- SQL query to find the top 5 customers based on the highest total sales:

SELECT TOP 5
		customer_id, SUM (total_sale) Total_Sales
FROM Retail_Sales
GROUP BY customer_id 
ORDER BY Total_Sales DESC;

-- SQL query to find the number of unique customers who purchased items from each category:

SELECT DISTINCT (COUNT(customer_id)) customer_count, category
FROM Retail_Sales
GROUP BY category


--												END OF PROJECT.


