CREATE TABLE IF NOT EXISTS ecommerce.returns
(
    return_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    order_item_id INTEGER NOT NULL,

    returned_quantity INTEGER NOT NULL
        CHECK (returned_quantity > 0),

    return_reason VARCHAR(255) NOT NULL,

    return_status VARCHAR(20) NOT NULL
        CHECK
        (
            return_status IN
            (
                'Requested',
                'Approved',
                'Rejected',
                'Refunded'
            )
        ),

    refund_amount NUMERIC(10,2) NOT NULL
        CHECK (refund_amount >= 0),

    returned_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    processed_at TIMESTAMP,

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_item
        FOREIGN KEY(order_item_id)
        REFERENCES ecommerce.order_items(order_item_id)
        ON DELETE RESTRICT
);