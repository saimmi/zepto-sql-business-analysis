# zepto-sql-business-analysis
SQL-based business analysis project on Zepto inventory and pricing data using PostgreSQL, focused on revenue insights, discount analysis, and inventory optimization.
# 🛒 Zepto SQL Business Analysis Project

## 📌 Project Overview
This project focuses on analyzing Zepto’s inventory and pricing data using PostgreSQL. The objective is to extract meaningful business insights related to pricing strategy, discount patterns, stock availability, inventory management, revenue opportunities, and product segmentation.

The project demonstrates practical SQL skills commonly used in real-world business analytics and data analysis roles.

---

# 🎯 Business Objectives
- Analyze product pricing and discount strategies
- Evaluate stock availability and inventory distribution
- Identify revenue-driving categories and products
- Detect inventory risks and pricing anomalies
- Perform category-level business analysis
- Apply advanced SQL techniques for business reporting

---

# 🛠️ Tech Stack
- PostgreSQL
- SQL
- pgAdmin 4
- Kaggle Dataset

---

# 📂 Dataset Information
**Dataset:** Zepto Inventory Dataset

The dataset contains product-level inventory information including:
- Product categories
- Product names
- MRP and selling prices
- Discount percentages
- Available quantity
- Product weights
- Stock availability

---

# 🗄️ Database Schema

```sql
CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
```

---

# 🔍 Project Workflow

## Data Exploration
Performed exploratory analysis to:
- Understand dataset structure
- Identify null values
- Analyze product categories
- Examine stock availability
- Detect duplicate products

## Data Cleaning
Performed data cleaning operations such as:
- Removing invalid pricing records
- Handling inconsistent data
- Converting prices from paise to rupees
- Verifying pricing accuracy

## Business Analysis
Analyzed:
- Product pricing trends
- Discount strategies
- Revenue opportunities
- Inventory distribution
- Stock availability
- Product segmentation

---

# 📊 Key Analysis Performed

- Top discounted products analysis
- Revenue estimation by category
- Inventory stock analysis
- Out-of-stock risk analysis
- Pricing segmentation
- Margin retention analysis
- Inventory value analysis
- Weight-based product segmentation
- Discount dependency analysis

---

# 🧾 Sample SQL Queries

## Top 10 Products Offering the Highest Discounts

```sql
SELECT DISTINCT name,
       category,
       mrp,
       discountedSellingPrice,
       discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
```

---

## Estimated Revenue by Category

```sql
SELECT category,
       ROUND(SUM(discountedSellingPrice * availableQuantity),2) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;
```

---

## Products With Low Inventory

```sql
SELECT name,
       category,
       availableQuantity
FROM zepto
WHERE availableQuantity < 10
ORDER BY availableQuantity ASC;
```

---

## Category Contribution Percentage

```sql
SELECT category,
       ROUND(
           SUM(discountedSellingPrice * availableQuantity) * 100.0 /
           SUM(SUM(discountedSellingPrice * availableQuantity)) OVER(),
           2
       ) AS revenue_percentage
FROM zepto
GROUP BY category
ORDER BY revenue_percentage DESC;
```

---

# 📈 Advanced SQL Concepts Used

- Aggregate Functions
- CASE Statements
- Window Functions
- RANK() Function
- GROUP BY & HAVING
- Conditional Aggregation
- Revenue Estimation Logic
- Inventory Analytics
- Data Cleaning Operations

---

# 💡 Key Business Insights

- Some categories rely heavily on discount-driven sales.
- Premium products with deep discounts may reduce profit margins.
- Certain categories generate high revenue despite lower discounts.
- Out-of-stock products may lead to potential revenue loss.
- Inventory concentration varies significantly across categories.
- Product packaging size impacts revenue generation.

---

# 🚀 Project Deliverables

This repository includes:

- `README.md` → Project overview and documentation
- `zepto_analysis_queries.sql` → Complete SQL queries
- `Business_Insights_Report.pdf` → Detailed analysis and insights
- `Presentation.pptx` → Project presentation
- `Screenshots/` → Query result screenshots
- `Dataset/` → Source dataset

---

# 📷 Project Screenshots

## Revenue Analysis
![Revenue Analysis](Screenshots/revenue_analysis.png)

## Discount Analysis
![Discount Analysis](Screenshots/discount_analysis.png)

## Inventory Analysis
![Inventory Analysis](Screenshots/inventory_analysis.png)

---

# 📌 Skills Demonstrated

- SQL Query Writing
- Data Cleaning
- Exploratory Data Analysis
- Business Analysis
- Inventory Analytics
- Pricing Analysis
- Revenue Analysis
- Window Functions
- Data Validation
- Business Problem Solving

---

# 📌 Conclusion

This project demonstrates practical SQL skills applied to real-world business problems involving inventory management, pricing analysis, revenue estimation, and business intelligence.

The analysis showcases how SQL can transform raw business data into actionable insights for operational and strategic decision-making.

---

# ⭐ If You Found This Project Useful
Feel free to star the repository and connect with me on LinkedIn.
