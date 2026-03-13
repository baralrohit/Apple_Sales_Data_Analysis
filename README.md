# Apple_Sales_Data_Analysis
SQL-based analysis of a 1M+ row Apple retail sales dataset covering sales trends, warranty claims, store performance, and advanced analytics using PostgreSQL.

# Apple Sales SQL Analysis

SQL-based analysis of a large Apple retail sales dataset (~1M rows) exploring store performance, product trends, warranty claims, and sales growth using PostgreSQL.

---

## Project Overview

This project analyzes Apple retail sales data using SQL to uncover insights related to sales performance, warranty claims, product pricing, and store-level trends.  

The analysis demonstrates practical SQL skills used by data analysts including exploratory data analysis, query optimization, advanced aggregations, and window functions.

---

## Dataset

The dataset used in this project contains approximately **1 million sales records** and includes the following tables:

| Table | Description |
|------|-------------|
| `sales` | Sales transactions including sale date, quantity sold, product ID, and store ID |
| `products` | Product catalog including price, launch date, and category |
| `stores` | Store information including city and country |
| `warranty` | Warranty claim records including claim date and repair status |
| `category` | Product category classification |

### Dataset Availability

The dataset used for this project was purchased from a third-party provider and cannot be distributed publicly due to licensing restrictions.

However, the SQL queries and analysis can be reproduced using any dataset with a similar schema.

---

## Project Goals

This project answers key business questions such as:

- Which stores generate the highest sales?
- How are stores distributed across countries?
- What are the seasonal sales patterns?
- Which products have the lowest sales across different regions?
- What percentage of purchases result in warranty claims?
- How do product prices relate to warranty claims?
- Which stores have the highest repair rates?
- How have store sales grown over time?

---

## Key Analysis Questions

### 1. Store Distribution
Determine the number of stores operating in each country.

### 2. Store Sales Performance
Calculate the total units sold by each store to identify the top-performing locations.

### 3. Seasonal Sales
Analyze total units sold in December 2023 to understand seasonal demand.

### 4. Warranty Coverage
Identify stores that have never received a warranty claim.

### 5. Warranty Claim Quality
Calculate the percentage of claims marked as **"Warranty Void"**.

### 6. Highest Selling Store (Last Year)
Determine which store sold the most units in the past year.

### 7. Product Diversity
Count the number of unique products sold during the past year.

### 8. Product Pricing Analysis
Compute the average product price per category.

### 9. Historical Warranty Claims
Determine how many warranty claims were filed in **2020**.

### 10. Store Sales Patterns
Identify the best-selling day of the week for each store.

---

# Advanced SQL Analysis

### 11. Least Selling Product by Country & Year
Using window functions and ranking to identify the lowest-selling products across countries annually.

### 12. Warranty Claims Timing
Calculate how many warranty claims were filed within **180 days of purchase**.

### 13. Warranty Claims for Newly Launched Products
Analyze claims for products launched within the **last two years**.

### 14. High Sales Months
Identify months where **USA sales exceeded 5,000 units** during the last three years.

### 15. Warranty Claims by Product Category
Determine which product category generated the most warranty claims in recent years.

### 16. Warranty Claim Probability
Calculate the **percentage chance of receiving a warranty claim** after purchase for each country.

### 17. Year-over-Year Store Growth
Use window functions (**LAG**) to measure yearly growth ratios for each store.

### 18. Price vs Warranty Claims Correlation
Calculate the correlation between product price and warranty claims using PostgreSQL's **CORR()** function.

Products are segmented into:

- Low price
- Medium price
- High price

### 19. Store Repair Performance
Identify stores with the highest percentage of **"Paid Repaired"** claims relative to total claims.

### 20. Monthly Running Sales Trends
Compute **monthly cumulative sales totals** for each store over the past four years to identify long-term trends.

---

# SQL Techniques Used

This project demonstrates practical use of advanced SQL techniques:

- Aggregations (`SUM`, `COUNT`, `AVG`)
- Joins (`INNER JOIN`, `LEFT JOIN`)
- Common Table Expressions (**CTE**)
- Window functions
  - `LAG()`
  - `RANK()`
  - `SUM() OVER`
- Date functions (`EXTRACT`, `INTERVAL`)
- Conditional logic (`CASE`)
- Correlation analysis (`CORR`)
- Indexing for performance optimization

---

# Example Insights

Some insights discovered during the analysis:

- **USA and UK** have the highest number of Apple stores (**10 each**).
- **Apple South Coast Plaza** recorded the highest total units sold.
- **December 2023** had over **32,000 units sold**, indicating strong holiday demand.
- Certain product categories generate significantly higher warranty claims.
- Sales trends show steady growth across multiple stores over the past four years.

---

# Tools Used

- PostgreSQL
- SQL
- Query Optimization with Indexes
- Analytical SQL Techniques
