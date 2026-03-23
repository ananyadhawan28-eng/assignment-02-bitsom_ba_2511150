-- ============================================================
-- duckdb_queries.sql
-- Part 5: Data Lake — DuckDB Cross-Format Queries
-- Files: customers.csv, orders.json, products.parquet
-- ============================================================

-- Q1: List all customers along with total number of orders placed
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM 'customers.csv' c
LEFT JOIN 'orders.json' o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;


-- Q2: Find the top 3 customers by total order value
SELECT
    c.customer_id,
    c.name,
    SUM(o.total_amount) AS total_value
FROM 'customers.csv' c
JOIN 'orders.json' o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_value DESC
LIMIT 3;


-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT
    c.name     AS customer,
    c.city,
    p.product_name,
    p.category
FROM 'customers.csv' c
JOIN 'orders.json'      o ON c.customer_id = o.customer_id
JOIN 'products.parquet' p ON o.order_id    = p.order_id
WHERE c.city = 'Bangalore';


-- Q4: Customer name, order date, product name, quantity
SELECT
    c.name          AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM 'customers.csv' c
JOIN 'orders.json'      o ON c.customer_id = o.customer_id
JOIN 'products.parquet' p ON o.order_id    = p.order_id
ORDER BY o.order_date;
