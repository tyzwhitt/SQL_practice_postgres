-- ============================================
-- Assign categories to uncategorized products
-- ============================================
BEGIN;

-- 1) Preview: products that currently have no category
SELECT product_id, name AS product_name, category_id
FROM products
WHERE category_id IS NULL
ORDER BY product_id;

-- 2) Mapping: product_name -> category_name
--    (Check each line and confirm these pairings are what you want.)
WITH mapping AS (
  SELECT * FROM (VALUES
    ('Travel Pillow',       'Travel'),
    ('Tripod',              'Photography'),
    ('Acrylic Paint Set',   'Art & Craft'),
    ('Board Game',          'Games'),
    ('Running Shoes',       'Shoes'),
    ('Silver Necklace',     'Jewelry'),
    ('Baby Monitor',        'Baby'),
    ('Cordless Drill',      'Tools'),
    ('Multivitamins',       'Health'),
    ('Blu-ray Player',      'Movies'),
    ('Acoustic Guitar',     'Music'),
    ('Organic Coffee Beans','Groceries'),
    ('Dog Leash',           'Pet Supplies'),
    ('Notebook Pack',       'Office'),
    ('Garden Hose',         'Garden'),
    ('Car Phone Mount',     'Automotive'),
    ('Face Serum',          'Beauty')
  ) AS x(product_name, category_name)
),

-- 3) UPDATE: join products to mapping + categories, and fill category_id
updated AS (
  UPDATE products p
  SET category_id = c.category_id
  FROM mapping m
  JOIN categories c
    ON c.name = m.category_name
  WHERE p.name = m.product_name
  RETURNING
    p.product_id,
    p.name        AS product_name,
    p.category_id,
    c.name        AS category_name
)

-- 4) Preview: show exactly what we updated in this run
SELECT *
FROM updated
ORDER BY product_id;

-- 5) Sanity check: any products still missing a category?
SELECT product_id, name AS product_name
FROM products
WHERE category_id IS NULL
ORDER BY product_id;

-- After reviewing the previews:
COMMIT;    -- <- run this when you’re happy
-- ROLLBACK;  -- <- run this instead if something looks wrong
