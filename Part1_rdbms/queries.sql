-- ============================================================
-- queries.sql
-- Part 1: RDBMS — SQL Queries (Q1 to Q5)
-- Database: retail_db
-- Tables used: customers, products, sales_reps, orders
-- ============================================================

USE retail_db;


-- ============================================================
-- Q1: List all customers from Mumbai along with their
--     total order value
-- ============================================================
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    SUM(o.total_price) AS total_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name, c.email
ORDER BY total_order_value DESC;


-- ============================================================
-- Q2: Find the top 3 products by total quantity sold
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_qty_sold
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_qty_sold DESC
LIMIT 3;


-- ============================================================
-- Q3: List all sales representatives and the number of
--     unique customers they have handled
-- ============================================================
SELECT
    sr.sales_rep_id,
    sr.rep_name,
    sr.rep_email,
    COUNT(DISTINCT o.customer_id) AS unique_customers_handled
FROM sales_reps sr
LEFT JOIN orders o ON sr.sales_rep_id = o.sales_rep_id
GROUP BY sr.sales_rep_id, sr.rep_name, sr.rep_email
ORDER BY unique_customers_handled DESC;


-- ============================================================
-- Q4: Find all orders where the total value exceeds 10,000,
--     sorted by value descending
-- ============================================================
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    o.quantity,
    o.total_price,
    o.order_date,
    sr.rep_name AS sales_rep
FROM orders o
JOIN customers c  ON o.customer_id  = c.customer_id
JOIN products p   ON o.product_id   = p.product_id
JOIN sales_reps sr ON o.sales_rep_id = sr.sales_rep_id
WHERE o.total_price > 10000
ORDER BY o.total_price DESC;


-- ============================================================
-- Q5: Identify any products that have never been ordered
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;