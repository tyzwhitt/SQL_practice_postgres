--Mathmatical FUNCTIONS
SELECT ABS(-15); -- Returns 15 absolute value
SELECT CEIL(4.2); -- Returns 5 Ceiling value or highest possible value
SELECT FLOOR(4.7); -- Returns 4 lowest possible value
SELECT ROUND(4.5); -- Returns 5
SELECT POWER(2, 3); -- Returns 8 
SELECT SQRT(16); -- Returns 4
SELECT MOD(10, 3); -- Returns 1
SELECT RANDOM(); -- Returns a random number between 0 and 1
SELECT TRUNC(4.7); -- Returns 4


SELECT product_id, ABS(price - 100) AS price_difference
FROM products;
-- Find products with price difference from 100

SELECT product_id, CEIL(price) AS rounded_up_price
FROM products;
-- Find products with price rounded up

SELECT product_id, FLOOR(price) AS rounded_down_price
FROM products;
-- Find products with price rounded down

SELECT name, ROUND(price, 1) AS rounded_price
FROM products;
-- Find products with price rounded to 1 decimal place

SELECT order_id, SQRT(total_amount) AS sqrt_total
FROM orders;
-- Find square root of total amount in orders