CREATE TABLE IF NOT EXISTS ecommerce.orders
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    order_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_order_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    customer_id INTEGER NOT NULL,

    address_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Order Details
    --------------------------------------------------------------------

    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    order_status VARCHAR(20) NOT NULL,

    total_amount NUMERIC(12,2) NOT NULL,

    payment_status VARCHAR(20) NOT NULL,

    --------------------------------------------------------------------
    -- Recipient Snapshot
    --------------------------------------------------------------------

    recipient_name VARCHAR(200) NOT NULL,

    recipient_phone VARCHAR(20) NOT NULL,

    shipping_address TEXT NOT NULL,

    --------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_orders
        PRIMARY KEY (order_id),

    CONSTRAINT uq_orders_source_order_id
        UNIQUE (source_order_id),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers(customer_id),

    CONSTRAINT fk_orders_address
        FOREIGN KEY (address_id)
        REFERENCES ecommerce.addresses(address_id),

    CONSTRAINT chk_orders_total_amount
        CHECK (total_amount >= 0),

    CONSTRAINT chk_orders_status
        CHECK (
            order_status IN (
                'Pending',
                'Confirmed',
                'Packed',
                'Shipped',
                'Delivered',
                'Cancelled'
            )
        ),

    CONSTRAINT chk_orders_payment_status
        CHECK (
            payment_status IN (
                'Pending',
                'Paid',
                'Failed',
                'Refunded'
            )
        )
);

CREATE INDEX idx_orders_customer
ON ecommerce.orders(customer_id);

CREATE INDEX idx_orders_address
ON ecommerce.orders(address_id);

CREATE INDEX idx_orders_order_date
ON ecommerce.orders(order_date);