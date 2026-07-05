# Data Dictionary

## Overview

This document describes the purpose of every table and column in the eCommerce Data Platform. It serves as a reference for developers, data engineers, analysts, and business users.

---

# Table: customers

**Purpose**

Stores the current profile information of registered customers. This table represents the master record for each customer.

| Column | Data Type | Description |
|---------|-----------|-------------|
| customer_id | INTEGER | System-generated unique identifier for each customer. Primary Key. |
| first_name | VARCHAR(100) | Customer's first name. |
| last_name | VARCHAR(100) | Customer's last name. |
| email | VARCHAR(254) | Customer's email address. Must be unique. Used for login and communication. |
| phone | VARCHAR(20) | Customer's phone number. Unique when provided. |
| dob | DATE | Customer's date of birth. Optional. |
| gender | VARCHAR(20) | Customer's gender. Optional. |
| is_active | BOOLEAN | Indicates whether the customer account is currently active. Used for soft deletion. |
| created_at | TIMESTAMP | Timestamp when the customer account was created. |
| updated_at | TIMESTAMP | Timestamp when the customer record was last updated. |

### Business Notes

- This table stores only the **current** customer information.
- Historical orders should **never** depend on mutable customer attributes.
- Customer details such as name or phone number may change over time.
- Orders should snapshot customer information when necessary.

---

# Table: addresses

**Purpose**

Stores all addresses saved by customers. A customer can have multiple addresses (Home, Work, etc.).

| Column | Data Type | Description |
|---------|-----------|-------------|
| address_id | INTEGER | System-generated unique identifier for each address. Primary Key. |
| customer_id | INTEGER | References the customer who owns this address. Foreign Key to `customers.customer_id`. |
| address_type | VARCHAR(20) | Type of address (Home, Work, Other). |
| address_line1 | VARCHAR(255) | Primary street address. |
| address_line2 | VARCHAR(255) | Additional address information such as apartment or suite number. Optional. |
| landmark | VARCHAR(255) | Nearby landmark used for easier delivery. Optional. |
| city | VARCHAR(100) | City name. |
| state | VARCHAR(100) | State or province. |
| country | VARCHAR(100) | Country name. |
| postal_code | VARCHAR(20) | ZIP/Postal code. |
| phone | VARCHAR(20) | Contact number associated with this address. Optional. |
| is_default | BOOLEAN | Indicates whether this is the customer's default shipping address. |
| is_active | BOOLEAN | Indicates whether the address is currently active. Used instead of deleting addresses when customers update them. |
| created_at | TIMESTAMP | Timestamp when the address was created. |
| updated_at | TIMESTAMP | Timestamp when the address was last updated. |

### Business Notes

- One customer can save multiple addresses.
- Historical orders should **not** rely on this table for shipping information.
- Orders will store a **snapshot** of the shipping address used during checkout.
- When a customer changes an address, a new address record may be created while the previous one is marked inactive.
- This table represents the customer's current saved addresses, not historical shipping records.

---

## Design Principles Applied

### 1. Master Data vs Transaction Data

The `customers` and `addresses` tables are **master data** tables. Their values may change over time.

Transaction tables (such as `orders` and `order_items`) will store snapshots of important business information to preserve historical accuracy.

---

### 2. Soft Deletes

Instead of physically deleting customer or address records, we use the `is_active` column to indicate whether the record is currently active.

This helps preserve historical relationships and supports auditing.

---

### 3. Referential Integrity

The `addresses.customer_id` column is enforced through a Foreign Key constraint to ensure that every address belongs to a valid customer.

---

---

# Table: categories

## Purpose

Stores the master list of product categories used to classify products within the eCommerce platform.

This table helps organize the product catalog, supports filtering and searching, enables category-level reporting, and eliminates duplicate category names across the database.

---

## Columns

