--updating values in a row or multiple columns

SELECT * FROM products;

UPDATE products set price=500, category_id=2 WHERE product_id=6;

--need to use where statement to only change one row

UPDATE products set price=3000 WHERE product_id=1;

UPDATE products set price=299 WHERE product_id=4;