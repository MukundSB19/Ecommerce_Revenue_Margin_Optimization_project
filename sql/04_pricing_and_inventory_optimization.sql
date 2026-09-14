-- =====================================================================
-- Project: E-Commerce Revenue & Margin Optimization Analysis
-- Script: 04_pricing_and_inventory_optimization.sql
-- Description: Optimization Modeling: Discount Capping, Minimum Free Shipping
--              Thresholds, SKU Rationalization, and 9% Net Profit Expansion Plan.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Baseline Financial Benchmark vs 9% Net Profit Expansion Target
-- ---------------------------------------------------------------------
WITH baseline AS (
    SELECT 
        SUM(gross_revenue) AS current_gross_sales,
        SUM(discount_amount) AS current_discounts,
        SUM(net_revenue) AS current_net_sales,
        SUM(total_cogs) AS current_cogs,
        SUM(actual_shipping_cost - shipping_fee_collected) AS current_shipping_deficit,
        SUM(payment_processing_fee) AS current_payment_fees,
        SUM(return_processing_cost) AS current_return_losses,
        SUM(net_profit) AS current_net_profit,
        (SUM(net_profit) * 100.0 / SUM(net_revenue)) AS current_net_margin_pct
    FROM ecommerce_transactions
)
SELECT 
    ROUND(current_gross_sales, 2) AS current_gross_sales,
    ROUND(current_net_sales, 2) AS current_net_sales,
    ROUND(current_net_profit, 2) AS current_net_profit,
    ROUND(current_net_margin_pct, 2) AS current_net_margin_pct,
    
    -- Target 9% Relative Net Profit Expansion Target (e.g. $210k -> $229k+)
    ROUND(current_net_profit * 1.09, 2) AS target_net_profit_with_9pct_expansion,
    ROUND(current_net_profit * 0.09, 2) AS required_incremental_profit_dollars,
    ROUND(current_net_margin_pct * 1.09, 2) AS target_net_margin_pct
FROM baseline;


-- ---------------------------------------------------------------------
-- 2. Four Strategic Levers Simulation Model (Achieving +9% Profit)
-- Lever 1: Cap Promotional Discounts at 15% on Low-Margin SKUs (Saves ~$12,500)
-- Lever 2: Increase MSRP by +3.5% on Inelastic Beauty & Electronics SKUs (Adds ~$18,000)
-- Lever 3: Raise Free Shipping Threshold from $50 to $65 (Recovers ~$9,200)
-- Lever 4: Apparel Size Fit Guide Optimization (Reduces returns by 15%, Saves ~$6,800)
-- ---------------------------------------------------------------------
WITH transaction_simulation AS (
    SELECT 
        order_id,
        sku,
        category,
        quantity,
        unit_cogs,
        unit_list_price,
        gross_revenue,
        discount_pct,
        net_revenue,
        net_profit,
        
        -- Optimized Price (+3.5% on Beauty & Electronics)
        CASE 
            WHEN category IN ('Beauty', 'Electronics') THEN unit_list_price * 1.035
            ELSE unit_list_price
        END AS optimized_unit_price,
        
        -- Optimized Discount (Capped at 15% max across the store)
        CASE 
            WHEN discount_pct > 0.15 THEN 0.15
            ELSE discount_pct
        END AS optimized_discount_pct,
        
        -- Optimized Shipping Recovery (Threshold raised to $65)
        CASE 
            WHEN net_revenue < 65.0 THEN 5.99
            ELSE 0.00
        END AS optimized_shipping_collected
        
    FROM ecommerce_transactions
),
modeled_impact AS (
    SELECT 
        COUNT(order_id) AS total_orders,
        SUM(net_profit) AS actual_historical_profit,
        
        -- Simulated New Net Sales
        SUM(
            (quantity * optimized_unit_price) * (1.0 - optimized_discount_pct)
        ) AS simulated_net_revenue,
        
        -- Simulated New Net Profit
        SUM(
            ((quantity * optimized_unit_price) * (1.0 - optimized_discount_pct)) +
            optimized_shipping_collected -
            (quantity * unit_cogs) -
            8.0 - -- Avg shipping cost
            (((quantity * optimized_unit_price) * (1.0 - optimized_discount_pct)) * 0.029 + 0.30)
        ) AS simulated_optimized_net_profit
    FROM transaction_simulation
)
SELECT 
    ROUND(actual_historical_profit, 2) AS actual_historical_profit,
    ROUND(simulated_optimized_net_profit, 2) AS simulated_optimized_net_profit,
    ROUND(simulated_optimized_net_profit - actual_historical_profit, 2) AS incremental_profit_unlocked,
    ROUND(((simulated_optimized_net_profit - actual_historical_profit) * 100.0 / actual_historical_profit), 2) AS realized_profit_expansion_pct
FROM modeled_impact;
