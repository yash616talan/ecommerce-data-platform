CREATE TABLE IF NOT EXISTS ecommerce.returns
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    return_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_return_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    order_item_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Return Details
    --------------------------------------------------------------------

    return_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    quantity_returned INTEGER NOT NULL,

    return_reason VARCHAR(100) NOT NULL,

    refund_amount NUMERIC(12,2) NOT NULL,

    return_status VARCHAR(20) NOT NULL,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_returns
        PRIMARY KEY (return_id),

    CONSTRAINT uq_returns_source_return_id
        UNIQUE (source_return_id),

    CONSTRAINT fk_returns_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES ecommerce.order_items(order_item_id),

    CONSTRAINT chk_returns_quantity
        CHECK (quantity_returned > 0),

    CONSTRAINT chk_returns_refund_amount
        CHECK (refund_amount >= 0),

    CONSTRAINT chk_returns_status
        CHECK (
            return_status IN (
                'Requested',
                'Approved',
                'Rejected',
                'Completed'
            )
        )
);

CREATE INDEX idx_returns_order_item
ON ecommerce.returns(order_item_id);

CREATE INDEX idx_returns_date
ON ecommerce.returns(return_date);