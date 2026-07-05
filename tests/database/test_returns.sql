-- Valid Return

INSERT INTO ecommerce.returns
(
    order_item_id,
    return_reason,
    return_status,
    refund_amount
)
VALUES
(
    1,
    'Damaged Product',
    'Requested',
    1499.99
);

-- Invalid Status

INSERT INTO ecommerce.returns
(
    order_item_id,
    return_reason,
    return_status,
    refund_amount
)
VALUES
(
    1,
    'Wrong Product',
    'Completed',
    1499.99
);