-- 1. Check Total Number of Records
SELECT COUNT (*) AS total_records
FROM zepto;

-- 2. View Sample Data
SELECT *
FROM zepto
LIMIT 10;

--3. Check for Null Values
SELECT *
FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- 4. View Different Product Categories
SELECT DISTINCT category
FROM zepto
ORDER by category;

-- 5. Analyze Products In Stock vs Out of Stock
SELECT outOfStock,
       COUNT(sku_id) AS total_products
FROM zepto
GROUP BY outOfStock; 

-- 6. Identify Products Appearing Multiple Times
SELECT name,
       COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY number_of_skus DESC;

-- DATA CLEANING
-- 1. Find Products with Invalid Pricing
SELECT *
FROM zepto
WHERE mrp = 0
   OR discountedSellingPrice = 0;

-- 2. Remove Products with Invalid MRP
DELETE FROM zepto
WHERE mrp = 0;

-- 3. Convert Prices from Paise to Rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- 4. Verify Updated Prices
SELECT mrp,
       discountedSellingPrice
FROM zepto;

-- Business Analysis Queries

-- 1. Total Products Available
SELECT COUNT(*) AS total_products
FROM zepto;

-- 2. Total Categories
SELECT COUNT(DISTINCT category) AS total_categories
FROM zepto;

-- 3. Top 10 Categories With Most Products
SELECT category,
       COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC
LIMIT 10;

-- 4. Average Discount Percentage by Category
SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--5. Top 10 Most Expensive Products
SELECT name,
       category,
       mrp
FROM zepto
ORDER BY mrp DESC
LIMIT 10;

-- 6. Top 10 Products Offering the Highest Discounts
SELECT DISTINCT name,
       category,
       mrp,
       discountedSellingPrice,
       discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- 7. Out-of-Stock Products Count
SELECT COUNT(*) AS out_of_stock_products
FROM zepto
WHERE outOfStock = TRUE;

--8. High-MRP Products That Are Out of Stock
SELECT DISTINCT name,
       category,
       mrp
FROM zepto
WHERE outOfStock = TRUE
  AND mrp > 300
ORDER BY mrp DESC;

--9. Average Selling Price by Category
SELECT category,
       ROUND(AVG(discountedSellingPrice),2) AS avg_selling_price
FROM zepto
GROUP BY category
ORDER BY avg_selling_price DESC;

--10. Estimated Revenue by Category
SELECT category,
       ROUND(SUM(discountedSellingPrice * availableQuantity),2) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;

--11. Products With Highest Inventory
SELECT name,
       category,
       availableQuantity
FROM zepto
ORDER BY availableQuantity DESC
LIMIT 10;

--12. Products With Low Inventory
SELECT name,
       category,
       availableQuantity
FROM zepto
WHERE availableQuantity < 10
ORDER BY availableQuantity ASC;

--13. Discount Impact Analysis
SELECT name,
       mrp,
       discountedSellingPrice,
       (mrp - discountedSellingPrice) AS discount_amount
FROM zepto
ORDER BY discount_amount DESC
LIMIT 10;

-- 14. Category-Wise Stock Availability
SELECT category,
       SUM(availableQuantity) AS total_stock
FROM zepto
GROUP BY category
ORDER BY total_stock DESC;

-- 15. Products With No Discount
SELECT name,
       category,
       mrp
FROM zepto
WHERE discountPercent = 0;

-- 16. Price Range Segmentation
SELECT
    CASE
        WHEN discountedSellingPrice < 100 THEN 'Budget'
        WHEN discountedSellingPrice BETWEEN 100 AND 500 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_segment,
    COUNT(*) AS total_products
FROM zepto
GROUP BY price_segment;

--17. Most Common Product Weights
SELECT weightInGms,
       COUNT(*) AS total_products
FROM zepto
GROUP BY weightInGms
ORDER BY total_products DESC
LIMIT 10;

-- 18. Category-Wise Average Quantity
SELECT category,
       ROUND(AVG(quantity),2) AS avg_quantity
FROM zepto
GROUP BY category
ORDER BY avg_quantity DESC;

--19. Calculate Price Per Gram for Products Above 100g
SELECT DISTINCT name,
       weightInGms,
       discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- 20. Categorize Products Based on Weight
SELECT DISTINCT name,
       weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- 21. Calculate Total Inventory Weight per Category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC

--📈 Advanced SQL Analysis

--1. Rank Products by Discount Within Each Category
SELECT category,
       name,
       discountPercent,
       RANK() OVER(PARTITION BY category ORDER BY discountPercent DESC) AS discount_rank
FROM zepto;

