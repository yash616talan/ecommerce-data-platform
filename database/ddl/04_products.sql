CREATE TABLE IF NOT EXISTS ecommerce.products
(
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    category_id INTEGER NOT NULL,

    product_name VARCHAR(255) NOT NULL,

    sku VARCHAR(100) NOT NULL UNIQUE,

    brand VARCHAR(100),

    description TEXT,

    current_price NUMERIC(10,2) NOT NULL
        CHECK (current_price >= 0),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_category
        FOREIGN KEY (category_id)
        REFERENCES ecommerce.categories(category_id)
        ON DELETE RESTRICT
);