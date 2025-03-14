# 💼 Retail Sales Analytics: Unlocking Revenue Trends from 100,000+ Transactions
![Screenshot (27)](https://github.com/user-attachments/assets/b3ef2057-dcea-43b3-ac4b-ad65f9c51394)

## 📌 Project Overview
**Project Title:** Retail Sales Analysis  

This project focuses on exploring, cleaning, and analyzing a superstore's retail sales data. It involves setting up a retail sales database, conducting exploratory data analysis (EDA), and using SQL queries to address key business questions.

## 🎯 Project Objectives 
1. **Database Setup** – Establish and populate a database using the provided sales data.
2. **Data Cleaning** – Detect and eliminate records containing missing or null values to ensure data quality.
3. **Exploratory Data Analysis (EDA):** Perform basic exploratory data analysis to understand the dataset.
4. **Key Business Insights** – Conduct an initial analysis to gain insights into the dataset's structure and key trends. Utilize SQL queries to address critical business questions and extract meaningful insights from the sales data.  
5. **Business Findings and Reccommendations** – Provide Business recommendations using insights & trends gotten from the sales data.

## 🛠️ Technology Stack
- **Data Preparation & Loading** - Microsoft Excel
- **DBMS:** PostgreSQL 
- **Query Language:** SQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Data Visualizations**: Powerbi (Data Modelling, DAX, Data visualization and interactive reporting.)

--- 

### Data Source
- The dataset used for this project consists of all sales transaction made by the Retail company. 
- Dataset was downloaded from [Kaggle](www.kaggle.com)

## Dataset Description
The dataset contains transaction records from a retail store, including details such as:  
- **Transaction ID** – Unique identifier for each sale.  
- **Sale Date & Time** – Timestamp of the transaction.  
- **Customer ID** – Unique identifier for each customer.  
- **Demographics** – Customer gender and age.  
- **Product Category** – Classification of purchased products.  
- **Quantity & Pricing** – Quantity sold, price per unit, and cost of goods sold (COGS).  
- **Total Sale** – Final amount spent on each transaction.

---

## Project Structure

### 1. Data Preparation (Microsoft Excel): 
- Data understanding, exploration, data loading, data importing.
- Check dataset structure using Column Headers & Data Types
- Standardizing Data Formats
  
### 2. Database Setup
- **Database Creation:** The project begins with setting up a database named `db_Retail_Sales`.  
- **Table Creation:** A table called `Retail_Sales` is created to store sales data.  

```sql
CREATE DATABASE db_Retail_Sales;

-- CREATE TABLE
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
```
### 3. Data Exploration & Cleaning
  - **Record Count:** Determine the total number of records in the dataset.  
  - **Customer Count:** Find out how many unique customers are in the dataset.  
  - **Category Count:** Identify all unique product categories in the dataset.  
  - **Null Value Check:** Check for any null values in the dataset and delete records with missing data.  

```sql
-- Record Count: Determine the total number of records in the dataset:

SELECT COUNT (*) 
FROM Retail_Sales;

-- Customer Count: Find out how many unique customers are in the dataset:

SELECT COUNT(DISTINCT customer_id)
FROM Retail_Sales;

-- Category Count: Identify all unique product categories in the dataset:

SELECT COUNT(DISTINCT category)
FROM Retail_Sales;

-- Null Value Check: Check for any null values in the dataset and delete records with missing data:

SELECT *
FROM Retail_Sales
WHERE transactions_id IS null OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

### 4. Key Business Insights

1. SQL query to Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

```sql
SELECT *
FROM Retail_Sales
WHERE category = 'Clothing' 
	AND quantity >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
```
2. SQL query to retrieve all columns for sales made on '2022-11-05:
```sql
SELECT * 
FROM Retail_Sales
WHERE sale_date = '2022-11-05';
```
3. SQL query to calculate the average sale for each month. Find out best selling month in each year:

```sql
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
```

4. SQL query to calculate the total sales (total_sale) for each category.:

```sql
SELECT category, COUNT(*) Total_orders, SUM(total_sale) Total_sales
FROM Retail_Sales
GROUP BY category;
```

5. SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
```sql
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
```
6. SQL query to find the average age of customers who purchased items from the 'Beauty' category:
```sql
SELECT category, AVG(age) Average_age
FROM Retail_Sales
WHERE category = 'Beauty'
GROUP BY category
```

7. SQL query to find all transactions where the total_sale is greater than 1000:
```sql
SELECT * 
FROM Retail_Sales
WHERE total_sale > 1000
```
8. SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

```sql
SELECT gender, category, COUNT(*) Total_tranactions
FROM Retail_Sales
GROUP BY gender, category
ORDER BY gender, category;
```
9. SQL query to find the top 5 customers based on the highest total sales:

```sql
SELECT TOP 5
		customer_id, SUM (total_sale) Total_Sales
FROM Retail_Sales
GROUP BY customer_id 
ORDER BY Total_Sales DESC;
```
10. SQL query to find the number of unique customers who purchased items from each category:
```sql
SELECT DISTINCT (COUNT(customer_id)) customer_count, category
FROM Retail_Sales
GROUP BY category
```
---
## 5. Project Reports & Visualizations (Powerbi):
- **Sales Summary:** Overview of total sales, customer demographics, and category performance.  
- **Trend Analysis:** Insights into sales patterns across different months and time slots.  
- **Customer Insights:** Reports on top-spending customers and unique customer counts per category.

## 🧮 Key Visuals
#### Overall Dashboard Overview:
![Screenshot (27)](https://github.com/user-attachments/assets/b3ef2057-dcea-43b3-ac4b-ad65f9c51394)

## Customers Purchase Behavior Insights:
![Screenshot (30)](https://github.com/user-attachments/assets/b40c60a4-c726-40be-bb09-dd248edd3f78)

## 📌 Live Power BI Dashboard Link:
Click the Link To [View the Interactive Retail Sales Dashboard to view Key Visuals](https://app.powerbi.com/reportEmbed?reportId=7c27309d-82a6-4b12-8fc3-052503ef371d&autoAuth=true&ctid=3af45fec-8c0e-49be-8467-608b1fd05a35)

---

## 6. Findings & Insights

- **Customer Demographics:** Sales data spans different age groups, with Clothing and Beauty being the most popular categories.  
- **High-Value Transactions:** Multiple transactions exceed $1,000, indicating a segment of high-spending customers.  
- **Sales Trends:** Monthly variations help identify peak sales seasons.  
- **Customer Insights:** The analysis highlights the top-spending customers and most popular product categories.  
- **Sales by Time of Day:** Most transactions occur in the **Afternoon**, followed by the **Evening**.  

## 7. Business Recommendations

1. **🌟 Targeted Marketing:** Focus promotions on high-value customers and best-selling product categories.  
2. **🌐 Seasonal Sales Planning:** Prepare inventory and marketing campaigns based on peak sales months.  
3. **⏳ Operational Efficiency:** Allocate more staff during peak shopping hours to improve customer experience.  
4. **🛒 Product Bundling:** Offer discounts on complementary products to increase average transaction size.  

---

## 📌 About Me
Hi, I'm Oluwatosin Amosu Bolaji, a Data Analyst skilled in SQL, Power BI, and Excel. I enjoy turning complex datasets into actionable insights through data visualization and business intelligence techniques.

- **🔹 Key Skills:** Data Analysis | SQL Queries | Power BI Dashboards | Data Cleaning | Reporting
- **🔹 Passionate About:** Data storytelling, problem-solving, and continuous learning

#### 🚀 **Always learning and improving—driven by curiosity and a passion for analytics.**  

### 📫 **Let’s connect!**  
- 📩 oluwabolaji60@gmail.com
- 🔗 : [LinkedIn](https://www.linkedin.com/in/oluwatosin-amosu-722b88141)
- 🌐 : [My Portfolio](https://www.datascienceportfol.io/oluwabolaji60) 
- 𝕏 : [Twitter/X](https://x.com/thee_oluwatosin?s=21&t=EqoeQVdQd038wlSUzAtQzw)
- 🔗 : [Medium](https://medium.com/@oluwabolaji60)
