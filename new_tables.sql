/*Tables created for exploration and documentation of results and more practice
 due to Temp tables not working efficiently in my curretn setup might delete tables later
 to then switch to a different extension setup like MYSQL to create and use temp tables properly
*/



--all products with null order_ids
SELECT pr.product_name FROM products_without_orders pr;
SELECT * FROM products_without_orders;
--DROP TABLE products_without_orders;


--categories that have no orders
SELECT * FROM categories_without_orders;

--DROP TABLE IF EXISTS categories_without_orders;


CREATE TABLE IF NOT EXISTS categories_products_wout_orders AS
SELECT miss.missing_category, pr.product_name
FROM categories_without_orders miss
FULL OUTER JOIN products_without_orders pr ON pr.product_id = miss.product_id;

--Table with all categories and products without orders
SELECT * FROM categories_products_wout_orders;

