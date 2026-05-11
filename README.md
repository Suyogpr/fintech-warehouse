# Mini Data Warehouse Pipeline for Transaction Analytics

A production-style data warehouse pipeline built with PostgreSQL and Python,
modelled after real fintech data engineering architectures.

## Architecture

Data flows through three layers:

- **Raw layer** — CSV data loaded as-is into PostgreSQL (no transformations)
- **Staging layer** — SQL-based cleaning: null removal, type casting, deduplication
- **Analytics layer** — Star schema optimised for business queries

## Tech Stack

- PostgreSQL 18
- Python 3 (psycopg2, Faker, python-dotenv)
- SQL (core transformation logic)

## Dataset

Generated using Faker:
- 500 users across multiple countries
- 50 merchants across 6 categories
- 5,000 raw transactions (with intentional dirty data)
- ~2,500 clean transactions after staging

## Pipeline Stages

### 1. Raw layer
Loads CSV data directly into PostgreSQL with no transformation.
All columns stored as TEXT to accept any input without errors.

### 2. Staging layer
SQL transformations clean the data:
- Nulls removed
- Negative and invalid amounts filtered out
- Types cast: TEXT → UUID, NUMERIC, TIMESTAMP
- Emails normalised to lowercase
- 2,498 dirty rows dropped (~50% of raw data)

### 3. Analytics layer (star schema)
Clean data restructured into a star schema: