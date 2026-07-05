-- Valid Payment

INSERT INTO ecommerce.payments
(
    order_id,
    payment_method,
    transaction_reference,
    amount,
    payment_status,
    payment_gateway,
    payment_time
)
VALUES
(
    1,
    'UPI',
    'TXN123456789',
    2500.00,
    'Success',
    'Razorpay',
    CURRENT_TIMESTAMP
);

-- Duplicate Transaction ID

INSERT INTO ecommerce.payments
(
    order_id,
    payment_method,
    transaction_reference,
    amount,
    payment_status
)
VALUES
(
    1,
    'Credit Card',
    'TXN123456789',
    2500,
    'Success'
);