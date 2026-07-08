CREATE TABLE IF NOT EXISTS ecommerce.inventory
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    inventory_id INTEGER GENERATED ALWAYS AS IDENTITY,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    product_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Inventory Details
    --------------------------------------------------------------------

    quantity_available INTEGER NOT NULL DEFAULT 0,

    quantity_reserved INTEGER NOT NULL DEFAULT 0,

    reorder_level INTEGER NOT NULL DEFAULT 10,

    last_stock_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_inventory
        PRIMARY KEY (inventory_id),

    CONSTRAINT uq_inventory_product
        UNIQUE (product_id),

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES ecommerce.products(product_id),

    CONSTRAINT chk_inventory_available
        CHECK (quantity_available >= 0),

    CONSTRAINT chk_inventory_reserved
        CHECK (quantity_reserved >= 0),

    CONSTRAINT chk_inventory_reorder_level
        CHECK (reorder_level >= 0)
);

CREATE INDEX idx_inventory_product
ON ecommerce.inventory(product_id);