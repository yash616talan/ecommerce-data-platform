# Future Enhancements

## FE-001: Split Payments

### Current Design

Each order supports multiple payment attempts, but only one successful payment.

### Future Enhancement

Allow multiple successful payments for a single order.

Example:

Order Total = ₹2,500

Gift Card = ₹1,000

Credit Card = ₹1,500

### Challenges

- Payment reconciliation
- Partial refunds
- Accounting entries
- ETL validation
- Financial reporting