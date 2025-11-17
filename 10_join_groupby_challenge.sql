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
    c.email
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
CREATE TEMP TABLE products_never_ordered AS
SELECT
    p.product_id,
    p.name AS product_name,
    p.price
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
SELECT * FROM products_never_ordered;
--TEMP TABLE will be dropped automatically at the end of the session the session ends every time I run a query making temp tables hard to work WITH

--For each category calculate the total revenue (GROUP By for aggregate commands)
SELECT
    cat.name AS category_name,
    SUM(o.total_amount) AS total_revenue
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN orders o ON p.product_id = o.product_id
GROUP BY cat.name
ORDER BY total_revenue DESC NULLS LAST;

SELECT * FROM categories;
SELECT p.name AS product_name, cat.name AS category_name
 FROM products p
 JOIN categories cat ON p.category_id = cat.category_id;

SELECT * FROM orders;
SELECT * FROM customer;
SELECT * FROM products;
SELECT * FROM categories;

SELECT o.total_amount, p.product_id, o.product_id, p.name
    FROM orders o
    JOIN products p ON o.product_id = p.product_id;

SELECT cat.name AS category_name, cat.category_id, p.category_id
    FROM categories cat
    JOIN products p ON cat.category_id = p.category_id;

--correct join keys for this schema
--products.category_id ↔ categories.category_id
--orders.customer_id ↔ customer.customer_id
--orders.product_id ↔ products.product_id