-- =========================================================
-- Fix uncategorized products with human oversight
-- =========================================================

BEGIN;

-- 1) Ensure the "Travel" category exists (idempotent).
INSERT INTO categories (name)
SELECT 'Travel'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Travel');

-- Show the Travel category_id so you can see what it is:
SELECT category_id AS travel_id FROM categories WHERE name = 'Travel';

-- 2) Validate that all target category_ids (30..45) exist
--    (YOU review this output: if any rows appear, those IDs are missing)
SELECT t.id AS missing_category_id
FROM (VALUES (30),(31),(32),(33),(34),(35),(36),(37),(38),(39),
             (40),(41),(42),(43),(44),(45)) AS t(id)
LEFT JOIN categories c ON c.category_id = t.id
WHERE c.category_id IS NULL;

-- 3) Preview the products you intend to update (YOU review)
SELECT product_id, name, category_id AS current_category
FROM products
WHERE product_id IN (45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29)
ORDER BY product_id DESC;

-- 4) Do the updates using a data-driven mapping table.
--    Note: we look up the Travel category_id dynamically.
WITH map(product_id, category_id) AS (
  VALUES
    (45, (SELECT category_id FROM categories WHERE name = 'Travel')),
    (44, 45),
    (43, 44),
    (42, 43),
    (41, 42),
    (40, 41),
    (39, 40),
    (38, 39),
    (37, 38),
    (36, 37),
    (35, 36),
    (34, 35),
    (33, 34),
    (32, 33),
    (31, 32),
    (30, 31),
    (29, 30)
)
UPDATE products p
SET category_id = m.category_id
FROM map m
WHERE p.product_id = m.product_id;

-- 5) Verify the changes (YOU review)
SELECT
  p.product_id,
  p.name AS product_name,
  p.category_id,
  c.name  AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id IN (45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29)
ORDER BY p.product_id DESC;

-- Also re-check for any products still lacking a category
SELECT p.product_id, p.name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

-- 6) Decide: keep or revert
COMMIT;    -- <- run this if the verification looks good
-- ROLLBACK;  -- <- run this instead if anything looks wrong