| Column | Data Type | Description |
|---------|-----------|-------------|
| category_id | INTEGER | System-generated unique identifier for each category. Primary Key. |
| category_name | VARCHAR(100) | Name of the category (e.g., Electronics, Books, Fashion). Must be unique. |
| description | TEXT | Optional description providing additional details about the category. |
| is_active | BOOLEAN | Indicates whether the category is currently active. Used for soft deletion instead of physically removing the category. |
| created_at | TIMESTAMP | Timestamp when the category was created. |
| updated_at | TIMESTAMP | Timestamp when the category was last modified. |

---

## Business Notes

- This table stores **master data** that is shared by multiple products.
- Each product belongs to **one** category.
- A category can contain **many** products.
- Category names must be unique to prevent duplicate classifications.
- Categories should generally be deactivated (`is_active = FALSE`) instead of deleted to preserve historical references.
- Updating a category name automatically reflects across all associated products because products reference the category using `category_id`.

---

## Relationships

### Parent Tables

None

### Child Tables

- `products`
    - `products.category_id` → `categories.category_id`

Relationship:

```text
Categories (1)
      │
      │
      ▼
Products (Many)
```

---

## Design Decisions

### Why create a separate Categories table?

Instead of storing the category name inside every product record, we normalize the schema by creating a dedicated `categories` table.

Example:

❌ Poor Design

| Product | Category |
|----------|----------|
| Laptop | Electronics |
| Mouse | Electronics |
| Keyboard | Electronics |

If the category name changes to **Consumer Electronics**, every product record must be updated.

---

✅ Normalized Design

Categories

| category_id | category_name |
|--------------|---------------|
| 1 | Electronics |

Products

| product_name | category_id |
|--------------|-------------|
| Laptop | 1 |
| Mouse | 1 |
| Keyboard | 1 |

Now only a single row in the `categories` table needs to be updated.

This eliminates update anomalies and improves data consistency.

---

### Why use `is_active` instead of deleting a category?

Products may still reference a category that is no longer available for new products.

Marking a category as inactive:

- Preserves historical product information.
- Prevents accidental data loss.
- Allows reporting on discontinued categories.
- Supports future reactivation if required.

---

## Future Enhancements

As the platform grows, the category hierarchy can be extended by introducing a `parent_category_id` column.

Example:

```text
Electronics
│
├── Mobile Phones
├── Laptops
├── Cameras
└── Accessories
```

This enables hierarchical categories without redesigning the database.

---

# Table: products

## Purpose

Stores the master catalog of products available for sale on the eCommerce platform.

Each record represents a unique sellable product. The table maintains the current product information such as name, SKU, brand, category, and current selling price.

This table is considered **Master Data**, meaning its values can change over time. Historical transactions should never rely directly on mutable fields in this table.

---

## Columns

| Column | Data Type | Description |
|---------|-----------|-------------|
| product_id | INTEGER | System-generated unique identifier for each product. Primary Key. |
| category_id | INTEGER | References the category to which the product belongs. Foreign Key to `categories.category_id`. |
| product_name | VARCHAR(255) | Display name of the product. |
| sku | VARCHAR(100) | Stock Keeping Unit (SKU). A unique business identifier used for inventory and order management. |
| brand | VARCHAR(100) | Manufacturer or brand of the product. Optional. |
| description | TEXT | Detailed description of the product. Optional. |
| current_price | NUMERIC(10,2) | Current selling price of the product. Must be greater than or equal to zero. |
| is_active | BOOLEAN | Indicates whether the product is currently available for sale. Used for soft deletion. |
| created_at | TIMESTAMP | Timestamp when the product was created. |
| updated_at | TIMESTAMP | Timestamp when the product was last modified. |

---

## Business Notes

- Each product belongs to exactly **one category**.
- A category can contain **many products**.
- The SKU is the primary business identifier for a product and must be unique.
- Product names may change due to marketing updates, but the SKU should remain constant.
- The `current_price` represents the latest selling price and should **never** be used for historical order calculations.
- Historical prices are stored in the `order_items` table as `unit_price`.
- Products are marked as inactive (`is_active = FALSE`) instead of being deleted to preserve historical order references.

