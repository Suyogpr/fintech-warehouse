import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

conn = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD")
)

with conn.cursor() as cur:
    with open("sql/analytics/transform_analytics.sql", "r") as f:
        sql = f.read()
    cur.execute(sql)

    cur.execute("SELECT COUNT(*) FROM analytics.dim_users")
    print(f"✓ dim_users:         {cur.fetchone()[0]} rows")

    cur.execute("SELECT COUNT(*) FROM analytics.dim_merchants")
    print(f"✓ dim_merchants:     {cur.fetchone()[0]} rows")

    cur.execute("SELECT COUNT(*) FROM analytics.dim_date")
    print(f"✓ dim_date:          {cur.fetchone()[0]} rows")

    cur.execute("SELECT COUNT(*) FROM analytics.fact_transactions")
    print(f"✓ fact_transactions: {cur.fetchone()[0]} rows")

conn.commit()
conn.close()
print("\nAnalytics layer ready!")