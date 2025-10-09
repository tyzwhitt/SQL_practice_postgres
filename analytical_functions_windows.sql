--analytical functions also known as window functions
--these functions perform calculations across a set of table rows that are somehow related to the current row


--Ranks rows within a partition (like per customer or per product). If two rows have the same value, they share the same rank — but the next rank number skips ahead.

SELECT 
    o.order_id,
    c.customer_name,
    o.total_amount,
    RANK() OVER (ORDER BY o.total_amount DESC) AS order_rank
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id;
--bad example because no matching value, but if there were the order could look like this (1,2,2,4,5)
SELECT customer_id,
RANK() OVER (PARTITION by customer_id ORDER BY total_amount DESC) AS order_rank, total_amount
FROM orders; --better example to show skips for RANK when values match


--Same as RANK() but does not skip numbers after ties.

SELECT 
    o.order_id,
    o.total_amount,
    DENSE_RANK() OVER (ORDER BY o.total_amount DESC) AS dense_rank
FROM orders o;


SELECT 
    o.order_id,
    c.customer_name,
    o.total_amount,
    ROW_NUMBER() OVER (ORDER BY o.order_timestamp) AS row_num
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id;
--gives each row a unique sequential integer, even if there are ties. No gaps in numbering.


SELECT 
    o.order_id,
    c.customer_name,
    o.total_amount,
    LEAD(o.total_amount) OVER (ORDER BY o.order_timestamp) AS next_order_amount
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id;
--accesses data from the next row in the result set without using a self-join. useful for comparing values between consecutive rows.



SELECT 
    o.order_id,
    c.customer_name,
    o.total_amount,
    LEAD(o.total_amount) OVER (ORDER BY o.order_timestamp) AS next_order_amount
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id;
--LEAD allows you to retrieve data from the next row in the result set without using a self-join. useful for comparing values between consecutive rows.
--w/ PARTITION
SELECT customer_id, order_id, order_timestamp,
LEAD(order_timestamp,1) over (PARTITION by customer_id ORDER BY order_timestamp) AS previous_order
FROM orders;

SELECT customer_id, order_id, order_timestamp,
LAG (order_timestamp,1) over (PARTITION by customer_id ORDER BY order_timestamp) AS previous_order
FROM orders;

SELECT 
    o.order_id,
    c.customer_name,
    o.total_amount,
    LAG(o.total_amount) OVER (ORDER BY o.order_timestamp) AS previous_order_amount
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id;
--LAG allows you to retrieve data from the previous row in the result set without using a self-join. useful for comparing values between consecutive rows.

--SUM() OVER() running total
SELECT  customer_id, order_id, order_timestamp,
SUM(total_amount) OVER (PARTITION by customer_id ORDER BY order_timestamp) AS running_total
FROM orders;

SELECT product_id, order_timestamp, total_quantity,
SUM(total_quantity) OVER (PARTITION by product_id ORDER BY order_timestamp) AS running_quantity
FROM orders; 

--calculate moving average by usng AVG() OVER()
SELECT order_id, customer_id, order_timestamp   , total_amount,
AVG(total_amount) OVER (PARTITION by customer_id ORDER BY order_timestamp
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM orders;


