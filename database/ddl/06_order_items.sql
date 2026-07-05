CREATE TABLE IF NOT EXISTS ecommerce.order_items
(
    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_id INTEGER NOT NULL,

    product_id INTEGER NOT NULL,

    product_name VARCHAR(255) NOT NULL,

    unit_price NUMERIC(10,2) NOT NULL
        CHECK (unit_price >= 0),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    discount_amount NUMERIC(10,2) NOT NULL
        DEFAULT 0
        CHECK (discount_amount >= 0),

    line_total NUMERIC(10,2) NOT NULL
        CHECK (line_total >= 0),

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order
        FOREIGN KEY(order_id)
        REFERENCES ecommerce.orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_product
        FOREIGN KEY(product_id)
        REFERENCES ecommerce.products(product_id)
        ON DELETE RESTRICT
);