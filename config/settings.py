"""
Application Configuration

This file contains all configurable parameters for the project.
Changing values here should not require changes to the application code.
"""

# ----------------------------------
# Data Generation
# ----------------------------------

NUM_CUSTOMERS = 1000
NUM_CATEGORIES = 20
NUM_PRODUCTS = 500
NUM_ORDERS = 5000

# ----------------------------------
# Faker Configuration
# ----------------------------------

FAKER_LOCALE = "en_IN"

# ----------------------------------
# Output Directories
# ----------------------------------

RAW_DATA_PATH = "data/raw"

# ----------------------------------
# Random Seed
# ----------------------------------

RANDOM_SEED = 42