-- 1. Daily transaction volume and revenue
CREATE OR REPLACE VIEW analytics.v_daily_revenue AS
SELECT
    d.full_date,
    d.day_of_week,
    d.is_weekend,
    COUNT(f.transaction_key)        AS total_transactions,
    SUM(f.amount)                   AS total_revenue,
    AVG(f.amount)                   AS avg_transaction_value
FROM analytics.fact_transactions f
JOIN analytics.dim_date d ON f.date_key = d.date_key
WHERE f.status = 'success'
GROUP BY d.full_date, d.day_of_week, d.is_weekend
ORDER BY d.full_date;


-- 2. Top merchants by revenue
CREATE OR REPLACE VIEW analytics.v_top_merchants AS
SELECT
    m.name                          AS merchant_name,
    m.category,
    m.country,
    COUNT(f.transaction_key)        AS total_transactions,
    SUM(f.amount)                   AS total_revenue,
    AVG(f.amount)                   AS avg_order_value,
    ROUND(
        100.0 * SUM(f.amount) /
        SUM(SUM(f.amount)) OVER (), 2
    )                               AS revenue_share_pct
FROM analytics.fact_transactions f
JOIN analytics.dim_merchants m ON f.merchant_key = m.merchant_key
WHERE f.status = 'success'
GROUP BY m.name, m.category, m.country
ORDER BY total_revenue DESC;


-- 3. Transaction success vs failure rates
CREATE OR REPLACE VIEW analytics.v_transaction_status AS
SELECT
    status,
    COUNT(*)                        AS total,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (), 2
    )                               AS percentage
FROM analytics.fact_transactions
GROUP BY status
ORDER BY total DESC;


-- 4. Revenue by merchant category
CREATE OR REPLACE VIEW analytics.v_revenue_by_category AS
SELECT
    m.category,
    COUNT(f.transaction_key)        AS total_transactions,
    SUM(f.amount)                   AS total_revenue,
    AVG(f.amount)                   AS avg_transaction_value
FROM analytics.fact_transactions f
JOIN analytics.dim_merchants m ON f.merchant_key = m.merchant_key
WHERE f.status = 'success'
GROUP BY m.category
ORDER BY total_revenue DESC;


-- 5. Monthly revenue trend
CREATE OR REPLACE VIEW analytics.v_monthly_revenue AS
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(f.transaction_key)        AS total_transactions,
    SUM(f.amount)                   AS total_revenue
FROM analytics.fact_transactions f
JOIN analytics.dim_date d ON f.date_key = d.date_key
WHERE f.status = 'success'
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;


-- 6. Most active users by spending
CREATE OR REPLACE VIEW analytics.v_top_users AS
SELECT
    u.full_name,
    u.country,
    COUNT(f.transaction_key)        AS total_transactions,
    SUM(f.amount)                   AS total_spent,
    AVG(f.amount)                   AS avg_transaction_value
FROM analytics.fact_transactions f
JOIN analytics.dim_users u ON f.user_key = u.user_key
WHERE f.status = 'success'
GROUP BY u.full_name, u.country
ORDER BY total_spent DESC
LIMIT 20;