---

## Relationships

### Parent Tables

- `categories`
    - `products.category_id` → `categories.category_id`

### Child Tables

- `order_items`
    - `order_items.product_id` → `products.product_id`

Relationship:

```text
Categories (1)
      │
      ▼
Products (Many)
      │
      ▼
OrderItems (Many)
```

---

## Design Decisions

### Why create a separate Products table?

Products represent the central catalog of items available for purchase.

Separating products from orders allows:

- Independent product management.
- Product search and filtering.
- Inventory management.
- Category-based reporting.
- Historical transaction preservation.

---

### Why use SKU instead of Product Name?

The product name is intended for display purposes and may change over time.

Example:

```
Apple iPhone 16
```

↓

```
Apple iPhone 16 (Latest Model)
```

However, the SKU remains unchanged.

Example:

```
IP16-BLK-128
```

Using SKU ensures that business processes such as inventory management, warehouse operations, and order fulfillment always reference a stable identifier.

---

### Why use NUMERIC(10,2) instead of FLOAT?

Monetary values require exact precision.

Using `FLOAT` can introduce rounding errors because it stores approximate values in binary.

`NUMERIC(10,2)` guarantees exact decimal precision, making it suitable for prices, taxes, discounts, and financial calculations.

Example:

```
1499.99 ✔
99999999.99 ✔
```

---

### Why use current_price?

The product price changes over time.

Example:

```
January

Laptop

₹75,000
```

↓

```
July

Laptop

₹80,000
```

Historical orders should continue to display the original purchase price.

Therefore:

- `products.current_price` stores today's selling price.
- `order_items.unit_price` stores the price at the time of purchase.

This follows the principle:

> **Master data changes. Transactional data preserves history.**

---

### Why use ON DELETE RESTRICT?

A category should not be deleted while products still belong to it.

Using `ON DELETE RESTRICT` prevents accidental deletion of a category that is referenced by one or more products.

This preserves referential integrity and prevents orphaned product records.

---

## Future Enhancements

As the platform evolves, additional product attributes can be introduced, including:

- Weight
- Dimensions
- Color
- Size
- Manufacturer
- Warranty Period
- Barcode
- Product Images
- Product Ratings
- Tax Category

These attributes can either be added directly to this table or normalized into separate tables depending on business requirements.

---

# Table: orders

## Purpose

Stores every order placed by customers on the eCommerce platform.

Each record represents a single purchase transaction. The table captures the customer who placed the order, the shipping information used during checkout, payment status, order status, and financial details such as shipping charges, taxes, discounts, and the final order amount.

Unlike master data tables, the `orders` table stores **transactional snapshots**. Once an order is placed, the information should accurately represent the state of the transaction at that point in time.

---

## Columns

| Column | Data Type | Description |
|---------|-----------|-------------|
| order_id | INTEGER | System-generated unique identifier for each order. Primary Key. |
| customer_id | INTEGER | References the customer who placed the order. Foreign Key to `customers.customer_id`. |
| order_date | TIMESTAMP | Date and time when the order was placed. |
| payment_status | VARCHAR(20) | Current payment state of the order (Pending, Paid, Failed, Refunded). |
| order_status | VARCHAR(30) | Current lifecycle status of the order (Pending Payment, Confirmed, Packed, Shipped, Delivered, Cancelled, Returned). |
| shipping_name | VARCHAR(150) | Name of the recipient for this order. Stored as a snapshot. |
| shipping_phone | VARCHAR(20) | Contact number of the recipient. Stored as a snapshot. |
| shipping_address_line1 | VARCHAR(255) | Primary shipping address used for delivery. |
| shipping_address_line2 | VARCHAR(255) | Additional address information such as apartment or suite number. Optional. |
| shipping_city | VARCHAR(100) | Shipping city. |
| shipping_state | VARCHAR(100) | Shipping state or province. |
| shipping_country | VARCHAR(100) | Shipping country. |
| shipping_postal_code | VARCHAR(20) | Postal or ZIP code used during shipment. |
| shipping_cost | NUMERIC(10,2) | Shipping charges applied to the order. |
| tax_amount | NUMERIC(10,2) | Tax collected for the order. |
| discount_amount | NUMERIC(10,2) | Discount applied to the order. |
| total_amount | NUMERIC(10,2) | Final payable amount for the order after taxes and discounts. |
| created_at | TIMESTAMP | Timestamp when the order record was created. |
| updated_at | TIMESTAMP | Timestamp when the order record was last updated. |

