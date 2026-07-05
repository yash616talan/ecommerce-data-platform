-- Valid Customer
INSERT INTO ecommerce.customers
(
    first_name,
    last_name,
    email,
    phone,
    dob,
    gender
)
VALUES
(
    'Yash',
    'Talan',
    'yash@example.com',
    '9876543210',
    '1998-01-15',
    'Male'
);

-- Another Valid Customer
INSERT INTO ecommerce.customers
(
    first_name,
    last_name,
    email
)
VALUES
(
    'Rahul',
    'Sharma',
    'rahul@example.com'
);

-- Duplicate Email
INSERT INTO ecommerce.customers
(
    first_name,
    last_name,
    email
)
VALUES
(
    'Amit',
    'Singh',
    'yash@example.com'
);