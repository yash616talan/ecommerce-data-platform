-- Valid Inventory

INSERT INTO ecommerce.inventory
(
    product_id,
    available_quantity,
    reserved_quantity,
    reorder_level
)
VALUES
(
    1,
    100,
    0,
    20
);

-- Negative Inventory (Should Fail)

INSERT INTO ecommerce.inventory
(
    product_id,
    available_quantity
)
VALUES
(
    1,
    -5
);