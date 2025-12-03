--Updating_NULL_orders
--Table including all categories and products without orders
SELECT * FROM categories_products_wout_orders;

/*
7 products dont have orders
6 categories have no orders
fashion has no orders or products associated with it: DELETE
ADD orders to 6 products
*/


--Delete Fashion category
DELETE FROM categories
WHERE name = 'Fashion';

--Verify Deletion
SELECT * FROM categories
WHERE name = 'Fashion';
