-- =========================================================
-- MERGE DUPLICATE CUSTOMERS BY EMAIL (case/space-insensitive)
-- =========================================================

BEGIN;

-- A) Define canonical email key and pick a survivor per duplicate group.
--    We normalize emails with LOWER(TRIM(...)) so ' Alice@X.com ' == 'alice@x.com'.
--    We choose the LOWEST customer_id as the survivor (you can change this rule).
-- A) Build duplicate groups (by normalized email)
CREATE TEMP TABLE dedupe_groups AS
SELECT
  LOWER(TRIM(email)) AS email_key,
  MIN(customer_id)   AS survivor_id,  -- keep the lowest id
  COUNT(*)           AS members
FROM customer
WHERE email IS NOT NULL AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;

-- (Preview) what groups were found
SELECT * FROM dedupe_groups ORDER BY email_key;

-- B) Build a mapping of every duplicate_id → survivor_id for updates/deletes.
-- B) Map every duplicate id -> its survivor id
CREATE TEMP TABLE dedupe_mapping AS
SELECT
  c.customer_id AS duplicate_id,
  g.survivor_id,
  g.email_key
FROM customer c
JOIN dedupe_groups g
  ON LOWER(TRIM(c.email)) = g.email_key
WHERE c.customer_id <> g.survivor_id;

-- (Preview) mapping to be applied
SELECT * FROM dedupe_mapping ORDER BY email_key, survivor_id, duplicate_id;

-- C) PREVIEW — see which customers will be merged and how many orders will move.
SELECT
  m.email_key,
  m.duplicate_id,
  m.survivor_id,
  COUNT(o.order_id)                  AS orders_to_move,
  COALESCE(SUM(o.total_amount), 0)   AS amount_to_move
FROM dedupe_mapping m
LEFT JOIN orders o
  ON o.customer_id = m.duplicate_id
GROUP BY m.email_key, m.duplicate_id, m.survivor_id
ORDER BY m.email_key, m.survivor_id, m.duplicate_id;

-- (Optional) PREVIEW — current rows for those duplicates (to eyeball data fields)
SELECT c.*
FROM customer c
JOIN dedupe_mapping m
  ON c.customer_id = m.duplicate_id
ORDER BY m.email_key, c.customer_id;

-- ======================
-- WHEN PREVIEW LOOKS GOOD
-- ======================

-- D) MOVE ORDERS: point all orders from each duplicate to its survivor.
UPDATE orders o
SET customer_id = m.survivor_id
FROM dedupe_mapping m
WHERE o.customer_id = m.duplicate_id;

-- E) DELETE DUPLICATE CUSTOMER ROWS (survivor remains)
DELETE FROM customer c
USING dedupe_mapping m
WHERE c.customer_id = m.duplicate_id;

-- F) POST-CHECK — any orders pointing to missing customers? (Should be zero rows)
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customer c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- G) Decide:
COMMIT;   -- finalize changes
-- ROLLBACK; -- revert if anything looks off


-- A) PREVIEW duplicates with a row number (rn>1 are deletable)
WITH dups AS (
  SELECT
    order_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id, product_id, total_quantity, total_amount,
                   order_rating, length, width, order_timestamp, delivery_timestamp
      ORDER BY order_id  -- keep the smallest order_id
    ) AS rn
  FROM orders
)
SELECT *
FROM orders o
JOIN dups d USING (order_id)
WHERE d.rn > 1
ORDER BY o.customer_id, o.product_id, o.order_timestamp, o.order_id;
--these are the duplicates we are going to DELETE


-- ======================
-- WHEN PREVIEW LOOKS GOOD
BEGIN;

WITH dups AS (
  SELECT
    order_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id, product_id, total_quantity, total_amount,
                   order_rating, length, width, order_timestamp, delivery_timestamp
      ORDER BY order_id
    ) AS rn
  FROM orders
)
DELETE FROM orders o
USING dups d
WHERE o.order_id = d.order_id
  AND d.rn > 1;

-- Post-check: any orphan FKs (should be none; orders is usually a leaf)
SELECT o.order_id
FROM orders o
LEFT JOIN customer c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT o.order_id
FROM orders o
LEFT JOIN products p ON p.product_id = o.product_id
WHERE p.product_id IS NULL;

COMMIT;
