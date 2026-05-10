# zepto-sql-business-analysis
SQL-based business analysis project on Zepto inventory and pricing data using PostgreSQL, focused on revenue insights, discount analysis, and inventory optimization.
# Zepto Inventory & Pricing Business Analysis Using SQL

A SQL-based business analysis of Zepto's grocery inventory dataset to uncover actionable insights around pricing, discounts, stock availability, and revenue performance across 14 product categories.

---

## Project Overview

This project analyzes Zepto's grocery inventory and pricing dataset using SQL to generate actionable business insights.

**The analysis focuses on:**
- Product pricing structure
- Discount strategy effectiveness
- Inventory management efficiency
- Stock availability risks
- Category-wise performance
- Revenue contribution
- Product segmentation by weight and price
- Business risk identification

> **Goal:** Understand how Zepto manages inventory, pricing, and promotions across different product categories.

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| SQL (PostgreSQL) | Data querying and analysis |
| pgAdmin 4 | Database management |
| Kaggle | Dataset source |

---

## Dataset

- **Dataset:** Zepto Inventory Dataset (Kaggle)
- **Records:** ~3,731 products
- **Categories:** 14 product categories

---

## Data Exploration

### 1. Total Records

```sql
SELECT COUNT(*) AS total_records FROM zepto;
```

**Insight:** The dataset contains **3,731 product records**, providing a strong base for inventory and pricing analysis.

---

### 2. Data Quality Check

```sql
SELECT * FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL;
```

**Insight:** No missing values were found — the dataset is complete and ready for analysis without any imputation needed.

---

### 3. Category Distribution

```sql
SELECT DISTINCT category FROM zepto;
```

**Insight:** The dataset includes **14 distinct product categories** covering food, beverages, personal care, and household essentials.

---

### 4. Stock Availability

```sql
SELECT outOfStock, COUNT(*) FROM zepto GROUP BY outOfStock;
```

**Insight:**
- ✅ In Stock: **3,278 products**
- ❌ Out of Stock: **453 products**

Generally healthy inventory levels, though a 12.1% stockout rate is a concern for a quick-commerce platform where instant availability is the core promise.

---

### 5. Duplicate Products

```sql
SELECT name, COUNT(*)
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;
```

**Insight:** Around **1,214 products** appear multiple times with different SKUs — indicating product variants such as different pack sizes, weights, or flavors listed under the same name.

---

## Data Cleaning

### 6. Invalid Pricing Check

```sql
SELECT * FROM zepto WHERE mrp = 0 OR discountedSellingPrice = 0;
```

**Insight:** Detected incorrect zero-price entries that were removed before analysis to prevent skewed results.

---

### 7. Price Conversion (Paise → Rupees)

```sql
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
```

**Insight:** Raw pricing was stored in paise. Converted to rupees for accurate and readable analysis.

---

## Business Analysis

### 8. Top Categories by Product Count

```sql
SELECT category, COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC;
```

**Insight:** Top categories by product volume:
1. Munchies
2. Cooking Essentials
3. Packaged Food
4. Ice Cream & Desserts
5. Chocolates & Candies

These categories dominate the inventory, reflecting a strong focus on fast-moving consumer goods (FMCG).

---

### 9. Category Discount Strategy

```sql
SELECT category, AVG(discountPercent)
FROM zepto
GROUP BY category;
```

**Insight:**
- 🔴 **Highest discounts:** Fruits & Vegetables (~15.46%)
- 🟢 **Lowest discounts:** Home & Cleaning (~5.7%)

Perishable categories rely more heavily on discounts to drive sales and reduce wastage.

---

### 10. Out-of-Stock Risk by Category

```sql
SELECT category,
COUNT(*) AS total_products,
SUM(CASE WHEN outOfStock THEN 1 ELSE 0 END) AS out_of_stock_products
FROM zepto
GROUP BY category;
```

**Insight:**
- ⚠️ **Biscuits** has the highest stockout risk at **~28.6%**
- Beverages and Dairy also show elevated stockout rates

These categories need improved inventory planning and proactive replenishment triggers.

---

### 11. Revenue Loss Due to Stockouts

```sql
SELECT SUM(discountedSellingPrice * quantity)
FROM zepto
WHERE outOfStock = TRUE;
```

**Insight:** Out-of-stock products represent an estimated potential revenue loss of **₹8.91 million** — making inventory availability a direct revenue lever, not just an operational metric.

---

### 12. Inventory Value by Category

```sql
SELECT category,
SUM(mrp * availableQuantity)
FROM zepto
GROUP BY category;
```

**Insight:** Highest inventory value is concentrated in:
- Cooking Essentials
- Munchies
- Personal Care

These categories represent the largest capital investment in the inventory portfolio.

---

### 13. Margin Retention Analysis

