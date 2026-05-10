from faker import Faker
import csv
import random
import uuid
import os

fake = Faker()

NUM_USERS = 500
NUM_MERCHANTS = 50
NUM_TRANSACTIONS = 5000

CURRENCIES = ["USD", "EUR", "GBP", "NPR", "AUD"]
STATUSES   = ["success", "success", "success", "failed", "pending"]
CATEGORIES = ["Food & Drink", "Electronics", "Travel", "Healthcare", "Retail", "Entertainment"]

os.makedirs("data/raw", exist_ok=True)

#__GENERATE USERS__

users=[]
for _ in range (NUM_USERS):
    users.append({
        "id":   str(uuid.uuid4()),
        "full_name": fake.name(),
        "email": fake.unique.email(),
        "country": fake.country(),
        "created_at": fake.date_time_between(start_date="-2y", end_date="now")
    })

with open("data/raw/users.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=users[0].keys())
    writer.writeheader()
    writer.writerows(users)
print(f"✓ Generated {NUM_USERS} users")

#__GENERATE MERCHANTS__

merchants = []
for _ in range(NUM_MERCHANTS):
    merchants.append({
        "id":         str(uuid.uuid4()),
        "name":       fake.company(),
        "category":   random.choice(CATEGORIES),
        "country":    fake.country(),
        "created_at": fake.date_time_between(start_date="-2y", end_date="now")
    })

with open("data/raw/merchants.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=merchants[0].keys())
    writer.writeheader()
    writer.writerows(merchants)
print(f"✓ Generated {NUM_MERCHANTS} merchants")

#__GENERATE TRANSACTIONS__

transactions = []
for _ in range(NUM_TRANSACTIONS):
    # Intentionally introduce some dirty data
    amount = random.choice([
        round(random.uniform(1, 5000), 2),
        round(random.uniform(1, 5000), 2),
        round(random.uniform(1, 5000), 2),
        None,           # missing value
        "N/A",          # bad string
        -round(random.uniform(1, 100), 2)  # negative amount
    ])
    transactions.append({
        "id":          str(uuid.uuid4()),
        "user_id":     random.choice(users)["id"],
        "merchant_id": random.choice(merchants)["id"],
        "amount":      amount,
        "currency":    random.choice(CURRENCIES),
        "status":      random.choice(STATUSES),
        "created_at":  fake.date_time_between(start_date="-1y", end_date="now")
    })

with open("data/raw/transactions.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=transactions[0].keys())
    writer.writeheader()
    writer.writerows(transactions)
print(f"✓ Generated {NUM_TRANSACTIONS} transactions")
print("\nDirty data intentionally added: nulls, 'N/A' values, negative amounts")