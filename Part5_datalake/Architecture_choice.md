### Architecture Choice (Food Delivery Startup)
**Recommendation: Data Lakehouse**
A fast-growing food delivery startup collecting GPS data, customer reviews, payment transactions, and restaurant menu images should use a Data Lakehouse architecture.
Why not a Data Warehouse?
Traditional warehouses are built for structured data with fixed schemas. This startup handles text, images, GPS logs, and payment records — formats that don't fit neatly into rigid tables.
Why not a pure Data Lake?
A data lake can store all formats but lacks strong support for querying, governance, and analytics.

### Why a Lakehouse?

Multi-format support: Stores structured (payments), semi-structured (GPS logs), and unstructured (reviews, images) data in one place without enforcing a fixed schema.
Dual workload support: Handles both real-time GPS ingestion (streaming) and batch analytical queries (orders, revenue trends).
Cost-efficient scalability: Uses cloud storage that scales independently of compute — more economical than traditional warehouses as data volume grows.

A Lakehouse is the most practical and future-proof choice for this use case.
