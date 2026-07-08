CREATE TABLE IF NOT EXISTS ecommerce.order_items
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    order_item_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_order_item_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    order_id INTEGER NOT NULL,

    product_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Order Item Details
    --------------------------------------------------------------------

    quantity INTEGER NOT NULL,

    unit_price NUMERIC(10,2) NOT NULL,

    discount_amount NUMERIC(10,2) NOT NULL DEFAULT 0,

    line_total NUMERIC(12,2) NOT NULL,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT uq_order_items_source_order_item_id
        UNIQUE (source_order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES ecommerce.products(product_id),

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_order_items_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_order_items_line_total
        CHECK (line_total >= 0)
);

CREATE INDEX idx_order_items_order
ON ecommerce.order_items(order_id);

CREATE INDEX idx_order_items_product
ON ecommerce.order_items(product_id);