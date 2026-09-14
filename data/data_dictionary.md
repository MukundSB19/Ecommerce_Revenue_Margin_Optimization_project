# Data Dictionary: E-Commerce Revenue & Margin Optimization

This document defines the schema, table attributes, and financial metrics for the **E-Commerce Revenue & Margin Optimization** project ($1.46M+ GMV dataset).

---

## 1. Table: `ecommerce_transactions` (15,800 rows)
Fact table capturing order line-item transactions, promotional discounts, fulfillment costs, payment fees, and net profitability.

| Column Name | Data Type | Description & Financial Formulation |
| :--- | :--- | :--- |
| `order_id` | `VARCHAR(20)` | Unique order identifier (e.g., `ORD-000001`). |
| `order_date` | `DATE` | Transaction timestamp (`YYYY-MM-DD`). |
| `customer_id` | `VARCHAR(20)` | Unique customer account ID. |
| `region` | `VARCHAR(20)` | Geographical customer region: `West`, `East`, `Central`, `South`. |
| `state` | `VARCHAR(10)` | Two-letter US state code (e.g., `CA`, `NY`, `TX`, `FL`). |
| `sku` | `VARCHAR(20)` **(FK)** | References `product_catalog.sku`. |
| `product_name` | `VARCHAR(100)` | Title of product. |
| `category` | `VARCHAR(40)` | Department: `Electronics`, `Home & Kitchen`, `Apparel`, `Beauty`. |
| `sub_category` | `VARCHAR(40)` | Granular sub-category (e.g., `Audio`, `Cookware`, `Footwear`, `Skincare`). |
| `quantity` | `INTEGER` | Units purchased in order line (Range: 1–4). |
| `unit_cogs` | `DECIMAL(10,2)` | Cost of Goods Sold per unit from supplier. |
| `unit_list_price` | `DECIMAL(10,2)` | Base MSRP catalog list price. |
| `gross_revenue` | `DECIMAL(10,2)` | `quantity * unit_list_price` (Top-line Gross Merchandise Value). |
| `coupon_code` | `VARCHAR(30)` | Promotional discount code applied: `NONE`, `SAVE10`, `SUMMER15`, `FLASH25`, `CLEARANCE40`. |
| `discount_pct` | `DECIMAL(5,2)` | Percentage discount applied (0.00 to 0.40). |
| `discount_amount` | `DECIMAL(10,2)` | `gross_revenue * discount_pct` (Discount dollar value). |
| `net_revenue` | `DECIMAL(10,2)` | `gross_revenue - discount_amount` (Net sales collected). |
| `shipping_fee_collected` | `DECIMAL(10,2)` | Freight charge paid by customer ($0 if order $\ge$ $50). |
| `actual_shipping_cost` | `DECIMAL(10,2)` | Carrier fulfillment expense based on package weight and distance. |
| `payment_processing_fee`| `DECIMAL(10,2)` | Payment gateway fee (`net_revenue * 2.9% + $0.30`). |
| `total_cogs` | `DECIMAL(10,2)` | `unit_cogs * quantity`. |
| `gross_profit` | `DECIMAL(10,2)` | `net_revenue - total_cogs`. |
| `gross_margin_pct` | `DECIMAL(5,2)` | `(gross_profit / net_revenue) * 100`. |
| `return_status` | `VARCHAR(20)` | `Completed` or `Returned`. |
| `return_reason` | `VARCHAR(100)` | Root cause (e.g., `Size / Fit Issue`, `Defective`, `Changed Mind`). |
| `return_processing_cost`| `DECIMAL(10,2)` | Reverse logistics and restocking costs if returned. |
| `net_profit` | `DECIMAL(10,2)` | True bottom-line profit after COGS, discounts, shipping, gateway fees, and returns. |
| `net_margin_pct` | `DECIMAL(5,2)` | `(net_profit / net_revenue) * 100`. |
| `margin_leakage_flag` | `INTEGER` | Binary flag (1 = loss-making or high-leakage transaction, 0 = standard). |

---

## 2. Table: `product_catalog` (20 SKUs)
Dimension table defining product specifications, cost structures, and weight.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `sku` | `VARCHAR(20)` **(PK)** | Stock Keeping Unit code. |
| `name` | `VARCHAR(100)` | Full product title. |
| `cat` | `VARCHAR(40)` | Parent category. |
| `subcat` | `VARCHAR(40)` | Sub-category. |
| `cogs` | `DECIMAL(10,2)` | Manufacturing / procurement cost per unit. |
| `list_price` | `DECIMAL(10,2)` | Base MSRP price. |
| `weight_kg` | `DECIMAL(5,2)` | Unit package weight in kilograms. |
