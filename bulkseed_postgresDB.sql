-- Reset/align all serial sequences to prevent duplicate key errors
SELECT setval(pg_get_serial_sequence('categories','category_id'),
              COALESCE((SELECT MAX(category_id) FROM categories), 0), true);
SELECT setval(pg_get_serial_sequence('products','product_id'),
              COALESCE((SELECT MAX(product_id) FROM products), 0), true);
SELECT setval(pg_get_serial_sequence('customer','customer_id'),
              COALESCE((SELECT MAX(customer_id) FROM customer), 0), true);
SELECT setval(pg_get_serial_sequence('orders','order_id'),
              COALESCE((SELECT MAX(order_id) FROM orders), 0), true);

-- See where you are
SELECT current_user, current_database();

--    (Required for categories(name) and products(name) if you use ON CONFLICT there)
CREATE UNIQUE INDEX IF NOT EXISTS categories_name_uk_idx ON categories (name);
CREATE UNIQUE INDEX IF NOT EXISTS products_name_uk_idx   ON products   (name);
-- Enforce uniqueness of email, ignoring case and surrounding spaces
CREATE UNIQUE INDEX IF NOT EXISTS customer_email_uk_idx
ON public.customer ((LOWER(TRIM(email))));
--Enforce uniqueness of orders based on customer_id and product_id
CREATE UNIQUE INDEX IF NOT EXISTS orders_customer_product_uk_idx ON public.orders (customer_id, product_id);

-- Begin transaction for bulk insert
BEGIN;

-- =========================
-- 1) CATEGORIES (+20 rows)
-- =========================
-- Existing had 3. These will become ids ~4..23 (SERIAL handles it).
INSERT INTO categories (name) VALUES
('Books'),
('Toys'),
('Sports & Outdoors'),
('Beauty'),
('Automotive'),
('Garden'),
('Office'),
('Pet Supplies'),
('Groceries'),
('Music'),
('Movies'),
('Health'),
('Tools'),
('Baby'),
('Jewelry'),
('Shoes'),
('Games'),
('Art & Craft'),
('Photography'),
('Travel')
ON CONFLICT (name) DO NOTHING;


-- =========================
-- 2) PRODUCTS (+20 rows)
-- =========================
-- Use a spread of category_ids (1..20+). Some prices NULL on purpose.
INSERT INTO products (name, price, description, tags, category_id, supplier) VALUES
('E-Reader', 119.99, '6" glare-free e-ink display', 'electronics,books,reading',
  (SELECT category_id FROM categories WHERE name='Books'), 'SupplierC'),
('Action Figure', 24.99, 'Articulated 6" hero figure', 'toys,collectibles',
  (SELECT category_id FROM categories WHERE name='Toys'), 'SupplierD'),
('Yoga Mat', 29.95, 'Non-slip, 6mm thickness', 'sports,fitness',
  (SELECT category_id FROM categories WHERE name='Sports & Outdoors'), 'SupplierE'),                     
('Face Serum', 39.50, 'Vitamin C brightening serum', 'beauty,skincare',
  (SELECT category_id FROM categories WHERE name ='beauty,skincare'),'SupplierF'),
('Car Phone Mount', 17.49, 'Magnetic vent mount', 'automotive,accessories', 
  (SELECT category_id FROM categories WHERE name ='automotive,accessories'),'SupplierG'),
('Garden Hose', 34.99, 'Expandable 50ft hose', 'garden,outdoors', 
  (SELECT category_id FROM categories WHERE name ='garden,outdoors'),'SupplierH'),
('Notebook Pack', 9.99, 'A5 dotted notebooks (3-pack)', 'office,stationery', 
  (SELECT category_id FROM categories WHERE name ='office,stationery'),'SupplierI'),
('Dog Leash', 14.99, 'Reflective 6ft nylon leash', 'pets,accessories', 
  (SELECT category_id FROM categories WHERE name ='pets,accessories'),'SupplierJ'),
