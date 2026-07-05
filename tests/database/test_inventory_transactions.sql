-- Initial Stock Purchase
INSERT INTO ecommerce.inventory_transactions
(
    product_id,
    transaction_type,
    quantity,
    remarks
)
VALUES
(
    1,
    'Purchase',
    100,
    'Initial stock received from supplier'
);

-- Sale
INSERT INTO ecommerce.inventory_transactions
(
    product_id,
    transaction_type,
    quantity,
    reference_id,
    remarks
)
VALUES
(
    1,
    'Sale',
    2,
    1,
    'Order #1'
);

-- Invalid Transaction Type
INSERT INTO ecommerce.inventory_transactions
(
    product_id,
    transaction_type,
    quantity
)
VALUES
(
    1,
    'Lost',
    1
);