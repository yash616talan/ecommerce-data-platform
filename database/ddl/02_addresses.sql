CREATE TABLE IF NOT EXISTS ecommerce.addresses
(
    -- Surrogate Key
    address_id INTEGER GENERATED ALWAYS AS IDENTITY,

    -- Business Key from Source System
    source_address_id INTEGER NOT NULL,

    -- Foreign Key
    customer_id INTEGER NOT NULL,

    -- Address Details
    address_type VARCHAR(20) NOT NULL,

    address_line_1 VARCHAR(255) NOT NULL,

    address_line_2 VARCHAR(255),

    city VARCHAR(100) NOT NULL,

    state VARCHAR(100) NOT NULL,

    postal_code VARCHAR(20) NOT NULL,

    country VARCHAR(100) NOT NULL DEFAULT 'India',

    -- Status
    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_addresses
        PRIMARY KEY (address_id),

    CONSTRAINT uq_addresses_source_address_id
        UNIQUE (source_address_id),

    CONSTRAINT fk_addresses_customer
        FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers(customer_id),

    CONSTRAINT chk_addresses_type
        CHECK (address_type IN ('Home', 'Office', 'Other'))
);

--------------------------------------------------------------------
-- Indexes
--------------------------------------------------------------------

CREATE INDEX idx_addresses_customer
ON ecommerce.addresses(customer_id);

CREATE INDEX idx_addresses_city
ON ecommerce.addresses(city);

CREATE INDEX idx_addresses_state
ON ecommerce.addresses(state);

CREATE INDEX idx_addresses_postal_code
ON ecommerce.addresses(postal_code);