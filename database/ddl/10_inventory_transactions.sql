CREATE TABLE IF NOT EXISTS ecommerce.inventory_transactions
(
    transaction_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    product_id INTEGER NOT NULL,

    transaction_type VARCHAR(20) NOT NULL
        CHECK (
            transaction_type IN
            (
                'Purchase',
                'Sale',
                'Return',
                'Damage',
                'Adjustment'
            )
        ),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    reference_id INTEGER,

    remarks TEXT,

    transaction_date TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product
        FOREIGN KEY(product_id)
        REFERENCES ecommerce.products(product_id)
        ON DELETE RESTRICT
);