# Excel Margin Waterfall Model & Scenario Guide: E-Commerce Optimization

This guide explains how to construct an interactive financial margin model and scenario calculator in Microsoft Excel using native formulas (`SUMIFS`, `XLOOKUP`, `LET`, and dynamic arrays).

---

## 1. Excel Workbook Architecture

1. **`Transactions_Data`**: Connected to `ecommerce_transactions_15k.csv` via Power Query.
2. **`Product_Catalog`**: Connected to `product_catalog.csv`.
3. **`Margin_Waterfall_Engine`**: Automated formulas computing the Gross-to-Net revenue waterfall.
4. **`SKU_Diagnostics`**: Dynamic lookup table ranking SKUs by Margin Leakage and Net Profit.
5. **`Scenario_Manager`**: What-If model evaluating price hikes, discount caps, and 9% net profit expansion.

---

## 2. Advanced Excel Formulas Catalog

### A. Executive Margin Waterfall Formulas

- **Total Gross GMV ($)**:
  ```excel
  =SUM(Transactions_Data[gross_revenue])
  ```

- **Promotional Discounts ($)**:
  ```excel
  =SUM(Transactions_Data[discount_amount])
  ```

- **Net Revenue Collected ($)**:
  ```excel
  =SUM(Transactions_Data[net_revenue])
  ```

- **Total Product COGS ($)**:
  ```excel
  =SUM(Transactions_Data[total_cogs])
  ```

- **Gross Profit ($)**:
  ```excel
  =Net_Revenue - Total_COGS
  ```

- **Net Freight Deficit ($)**:
  ```excel
  =SUM(Transactions_Data[actual_shipping_cost]) - SUM(Transactions_Data[shipping_fee_collected])
  ```

- **Merchant & Payment Fees ($)**:
  ```excel
  =SUM(Transactions_Data[payment_processing_fee])
  ```

- **Reverse Logistics Cost ($)**:
  ```excel
  =SUM(Transactions_Data[return_processing_cost])
  ```

- **Bottom-Line Net Profit ($)**:
  ```excel
  =Gross_Profit - Net_Freight_Deficit - Merchant_Fees - Reverse_Logistics
  ```

- **Net Profit Margin %**:
  ```excel
  =Net_Profit / Net_Revenue
  ```

---

## 3. Dynamic SKU Diagnostics with Dynamic Arrays

Using Excel's `FILTER` and `SORT` dynamic array functions:

```excel
=SORT(
    FILTER(
        CHOOSECOLS(Transactions_Data, 6, 7, 8, 17, 27, 28, 29), 
        Transactions_Data[margin_leakage_flag] = 1
    ), 
    5, 
    1
)
```
*Extracts all loss-making/leakage SKUs and sorts them in ascending order of Net Profit to immediately highlight the biggest profit drains.*

---

## 4. 9% Net Profit Scenario Formula

In the `Scenario_Manager` tab:
- Cell `B2`: Historical Base Net Profit (`$214,000`)
- Cell `B3`: Target Profit Expansion (`9.0%`)
- Cell `B4`: Target Net Profit: `=B2 * (1 + B3)` (`$233,260`)
- Cell `B5`: Required Profit Uplift: `=B4 - B2` (`+$19,260`)
