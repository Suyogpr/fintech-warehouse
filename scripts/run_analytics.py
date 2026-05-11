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

def run_query(cursor, title, query, limit=5):
    print(f"\n{'='*55}")
    print(f"  {title}")
    print(f"{'='*55}")
    cursor.execute(query)
    rows = cursor.fetchall()
    cols = [desc[0] for desc in cursor.description]
    print("  " + " | ".join(f"{c:<20}" for c in cols))
    print("  " + "-"*50)
    for row in rows[:limit]:
        print("  " + " | ".join(f"{str(v):<20}" for v in row))

with conn.cursor() as cur:

    # Create all views first
    with open("sql/views/analytics_views.sql", "r") as f:
        cur.execute(f.read())
    conn.commit()
    print("Views created successfully.")

    run_query(cur, "Daily Revenue (last 5 days)",
        "SELECT full_date, total_transactions, total_revenue FROM analytics.v_daily_revenue ORDER BY full_date DESC LIMIT 5")

    run_query(cur, "Top 5 Merchants by Revenue",
        "SELECT merchant_name, category, total_revenue, revenue_share_pct FROM analytics.v_top_merchants LIMIT 5")

    run_query(cur, "Transaction Status Breakdown",
        "SELECT status, total, percentage FROM analytics.v_transaction_status")

    run_query(cur, "Revenue by Category",
        "SELECT category, total_transactions, total_revenue FROM analytics.v_revenue_by_category")

    run_query(cur, "Monthly Revenue Trend",
        "SELECT year, month_name, total_transactions, total_revenue FROM analytics.v_monthly_revenue")

    run_query(cur, "Top 5 Spenders",
        "SELECT full_name, country, total_transactions, total_spent FROM analytics.v_top_users LIMIT 5")

conn.close()