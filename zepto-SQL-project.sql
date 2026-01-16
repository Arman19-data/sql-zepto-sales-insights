drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(100),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPerecent NUMERIC(5,3),
	availableQuantity INT,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INT,
	outOfStock BOOLEAN,
	quantity INT
);

SELECT * FROM zepto;

--DATA EXPLORATION

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data 
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto
WHERE 
category IS NULL
OR name IS NULL
OR mrp IS NULL
OR discountPerecent IS NULL
OR availableQuantity IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product in stock vs product out of stock
SELECT outOfStock, COUNT(sku_id) AS items
FROM zepto
GROUP BY OutOfStock;

--products name present multiple times               (SKU's : Stock Keeping Units)
SELECT name, COUNT(sku_id) AS "Number of SKU's"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


--DATA CLEANING


--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert mrp from paise to rupee
UPDATE zepto
SET mrp = mrp/100,
discountedSellingPrice = discountedSellingPrice/100;

SELECT mrp, discountedSellingPrice FROM zepto;


--VALUABLE INSIGHTS 


-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPerecent, discountedSellingPrice
FROM zepto
ORDER BY discountPerecent DESC
LIMIT 10;


--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;


--Q3.Calculate Estimated Revenue for each category
SELECT DISTINCT category, 
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPerecent
FROM zepto
WHERE mrp > 500 AND discountPerecent < 10
ORDER BY mrp DESC, discountPerecent DESC;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT DISTINCT category, 
ROUND(AVG(discountPerecent), 2) AS "avg discount percentage"
FROM zepto
GROUP BY category
ORDER BY "avg discount percentage" DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gm
FROM zepto
WHERE weightInGms > 100 
ORDER BY price_per_gm ASC;


--Q7.Group the products into categories like Low, Medium, Bulk on the basis of weight.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 500 THEN 'Low'
	WHEN weightInGms < 2000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;


--Q8.What is the Total Inventory Weight Per Category 
SELECT category, 
SUM(weightInGms * availableQuantity) AS total_weight_in_gm
FROM zepto
GROUP BY category
ORDER BY total_weight_in_gm DESC;











