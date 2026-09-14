# Power BI Dashboard Blueprint: E-Commerce Margin Optimization

This document specifies the exact visual elements, charts, KPI cards, and interactive slicers for the **4 pages** of the E-Commerce Power BI Report.

---

## Page 1: Executive Revenue & Margin Performance

### 1. Top KPI Summary Cards (Header Row)
- **Card 1: Gross Sales (GMV)**: `[Gross Revenue ($)]` (Formatted: `$1.47M`)
- **Card 2: Net Sales Revenue**: `[Net Revenue ($)]` (Formatted: `$1.32M`)
- **Card 3: Gross Margin %**: `[Gross Margin %]` (Formatted: `52.4%`)
- **Card 4: Bottomline Net Profit**: `[Net Profit ($)]` (Formatted: `$214K`)
- **Card 5: Net Profit Margin %**: `[Net Profit Margin %]` (Formatted: `16.2%`)
- **Card 6: Overall Return Rate**: `[Return Rate %]` (Formatted: `9.4%`)

### 2. Main Visuals
- **Visual 1 (Waterfall Chart - Center Left)**: *Financial Margin Waterfall*
  - Breakdown: `Gross Sales ($)` $\to$ `Discounts (-$150K)` $\to$ `Net Sales` $\to$ `COGS (-$630K)` $\to$ `Gross Profit` $\to$ `Freight & Gateway (-$290K)` $\to$ `Reverse Logistics (-$35K)` $\to$ **`Net Profit ($214K)`**.
- **Visual 2 (Line & Clustered Column Chart - Center Right)**: *Monthly Revenue & Net Margin Trajectory*
  - X-Axis: `Dim_Date[Month]`
  - Column Y-Axis: `[Net Revenue ($)]`
  - Line Y-Axis: `[Net Profit Margin %]`
- **Visual 3 (Donut Chart - Bottom Left)**: *Net Revenue by Product Category*
  - Legend: `category`
  - Values: `[Net Revenue ($)]`
- **Visual 4 (Bar Chart - Bottom Right)**: *Net Profit Contribution by Category*
  - Y-Axis: `category`
  - X-Axis: `[Net Profit ($)]`

---

## Page 2: Product & SKU Margin Leakage Deep-Dive

### 1. Visuals & Layout
- **Visual 1 (Scatter Plot / Quadrant - Top Half)**: *Gross Sales vs Net Profit Margin % by SKU*
  - X-Axis: `[Net Revenue ($)]`
  - Y-Axis: `[Net Profit Margin %]`
  - Quadrants: High Volume / High Margin (Stars), High Volume / Low Margin (Leakage Culprits), Low Volume / High Margin (Niche), Low Volume / Low Margin (Discontinue).
- **Visual 2 (Matrix Table - Bottom Left)**: *SKU Margin Diagnostic Table*
  - Columns: SKU, Product Name, Category, Units Sold, Discount Rate %, Gross Margin %, Return %, Net Profit ($), Margin Leakage Flag.
- **Visual 3 (Bar Chart - Bottom Right)**: *Coupon Code Bleed Comparison*
  - Y-Axis: `coupon_code` (`CLEARANCE40`, `FLASH25`, `SUMMER15`, etc.)
  - X-Axis: `[Total Discounts ($)]` vs `[Net Profit ($)]`

---

## Page 3: Regional Logistics & Return Economics

### 1. Visuals & Layout
- **Visual 1 (Map Visual / Filled Map - Left Half)**: *Regional Profitability & Shipping Deficit Heatmap*
  - Location: `state`
  - Bubble Color: `[Net Profit Margin %]`
  - Tooltip: `[Net Shipping Deficit ($)]`, `[Return Rate %]`
- **Visual 2 (Clustered Column Chart - Top Right)**: *Freight Collected vs Actual Freight Cost by Region*
  - X-Axis: `region`
  - Columns: `[Shipping Revenue Collected ($)]` vs `[Total Actual Freight Cost ($)]`
- **Visual 3 (Donut / Treemap - Bottom Right)**: *Return Reasons Breakdown & Direct Reverse Losses*
  - Categories: `Size / Fit Issue`, `Defective / Damaged`, `Changed Mind`, `Late Delivery`
  - Values: `[Reverse Logistics Cost ($)]`

---

## Page 4: Pricing, Assortment & Profitability Simulator (9% Net Profit Plan)

### 1. Interactive What-If Controls
- **Slider 1**: *Target Price Adjustment on Inelastic SKUs (%)* (0% to 10%)
- **Slider 2**: *Maximum Discount Cap (%)* (5% to 25%)
- **Slider 3**: *Free Shipping Minimum Threshold ($)* ($40 to $80)

### 2. Strategic Impact Cards & Bridge
- **Card 1**: Historical Net Profit: `$214,000`
- **Card 2**: **Optimized Net Profit (Target +9%): `$233,260`**
- **Card 3**: Incremental Profit Unlocked: **`+$19,260`**
- **Bridge Visual**: *Profit Expansion Waterfall*
  - Base Profit $\to$ Price Hikes (+$12.1k) $\to$ Discount Capping (+$5.8k) $\to$ Shipping Threshold (+$4.2k) $\to$ Return Optimization (+$2.1k) $\to$ **New Run-Rate**.
