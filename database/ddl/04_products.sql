CREATE TABLE IF NOT EXISTS ecommerce.products
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    product_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_product_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------

    category_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Product Details
    --------------------------------------------------------------------

    product_name VARCHAR(255) NOT NULL,

    description TEXT,

    sku VARCHAR(100) NOT NULL,

    brand VARCHAR(100),

    unit_price NUMERIC(10,2) NOT NULL,

    --------------------------------------------------------------------
    -- Status
    --------------------------------------------------------------------

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------

    CONSTRAINT pk_products
        PRIMARY KEY (product_id),

    CONSTRAINT uq_products_source_product_id
        UNIQUE (source_product_id),

    CONSTRAINT uq_products_sku
        UNIQUE (sku),

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES ecommerce.categories(category_id),

    CONSTRAINT chk_products_unit_price
        CHECK (unit_price >= 0)
);