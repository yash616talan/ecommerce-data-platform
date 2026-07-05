-- Valid Order Item
INSERT INTO ecommerce.order_items
(
    order_id,
    product_id,
    product_name,
    unit_price,
    quantity,
    line_total
)
VALUES
(
    1,
    1,
    'Wireless Mouse',
    1499.99,
    2,
    2999.98
);