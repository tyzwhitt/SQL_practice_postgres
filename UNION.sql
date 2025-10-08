--Find the category_id for electronics

SELECT * FROM categories WHERE name = 'Electronics';

--this shows us that the category_id for electronics is 1

--now want the table to only show products in the electronics category

SELECT * FROM products WHERE category_id = 1;

--Now we want all products with the order quantity exceeds 1 using inner JOIN
-- to meet both conditions we can use UNION


SELECT name FROM products WHERE category_id = 1

UNION

Select name From products p INNER JOIN orders o ON o.product_id = p.product_id WHERE o.total_quantity > 1;

--the difference between UNION and JOINS is that UNION combines the results of two separate queries
--while JOINS combine data from multiple tables based on a related column between them
--UNION combines vertically while JOINS combine horizontally
--UNION removes duplicates while JOINS do not
--UNION requires the same number of columns with compatible data types while JOINS do not have this requirement