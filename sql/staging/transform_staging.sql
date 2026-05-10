-- Clean and load staging.users

INSERT INTO staging.users(id, full_name, email, country, created_at)
SELECT 
    id::UUID,
    INITCAP(TRIM(full_name)),
    LOWER(TRIM(email)),
    INITCAP(TRIM(country)),
    created_at::TIMESTAMP
FROM raw.users
WHERE id IS NOT NULL
    AND email IS NOT NULL
ON CONFLICT (id) DO NOTHING;

-- CLEAN AND LAOD staging.merchants

INSERT INTO staging.merchants(id,name,category,country,created_at)
SELECT
    id::UUID,
    INITCAP(TRIM(name)),
    INITCAP(TRIM(category)),
    INITCAP(TRIM(country)),
    created_at::TIMESTAMP
FROM raw.merchants
WHERE ID IS NOT NULL
ON CONFLICT (id) DO NOTHING;

-- Clean and load staging.transactions
-- This is where most of the dirty data gets removed

INSERT INTO staging.transactions(id,user_id,merchant_id,amount,currency,status,created_at)
SELECT 
    id::UUID,
    user_id::UUID,
    merchant_id::UUID,
    amount::NUMERIC(12,2),
    UPPER(TRIM(currency)),
    LOWER(TRIM("status")),
    created_at::TIMESTAMP
FROM raw.transactions
WHERE id IS NOT NULL
  AND user_id IS NOT NULL
  AND merchant_id IS NOT NULL
  AND amount IS NOT NULL
  AND amount != 'N/A'                   -- remove bad strings
  AND amount::NUMERIC > 0               -- remove negative amounts
ON CONFLICT (id) DO NOTHING;