run:
	python scripts/generate_data.py
	python scripts/load_raw.py
	python scripts/transform_staging.py
	python scripts/transform_analytics.py
	python scripts/run_analytics.py

setup:
	python scripts/create_tables.py

# To run the whole pipeline from scratch:
make run