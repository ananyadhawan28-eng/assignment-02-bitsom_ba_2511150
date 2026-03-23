### RDBMS vs NoSQL (Healthcare System)
**Recommendation: MySQL (Primary) + MongoDB (Fraud Detection)**
Core Patient Management → MySQL
Patient data involves well-defined relationships between entities like patients, doctors, appointments, prescriptions, and billing. A relational database maps naturally onto this structure.
More importantly, healthcare systems demand strict data accuracy. MySQL follows ACID properties, ensuring every transaction completes fully or not at all. If a system failure occurs mid-write, no partial or corrupted data is stored.
MongoDB, by contrast, follows BASE principles, which permit temporary inconsistencies. While this improves availability and scalability, it is unsuitable for clinical data where accuracy is non-negotiable.
Per the CAP theorem, MySQL prioritizes Consistency over Availability — the right trade-off for a system where doctors and staff must always see accurate, current information.

Fraud Detection Module → MongoDB
Fraud detection involves large volumes of dynamic, semi-structured data — login patterns, behavioral signals, transaction logs — that don't map well to a fixed schema. MongoDB's flexible document model and horizontal scalability make it a better fit here.
