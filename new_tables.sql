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

/*
With the selection below we can see that 7 categories dont have orders
and of those 7 we can see that 6 of them have products associated with them that also have no orders
fashion has no orders or products associated with it
in conclusion we should be able to safely remove the 7 categories, which will inturn also rid the 6 products that have no orders
or we can create orders for 6 of them and only delete fashion they do have prices associated with them.
*/
SELECT miss.missing_category, pr.product_name
FROM categories_without_orders miss
FULL OUTER JOIN products_without_orders pr ON pr.product_id = miss.product_id;

