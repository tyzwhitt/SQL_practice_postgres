--inner join which joins two tables together based on a common column between them

SELECT name, description,total_amount
 FROM orders o
 INNER JOIN products p ON p.product_id = o.product_id;


 SELECT customer_name, total_amount from orders o JOIN customer c ON o.customer_id = c.customer_id; 

 --INNER JOIN AND JOIN are the same

 --left join returns all rows from the left table and the matched rows from the right table. If there is no match, NULL values are returned for columns from the right table.
 --reight join returns all rows from the right table and the matched rows from the left table. If there is no match, NULL values are returned for columns from the left table.  

 SELECT customer_name, total_amount from customer c LEFT JOIN orders o ON c.customer_id = o.customer_id;

 SELECT name, total_quantity from orders o RIGHT JOIN products p ON p.product_id = o.product_id;


 --outer join returns all rows from both tables, with NULL values in place where the join condition is not met.

 SELECT customer_name, total_quantity from customer c FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

 --joining 3 tables you join 2 tables first and then join the third with the table returned by the first JOIN
 
 SELECT customer_name, name, total_quantity FROM customer c FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
    Full OUTER JOIN products p ON p.product_id = o.product_id;
    