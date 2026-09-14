# Power BI Data Model Architecture: E-Commerce Margin Optimization

This document outlines the dimensional schema, relationships, and model design for the E-Commerce Power BI dashboard.

---

## 1. Relational Star Schema Model

```mermaid
erDiagram
    Dim_Date ||--o{ Fact_Transactions : "order_date -> Date"
    Dim_Product ||--o{ Fact_Transactions : "sku -> sku"
    Dim_Region ||--o{ Fact_Transactions : "region -> region"
    Dim_Customer ||--o{ Fact_Transactions : "customer_id -> customer_id"

    Fact_Transactions {
        string order_id PK
        date order_date FK
        string customer_id FK
        string sku FK
        string region FK
        int quantity
        decimal gross_revenue
        decimal discount_amount
        decimal net_revenue
        decimal total_cogs
        decimal gross_profit
        decimal actual_shipping_cost
        decimal payment_processing_fee
        decimal net_profit
        int margin_leakage_flag
    }

    Dim_Product {
        string sku PK
        string name
        string cat
        string subcat
        decimal cogs
        decimal list_price
        decimal weight_kg
    }

    Dim_Region {
        string region PK
        string states_covered
        decimal base_freight_cost
    }

    Dim_Date {
        date Date PK
        int Year
        string Month_Name
        string Quarter
    }
```

---

## 2. Table Cardinalities & Cross-Filtering

| Parent Dimension | Child Fact Table | Join Key | Cardinality | Filter Direction |
| :--- | :--- | :--- | :--- | :--- |
| `Dim_Product` | `Fact_Transactions` | `sku` | **1 : Many (1:*)** | Single |
| `Dim_Date` | `Fact_Transactions` | `Date` $\to$ `order_date` | **1 : Many (1:*)** | Single |
| `Dim_Region` | `Fact_Transactions` | `region` | **1 : Many (1:*)** | Single |
