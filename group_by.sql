--group by function AGGREGATEs your tables on columns with matching values to give you a summary of the data using AGGREGATE commands

SELECT city, COUNT(customer_id) FROM customer
GROUP BY city;

SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

SELECT 
    p.name AS product_name, 
    SUM(o.total_quantity) AS total_units_sold
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.name;

SELECT 
    c.customer_name, 
    ROUND(AVG(o.order_rating), 2) AS avg_rating
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;