---

## Business Notes

- One customer can place multiple orders.
- Each order belongs to exactly one customer.
- An order represents a **business transaction** and should be treated as historical data.
- Shipping information is intentionally copied into this table to preserve the exact delivery details used when the order was placed.
- Changes to the customer's saved addresses must never modify historical orders.
- Financial values such as shipping cost, tax, discount, and total amount are stored as snapshots to preserve historical accuracy.
- The order stores only summary information. Individual products purchased are stored in the `order_items` table.

---

## Relationships

### Parent Tables

- `customers`
    - `orders.customer_id` → `customers.customer_id`

### Child Tables

- `order_items`
    - `order_items.order_id` → `orders.order_id`

- `payments`
    - `payments.order_id` → `orders.order_id`

Relationship:

```text
Customers (1)
      │
      ▼
Orders (Many)
      │
      ├─────────────┐
      ▼             ▼
OrderItems      Payments
```

---

## Design Decisions

### Why store the shipping address inside the Orders table?

Shipping addresses are copied into the order instead of referencing the current address stored in the `addresses` table.

Example:

```
Customer places an order.

↓

Address = Delhi

↓

Customer moves to Mumbai.
```

The original order must still show **Delhi**, because that is where the package was delivered.

Orders represent historical business events and should never change because master data changes.

---

### Why store recipient name and phone?

The recipient is not always the customer.

Examples include:

- Gift orders
- Family members
- Corporate deliveries

The order must preserve the exact recipient details used during delivery.

---

### Why store financial amounts instead of calculating them?

Although the total amount could theoretically be calculated from the order items, storing the financial summary provides:

- Faster reporting
- Simpler invoice generation
- Historical accuracy
- Protection against future price changes

---

### Why not store AddressID?

The order should not depend on mutable master data.

If the customer edits or deletes a saved address, historical orders must remain unchanged.

Therefore, the complete shipping address is stored as a transaction snapshot.

---

### Why use CHECK constraints?

`payment_status` and `order_status` are limited to predefined business values.

This prevents invalid data such as:

```
Payed
Done
Completed
Unknown
```

Only approved status values are allowed.

---

## Business Rules

1. Every order must belong to a valid customer.
2. An order cannot exist without a customer.
3. Shipping information must remain unchanged after the order is placed.
4. Financial values cannot be negative.
5. Every order will eventually contain one or more records in the `order_items` table.
6. Orders should never be physically deleted after they become part of business history.
7. Payment status and order status represent different business processes and must be tracked independently.
8. Historical reporting must always use values stored in the order, not values from master tables.

---

## Future Enhancements

As the platform grows, the following features can be introduced:

- Order Status History
- Multiple Shipping Packages
- Gift Orders
- Coupon Management
- Currency Support
- Multi-Warehouse Fulfillment
- Shipping Carrier Information
- Estimated Delivery Date
- Actual Delivery Date
- Order Cancellation Reason
- Audit Trail

---

# Table: order_items

## Purpose

Stores the individual products that belong to an order.

Each record represents one product purchased within an order. This table captures product information, pricing, quantity, discounts, and the final amount for that specific line item.

The `order_items` table acts as the bridge between the `orders` table and the `products` table, enabling a single order to contain multiple products.

Unlike the `products` table, this table stores **transactional snapshots** to preserve the exact details of each purchased product at the time of checkout.

---

## Columns

