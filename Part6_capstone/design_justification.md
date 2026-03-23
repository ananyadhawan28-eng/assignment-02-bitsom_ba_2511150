# Part 6 — Capstone Design Justification

---

## Storage Systems

The architecture uses four storage systems, each chosen based on the specific nature of its workload.

**Data Warehouse (Snowflake / BigQuery)** is used for Goals 1 and 3. It is purpose-built for analytical workloads and can process large volumes of historical patient data efficiently. For Goal 1, the warehouse provides cleaned and structured treatment history that is used to train the readmission risk prediction model. For Goal 3, it serves as the source for monthly management reports covering bed occupancy and department-wise costs. Since these are read-heavy, aggregation-based queries over historical data, a columnar data warehouse is the most suitable choice.

**PostgreSQL** is used as the OLTP database for Goal 2. It stores structured patient records including diagnoses, appointments, and prescriptions. When a doctor submits a plain-English question, it is converted into SQL by an NLP engine and executed against PostgreSQL to return accurate, real-time results. Its support for ACID transactions ensures that patient records remain consistent and reliable at all times.

**Vector Database (Pinecone / pgvector)** is also used for Goal 2 to handle unstructured data such as clinical notes and discharge summaries. These documents are converted into vector embeddings and stored for semantic search. This allows the system to retrieve contextually relevant results even when the doctor's query does not use the exact words present in the records.

**Time-Series Database (InfluxDB / TimescaleDB)** is used for Goal 4 to ingest and store real-time vitals from ICU devices such as heart rate, blood pressure, SpO₂, and temperature. This database is optimised for high-frequency writes and supports efficient time-based queries, making it well suited for continuous monitoring and threshold-based alerting.

---

## OLTP vs OLAP Boundary

In this design, **PostgreSQL acts as the OLTP system**. It handles live, transactional operations such as updating patient records, processing new admissions, and responding to real-time doctor queries. These operations require low latency, strict consistency, and row-level access — all of which PostgreSQL supports well.

The **Data Warehouse serves as the OLAP system**, where large-scale analytical queries are executed over historical data. A nightly batch ETL pipeline extracts, cleans, and loads data from PostgreSQL and other operational sources into the warehouse. This clear separation ensures that heavy analytical workloads — such as training ML models or generating reports — do not compete with or slow down the transactional system.

The ETL pipeline acts as the controlled boundary between OLTP and OLAP, maintaining data freshness on a scheduled basis while keeping the two layers independent.

---

## Trade-offs

The most significant trade-off in this design is **data freshness versus system simplicity**. Because data is transferred to the warehouse through a nightly batch process, there can be a delay of up to 24 hours before updated records are available for model training or report generation. This lag could reduce the accuracy of readmission predictions if a patient's condition changed recently but that change has not yet reached the warehouse.

To mitigate this, two approaches can be introduced incrementally. First, **Change Data Capture (CDC)** can be applied to PostgreSQL so that any record update is immediately streamed to the warehouse rather than waiting for the nightly batch. Second, **micro-batch processing** using tools like Apache Spark Structured Streaming can reduce the load interval from 24 hours to a few minutes. Both methods improve data freshness without requiring a complete redesign of the existing architecture, allowing the system to evolve without significantly increasing operational complexity.