('Organic Coffee Beans', 16.99, 'Medium roast, 1 lb', 'groceries,coffee', 
  (SELECT category_id FROM categories WHERE name ='groceries,coffee'),'SupplierK'),
('Acoustic Guitar', 199.00, 'Full-size spruce top', 'music,instrument', 
  (SELECT category_id FROM categories WHERE name ='music,instrument'),'SupplierL'),
('Blu-ray Player', 89.00, '1080p upscaling', 'movies,home', 
  (SELECT category_id FROM categories WHERE name ='movies,home'),'SupplierM'),
('Multivitamins', 22.50, 'Once-daily, 120 tablets', 'health,supplements', 
  (SELECT category_id FROM categories WHERE name ='health,supplements'),'SupplierN'),
('Cordless Drill', 79.00, '20V compact drill/driver', 'tools,DIY', 
  (SELECT category_id FROM categories WHERE name ='tools,DIY'),'SupplierO'),
('Baby Monitor', 139.00, '1080p camera with audio', 'baby,monitor', 
  (SELECT category_id FROM categories WHERE name ='baby,monitor'),'SupplierP'),
('Silver Necklace', 59.00, 'Sterling silver, 18"', 'jewelry,accessories', 
  (SELECT category_id FROM categories WHERE name ='jewelry,accessories'),'SupplierQ'),
('Running Shoes', 89.99, 'Cushioned road runners', 'shoes,fitness',
  (SELECT category_id FROM categories WHERE name ='shoes,fitness'),'SupplierR'),
('Board Game', 34.95, 'Strategy game for 2-4 players', 'games,family', 
  (SELECT category_id FROM categories WHERE name ='games,family'), NULL),
('Acrylic Paint Set', 19.49, '24-color artist set', 'art,craft', 
  (SELECT category_id FROM categories WHERE name ='art,craft'), NULL),
('Tripod', 44.00, 'Aluminum travel tripod', 'photography,camera', 
  (SELECT category_id FROM categories WHERE name ='photography,camera'),'SupplierS'),
('Travel Pillow', NULL, 'Memory foam neck pillow', 'travel,comfort', 
  (SELECT category_id FROM categories WHERE name ='travel,comfort'), NULL)
ON CONFLICT (name) DO NOTHING;
  
