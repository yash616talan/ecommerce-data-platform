CREATE TABLE IF NOT EXISTS ecommerce.payments
(
    payment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_id INTEGER NOT NULL,

    payment_method VARCHAR(30) NOT NULL
        CHECK (
            payment_method IN
            (
                'Credit Card',
                'Debit Card',
                'UPI',
                'Net Banking',
                'Wallet',
                'Cash on Delivery'
            )
        ),

    transaction_reference VARCHAR(100) UNIQUE,

    amount NUMERIC(10,2) NOT NULL
        CHECK (amount >= 0),

    payment_status VARCHAR(20) NOT NULL
        CHECK (
            payment_status IN
            (
                'Pending',
                'Success',
                'Failed',
                'Refunded'
            )
        ),

    payment_gateway VARCHAR(100),

    payment_time TIMESTAMP,

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order
        FOREIGN KEY(order_id)
        REFERENCES ecommerce.orders(order_id)
        ON DELETE CASCADE
);