# Banking Data Quality, Lineage & Analytics Framework

## 📌 What We Did

Built an end-to-end banking data analytics and governance workflow using **Python, SQL and Power BI**.

The project focuses on making banking data **clean, validated, traceable and ready for business reporting**.

### Key Work Performed

* Profiled and cleaned Customer, Account, Transaction and Branch data using Python/Pandas.
* Performed data-quality checks for missing values, duplicates, validity and consistency.
* Validated primary-key and foreign-key relationships using SQL.
* Created **Source-to-Target Mapping** to document data transformations.
* Created **Data Lineage** to track data from source to reporting.
* Created a **Data Dictionary** to document metadata and business definitions.
* Performed SQL-based business analysis.
* Built an interactive **Power BI dashboard** for banking insights and reporting.

---

## 🏗️ Architecture

```text
Banking Source Data
        ↓
Python / Pandas
Profiling & Cleaning
        ↓
Data Quality Controls
        ↓
SQL Validation & Analysis
        ↓
Data Lineage + Metadata
        ↓
Validated Banking Data
        ↓
Power BI Dashboard
        ↓
Business Insights & Recommendations
```

### Architecture Explanation

**1. Source Data**
Customer, Account, Transaction and Branch datasets are used as the banking data sources.

**2. Python / Pandas**
Data is profiled and cleaned by identifying missing values, duplicates and data-quality issues.

**3. Data Quality Controls**
Key controls are applied to check completeness, uniqueness, validity and referential integrity.

**4. SQL**
SQL is used to independently validate relationships and perform business analysis.

**5. Governance Layer**
Source-to-target mapping, data lineage and data dictionary provide traceability and metadata.

**6. Power BI**
Validated data is transformed into interactive dashboards and business reports.

**7. Business Insights**
The final layer converts validated data into actionable business findings.

---

## 📊 Power BI Dashboard

*Dashboard screenshots are provided below.*

> **<img width="1320" height="742" alt="Screenshot 2026-08-22 151614" src="https://github.com/user-attachments/assets/844a8d9e-4d2e-4fff-90ea-1337fa495310" />
**

The dashboard provides visibility into:

* Transaction performance
* Transaction types
* Branch activity
* Customer activity
* Key banking KPIs

---

## 💡 Key Business Insights

* Analyzed approximately **50,000 banking transactions** across customers, accounts and branches.
* Identified transaction patterns across **Deposit, Withdrawal, Transfer and Payment** categories.
* Identified high-value and high-activity branches for potential operational monitoring.
* Analyzed customer transaction activity to identify high-value customers and concentration.
* Used data-quality controls to improve confidence in downstream reporting.
* Established traceability from source data to analytical dashboards through lineage and mapping.

### Business Value

The project demonstrates how **data quality + governance + analytics** can work together to provide more reliable business reporting and support data-driven decision-making.

---
