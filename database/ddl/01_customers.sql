CREATE TABLE IF NOT EXISTS ecommerce.customers
(
    -- Surrogate Key
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY,

    -- Business Key from Source System
    source_customer_id INTEGER NOT NULL,

    -- Customer Information
    first_name VARCHAR(100) NOT NULL,

    last_name VARCHAR(100) NOT NULL,

    email VARCHAR(254) NOT NULL,

    phone VARCHAR(20),

    dob DATE,

    gender VARCHAR(20),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_customers
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customers_source_customer_id
        UNIQUE (source_customer_id),

    CONSTRAINT uq_customers_email
        UNIQUE (email),

    CONSTRAINT uq_customers_phone
        UNIQUE (phone),

    CONSTRAINT chk_customers_gender
        CHECK (gender IN ('Male', 'Female'))
);

--------------------------------------------------------------------
-- Indexes
--------------------------------------------------------------------

CREATE INDEX idx_customers_source_customer_id
ON ecommerce.customers(source_customer_id);

CREATE INDEX idx_customers_last_name
ON ecommerce.customers(last_name);