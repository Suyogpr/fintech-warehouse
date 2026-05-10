CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.transactions (
    id          UUID PRIMARY KEY,
    user_id     UUID,
    merchant_id UUID,
    amount      NUMERIC(12,2),
    currency    VARCHAR(3),
    status      VARCHAR(20),
    created_at  TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.users (
    id          UUID PRIMARY KEY,
    full_name   VARCHAR(200),
    email       VARCHAR(200) UNIQUE,
    country     VARCHAR(100),
    created_at  TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.merchants (
    id          UUID PRIMARY KEY,
    name        VARCHAR(200),
    category    VARCHAR(100),
    country     VARCHAR(100),
    created_at  TIMESTAMP
);