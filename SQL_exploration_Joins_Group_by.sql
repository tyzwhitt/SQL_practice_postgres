SELECT table_name 
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
-- This query retrieves the names of all tables in the 'public' schema of the PostgreSQL database and orders them alphabetically.

SELECT * FROM categories LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM customer LIMIT 40;
SELECT * FROM orders LIMIT 5;
-- These queries display the first 5 rows from the 'categories', 'products', 'customer', and 'orders' tables to give an overview of their structure and data.


--category_id integer is a in both categories and products table
--product_id integer is a in both products and orders table
--customer_id integer is a in both customer and orders table

SELECT 'categories' AS table_name, COUNT(*) AS rows FROM categories
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;
-- This query counts the number of rows in each of the four tables: 'categories', 'products', 'customer', and 'orders', and displays the results in a single result set with the table names.

-- Check for any missing category/product links
SELECT p.name AS product_name, p.category_id, c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT c.customer_name, o.order_id, o.total_amount
FROM customer c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;
-- This query retrieves the customer names along with their corresponding order IDs and total amounts by performing an inner join between the 'customer' and 'orders' tables based on the customer_id.

SELECT c.customer_name, o.order_id, o.total_amount
FROM customer c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;
-- This query retrieves all customer names along with their corresponding order IDs and total amounts, including customers who may not have placed any orders, by performing a left join between the 'customer' and 'orders' tables based on the customer_id.


SELECT p.product_id, p.name AS product_name, p.description, p.tags
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT * FROM categories

--p.45 to new catergory "Travel" it does exist category_id 46
--p.44 move to c.45
--p.43 to c.44
--p.42 t0 c.43
--p.41 to c.42
--p.40 to c.41
--p.39 to c.40
--p.38 to c.39
--p.37 to c.38
--p.36 to c.37
--p.35 to c.36
--p.34 to c.35
--p.33 to c.34
--p.32 to c.33
--p.31 to c.32
--p.30 to c.31
--p.29 to c.30

--making sure our update from the update file worked on our database
--again updated Null product category_ids to there proper category_ids
-- Should return the updated products with categories
SELECT p.product_id, p.name, c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id IN (45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29)
ORDER BY p.product_id DESC;

-- Should return zero rows now:
SELECT p.product_id, p.name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;


--lets keep exploring
SELECT * FROM customer
WHERE customer_name = 'Noah Foster';
SELECT 'customer', COUNT(*) FROM customer;

--need to figure out the duplicates situation with the customer names why is there so many more rows of customer names than the rest of the tables?

-- How many rows share the same name
SELECT customer_name, COUNT(*) AS cnt
FROM customer
GROUP BY customer_name
HAVING COUNT(*) > 1
ORDER BY cnt DESC, customer_name;
-- This query identifies customer names that appear more than once in the 'customer' table, counting the occurrences and ordering the results by the count in descending order and then by customer name.

-- List those rows so you can inspect differences (email, phone, city)
WITH dup AS (
  SELECT customer_name
  FROM customer
  GROUP BY customer_name
  HAVING COUNT(*) > 1
)
SELECT c.*
FROM customer c
JOIN dup d USING (customer_name)
ORDER BY c.customer_name, c.email, c.customer_id;

SELECT
  c.customer_id,
  c.customer_name,
  c.email,
  COUNT(o.order_id)           AS order_count,
  COALESCE(SUM(o.total_amount),0) AS total_spent
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.email
ORDER BY c.customer_name, c.customer_id;

--it seems like all the duplicat entries dont have any orders thus we should be able to delete them safely if we wanted to clean up the database

SELECT
  o.order_id,
    o.total_amount,
    o.customer_id,
  COUNT(o.order_id)           AS order_count,
  COALESCE(SUM(o.total_amount),0) AS total_spent
FROM orders o
LEFT JOIN customer c ON o.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
ORDER BY o.total_amount;




SELECT customer_id, customer_name, order_id
 orders

SELECT * FROM orders o
ORDER BY o.customer_id;