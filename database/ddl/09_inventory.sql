CREATE TABLE IF NOT EXISTS ecommerce.inventory
(
    inventory_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    product_id INTEGER NOT NULL UNIQUE,

    available_quantity INTEGER NOT NULL
        DEFAULT 0
        CHECK (available_quantity >= 0),

    reserved_quantity INTEGER NOT NULL
        DEFAULT 0
        CHECK (reserved_quantity >= 0),

    reorder_level INTEGER NOT NULL
        DEFAULT 10
        CHECK (reorder_level >= 0),

    last_stock_update TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product
        FOREIGN KEY(product_id)
        REFERENCES ecommerce.products(product_id)
        ON DELETE RESTRICT
);