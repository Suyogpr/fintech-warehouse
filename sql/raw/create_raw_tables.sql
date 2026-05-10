CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.transactions (
    id          TEXT,
    user_id     TEXT,
    merchant_id TEXT,
    amount      TEXT,
    currency    TEXT,
    status      TEXT,
    created_at  TEXT
);

CREATE TABLE IF NOT EXISTS raw.users (
    id          TEXT,
    full_name   TEXT,
    email       TEXT,
    country     TEXT,
    created_at  TEXT
);

CREATE TABLE IF NOT EXISTS raw.merchants (
    id          TEXT,
    name        TEXT,
    category    TEXT,
    country     TEXT,
    created_at  TEXT
);