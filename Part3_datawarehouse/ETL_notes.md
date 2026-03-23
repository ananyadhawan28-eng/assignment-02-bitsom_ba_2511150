 ## ETL Decisions
### Decision 1 — Standardizing Date Formats
Problem: Raw data contained dates in three different formats:

DD/MM/YYYY — 105 rows
DD-MM-YYYY — 83 rows
YYYY-MM-DD — 112 rows

Mixed formats cause incorrect sorting and failed comparisons in analytical queries.
Resolution: All dates were converted to YYYY-MM-DD. A date_key in YYYYMMDD format (e.g., 20230829) was created as the primary key for efficient joins between fact_sales and dim_date.

### Decision 2 — Fixing Inconsistent Category Casing
Problem: The category column had multiple representations for the same value:

"Electronics" and "electronics" were treated as distinct
"Grocery" and "Groceries" referred to the same category

This caused incorrect grouping in revenue reports.
Resolution: All values were standardized to title case with consistent naming — "electronics" → "Electronics", "Grocery" → "Groceries" — before loading into dim_product.

### Decision 3 — Filling NULL Store City Values
Problem: 19 rows had a blank store_city field. Since city is used in store-level filtering and grouping, NULL values would produce incomplete query results.
Resolution: Missing city values were backfilled using a store-to-city mapping derived from non-null rows. For example, all rows with store_name = "Mumbai Central" were assigned store_city = "Mumbai".
