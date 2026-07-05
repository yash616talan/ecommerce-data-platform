CREATE TABLE IF NOT EXISTS ecommerce.addresses
(
    address_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    customer_id INTEGER NOT NULL,

    address_type VARCHAR(20) NOT NULL,

    address_line1 VARCHAR(255) NOT NULL,

    address_line2 VARCHAR(255),

    landmark VARCHAR(255),

    city VARCHAR(100) NOT NULL,

    state VARCHAR(100) NOT NULL,

    country VARCHAR(100) NOT NULL,

    postal_code VARCHAR(20) NOT NULL,

    phone VARCHAR(20),

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers(customer_id)
        ON DELETE CASCADE
);