-- Populate dim_users
INSERT INTO analytics.dim_users (user_id, full_name, email, country, created_at)
SELECT id, full_name, email, country, created_at
FROM staging.users
ON CONFLICT (user_id) DO NOTHING;


-- Populate dim_merchants
INSERT INTO analytics.dim_merchants (merchant_id, name, category, country)
SELECT id, name, category, country
FROM staging.merchants
ON CONFLICT (merchant_id) DO NOTHING;


-- Populate dim_date from actual transaction dates
INSERT INTO analytics.dim_date (
    date_key, full_date, day_of_week, day_of_month,
    month, month_name, quarter, year, is_weekend
)
SELECT DISTINCT
    TO_CHAR(created_at, 'YYYYMMDD')::INTEGER,
    created_at::DATE,
    TO_CHAR(created_at, 'Day'),
    EXTRACT(DAY   FROM created_at)::INTEGER,
    EXTRACT(MONTH FROM created_at)::INTEGER,
    TO_CHAR(created_at, 'Month'),
    EXTRACT(QUARTER FROM created_at)::INTEGER,
    EXTRACT(YEAR    FROM created_at)::INTEGER,
    EXTRACT(DOW     FROM created_at) IN (0, 6)
FROM staging.transactions
ON CONFLICT (date_key) DO NOTHING;


-- Populate fact_transactions
INSERT INTO analytics.fact_transactions (
    transaction_id, user_key, merchant_key, date_key, amount, currency, status
)
SELECT
    t.id,
    u.user_key,
    m.merchant_key,
    TO_CHAR(t.created_at, 'YYYYMMDD')::INTEGER,
    t.amount,
    t.currency,
    t.status
FROM staging.transactions t
JOIN analytics.dim_users     u ON t.user_id     = u.user_id
JOIN analytics.dim_merchants m ON t.merchant_id = m.merchant_id
ON CONFLICT (transaction_id) DO NOTHING;