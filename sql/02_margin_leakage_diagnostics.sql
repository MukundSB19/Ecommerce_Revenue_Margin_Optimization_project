-- =====================================================================
-- Project: E-Commerce Revenue & Margin Optimization Analysis
-- Script: 02_margin_leakage_diagnostics.sql
-- Description: Financial Margin Waterfall, SKU Margin Leakage, Coupon
--              Bleed Diagnostics, and Reverse Logistics Friction Analysis.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Full Executive Margin Waterfall ($ and % of Gross GMV)
-- ---------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units_sold,
    
    -- Topline Gross Merchandise Value
    ROUND(SUM(gross_revenue), 2) AS gross_sales_gmv,
    
    -- Leakage Lever 1: Promotional Discounts
    ROUND(SUM(discount_amount), 2) AS total_discounts_given,
    ROUND((SUM(discount_amount) * 100.0 / SUM(gross_revenue)), 2) AS discount_rate_pct,
    
    -- Net Sales
    ROUND(SUM(net_revenue), 2) AS net_revenue_sales,
    
    -- Leakage Lever 2: Direct Product COGS
    ROUND(SUM(total_cogs), 2) AS total_cost_of_goods,
    ROUND((SUM(total_cogs) * 100.0 / SUM(net_revenue)), 2) AS cogs_pct_of_net_revenue,
    
    -- Gross Profit
    ROUND(SUM(gross_profit), 2) AS gross_profit_dollars,
    ROUND((SUM(gross_profit) * 100.0 / SUM(net_revenue)), 2) AS gross_profit_margin_pct,
    
    -- Leakage Lever 3: Fulfillment & Shipping Deficit
    ROUND(SUM(actual_shipping_cost), 2) AS total_actual_shipping_cost,
    ROUND(SUM(shipping_fee_collected), 2) AS shipping_revenue_collected,
    ROUND(SUM(actual_shipping_cost - shipping_fee_collected), 2) AS net_shipping_deficit,
    
    -- Leakage Lever 4: Merchant Gateway & Return Logistics
    ROUND(SUM(payment_processing_fee), 2) AS total_payment_gateway_fees,
    ROUND(SUM(return_processing_cost), 2) AS total_return_reverse_costs,
    
    -- Bottomline Net Profit
    ROUND(SUM(net_profit), 2) AS net_bottomline_profit,
    ROUND((SUM(net_profit) * 100.0 / SUM(net_revenue)), 2) AS net_profit_margin_pct
FROM ecommerce_transactions;


-- ---------------------------------------------------------------------
-- 2. SKU-Level Margin Leakage Diagnostic (Top Loss-Making & Bleeding SKUs)
-- ---------------------------------------------------------------------
SELECT 
    sku,
    product_name,
    category,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(gross_revenue), 2) AS gross_revenue_gmv,
    ROUND(SUM(discount_amount), 2) AS discount_bleed_dollars,
    ROUND(AVG(discount_pct) * 100, 1) AS avg_discount_applied_pct,
    ROUND(SUM(gross_profit), 2) AS total_gross_profit,
    ROUND(SUM(actual_shipping_cost + return_processing_cost), 2) AS total_logistics_cost,
    ROUND(SUM(net_profit), 2) AS total_net_profit,
    ROUND((SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)), 2) AS net_profit_margin_pct,
    ROUND(SUM(CASE WHEN return_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS return_rate_pct,
    
    -- Profit Contribution Classification
    CASE 
        WHEN SUM(net_profit) < 0 THEN 'SEVERE LEAKAGE: Loss Making'
        WHEN (SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)) < 8.0 THEN 'LOW MARGIN: Margin Bleed'
        WHEN (SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)) < 20.0 THEN 'HEALTHY: Standard Contributor'
        ELSE 'STAR PERFORMER: High Margin'
    END AS sku_profitability_status
FROM ecommerce_transactions
GROUP BY sku, product_name, category
ORDER BY total_net_profit ASC;


-- ---------------------------------------------------------------------
-- 3. Coupon Code Effectiveness & Margin Bleed Analysis
-- ---------------------------------------------------------------------
SELECT 
    coupon_code,
    COUNT(order_id) AS total_orders_used,
    ROUND(SUM(gross_revenue), 2) AS gross_sales_driven,
    ROUND(SUM(discount_amount), 2) AS discount_dollars_given,
    ROUND(AVG(discount_pct) * 100, 1) AS effective_discount_pct,
    ROUND(SUM(net_revenue), 2) AS net_sales_captured,
    ROUND(SUM(net_profit), 2) AS total_net_profit,
    ROUND((SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)), 2) AS net_margin_realized_pct,
    ROUND(SUM(CASE WHEN return_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS return_rate_pct
FROM ecommerce_transactions
GROUP BY coupon_code
ORDER BY effective_discount_pct DESC;


-- ---------------------------------------------------------------------
-- 4. Return Reason Root Cause & Cost of Friction
-- ---------------------------------------------------------------------
SELECT 
    category,
    return_reason,
    COUNT(order_id) AS return_events_count,
    ROUND(SUM(net_revenue), 2) AS gross_returned_merchandise_value,
    ROUND(SUM(return_processing_cost), 2) AS direct_reverse_freight_loss,
    ROUND(AVG(actual_shipping_cost), 2) AS original_freight_sunk_cost
FROM ecommerce_transactions
WHERE return_status = 'Returned'
GROUP BY category, return_reason
ORDER BY category, return_events_count DESC;
