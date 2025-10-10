--A view is a virtual table derived from the result of a SELECT query. It doesn't store data itself but provides an organized way to look at data.


--benefits of using views:
--1. Simplified Data Access: Views can simplify complex queries by encapsulating them in a single object.
--2. Security: Views can restrict access to specific columns or rows of a table, enhancing data security.
--3. Data Abstraction: Views provide a level of abstraction, allowing users to interact with data without needing to understand the underlying table structures.
--4. Reusability: Once created, views can be reused in multiple queries, promoting consistency and reducing redundancy.
--5. Logical Data Independence: Changes to the underlying table structure do not affect the view, as long as the changes do not alter the columns used in the view.

--Creating a VIEW
--CREATE VIEW view_name AS
--SELECT column1, column2, ...
--FROM table_name
--WHERE condition;

--Example: Create a view to show employee names and their department names
CREATE VIEW customer_order_summary AS
SELECT customer_id,
COUNT(total_amount)
FROM
orders
GROUP BY customer_id;
--Querying a VIEW
SELECT * FROM customer_order_summary WHERE customer_id = 1;


/*Standard Views:
These execute the underlying query each time the view is accessed.
Materialized Views: 
These store the result of the query on disk, providing faster access
but potentially outdated data if the source data changes frequently.*/
