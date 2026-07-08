CREATE TABLE IF NOT EXISTS ecommerce.categories
(
    --------------------------------------------------------------------
    -- Keys
    --------------------------------------------------------------------

    category_id INTEGER GENERATED ALWAYS AS IDENTITY,

    source_category_id INTEGER NOT NULL,

    --------------------------------------------------------------------
    -- Category Details
    --------------------------------------------------------------------

    category_name VARCHAR(100) NOT NULL,

    parent_category_id INTEGER,

    description VARCHAR(500),

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

    CONSTRAINT pk_categories
        PRIMARY KEY (category_id),

    CONSTRAINT uq_categories_source_category_id
        UNIQUE (source_category_id),

    CONSTRAINT uq_categories_name
        UNIQUE (category_name),

    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_category_id)
        REFERENCES ecommerce.categories(category_id)
);