| Column | Data Type | Description |
|---------|-----------|-------------|
| order_item_id | INTEGER | System-generated unique identifier for each order item. Primary Key. |
| order_id | INTEGER | References the order to which this item belongs. Foreign Key to `orders.order_id`. |
| product_id | INTEGER | References the purchased product. Foreign Key to `products.product_id`. |
| product_name | VARCHAR(255) | Snapshot of the product name at the time of purchase. |
| unit_price | NUMERIC(10,2) | Price of a single unit at the time the order was placed. |
| quantity | INTEGER | Number of units purchased. Must be greater than zero. |
| discount_amount | NUMERIC(10,2) | Discount applied to this line item. |
| line_total | NUMERIC(10,2) | Final amount for this line item after discounts. |
| created_at | TIMESTAMP | Timestamp when the order item was created. |

---

## Business Notes

- One order can contain multiple order items.
- Each order item represents one product purchased in an order.
- Product information is intentionally copied into this table to preserve historical accuracy.
- Product prices may change over time, but historical orders must always display the original purchase price.
- Discounts can differ for individual products within the same order.
- The sum of all `line_total` values should equal the order's total product value before shipping and taxes.

---

## Relationships

### Parent Tables

- `orders`
    - `order_items.order_id` → `orders.order_id`

- `products`
    - `order_items.product_id` → `products.product_id`

### Child Tables

- `returns`
    - `returns.order_item_id` → `order_items.order_item_id`

Relationship:

```text
Orders (1)
     │
     ▼
OrderItems (Many)
     │
     ▼
Returns (Many)
```

---

## Design Decisions

### Why separate Orders and OrderItems?

An order can contain multiple products.

Separating the tables eliminates unnecessary duplication of order-level information such as:

- Shipping Address
- Payment Status
- Order Status
- Taxes
- Shipping Charges

This follows the principles of normalization while maintaining a flexible order structure.

---

### Why store product_name?

The product name may change over time due to marketing updates or product rebranding.

Example:

```
Apple iPhone 16
```

↓

```
Apple iPhone 16 (Latest Model)
```

Historical invoices should continue displaying the original purchased product name.

---

### Why store unit_price?

The current product price is stored in the `products` table.

However, product prices change frequently.

Example:

```
January

Laptop

₹75,000
```

↓

```
July

Laptop

₹80,000
```

Historical orders must continue displaying ₹75,000.

Therefore:

- `products.current_price` stores today's selling price.
- `order_items.unit_price` stores the purchase price.

---

### Why store line_total?

Although it can be calculated as:

```
unit_price × quantity − discount_amount
```

it is stored because:

- Improves reporting performance.
- Simplifies invoice generation.
- Preserves historical calculations.
- Prevents future pricing logic changes from affecting old orders.

---

### Why ON DELETE CASCADE for Orders?

Order items have no meaning without an order.

If an order is removed in a development or test environment, its associated order items should also be removed automatically.

---

### Why ON DELETE RESTRICT for Products?

Products may no longer be sold, but historical purchases must remain valid.

Preventing product deletion protects historical transaction records and maintains referential integrity.

---

## Business Rules

1. Every order item must belong to a valid order.
2. Every order item must reference a valid product.
3. Quantity must always be greater than zero.
4. Unit price cannot be negative.
5. Discount amount cannot be negative.
6. Line total cannot be negative.
7. Product information should never be updated after an order is placed.
8. Historical reporting must use `unit_price` stored in this table rather than the current product price.

---

## Future Enhancements

As the platform evolves, the following attributes may be added:

- Tax Amount (per item)
- Coupon Allocation
- Product Variant (Color, Size)
- Warehouse ID
- Shipment ID
- Gift Wrapping
- Estimated Delivery Date
- Actual Delivery Date
- Item-level Status
- Return Eligibility
- Warranty Information

---

# Table: payments

## Purpose

Stores every payment attempt made for an order.

A payment represents the financial transaction associated with an order and is independent of the order itself. An order may have multiple payment attempts due to failures, retries, or different payment methods.

