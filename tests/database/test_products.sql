-- Valid Product
INSERT INTO ecommerce.products
(
    category_id,
    product_name,
    sku,
    brand,
    current_price
)
VALUES
(
    1,
    'Wireless Mouse',
    'WM-001',
    'Logitech',
    1499.99
);

-- Duplicate SKU (Should Fail)
INSERT INTO ecommerce.products
(
    category_id,
    product_name,
    sku,
    brand,
    current_price
)
VALUES
(
    1,
    'Gaming Mouse',
    'WM-001',
    'Razer',
    2999.99
);

-- Invalid Price (Should Fail)
INSERT INTO ecommerce.products
(
    category_id,
    product_name,
    sku,
    brand,
    current_price
)
VALUES
(
    1,
    'Keyboard',
    'KB-001',
    'Logitech',
    -500
);