--Show each order with customer name and product name
--INNER JOIN
SELECT
    c.customer_name,
    p.name AS product_name,
    o.total_quantity,
    o.total_amount,
    o.order_timestamp
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_timestamp DESC;

--List customers who have not place an order yet
--LEFT JOIN
-- Create a temporary table with your results
CREATE TEMP TABLE customers_without_orders AS
SELECT
    c.customer_name,
    c.email,
    o.total_amount,
    o.total_quantity,
    o.order_id
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_name;
--Results 3 customers have not placed an order
SELECT * FROM customers_without_orders;
--TEMP TABLE will be dropped automatically at the end of the session
--Need to run intire Create Temp table script to query with temp table_am_handler_in

--which products have never been ordered?
--LEFT JOIN
-- Create a temporary table with your results
--CREATE TEMP TABLE products_never_ordered AS
--creating a permanent table until I delete it
CREATE TABLE IF NOT EXISTS products_without_orders AS
SELECT
    p.product_id,
    p.name AS product_name,
    p.price,
    o.total_quantity,
    o.total_amount
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL
Order by p.product_id;

SELECT * FROM products_without_orders;

--updating null values to 0
UPDATE products_without_orders
SET total_amount = COALESCE(total_amount, 0),
    total_quantity = COALESCE(total_quantity, 0)
WHERE total_amount IS NULL OR total_quantity IS NULL;
--TEMP TABLE will be dropped automatically at the end of the session the session ends every time I run a query making temp tables hard to work WITH
-- Clean up when done
--DROP TABLE products_without_orders;

--Products with orders that includes category name, product name


--For each category calculate the total revenue (GROUP By for aggregate commands)
SELECT
    cat.name AS category_name, p.price,
    SUM(o.total_amount) AS total_revenue
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.name, p.price
ORDER BY total_revenue DESC NULLS LAST;
--Results: Music has the highest revenue
--New results we can clearly see price and tital amount are not yet coralated and need to be fixed
--but what products are in music
SELECT p.name AS product_name, SUM(o.total_amount) AS total_revenue
FROM products p
JOIN categories cat ON cat.category_id = p.category_id
JOIN orders o ON p.product_id = o.product_id
WHERE cat.name = 'Music'
GROUP by p.name
ORDER BY total_revenue DESC NULLS LAST;
--lets double check to see how many products are in the music category
SELECT p.name
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
WHERE cat.name = 'Music';
--this agains prove that their is only one product in Music

SELECT * FROM orders limit (5);
SELECT * FROM customer limit (5);
SELECT * FROM products limit (5);
SELECT * FROM categories limit (5);
select 'categories', count(*)from categories;
select 'products', count(*) from products;
select 'customer', count(*) from customer;
select 'orders', count(*) from orders;



--correct join keys for this schema
--products.category_id ↔ categories.category_id
--orders.customer_id ↔ customer.customer_id
--orders.product_id ↔ products.product_id

--creating a table that shows categories without orders
CREATE TABLE IF NOT EXISTS categories_without_orders AS
SELECT cat.name AS missing_category, p.product_id
FROM categories cat
LEFT JOIN products p ON p.category_id = cat.category_id
WHERE cat.category_id NOT IN (
    SELECT DISTINCT p.category_id
    FROM products p
    JOIN orders o ON p.product_id = o.product_id
)
ORDER BY cat.name;

--products with no orders that includes cat name

SELECT
cat.name as cat_names_of_products_without_orders,
p.name as product_name
FROM orders o
RIGHT join products p ON p.product_id = o.product_id
RIGHT JOIN categories cat ON cat.category_id = p.category_id
WHERE o.order_id IS NULL
ORDER BY cat_names_of_products_without_orders;

