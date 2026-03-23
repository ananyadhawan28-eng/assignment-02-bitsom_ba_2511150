-- ─────────────────────────────────────────────────────────
-- Part 3 — Analytical Queries
-- Database: retail_dw
-- ─────────────────────────────────────────────────────────

USE retail_dw;

-- ─────────────────────────────────────────────────────────
-- Q1: Total sales revenue by product category for each month
-- ─────────────────────────────────────────────────────────
SELECT
    d.year                          AS sale_year,
    d.month_name                    AS sale_month,
    d.month                         AS month_number,
    p.category                      AS product_category,
    SUM(f.net_revenue)              AS total_net_revenue,
    SUM(f.gross_revenue)            AS total_gross_revenue,
    SUM(f.quantity_sold)            AS total_units_sold
FROM
    fact_sales      f
    JOIN dim_date    d ON f.date_key   = d.date_key
    JOIN dim_product p ON f.product_id = p.product_id
GROUP BY
    d.year,
    d.month,
    d.month_name,
    p.category
ORDER BY
    d.year  ASC,
    d.month ASC,
    total_net_revenue DESC;

-- ─────────────────────────────────────────────────────────
-- Q2: Top 2 performing stores by total revenue
-- ─────────────────────────────────────────────────────────
SELECT
    s.store_id,
    s.store_name,
    s.store_city,
    s.store_region,
    SUM(f.net_revenue)      AS total_net_revenue,
    SUM(f.quantity_sold)    AS total_units_sold,
    COUNT(f.sale_id)        AS total_transactions
FROM
    fact_sales  f
    JOIN dim_store s ON f.store_id = s.store_id
GROUP BY
    s.store_id,
    s.store_name,
    s.store_city,
    s.store_region
ORDER BY
    total_net_revenue DESC
LIMIT 2;

-- ─────────────────────────────────────────────────────────
-- Q3: Month-over-month sales trend across all stores
-- Shows revenue for each month and the change vs previous month
-- ─────────────────────────────────────────────────────────
WITH monthly_revenue AS (
    SELECT
        d.year                      AS sale_year,
        d.month                     AS sale_month,
        d.month_name                AS month_name,
        SUM(f.net_revenue)          AS total_revenue
    FROM
        fact_sales  f
        JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
)
SELECT
    sale_year,
    sale_month,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (
        ORDER BY sale_year, sale_month
    )                                                           AS prev_month_revenue,
    ROUND(
        total_revenue - LAG(total_revenue) OVER (
            ORDER BY sale_year, sale_month
        ),
    2)                                                          AS revenue_change,
    ROUND(
        (
            (total_revenue - LAG(total_revenue) OVER (
                ORDER BY sale_year, sale_month
            ))
            / NULLIF(LAG(total_revenue) OVER (
                ORDER BY sale_year, sale_month
            ), 0)
        ) * 100,
    2)                                                          AS growth_percent
FROM
    monthly_revenue
ORDER BY
    sale_year  ASC,
    sale_month ASC;