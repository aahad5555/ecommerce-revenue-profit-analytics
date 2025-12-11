# E-Commerce Revenue & Profitability Analytics (Olist)

## Overview

This project analyzes the revenue and profitability of a real e-commerce marketplace dataset (Olist, Brazil) to answer the kind of questions a CEO, Head of Sales, or Head of Operations would ask:

- Where is our **revenue** coming from (products, categories, regions)?
- Which parts of the catalog are truly **profitable** after shipping and fees?
- How do **new vs returning customers** contribute to revenue over time?
- Who are our **top customers and products** (Pareto / 80-20)?
- What are the most impactful actions to **grow profit**, not just revenue?

The project is designed to showcase **professional data analytics skills**:
SQL, data modeling, business metrics, and dashboard storytelling.

---

## Tech Stack

- **Database:** PostgreSQL (via Docker)
- **Analytics:** SQL (PostgreSQL), Python (pandas, SQLAlchemy)
- **BI / Visualization:** Tableau
- **Version control:** Git + GitHub

---

## Data

The analysis uses the **Olist Brazilian E-Commerce Public Dataset** (Kaggle), which includes:

- Orders and order items
- Customers and sellers
- Payments
- Products and categories
- Delivery timestamps

The raw CSV files are stored locally under `data_raw/` (not committed to Git).
Cleaned and transformed outputs for BI are stored in `data_processed/`.

---

## Goals & Key Metrics

### Core Objectives

1. Build a **clean analytics data model** (staging → dimensions → fact tables).
2. Compute and analyze:
   - Revenue and profit over time
   - Revenue and profit by category, product, and region
   - New vs returning customer revenue
   - Pareto distributions (top customers/products)
3. Design a **CEO-friendly dashboard** for monitoring performance.
4. Deliver a concise **Insights & Recommendations report** (PDF).

### Example KPIs

- Total Revenue, Total Gross Profit
- Average Order Value (AOV)
- Revenue & Profit by:
  - Product Category
  - Product
  - Region/State
- Revenue share: New vs Returning customers
- Top 10% customers’ contribution to total revenue (Pareto)

---

## Repository Structure

```text
.
├─ data_raw/         # Original CSV files (not tracked in Git)
├─ data_processed/   # Cleaned/exported data for BI tools
├─ sql/              # DDL, staging, dimension/fact, and analysis queries
├─ notebooks/        # Python notebooks for EDA and validation
├─ docs/             # ERD diagrams, PDF reports, images
├─ dashboards/       # BI project files (PBIX / Tableau) and screenshots
├─ .gitignore
├─ README.md
└─ requirements.txt  # Python dependencies
```
