--DELETE FUNCTION


DELETE FROM products
 WHERE product_id = 6;

 --need where statment or it will delete everything

 SELECT * FROM products;

CREATE TABLE "Fruit Juice" (
    "Juice ID" SERIAL PRIMARY KEY,
    "Juice Name" VARCHAR(100),
    "Flavor" VARCHAR(50),
    "Price" DECIMAL(5, 2)
);

SELECT * FROM "Fruit Juice";

DELETE FROM public."Fruit Juice";
 
Truncate public."Fruit Juice";

--these two commands do the same thing but truncate is faster and cannot be rolled back and deletes the strucuture of the table
-- when you want to delete one record use DELETE
-- when you want to delete an entire table use TRUNCATE
 SELECT * FROM products;

DROP TABLE public."Fruit Juice";
-- this command deletes the entire table and its structure
