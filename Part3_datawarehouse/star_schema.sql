-- ─────────────────────────────────────────────────────────
-- Part 3 — Data Warehouse: Star Schema
-- Database: retail_dw
-- ─────────────────────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS retail_dw;
USE retail_dw;

-- ─────────────────────────────────────────────────────────
-- DIMENSION TABLE 1: dim_date
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_date (
    date_key        INT PRIMARY KEY,        -- Format: YYYYMMDD e.g. 20230815
    full_date       DATE NOT NULL,
    day             TINYINT NOT NULL,
    month           TINYINT NOT NULL,
    month_name      VARCHAR(15) NOT NULL,
    quarter         TINYINT NOT NULL,
    year            SMALLINT NOT NULL,
    day_of_week     VARCHAR(10) NOT NULL,
    is_weekend      BOOLEAN NOT NULL
);

-- ─────────────────────────────────────────────────────────
-- DIMENSION TABLE 2: dim_store
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_store (
    store_id        VARCHAR(10) PRIMARY KEY,
    store_name      VARCHAR(100) NOT NULL,
    store_city      VARCHAR(50) NOT NULL,
    store_state     VARCHAR(50) NOT NULL,
    store_region    VARCHAR(30) NOT NULL
);

-- ─────────────────────────────────────────────────────────
-- DIMENSION TABLE 3: dim_product
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_product (
    product_id      VARCHAR(10) PRIMARY KEY,
    product_name    VARCHAR(150) NOT NULL,
    category        VARCHAR(50) NOT NULL,   -- Standardised to title case
    sub_category    VARCHAR(50),
    unit_price      DECIMAL(10,2) NOT NULL
);

-- ─────────────────────────────────────────────────────────
-- FACT TABLE: fact_sales
-- ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id             INT AUTO_INCREMENT PRIMARY KEY,
    date_key            INT NOT NULL,
    store_id            VARCHAR(10) NOT NULL,
    product_id          VARCHAR(10) NOT NULL,
    quantity_sold       INT NOT NULL,
    unit_price          DECIMAL(10,2) NOT NULL,
    discount_amount     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    gross_revenue       DECIMAL(12,2) NOT NULL,   -- quantity * unit_price
    net_revenue         DECIMAL(12,2) NOT NULL,   -- gross_revenue - discount
    FOREIGN KEY (date_key)   REFERENCES dim_date(date_key),
    FOREIGN KEY (store_id)   REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- ─────────────────────────────────────────────────────────
-- INSERT: dim_date
-- Raw data had mixed formats (DD/MM/YYYY, DD-MM-YYYY, YYYY-MM-DD)
-- All standardised to YYYY-MM-DD; date_key as YYYYMMDD integer
-- ─────────────────────────────────────────────────────────
INSERT INTO dim_date
    (date_key, full_date, day, month, month_name, quarter, year, day_of_week, is_weekend)
VALUES
    (20230801, '2023-08-01',  1,  8, 'August',    3, 2023, 'Tuesday',  FALSE),
    (20230815, '2023-08-15', 15,  8, 'August',    3, 2023, 'Tuesday',  FALSE),
    (20230902, '2023-09-02',  2,  9, 'September', 3, 2023, 'Saturday', TRUE),
    (20230918, '2023-09-18', 18,  9, 'September', 3, 2023, 'Monday',   FALSE),
    (20231005, '2023-10-05',  5, 10, 'October',   4, 2023, 'Thursday', FALSE),
    (20231020, '2023-10-20', 20, 10, 'October',   4, 2023, 'Friday',   FALSE),
    (20231105, '2023-11-05',  5, 11, 'November',  4, 2023, 'Sunday',   TRUE),
    (20231122, '2023-11-22', 22, 11, 'November',  4, 2023, 'Wednesday',FALSE),
    (20231210, '2023-12-10', 10, 12, 'December',  4, 2023, 'Sunday',   TRUE),
    (20231225, '2023-12-25', 25, 12, 'December',  4, 2023, 'Monday',   FALSE);

-- ─────────────────────────────────────────────────────────
-- INSERT: dim_store
-- NULL store_city values filled using store-to-city mapping
-- ─────────────────────────────────────────────────────────
INSERT INTO dim_store
    (store_id, store_name, store_city, store_state, store_region)
VALUES
    ('S001', 'Mumbai Central',  'Mumbai',    'Maharashtra', 'West'),
    ('S002', 'Delhi North',     'Delhi',     'Delhi',       'North'),
    ('S003', 'Bangalore Tech',  'Bangalore', 'Karnataka',   'South'),
    ('S004', 'Chennai Express', 'Chennai',   'Tamil Nadu',  'South'),
    ('S005', 'Pune Deccan',     'Pune',      'Maharashtra', 'West');

-- ─────────────────────────────────────────────────────────
-- INSERT: dim_product
-- Category casing standardised:
--   "electronics" → "Electronics"
--   "Grocery" / "grocery" → "Groceries"
--   "clothing" → "Clothing"
-- ─────────────────────────────────────────────────────────
INSERT INTO dim_product
    (product_id, product_name, category, sub_category, unit_price)
VALUES
    ('P001', 'Samsung 4K Smart TV 55"',     'Electronics', 'Televisions',    55000.00),
    ('P002', 'Apple iPhone 14 128GB',        'Electronics', 'Smartphones',    72000.00),
    ('P003', 'Boat Rockerz Wireless Earphones', 'Electronics', 'Audio',        2499.00),
    ('P004', "Levi's Men's 511 Slim Jeans",  'Clothing',    'Bottomwear',      3499.00),
    ('P005', 'Arrow Slim Fit Formal Shirt',  'Clothing',    'Topwear',         1299.00),
    ('P006', 'Aashirvaad Whole Wheat Flour 5kg', 'Groceries', 'Staples',        320.00),
    ('P007', 'Amul Gold Full Cream Milk 1L', 'Groceries',   'Dairy',            68.00),
    ('P008', 'Tata Salt 1kg',                'Groceries',   'Staples',          22.00);

-- ─────────────────────────────────────────────────────────
-- INSERT: fact_sales  (10 rows of cleaned, standardised data)
-- gross_revenue = quantity_sold * unit_price
-- net_revenue   = gross_revenue - discount_amount
-- ─────────────────────────────────────────────────────────
INSERT INTO fact_sales
    (date_key, store_id, product_id, quantity_sold, unit_price, discount_amount, gross_revenue, net_revenue)
VALUES
    (20230801, 'S001', 'P001',  2, 55000.00, 5000.00,  110000.00, 105000.00),
    (20230815, 'S002', 'P002',  3, 72000.00, 6000.00,  216000.00, 210000.00),
    (20230902, 'S003', 'P003', 10,  2499.00,  500.00,   24990.00,  24490.00),
    (20230918, 'S001', 'P004',  5,  3499.00,  300.00,   17495.00,  17195.00),
    (20231005, 'S004', 'P005',  8,  1299.00,  200.00,   10392.00,  10192.00),
    (20231020, 'S002', 'P006', 20,   320.00,   50.00,    6400.00,   6350.00),
    (20231105, 'S005', 'P007', 50,    68.00,    0.00,    3400.00,   3400.00),
    (20231122, 'S003', 'P008', 30,    22.00,    0.00,     660.00,    660.00),
    (20231210, 'S004', 'P001',  1, 55000.00, 3000.00,   55000.00,  52000.00),
    (20231225, 'S005', 'P002',  2, 72000.00, 4000.00,  144000.00, 140000.00);