-- =========================
-- 3) CUSTOMERS (+20 rows)
-- =========================
INSERT INTO customer (customer_name, email, phone_number, address, city) VALUES
('Grace Lee',     'grace.lee@example.com',     '313-555-0101', '10 River Rd',         'Detroit'),
('Henry Adams',   'henry.adams@example.com',   '313-555-0102', '22 Maple St',         'Ann Arbor'),
('Isla Perez',    'isla.perez@example.com',    '313-555-0103', '55 Oak Ln',           'Lansing'),
('Jack Young',    'jack.young@example.com',    '313-555-0104', '77 Birch Ave',        'Flint'),
('Karen Brooks',  'karen.brooks@example.com',  '313-555-0105', '88 Cedar Ct',         'Dearborn'),
('Liam Turner',   'liam.turner@example.com',   '313-555-0106', '19 Pine Dr',          'Grand Rapids'),
('Mia Collins',   'mia.collins@example.com',   '313-555-0107', '301 Lakeview Blvd',   'Kalamazoo'),
('Noah Foster',   'noah.foster@example.com',   '313-555-0108', '402 Hilltop Way',     'Traverse City'),
('Olivia Reed',   'olivia.reed@example.com',   '313-555-0109', '503 Market St',       'Ypsilanti'),
('Paul Diaz',     'paul.diaz@example.com',     '313-555-0110', '604 Cherry Pl',       'Warren'),
('Quinn Baker',   'quinn.baker@example.com',   '313-555-0111', '705 Walnut Rd',       'Sterling Heights'),
('Riley Morgan',  'riley.morgan@example.com',  '313-555-0112', '806 Summit Ave',      'Royal Oak'),
('Sophia Price',  'sophia.price@example.com',  '313-555-0113', '907 Meadow Ln',       'Troy'),
('Theo Howard',   'theo.howard@example.com',   '313-555-0114', '120 Harbor Dr',       'Novi'),
('Uma Carter',    'uma.carter@example.com',    '313-555-0115', '230 Sunset Blvd',     'Livonia'),
('Victor Stone',  'victor.stone@example.com',  '313-555-0116', '340 Forest St',       'Rochester'),
('Will Nash',     'will.nash@example.com',     '313-555-0117', '450 Brookside Trl',   'Bloomfield Hills'),
('Xena King',     'xena.king@example.com',     '313-555-0118', '560 Orchard Rd',      'Farmington'),
('Yara Flynn',    'yara.flynn@example.com',    '313-555-0119', '670 Highland Ave',    'Grosse Pointe'),
('Zane Ortiz',    'zane.ortiz@example.com',    '313-555-0120', '780 Riverside Dr',    'Southfield')
ON CONFLICT ((LOWER(TRIM(email)))) DO NOTHING;
-- =========================
-- 4) ORDERS (+20 rows)
-- =========================
-- Assumes customer ids now span at least 1..26 and product ids at least 1..25.
-- Mix quantities, amounts, ratings, dims, and timestamps.
INSERT INTO orders (customer_id, product_id, total_quantity, total_amount, order_rating, length, width, order_timestamp, delivery_timestamp) VALUES
((SELECT customer_id FROM customer WHERE customer_name='Mia Collins' LIMIT 1), (SELECT product_id FROM products WHERE name='Garden Hose' LIMIT 1),  1, 119.99, 4.2,  2.1, 1.0, '2023-05-01 09:10:00', '2023-05-02 13:40:00'),
((SELECT customer_id FROM customer WHERE customer_name='Noah Foster' LIMIT 1), (SELECT product_id FROM products WHERE name='Notebook Pack' LIMIT 1),  2,  49.98, 3.9,  1.3, 1.1, '2023-05-03 11:05:00', '2023-05-05 16:25:00'),
((SELECT customer_id FROM customer WHERE customer_name='Olivia Reed' LIMIT 1), (SELECT product_id FROM products WHERE name='Dog Leash' LIMIT 1),  1,  39.50, 4.6,  1.2, 1.0, '2023-05-06 10:00:00', '2023-05-08 12:10:00'),
((SELECT customer_id FROM customer WHERE customer_name='Paul Diaz' LIMIT 1), (SELECT product_id FROM products WHERE name='Organic Coffee Beans' LIMIT 1),  3, 104.97, 4.0,  2.0, 1.5, '2023-05-09 14:45:00', '2023-05-11 10:30:00'),
((SELECT customer_id FROM customer WHERE customer_name='Quinn Baker' LIMIT 1), (SELECT product_id FROM products WHERE name='Acoustic Guitar' LIMIT 1), 1, 199.00,  4.7,  3.0, 2.0, '2023-05-12 08:20:00', '2023-05-13 09:50:00'),
((SELECT customer_id FROM customer WHERE customer_name='Riley Morgan' LIMIT 1), (SELECT product_id FROM products WHERE name='Blu-ray Player' LIMIT 1), 1,  89.00,  3.8,  2.5, 1.9, '2023-05-13 17:30:00', '2023-05-15 18:15:00'),
((SELECT customer_id FROM customer WHERE customer_name='Sophia Price' LIMIT 1), (SELECT product_id FROM products WHERE name='Multivitamins' LIMIT 1), 2,  45.00,  4.1,  1.4, 1.2, '2023-05-16 09:40:00', '2023-05-17 11:05:00'),
((SELECT customer_id FROM customer WHERE customer_name='Theo Howard' LIMIT 1), (SELECT product_id FROM products WHERE name='Cordless Drill' LIMIT 1), 1,  79.00,  4.4,  2.2, 1.4, '2023-05-18 12:00:00', '2023-05-19 15:45:00'),
((SELECT customer_id FROM customer WHERE customer_name='Uma Carter' LIMIT 1), (SELECT product_id FROM products WHERE name='Baby Monitor' LIMIT 1), 1, 139.00,  4.9,  2.8, 1.6, '2023-05-20 16:10:00', '2023-05-22 13:10:00'),
((SELECT customer_id FROM customer WHERE customer_name='Victor Stone' LIMIT 1), (SELECT product_id FROM products WHERE name='Silver Necklace' LIMIT 1), 1,  59.00,  3.6,  1.5, 1.3, '2023-05-22 08:55:00', '2023-05-23 10:20:00'),
((SELECT customer_id FROM customer WHERE customer_name='Will Nash' LIMIT 1), (SELECT product_id FROM products WHERE name='Running Shoes' LIMIT 1), 1,  89.99,  4.2,  2.6, 1.9, '2023-05-24 11:25:00', '2023-05-26 09:35:00'),
((SELECT customer_id FROM customer WHERE customer_name='Xena King' LIMIT 1), (SELECT product_id FROM products WHERE name='Board Game' LIMIT 1), 2,  69.90,  4.0,  2.0, 1.5, '2023-05-26 13:45:00', '2023-05-28 16:05:00'),
((SELECT customer_id FROM customer WHERE customer_name='Yara Flynn' LIMIT 1), (SELECT product_id FROM products WHERE name='Acrylic Paint Set' LIMIT 1), 3,  58.47,  3.7,  1.1, 1.0, '2023-05-28 09:05:00', '2023-05-29 12:45:00'),
((SELECT customer_id FROM customer WHERE customer_name='Zane Ortiz' LIMIT 1), (SELECT product_id FROM products WHERE name='Tripod' LIMIT 1), 1,  44.00,  4.3,  2.4, 1.7, '2023-05-30 10:30:00', '2023-05-31 14:00:00'),
((SELECT customer_id FROM customer WHERE customer_name='Grace Lee' LIMIT 1), (SELECT product_id FROM products WHERE name='Travel Pillow' LIMIT 1), 2,      0,  3.5,  1.6, 1.2, '2023-06-01 15:20:00', '2023-06-03 10:25:00'),
((SELECT customer_id FROM customer WHERE customer_name='Henry Adams' LIMIT 1), (SELECT product_id FROM products WHERE name='Garden Hose' LIMIT 1), 1, 119.99,  4.1,  2.1, 1.0, '2023-06-03 09:40:00', '2023-06-04 12:05:00'),
((SELECT customer_id FROM customer WHERE customer_name='Isla Perez' LIMIT 1), (SELECT product_id FROM products WHERE name='Notebook Pack' LIMIT 1), 1,  24.99,  3.8,  1.3, 1.1, '2023-06-05 11:50:00', '2023-06-07 15:10:00'),
((SELECT customer_id FROM customer WHERE customer_name='Jack Young' LIMIT 1), (SELECT product_id FROM products WHERE name='Dog Leash' LIMIT 1), 2,  79.00,  4.6,  1.2, 1.0, '2023-06-07 13:15:00', '2023-06-08 17:30:00'),
((SELECT customer_id FROM customer WHERE customer_name='Karen Brooks' LIMIT 1), (SELECT product_id FROM products WHERE name='Organic Coffee Beans' LIMIT 1), 1,  34.99,  4.0,  2.0, 1.5, '2023-06-09 08:00:00', '2023-06-10 09:40:00'),
((SELECT customer_id FROM customer WHERE customer_name='Liam Turner' LIMIT 1), (SELECT product_id FROM products WHERE name='Acoustic Guitar' LIMIT 1), 1, 199.00,  4.9,  3.0, 2.0, '2023-06-11 18:10:00', '2023-06-12 19:20:00')
ON CONFLICT (customer_id, product_id) DO NOTHING;



-- Optional quick checks:
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM orders;

COMMIT;


-- End of bulkseed_postgresDB.sql


