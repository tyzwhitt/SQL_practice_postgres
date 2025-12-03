SELECT table_name 
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
-- This query retrieves the names of all tables in the 'public' schema of the PostgreSQL database and orders them alphabetically.

SELECT * FROM categories LIMIT 15;
SELECT * FROM products LIMIT 15;
SELECT * FROM customer LIMIT 15;
SELECT * FROM orders LIMIT 15;
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




Select p.category_id from products p
--results category_id in products table only has 8 valid rows the rest are NULL


SELECT p.category_id,
  p.product_id,
  p.name AS product_name,
  cat.name AS category_name,
  cat.category_id
FROM products p
LEft join categories cat
ON p.category_id = cat.category_id
ORDER BY p.product_id;

SELECT p.category_id,
  p.product_id,
  p.name AS product_name,
  cat.name AS category_name,
  cat.category_id
FROM products p
Right join categories cat
ON p.category_id = cat.category_id
ORDER BY cat.category_id;

SELECT p.category_id, p.product_id, p.name AS product_name, cat.name AS category_name, cat.category_id
FROM categories cat
Right join products p ON p.name = cat.name

--confirm products have orders
SELECT DISTINCT p.product_id, p.name
FROM products p
JOIN orders o ON o.product_id = p.product_id
ORDER BY p.product_id;

--correct join keys for this schema
--products.category_id ↔ categories.category_id
--orders.customer_id ↔ customer.customer_id
--orders.product_id ↔ products.product_id

SELECT product_id, name, description, tags
FROM products
WHERE category_id IS NULL;

--finding all products with null category_ids

SELECT product_id, name AS product_name
FROM products
WHERE category_id IS NULL
ORDER BY product_id;


SELECT
    cat.name AS category_name,
    SUM(o.total_amount) AS total_revenue
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.name
ORDER BY total_revenue DESC NULLS LAST;
--mising 6 categories need to find out why
--this code will use left join to show all categories and turn NULLS to 0
SELECT
    cat.name AS category_name,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue,
    COUNT(o.order_id) AS number_of_orders
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.name
ORDER BY total_revenue DESC NULLS LAST;

--This tells you:
--Which categories have no products at all
-- Which categories have products but no orders
SELECT 
    cat.name AS category_name,
    COUNT (cat.category_id) AS category_count,
    COUNT(p.product_id) AS number_of_products,
    COUNT(o.order_id) AS number_of_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.name
ORDER BY number_of_products DESC, total_revenue DESC;
--shows 6 categories with no orders
--one category with neither prodcut or order (fashion)
--i want to see only electronics rows with cat_id, product_id, and order_id
SELECT 
    cat.category_id,
    p.product_id,
    o.order_id,
    o.total_amount,
    p.price,
    p.description
FROM categories cat
LEFT JOIN products p ON cat.category_id = p.category_id
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE cat.name = 'Electronics';
--cat_id 1, product_id 5 has no correlating order_id
select * from products limit (1);

select 'orders', count(*) from orders;
SELECT 'products', count(*) from products;
select 'categories', count(*) from categories;
select 'customer', count(*) from customer;
--there are 25 products but only 24 orders why? and 26 customers
--25 categories fashion has no order_id or proudct_id associated with it
select * from categories
where name = 'Fashion';

select * from products
where category_id =6;
--No products for fashion only exists in categories table




SELECT 'categories' as table_name,* FROM categories LIMIT 5;
select 'products' as table_name,* from products LIMIT 5;
--select 'customer' as table_name,* from customer LIMIT 5;
select 'orders' as table_name,* from orders LIMIT 5;

Select total_quantity, total_amount, product_id
FRom orders
where total_amount = 0 or total_amount is NUll;
--product_id 45 has no total_amount

Select price, product_id
from products
where product_id = 45;
--product_id 45 has no price need to update with price
--then update total_amount in orders

--correct join keys for this schema
--products.category_id ↔ categories.category_id
--orders.customer_id ↔ customer.customer_id
--orders.product_id ↔ products.product_id

SELECT 'categories', COUNT (*) FROM categories;
SELECT 'customer', COUNT(*) FROM customer;
SELECT 'orders', COUNT(*)FROM orders;
SELECT 'products', COUNT (*)FROM products;
--there is 25 products but only 24 order rows tell me whhy?

SELECT p.price, p.product_id, cat.name
FROM products p
left join categories cat on cat.category_id = p.category_id
--again only one missing price for cat.name Travel p_id# 45

SELECT o.total_quantity, o.total_amount, cat.name, p.product_id, p.price, p.category_id
FROM orders o
LEFT join products p on o.product_id = p.product_id
LEFT JOIN categories cat on p.category_id = cat.category_id;
--it seems that every product_id cat.name has a vaild order and total amount
--24 orders only product_id 45 is missing an price and thus 0 total_amount

SELECT * from orders limit (5);


--NExt steps
--update products set price = 199.99 where product_id = 45;
--remove fashion(cat_id 6) has no products or orders
--create a table with categories with product_ids that have no order_id (6 of them)
--update total amount to be the price of product * total_quantity
--there is an extra product id that has no order_id aka no oder can we add this to no orders list?



--there are categories with product ids that dont have orders and thus don't have order ids which is okay


/*questions to be answered:
3 customers without orders
6 products without orders





*/


--correct join keys for this schema
--products.category_id ↔ categories.category_id
--orders.customer_id ↔ customer.customer_id
--orders.product_id ↔ products.product_id

Select p.category_id
FROM products p
WHERE p.category_id = 6;
