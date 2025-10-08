-- inserting values into product table
-- the order of the columns does not matter but has to match match the values you are inserting


INSERT INTO products (name,price,description, tags, category_id, supplier)

VALUES
('Ipad',
1,
'High-performance ipad for professionals',
'electronics,portable, tech',1, 'Supplier A')

-- catergory_id is the foriegn key thus 1 has to exist in the category table or it will cause ERROR

