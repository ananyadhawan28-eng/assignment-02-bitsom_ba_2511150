## Anomaly Analysis
### Update Anomaly
**Affected columns**: sales_rep_id, sales_rep_name, sales_rep_email, office_address
Sales representative data is repeated across every order row. SR01 alone appears in over 80 rows. When the office address was partially updated, some rows retained the old value while others were changed, resulting in inconsistent data. Since the same value is duplicated across hundreds of rows, a single missed update breaks data integrity.
### Delete Anomaly
**Affected columns**: product_id, product_name, category, unit_price
Product P008 (Webcam, Electronics, ₹2100) is referenced in only one order (ORD1185). If that order is deleted — due to cancellation or archiving — all information about this product is permanently lost, since no separate products table exists.
### Insert Anomaly
**Affected columns**: sales_rep_id, sales_rep_name, sales_rep_email, office_address
The dataset currently holds three reps: SR01 (Deepak Joshi), SR02 (Anita Desai), and SR03 (Ravi Kumar). Adding a new rep like SR04 (Priya Kapoor) is impossible without creating a fake order row, because all rep data is tied to order records rather than a dedicated table.

## Why Normalization Is Necessary
A flat table may appear simpler, but it introduces serious reliability problems at scale. The issues above — inconsistent addresses, product data lost on deletion, and inability to insert new entities independently — all stem from storing unrelated concerns in a single table.
Normalization resolves this by splitting data into focused, related tables. While it requires joins in queries, it eliminates redundancy, prevents data loss, and keeps records consistent. This is not over-engineering — it is a foundational requirement for any reliable, scalable system.
