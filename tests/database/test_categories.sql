-- Valid Category
INSERT INTO ecommerce.categories
(category_name, description)
VALUES
(
    'Electronics',
    'Electronic devices and accessories'
);

-- Another Valid Category
INSERT INTO ecommerce.categories
(category_name)
VALUES
(
    'Books'
);

-- Duplicate Category (Should Fail)
INSERT INTO ecommerce.categories
(category_name)
VALUES
(
    'Electronics'
);