--2. Running Revenue Total
SELECT name,
       discountedSellingPrice,
       SUM(discountedSellingPrice)
       OVER(ORDER BY discountedSellingPrice DESC) AS running_total
FROM zepto;

-- 3. Category Contribution Percentage
SELECT category,
       ROUND(
           SUM(discountedSellingPrice * availableQuantity) * 100.0 /
           SUM(SUM(discountedSellingPrice * availableQuantity)) OVER(),
           2
       ) AS revenue_percentage
FROM zepto
GROUP BY category
ORDER BY revenue_percentage DESC;

-- 🚀 Advanced Business Analysis Questions
-- 1. Which Categories Depend Most on Discounts?

SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount,
       ROUND(AVG(discountedSellingPrice),2) AS avg_price
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

-- 2. Which Products Have High Prices but Low Stock?
SELECT name,
       category,
       discountedSellingPrice,
       availableQuantity
FROM zepto
WHERE discountedSellingPrice > 500
AND availableQuantity < 10
ORDER BY discountedSellingPrice DESC;


-- 3. Detect Possible Overstocked Products
SELECT name,
       category,
       availableQuantity,
       discountPercent
FROM zepto
WHERE availableQuantity > 100
AND discountPercent < 5
ORDER BY availableQuantity DESC;

-- 4. Which Categories Contribute Most to Inventory Value?
SELECT category,
       ROUND(SUM(mrp * availableQuantity),2) AS inventory_value
FROM zepto
GROUP BY category
ORDER BY inventory_value DESC;

-- 5. Find Products With Suspicious Discounts
SELECT name,
       mrp,
       discountedSellingPrice,
       discountPercent
FROM zepto
WHERE discountedSellingPrice > mrp;

--6. Which Categories Have the Highest Out-of-Stock Risk?
SELECT category,
       COUNT(*) AS total_products,
       SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END) AS out_of_stock_products,
       ROUND(
           SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
           2
       ) AS stockout_percentage
FROM zepto
GROUP BY category
ORDER BY stockout_percentage DESC;

--7. Revenue Loss Due to Out-of-Stock Products
SELECT ROUND(SUM(discountedSellingPrice * quantity),2) AS potential_revenue_loss
FROM zepto
WHERE outOfStock = TRUE;

--8. Identify Premium Products With Heavy Discounts
SELECT name,
       category,
       mrp,
       discountPercent
FROM zepto
WHERE mrp > 1000
AND discountPercent > 30
ORDER BY discountPercent DESC;

--9. Which Categories Have the Best Average Margin Retention?
SELECT category,
       ROUND(AVG(
           ((discountedSellingPrice / mrp) * 100)
       ),2) AS price_retention_percentage
FROM zepto
GROUP BY category
ORDER BY price_retention_percentage DESC;

--10. Identify Fast-Moving Products (Proxy Logic)
SELECT name,
       category,
       availableQuantity,
       discountPercent
FROM zepto
WHERE availableQuantity < 20
AND discountPercent > 20
AND outOfStock = FALSE
ORDER BY availableQuantity ASC;


--11. Which Weight Segments Generate the Most Revenue?
SELECT
   CASE
       WHEN weightInGms < 500 THEN 'Small Pack'
       WHEN weightInGms BETWEEN 500 AND 2000 THEN 'Medium Pack'
       ELSE 'Bulk Pack'
   END AS weight_segment,
   ROUND(SUM(discountedSellingPrice * availableQuantity),2) AS revenue
FROM zepto
GROUP BY weight_segment
ORDER BY revenue DESC;



--12. Products Generating the Highest Inventory Value Per Unit
SELECT name,
       category,
       ROUND(mrp * availableQuantity,2) AS inventory_value
FROM zepto
ORDER BY inventory_value DESC
LIMIT 20;

-- 13. Which Categories Are Most Discount Aggressive?
SELECT category,
       COUNT(*) AS total_products,
       AVG(discountPercent) AS avg_discount,
       MAX(discountPercent) AS max_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--14. Create Product Price Buckets
SELECT
   CASE
       WHEN discountedSellingPrice < 100 THEN 'Low Price'
       WHEN discountedSellingPrice BETWEEN 100 AND 500 THEN 'Mid Price'
       WHEN discountedSellingPrice BETWEEN 500 AND 1000 THEN 'High Price'
       ELSE 'Luxury'
   END AS price_bucket,
   COUNT(*) AS total_products
FROM zepto
GROUP BY price_bucket;

--15. Find Categories With Low Average Discounts but High Revenue
SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount,
       ROUND(SUM(discountedSellingPrice * availableQuantity),2) AS revenue
FROM zepto
GROUP BY category
HAVING AVG(discountPercent) < 10
ORDER BY revenue DESC;
