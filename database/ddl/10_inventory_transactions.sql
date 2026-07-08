CREATE TABLE IF NOT EXISTS ecommerce.inventory_transactions
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    inventory_transaction_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_inventory_transaction_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    product_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Transaction Details
    --------------------------------------------------------------------

    transaction_type VARCHAR(20) NOT NULL,

    quantity INTEGER NOT NULL,

    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    reference_id INTEGER,

    remarks VARCHAR(500),

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_inventory_transactions
        PRIMARY KEY (inventory_transaction_id),

    CONSTRAINT uq_inventory_transactions_source_id
        UNIQUE (source_inventory_transaction_id),

    CONSTRAINT fk_inventory_transactions_product
        FOREIGN KEY (product_id)
        REFERENCES ecommerce.products(product_id),

    CONSTRAINT chk_inventory_transactions_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_inventory_transactions_type
        CHECK (
            transaction_type IN (
                'Purchase',
                'Sale',
                'Return',
                'Adjustment'
            )
        )
);

CREATE INDEX idx_inventory_transactions_product
ON ecommerce.inventory_transactions(product_id);

CREATE INDEX idx_inventory_transactions_date
ON ecommerce.inventory_transactions(transaction_date);

CREATE INDEX idx_inventory_transactions_type
ON ecommerce.inventory_transactions(transaction_type);