--CASE expression can handle multiple conditions and looks for first match return null value if no matches or retruns else statement

SELECT name,
description,
CASE
WHEN price < 100 THEN 'cheap'
WHEN price BETWEEN 100 AND 500 THEN 'affordable'
ELSE 'expensive'
END AS ProductType
FROM products;