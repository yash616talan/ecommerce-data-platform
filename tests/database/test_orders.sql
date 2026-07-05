-- Valid Order
INSERT INTO ecommerce.orders
(
    customer_id,
    payment_status,
    order_status,
    shipping_name,
    shipping_phone,
    shipping_address_line1,
    shipping_city,
    shipping_state,
    shipping_country,
    shipping_postal_code,
    total_amount
)
VALUES
(
    2,
    'Pending',
    'Pending Payment',
    'Rahul Sharma',
    '9876543210',
    '221B Baker Street',
    'Delhi',
    'Delhi',
    'India',
    '110001',
    2500.00
);

-- Invalid Payment Status (Should Fail)
INSERT INTO ecommerce.orders
(
    customer_id,
    payment_status,
    order_status,
    shipping_name,
    shipping_phone,
    shipping_address_line1,
    shipping_city,
    shipping_state,
    shipping_country,
    shipping_postal_code,
    total_amount
)
VALUES
(
    2,
    'Completed',
    'Pending Payment',
    'Rahul Sharma',
    '9876543210',
    '221B Baker Street',
    'Delhi',
    'Delhi',
    'India',
    '110001',
    2500.00
);