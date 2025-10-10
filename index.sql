/*
Indexes in SQL databases provide a quick and efficient way to look up
and retrieve data from a table, similar to a library catalog or a categorized restaurant menu.

Types of Indexes: The video explains different types of indexes,
including single-column, composite, unique, clustered, and non-clustered indexes.

Usage of Indexes: Indexes should be used on columns frequently involved in 
WHERE clauses, JOIN operations, ORDER BY, or GROUP BY clauses to enhance query performance and efficiency.

*/

--CREATE INDEX index_name
--ON table_name (column1, column2, ...);

CREATE INDEX idx_customer_email
ON customer (email);

CREATE INDEX idx_prod_cat
ON products (category_id);

CREATE UNIQUE INDEX idx_prod_name
ON products (name);

CREATE INDEX idx_cust_order
ON orders (customer_id, order_timestamp);


