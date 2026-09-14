-- =====================================================================
-- Project: E-Commerce Revenue & Margin Optimization Analysis
-- Script: 03_regional_and_customer_behavior.sql
-- Description: Regional Unit Economics, Freight Deficits, Customer RFM
--              Segmentation, and Repeat Buyer Profitability.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Regional Profitability & Shipping Deficit Heatmap
-- ---------------------------------------------------------------------
SELECT 
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(gross_revenue), 2) AS regional_gross_sales,
    ROUND(SUM(net_revenue), 2) AS regional_net_sales,
    ROUND(SUM(gross_profit), 2) AS gross_profit,
    ROUND(SUM(shipping_fee_collected), 2) AS freight_collected,
    ROUND(SUM(actual_shipping_cost), 2) AS actual_freight_incurred,
    
    -- Freight Net Deficit ($)
    ROUND(SUM(shipping_fee_collected - actual_shipping_cost), 2) AS freight_margin_net,
    
    ROUND(SUM(net_profit), 2) AS bottomline_net_profit,
    ROUND((SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)), 2) AS net_margin_pct,
    ROUND(SUM(CASE WHEN return_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS return_rate_pct
FROM ecommerce_transactions
GROUP BY region
ORDER BY bottomline_net_profit DESC;


-- ---------------------------------------------------------------------
-- 2. State-Level Margin Leakage Top/Bottom Ranks
-- ---------------------------------------------------------------------
WITH state_summary AS (
    SELECT 
        region,
        state,
        COUNT(order_id) AS order_volume,
        ROUND(SUM(net_revenue), 2) AS net_revenue,
        ROUND(SUM(net_profit), 2) AS net_profit,
        ROUND((SUM(net_profit) * 100.0 / NULLIF(SUM(net_revenue), 0)), 2) AS net_margin_pct,
        ROUND(SUM(CASE WHEN return_status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS return_rate_pct
    FROM ecommerce_transactions
    GROUP BY region, state
)
SELECT 
    region,
    state,
    order_volume,
    net_revenue,
    net_profit,
    net_margin_pct,
    return_rate_pct,
    DENSE_RANK() OVER (ORDER BY net_profit DESC) AS profit_rank_highest,
    DENSE_RANK() OVER (ORDER BY net_margin_pct ASC) AS margin_rank_lowest
FROM state_summary
ORDER BY net_profit DESC;


-- ---------------------------------------------------------------------
-- 3. Customer RFM & Value Tier Segmentation
-- ---------------------------------------------------------------------
WITH customer_aggregates AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS order_frequency,
        ROUND(SUM(net_revenue), 2) AS monetary_net_spend,
        ROUND(SUM(net_profit), 2) AS customer_cumulative_profit,
        ROUND(AVG(net_revenue), 2) AS average_order_value_aov,
        MAX(order_date) AS last_purchase_date
    FROM ecommerce_transactions
    GROUP BY customer_id
),
rfm_segmented AS (
    SELECT 
        customer_id,
        order_frequency,
        monetary_net_spend,
        customer_cumulative_profit,
        average_order_value_aov,
        CASE 
            WHEN order_frequency >= 4 AND monetary_net_spend >= 350 THEN '1. VIP Loyal High Spender'
            WHEN order_frequency >= 2 AND customer_cumulative_profit > 50 THEN '2. Repeat Profitable Buyer'
            WHEN order_frequency = 1 AND customer_cumulative_profit > 20 THEN '3. Standard One-Time Buyer'
            ELSE '4. Discount-Seeker / Low Value'
        END AS customer_segment
    FROM customer_aggregates
)
SELECT 
    customer_segment,
    COUNT(customer_id) AS customer_count,
    ROUND(SUM(monetary_net_spend), 2) AS total_segment_net_sales,
    ROUND(SUM(customer_cumulative_profit), 2) AS total_segment_net_profit,
    ROUND(AVG(average_order_value_aov), 2) AS segment_avg_aov,
    ROUND((SUM(customer_cumulative_profit) * 100.0 / NULLIF(SUM(monetary_net_spend), 0)), 2) AS segment_net_profit_margin_pct
FROM rfm_segmented
GROUP BY customer_segment
ORDER BY total_segment_net_profit DESC;
