import psycopg2
import csv
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

def load_csv(cursor, filepath, table):
    with open(filepath, "r") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        print(f"  No data in {filepath}")
        return

    columns     = rows[0].keys()
    col_str     = ", ".join(columns)
    placeholder = ", ".join(["%s"] * len(columns))

    query = f"INSERT INTO {table} ({col_str}) VALUES ({placeholder})"

    for row in rows:
        values = [None if v == "" or v == "None" else v for v in row.values()]
        cursor.execute(query, values)

    print(f"✓ Loaded {len(rows)} rows into {table}")

with conn.cursor() as cur:
    # Clear existing raw data before reload
    cur.execute("TRUNCATE raw.users, raw.merchants, raw.transactions")

    load_csv(cur, "data/raw/users.csv",        "raw.users")
    load_csv(cur, "data/raw/merchants.csv",     "raw.merchants")
    load_csv(cur, "data/raw/transactions.csv",  "raw.transactions")

conn.commit()
conn.close()
print("\nRaw layer loaded successfully!")