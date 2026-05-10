CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.dim_users (
    user_key    SERIAL PRIMARY KEY,
    user_id     UUID UNIQUE,
    full_name   VARCHAR(200),
    email       VARCHAR(200),
    country     VARCHAR(100),
    created_at  TIMESTAMP
);

CREATE TABLE IF NOT EXISTS analytics.dim_merchants (
    merchant_key SERIAL PRIMARY KEY,
    merchant_id  UUID UNIQUE,
    name         VARCHAR(200),
    category     VARCHAR(100),
    country      VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS analytics.dim_date (
    date_key     INTEGER PRIMARY KEY,
    full_date    DATE,
    day_of_week  VARCHAR(10),
    day_of_month INTEGER,
    month        INTEGER,
    month_name   VARCHAR(10),
    quarter      INTEGER,
    year         INTEGER,
    is_weekend   BOOLEAN
);

CREATE TABLE IF NOT EXISTS analytics.fact_transactions (
    transaction_key SERIAL PRIMARY KEY,
    transaction_id  UUID UNIQUE,
    user_key        INTEGER REFERENCES analytics.dim_users(user_key),
    merchant_key    INTEGER REFERENCES analytics.dim_merchants(merchant_key),
    date_key        INTEGER REFERENCES analytics.dim_date(date_key),
    amount          NUMERIC(12,2),
    currency        VARCHAR(3),
    status          VARCHAR(20)
);