# Modern Data Warehouse & Analytics Project

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-000000?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Data Engineering](https://img.shields.io/badge/Data%20Engineering-0A66C2?style=for-the-badge)
![ETL](https://img.shields.io/badge/ETL-FF6F00?style=for-the-badge)
![Star Schema](https://img.shields.io/badge/Star%20Schema-4CAF50?style=for-the-badge)
![Medallion Architecture](https://img.shields.io/badge/Medallion%20Architecture-Bronze%20%7C%20Silver%20%7C%20Gold-9C27B0?style=for-the-badge)

> Building a scalable data warehouse from fragmented ERP & CRM sources using Medallion Architecture - delivering clean, reliable insights for business decision-making.

This project showcases end-to-end **Data Engineering** and **Analytics** skills by transforming messy operational data into a production-ready analytical platform.

---

## Business Problem

A company operates with two disconnected source systems:

- **ERP System** → Handles sales, products, and inventory  
- **CRM System** → Manages customer and relationship data

This fragmentation created several critical issues:

- No single source of truth for sales and customer data  
- Inconsistent and poor-quality data (duplicates, nulls, mismatched formats)  
- Slow and unreliable reporting  
- Difficulty answering key business questions such as:  
  - Who are our most valuable customers?  
  - Which products drive the highest revenue?  
  - What are the current sales trends?

Stakeholders lacked trusted, timely insights needed for strategic decisions.

---

## Solution Overview

I designed and implemented a **Modern Data Warehouse** using the **Medallion Architecture** (Bronze → Silver → Gold) in SQL Server.

| Layer     | Purpose                                      | Outcome                          |
|-----------|----------------------------------------------|----------------------------------|
| **Bronze**   | Raw data ingestion from ERP & CRM CSV files | Source data preserved as-is     |
| **Silver**   | Data cleansing, standardization & integration | Clean, consistent, unified data |
| **Gold**     | Star Schema modeling for analytics           | Business-ready analytical model |

The final **Gold layer** enables fast, accurate reporting on **Customer Behavior**, **Product Performance**, and **Sales Trends**.

---

## Project Highlights

- Designed a complete **Medallion Architecture** data pipeline  
- Built robust **ETL processes** using T-SQL  
- Resolved data quality issues (duplicates, nulls, inconsistent naming)  
- Created a clean **Star Schema** optimized for analytical queries  
- Developed SQL-based analytics and insights  
- Applied professional **naming conventions** and documentation standards  

---

## Tech Stack

| Category              | Tools / Technologies                  |
|-----------------------|---------------------------------------|
| Database              | Microsoft SQL Server                  |
| Language              | T-SQL                                 |
| Architecture          | Medallion Architecture (Bronze-Silver-Gold) |
| Data Modeling         | Star Schema (Fact & Dimension tables) |
| Data Integration      | ETL Pipelines                         |
| Source Systems        | ERP & CRM (CSV files)                 |
| Documentation         | Markdown, Draw.io                     |

---

## Architecture

![Project Architecture](https://github.com/Tusneld/data_warehouse/blob/ebeb2c6309f1e77e49528dee5c1c07284481c509/Architecture.JPG)

1. **Bronze Layer** - Stores raw data exactly as received from source systems.  
2. **Silver Layer** - Performs data cleansing, standardization, and normalization.  
3. **Gold Layer** - Delivers a business-ready Star Schema for reporting and analytics.

---

## How to Run This Project

### Prerequisites
- Microsoft SQL Server (2019 or later recommended)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Basic understanding of T-SQL

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Tusneld/data_warehouse.git
   cd data_warehouse
```
Create a new database in SQL Server (e.g. DataWarehouse)
Run the scripts in order:
First run all scripts in scripts/bronze/
Then run all scripts in scripts/silver/
Finally run all scripts in scripts/gold/

Validate the results
Check that Bronze tables contain the raw data
Verify Silver tables are cleaned and standardized
Confirm Gold layer contains the Star Schema (dimensions + facts)

Optional: Connect the Gold layer to Power BI or any BI tool for visualization.

---

data-warehouse-project/
│
├── datasets/               # Raw ERP and CRM source files
├── docs/                   # Architecture diagrams, data catalog, naming conventions
├── scripts/
│   ├── bronze/             # Raw data loading scripts
│   ├── silver/             # Data cleaning & transformation scripts
│   └── gold/               # Star Schema and analytical models
├── tests/                  # Data quality and validation tests
├── README.md
└── LICENSE
---

## Key Outcomes

Established a single source of truth for sales and customer data
Significantly improved data quality and reliability
Enabled faster and more accurate business reporting
Created a scalable foundation ready for BI tools (Power BI, Tableau, etc.)

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/tusnelde-endjala-a65302253/)
[![Website](https://img.shields.io/badge/Website-000000?style=for-the-badge&logo=google-chrome&logoColor=white)](https://tusnelde.vercel.app/)
