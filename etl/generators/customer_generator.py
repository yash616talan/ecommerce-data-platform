"""
Customer Generator

Generates realistic customer data and exports it to CSV.
"""

from pathlib import Path
import random

import pandas as pd
from faker import Faker

from config.settings import (
    NUM_CUSTOMERS,
    RAW_DATA_PATH,
    RANDOM_SEED,
    FAKER_LOCALE,
)


class CustomerGenerator:
    """
    Generates customer records for the eCommerce platform.
    """

    def __init__(
        self,
        num_customers: int = NUM_CUSTOMERS,
        output_path: str = RAW_DATA_PATH,
    ):
        """
        Initialize the customer generator.
        """

        self.num_customers = num_customers
        self.output_path = Path(output_path)

        # Create output directory if it doesn't exist
        self.output_path.mkdir(parents=True, exist_ok=True)

        # Initialize Faker
        self.fake = Faker(FAKER_LOCALE)

        # Ensure reproducible results
        random.seed(RANDOM_SEED)
        Faker.seed(RANDOM_SEED)

        # Email domains
        self.email_domains = [
            "gmail.com",
            "outlook.com",
            "yahoo.com",
            "hotmail.com",
        ]

    def generate_customer(self, customer_number: int) -> dict:
        """
        Generate a single customer record.

        Parameters
        ----------
        customer_number : int
            Used only to generate a unique email address.

        Returns
        -------
        dict
            Customer record.
        """

        first_name = self.fake.first_name()
        last_name = self.fake.last_name()

        domain = random.choice(self.email_domains)

        email = (
            f"{first_name.lower()}."
            f"{last_name.lower()}"
            f"{customer_number}@{domain}"
        )

        return {
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "phone": f"+91{random.randint(6000000000, 9999999999)}",
            "dob": self.fake.date_of_birth(
                minimum_age=18,
                maximum_age=80,
            ),
            "gender": random.choice(
                ["Male", "Female"]
            ),
            "is_active": random.choices(
                [True, False],
                weights=[95, 5],
                k=1,
            )[0],
        }

    def generate_customers(self) -> list[dict]:
        """
        Generate all customer records.
        """

        customers = []

        for customer_number in range(1, self.num_customers + 1):
            customers.append(
                self.generate_customer(customer_number)
            )

        return customers

    def save_to_csv(self, customers: list[dict]) -> None:
        """
        Save customers to a CSV file.
        """

        df = pd.DataFrame(customers)

        output_file = self.output_path / "customers.csv"

        df.to_csv(output_file, index=False)

        print(f"\n✅ Customer data saved to:\n{output_file}")

    def run(self) -> None:
        """
        Execute the complete customer generation pipeline.
        """

        print(f"Generating {self.num_customers:,} customers...")

        customers = self.generate_customers()

        self.save_to_csv(customers)

        print("✅ Customer generation completed successfully.")


if __name__ == "__main__":
    generator = CustomerGenerator()
    generator.run()