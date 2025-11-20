-- Phase 1: Foundation & Inspection
-- 1. Install IDC_Pizza.dump as IDC_Pizza server
-- 2. List all unique pizza categories (`DISTINCT`).
SELECT DISTINCT category
FROM pizza_types;

/* 3. Display `pizza_type_id`, `name`, and ingredients, replacing 
NULL ingredients with `"Missing Data"`. Show first 5 rows.*/
SELECT pizza_type_id, name,
COALESCE(ingredients, 'Missing Data') AS ingredients
FROM pizza_types
LIMIT 5;

-- 4. Check for pizzas missing a price (`IS NULL`).
SELECT *
FROM pizzas
WHERE price IS NULL;

-- Phase 2: Filtering & Exploration
-- 1. Orders placed on `'2015-01-01'` (`SELECT` + `WHERE`).
SELECT *
FROM orders
WHERE date = '2015-01-01';

-- 2. List pizzas with `price` descending.
SELECT *
FROM pizzas
ORDER BY price DESC;

-- 3. Pizzas sold in sizes `'L'` or `'XL'`.
SELECT *
FROM pizzas
WHERE size IN ('L', 'XL');

-- 4. Pizzas priced between $15.00 and $17.00.
SELECT *
FROM pizzas
WHERE price BETWEEN 15.00 AND 17.00;

-- 5. Pizzas with `"Chicken"` in the name.
SELECT *
FROM pizza_types
WHERE name LIKE '%Chicken%';

-- 6. Orders on `'2015-02-15'` or placed after 8 PM.
SELECT *
FROM orders
WHERE date = '2015-02-15'
OR time >= '20:00:00';

-- Phase 3: Sales Performance
-- 1. Total quantity of pizzas sold (`SUM`).
SELECT SUM(quantity) AS total_quantity
FROM order_details;

-- 2. Average pizza price (`AVG`).
SELECT ROUND(AVG(price),2) AS avg_price
FROM pizzas;

-- 3. Total order value per order (`JOIN`, `SUM`, `GROUP BY`).
SELECT od.order_id,
SUM(od.quantity * p.price) AS total_order_value
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY od.order_id;

-- 4. Total quantity sold per pizza category (`JOIN`, `GROUP BY`).
SELECT pt.category,
SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- 5. Categories with more than 5,000 pizzas sold (`HAVING`).
SELECT pt.category,
SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
HAVING SUM(od.quantity) > 5000;

-- 6. Pizzas never ordered (`LEFT/RIGHT JOIN`).
SELECT p.*
FROM pizzas p
LEFT JOIN order_details od
ON p.pizza_id = od.pizza_id
WHERE od.order_id IS NULL;

/* 7. Price differences between different sizes of the same 
pizza (`SELF JOIN`).*/
SELECT 
p1.pizza_type_id,
p1.size AS size_1,
p2.size AS size_2,
p2.price - p1.price AS price_difference
FROM pizzas p1
JOIN pizzas p2
ON p1.pizza_type_id = p2.pizza_type_id
AND p1.size <> p2.size 
ORDER BY p1.pizza_type_id, size_1, size_2;
