CREATE TABLE IF NOT EXISTS ecommerce.orders
(
    order_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    customer_id INTEGER NOT NULL,

    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    payment_status VARCHAR(20) NOT NULL
        CHECK (
            payment_status IN
            ('Pending','Paid','Failed','Refunded')
        ),

    order_status VARCHAR(30) NOT NULL
        CHECK (
            order_status IN
            (
                'Pending Payment',
                'Confirmed',
                'Packed',
                'Shipped',
                'Delivered',
                'Cancelled',
                'Returned'
            )
        ),

    shipping_name VARCHAR(150) NOT NULL,

    shipping_phone VARCHAR(20) NOT NULL,

    shipping_address_line1 VARCHAR(255) NOT NULL,

    shipping_address_line2 VARCHAR(255),

    shipping_city VARCHAR(100) NOT NULL,

    shipping_state VARCHAR(100) NOT NULL,

    shipping_country VARCHAR(100) NOT NULL,

    shipping_postal_code VARCHAR(20) NOT NULL,

    shipping_cost NUMERIC(10,2) NOT NULL
        DEFAULT 0
        CHECK (shipping_cost >= 0),

    tax_amount NUMERIC(10,2) NOT NULL
        DEFAULT 0
        CHECK (tax_amount >= 0),

    discount_amount NUMERIC(10,2) NOT NULL
        DEFAULT 0
        CHECK (discount_amount >= 0),

    total_amount NUMERIC(10,2) NOT NULL
        CHECK (total_amount >= 0),

    created_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer
        FOREIGN KEY(customer_id)
        REFERENCES ecommerce.customers(customer_id)
        ON DELETE RESTRICT
);