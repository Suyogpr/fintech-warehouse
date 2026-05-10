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
    with open("sql/staging/transform_staging.sql","r") as f:
        sql = f.read()
    cur.execute(sql)

    # Show how many rows made it through cleaning
    cur.execute("SELECT COUNT(*) FROM staging.users")
    print(f"✓ staging.users:        {cur.fetchone()[0]} rows")

    cur.execute("SELECT COUNT(*) FROM staging.merchants")
    print(f"✓ staging.merchants:    {cur.fetchone()[0]} rows")

    cur.execute("SELECT COUNT(*) FROM staging.transactions")
    print(f"✓ staging.transactions: {cur.fetchone()[0]} rows")

    print("\nDirty rows removed:")
    cur.execute("SELECT COUNT(*) FROM raw.transactions")
    raw_count = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM staging.transactions")
    clean_count = cur.fetchone()[0]
    print(f"  raw: {raw_count} → staging: {clean_count} ({raw_count - clean_count} rows dropped)")

conn.commit()
conn.close()