-- =====================================================================
-- Project: E-Commerce Revenue & Margin Optimization Analysis
-- Script: 01_schema_and_tables.sql
-- Description: DDL schema setup, relational constraints, and performance
--              indexes for e-commerce transactions and product catalog.
-- =====================================================================

DROP TABLE IF EXISTS ecommerce_transactions;
DROP TABLE IF EXISTS product_catalog;

-- ---------------------------------------------------------------------
-- 1. Dimension Table: Product Catalog
-- ---------------------------------------------------------------------
CREATE TABLE product_catalog (
    sku                          VARCHAR(20) PRIMARY KEY,
    name                         VARCHAR(100) NOT NULL,
    cat                          VARCHAR(40) NOT NULL,
    subcat                       VARCHAR(40) NOT NULL,
    cogs                         DECIMAL(10, 2) NOT NULL,
    list_price                   DECIMAL(10, 2) NOT NULL,
    weight_kg                    DECIMAL(5, 2) NOT NULL
);

-- ---------------------------------------------------------------------
-- 2. Fact Table: E-Commerce Transactions
-- ---------------------------------------------------------------------
CREATE TABLE ecommerce_transactions (
    order_id                     VARCHAR(20) NOT NULL,
    order_date                   DATE NOT NULL,
    customer_id                  VARCHAR(20) NOT NULL,
    region                       VARCHAR(20) NOT NULL,
    state                        VARCHAR(10) NOT NULL,
    sku                          VARCHAR(20) NOT NULL,
    product_name                 VARCHAR(100) NOT NULL,
    category                     VARCHAR(40) NOT NULL,
    sub_category                 VARCHAR(40) NOT NULL,
    quantity                     INTEGER NOT NULL CHECK (quantity > 0),
    unit_cogs                    DECIMAL(10, 2) NOT NULL,
    unit_list_price              DECIMAL(10, 2) NOT NULL,
    gross_revenue                DECIMAL(10, 2) NOT NULL,
    coupon_code                  VARCHAR(30) NOT NULL,
    discount_pct                 DECIMAL(5, 2) NOT NULL,
    discount_amount              DECIMAL(10, 2) NOT NULL,
    net_revenue                  DECIMAL(10, 2) NOT NULL,
    shipping_fee_collected       DECIMAL(10, 2) NOT NULL,
    actual_shipping_cost         DECIMAL(10, 2) NOT NULL,
    payment_processing_fee       DECIMAL(10, 2) NOT NULL,
    total_cogs                   DECIMAL(10, 2) NOT NULL,
    gross_profit                 DECIMAL(10, 2) NOT NULL,
    gross_margin_pct             DECIMAL(5, 2) NOT NULL,
    return_status                VARCHAR(20) NOT NULL,
    return_reason                VARCHAR(100),
    return_processing_cost       DECIMAL(10, 2) NOT NULL,
    net_profit                   DECIMAL(10, 2) NOT NULL,
    net_margin_pct               DECIMAL(5, 2) NOT NULL,
    margin_leakage_flag          INTEGER NOT NULL,
    CONSTRAINT fk_ecom_sku FOREIGN KEY (sku) REFERENCES product_catalog(sku)
);

-- ---------------------------------------------------------------------
-- 3. Indexes for Fast Multi-Dimensional Aggregation
-- ---------------------------------------------------------------------
CREATE INDEX idx_ecom_date ON ecommerce_transactions(order_date);
CREATE INDEX idx_ecom_sku ON ecommerce_transactions(sku);
CREATE INDEX idx_ecom_cat ON ecommerce_transactions(category);
CREATE INDEX idx_ecom_region ON ecommerce_transactions(region);
CREATE INDEX idx_ecom_leakage ON ecommerce_transactions(margin_leakage_flag);