This table records the payment method used, transaction reference received from the payment gateway, payment status, payment amount, and payment gateway details.

---

## Columns

| Column | Data Type | Description |
|---------|-----------|-------------|
| payment_id | INTEGER | System-generated unique identifier for each payment attempt. Primary Key. |
| order_id | INTEGER | References the order for which the payment was attempted. Foreign Key to `orders.order_id`. |
| payment_method | VARCHAR(30) | Payment method used (Credit Card, Debit Card, UPI, Net Banking, Wallet, Cash on Delivery). |
| transaction_reference | VARCHAR(100) | Unique reference number received from the payment gateway after processing the payment. |
| amount | NUMERIC(10,2) | Amount processed during the payment attempt. |
| payment_status | VARCHAR(20) | Current status of the payment attempt (Pending, Success, Failed, Refunded). |
| payment_gateway | VARCHAR(100) | Name of the payment gateway used (e.g., Razorpay, Stripe, PayPal). |
| payment_time | TIMESTAMP | Timestamp when the payment was processed. |
| created_at | TIMESTAMP | Timestamp when the payment record was created. |

---

## Business Notes

- One order can have multiple payment attempts.
- A payment attempt belongs to exactly one order.
- Payment retries should create new records instead of updating existing ones.
- Each payment gateway generates a unique transaction reference for successful payment processing.
- Payment information is retained for auditing, reconciliation, and customer support.
- Failed payment attempts should not be deleted, as they provide valuable business insights.

---

## Relationships

### Parent Tables

- `orders`
    - `payments.order_id` → `orders.order_id`

### Child Tables

None

Relationship:

```text
Orders (1)
      │
      ▼
Payments (Many)
```

---

## Design Decisions

### Why create a separate Payments table?

An order and a payment represent two different business events.

An order captures the customer's intent to purchase products.

A payment records the financial transaction used to complete that purchase.

Keeping them separate allows the system to support:

- Payment retries
- Payment failures
- Different payment methods
- Refunds
- Payment reconciliation

---

### Why allow multiple payment records for one order?

Customers may retry payment if the initial attempt fails.

Example:

```
Order #1001

↓

Credit Card

↓

Failed

↓

UPI

↓

Success
```

Each attempt is stored as a separate payment record, preserving the complete payment history.

---

### Why store transaction_reference?

Every payment gateway generates a unique transaction reference.

Example:

```
TXN983472348723
```

This value is used for:

- Customer support
- Refund processing
- Payment reconciliation
- Gateway dispute resolution
- Financial audits

The transaction reference must be unique.

---

### Why use payment_status instead of updating existing records?

Each payment attempt has its own lifecycle.

Possible statuses include:

- Pending
- Success
- Failed
- Refunded

Recording the status allows the business to analyze payment failures and monitor gateway performance.

---

### Why use CHECK constraints?

The `payment_method` and `payment_status` columns accept only predefined business values.

This prevents invalid data such as:

```
Card Payment
Paid Successfully
Completed
Done
```

Only approved payment methods and statuses are permitted.

---

## Business Rules

1. Every payment must belong to a valid order.
2. Payment amount cannot be negative.
3. Transaction reference must be unique when provided.
4. Every payment attempt should create a new record rather than updating an existing one.
5. Failed payment attempts should be retained for reporting and analysis.
6. Payment status is independent of the order status.
7. An order may have multiple payment attempts.
8. (Current Project Scope) Only one payment attempt is expected to succeed for an order.
9. Payment information should never be physically deleted once recorded.

---

## Future Enhancements

Future versions of the platform may support:

- Split payments (Gift Card + Credit Card)
- Partial payments
- EMI payments
- Store Credits
- Loyalty Points
- Payment Installments
- Multiple Currency Support
- Payment Gateway Response Codes
- Fraud Detection Score
- Payment Risk Assessment
- Gateway Processing Fees
- Payment Reconciliation Status

---