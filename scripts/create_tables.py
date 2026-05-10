import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

conn = psycopg2.connect(
    host = os.getenv("DB_HOST"),
    port = os.getenv("DB_PORT"),
    dbname = os.getenv("DB_NAME"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD")
)

sql_files = [
     "sql/raw/create_raw_tables.sql",
    "sql/staging/create_staging_tables.sql",
    "sql/analytics/create_analytics_tables.sql",
]

with conn.cursor() as cur:
    for filepath in sql_files:
        with open(filepath,"r") as f:
            sql = f.read()
        cur.execute(sql)
        print(f"{filepath}")

conn.commit()
conn.close()
print("\nAll Tables Created!!!")