```sql
SELECT category,
AVG((discountedSellingPrice / mrp) * 100)
FROM zepto
GROUP BY category;
```

**Insight:**
- 🟢 **Home & Cleaning** → highest margin retention (~94%) — strong pricing power
- 🔴 **Fruits & Vegetables** → lowest retention (~84%) — highest discount pressure

Essential non-perishable goods maintain stronger pricing stability compared to perishable categories.

---

### 14. Price Segmentation

```sql
SELECT CASE
  WHEN discountedSellingPrice < 100 THEN 'Low'
  WHEN discountedSellingPrice BETWEEN 100 AND 500 THEN 'Mid'
  WHEN discountedSellingPrice BETWEEN 500 AND 1000 THEN 'High'
  ELSE 'Luxury'
END AS price_bucket,
COUNT(*)
FROM zepto
GROUP BY 1;
```

**Insight:**
| Segment | Products |
|---------|----------|
| Low (< ₹100) | 1,837 |
| Mid (₹100–₹500) | 1,782 |
| High (₹500–₹1,000) | 98 |
| Luxury (> ₹1,000) | 14 |

Zepto is a value-driven platform — **97% of products** fall in the budget or mid-range tiers, clearly targeting mass-market consumers.

---

### 15. Weight-Based Revenue Contribution

```sql
SELECT CASE
  WHEN weightInGms < 500 THEN 'Small'
  WHEN weightInGms BETWEEN 500 AND 2000 THEN 'Medium'
  ELSE 'Bulk'
END AS weight_category,
SUM(discountedSellingPrice * availableQuantity) AS revenue
FROM zepto
GROUP BY 1;
```

**Insight:**
- 📦 **Small packs dominate revenue** (~₹1.43M)
- Medium packs contribute moderately (~₹651K)
- Bulk packs contribute the least (~₹162K)

Consumers prefer small, frequent purchases — consistent with the quick-commerce use case.

---

### 16. Fast-Moving Products (Proxy Logic)

```sql
SELECT name, category
FROM zepto
WHERE availableQuantity < 20
AND discountPercent > 20
AND outOfStock = FALSE;
```

**Insight:** Products with low stock + high discounts are likely high-demand items nearing stockout. These appear across:
- Dairy products
- Packaged foods
- Personal care items

This proxy can serve as a daily early-warning indicator for supply chain teams.

---

### 17. Overstock Analysis

```sql
SELECT * FROM zepto
WHERE availableQuantity > 100
AND discountPercent < 5;
```

**Insight:** No strong overstock signals detected — the inventory does not currently show products with high stock levels and low discount rates simultaneously.

---

### 18. Premium Products With Heavy Discounts

```sql
SELECT name FROM zepto
WHERE mrp > 1000 AND discountPercent > 30;
```

**Insight:** Premium products like specialty cooking oils and baby care items are receiving discounts above 30%. This is likely a sales boost strategy, but risks long-term margin erosion and reduced perceived brand value.

---

### 19. Low Discount but High Revenue Categories

```sql
SELECT category,
AVG(discountPercent),
SUM(discountedSellingPrice * availableQuantity)
FROM zepto
GROUP BY category
HAVING AVG(discountPercent) < 10;
```

**Insight:** Categories generating strong revenue with minimal discount dependency:
- ✅ Cooking Essentials
- ✅ Munchies
- ✅ Personal Care

These are high-profit, stable categories where demand is organic — not promotion-driven.

---

## Key Business Findings

| Area | Finding |
|------|---------|
| 💰 Revenue Drivers | Cooking Essentials, Munchies, Personal Care |
| ⚠️ High Risk | Biscuits (28.6% OOS), Dairy (availability gaps) |
| 📊 Pricing Strategy | 97% of SKUs in budget/mid-range — mass-market focus |
| 📦 Inventory Pattern | Small packs dominate; bulk contributes least |
| 🔻 Revenue at Risk | ₹8.91M lost to out-of-stock products |

---

## Conclusion

This analysis demonstrates that Zepto's business model is primarily:

- **Mass-market focused** — affordability-first pricing across the catalog
- **Discount-driven in perishables** — heavy promotions on Fruits, Vegetables, and Meats
- **Strong in FMCG** — Munchies and Cooking Essentials are the commercial backbone
- **Small-pack oriented** — consumer behavior strongly favors frequent small purchases

**Key challenges identified:**
- Stockout management, especially in Biscuits and Beverages
- ₹8.91M in revenue leakage from unavailable products
- Over-discounting on premium SKUs risks margin compression

---

## Project Links

- 📁 [GitHub Repository](https://github.com/saimmi/zepto-sql-business-analysis)
- 📝 [Blog / Case Study](https://saimmi.github.io/zepto-sql-business-analysis/)
- 💼 [LinkedIn Profile](https://www.linkedin.com/in/s-nisha-31a78b212/)

