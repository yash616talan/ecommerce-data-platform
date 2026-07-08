CREATE TABLE IF NOT EXISTS ecommerce.payments
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    payment_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_payment_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    order_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Payment Details
    --------------------------------------------------------------------

    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    payment_method VARCHAR(30) NOT NULL,

    payment_status VARCHAR(20) NOT NULL,

    amount NUMERIC(12,2) NOT NULL,

    transaction_reference VARCHAR(100),

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_payments
        PRIMARY KEY (payment_id),

    CONSTRAINT uq_payments_source_payment_id
        UNIQUE (source_payment_id),

    CONSTRAINT uq_payments_transaction_reference
        UNIQUE (transaction_reference),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders(order_id),

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payments_method
        CHECK (
            payment_method IN (
                'Credit Card',
                'Debit Card',
                'UPI',
                'Net Banking',
                'Wallet',
                'Cash on Delivery'
            )
        ),

    CONSTRAINT chk_payments_status
        CHECK (
            payment_status IN (
                'Pending',
                'Success',
                'Failed',
                'Refunded'
            )
        )
);

CREATE INDEX idx_payments_order
ON ecommerce.payments(order_id);

CREATE INDEX idx_payments_date
ON ecommerce.payments(payment_date);