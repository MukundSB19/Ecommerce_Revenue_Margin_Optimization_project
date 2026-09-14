# E-Commerce Revenue & Margin Optimization Analysis

[![Tech: SQL](https://img.shields.io/badge/SQL-Advanced%20Analytics-blue.svg)](#)
[![Tech: Power BI](https://img.shields.io/badge/Power%20BI-DAX%20Modeling-yellow.svg)](#)
[![Tech: Advanced Excel](https://img.shields.io/badge/Excel-Financial%20Modeling-green.svg)](#)

An end-to-end commercial analytics and pricing optimization project analyzing **$1.46M+ in transaction volume** across 15,800+ line items to identify SKU-level margin leakage, coupon bleed, and regional logistics friction, delivering a multi-lever strategy targeting a **9% increase in net profitability**.

---

## 📌 Project Highlights & Core Business Impact
- **Margin Waterfall Diagnostics**: Dissected gross sales across 4 leakage stages (Promotions $\to$ COGS $\to$ Logistics/Shipping Deficit $\to$ Return Reverse Freight) to trace bottom-line net profit ($214,000 / 16.2% margin).
- **SKU Margin Leakage**: Identified loss-making SKUs driven by runaway 40% discount coupons and heavy shipping weights.
- **Regional & Logistics Economics**: Analyzed shipping deficits across geographical zones and reverse logistics friction in high-return categories (Apparel: 18.4% return rate).
- **9% Net Profit Expansion Roadmap**: Formulated a 4-lever pricing, discount-capping, shipping threshold, and fit-optimization strategy unlocking **+$19,260 to +$24,200 in incremental net profit**.

---

## 📂 Repository Structure

```text
├── data/
│   ├── ecommerce_transactions_15k.csv  # 15,800 rows transaction dataset ($1.46M+ GMV)
│   ├── product_catalog.csv             # 20 Master SKUs with COGS, MSRP, and package weights
│   └── data_dictionary.md              # Complete schema definitions and financial formulas
├── sql/
│   ├── 01_schema_and_tables.sql        # Database schema, table constraints, and indexes
│   ├── 02_margin_leakage_diagnostics.sql # Full margin waterfall, SKU leakage, and coupon bleed
│   ├── 03_regional_and_customer_behavior.sql # Regional freight deficits, RFM customer tiers
│   └── 04_pricing_and_inventory_optimization.sql # Price elasticity & 9% net profit expansion model
├── powerbi/
│   ├── dax_measures_catalog.dax        # Production DAX measures (Waterfall, Leakage, What-Ifs)
│   ├── data_model_architecture.md      # Star schema dimensional modeling guide
│   └── powerbi_dashboard_blueprint.md  # 4-page Power BI visual specifications & wireframes
├── excel/
│   └── margin_waterfall_template_guide.md # Dynamic Excel financial model & scenario manager
├── reports/
│   └── margin_optimization_strategy.md  # Executive presentation & strategic recommendations
└── README.md                           # Main repository documentation
```

---

## 🛠️ How to Use This Project

### 1. SQL Database Setup & Execution
1. Run `sql/01_schema_and_tables.sql` in PostgreSQL, MySQL, SQL Server, SQLite, Snowflake, or BigQuery.
2. Import `data/ecommerce_transactions_15k.csv` and `data/product_catalog.csv`.
3. Execute `sql/02_margin_leakage_diagnostics.sql` for margin waterfall and SKU diagnostics.
4. Execute `sql/03_regional_and_customer_behavior.sql` for regional economics and RFM clusters.
5. Execute `sql/04_pricing_and_inventory_optimization.sql` to view the 9% net profit expansion simulation.

### 2. Power BI Dashboard Setup
1. Open Power BI Desktop $\to$ Get Data $\to$ Select `data/ecommerce_transactions_15k.csv` and `data/product_catalog.csv`.
2. Follow the dimensional star schema in `powerbi/data_model_architecture.md`.
3. Create a measure table and paste the DAX measures from `powerbi/dax_measures_catalog.dax`.
4. Build the 4 report pages according to `powerbi/powerbi_dashboard_blueprint.md`.

### 3. Excel Financial Waterfall Model
1. Open Microsoft Excel $\to$ Data $\to$ Get Data from CSV.
2. Build the formulas and dynamic array lookups described in `excel/margin_waterfall_template_guide.md`.
