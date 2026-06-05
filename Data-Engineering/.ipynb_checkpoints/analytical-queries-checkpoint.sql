-- ==============================================================================
-- MAIN PROJECT: Online Store Data Gathering
-- PURPOSE: Grouping and pulling customer shop files to check for financial habits.
-- ==============================================================================

-- This tells the system to look inside the "my_guitar_shop" database folder.
USE my_guitar_shop;

-- This script links four separate lists (Customers, Orders, 
-- Items Bought, and Products) together. It creates a single, clean 
-- summary page showing buyer names, the dates they shopped, 
-- what they bought, the standard prices, and any discounts given.

SELECT 
    c.last_name, 
    c.first_name, 
    o.order_date, 
    p.product_name, 
    oi.item_price, 
    oi.discount_amount, 
    oi.quantity
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
ORDER BY 
    c.last_name ASC, 
    o.order_date ASC, 
    p.product_name ASC;

-- This adds a brand new person named Rick Raven and his email address directly into our customer directory sheet.

INSERT INTO customers (email_address, password, first_name, last_name)
VALUES ('rick@raven.com', '', 'Rick', 'Raven');

-- This searches our customer directory to find Rick Raven's email. 
-- We run this to double-check that his information was saved correctly and can be found without any errors.
SELECT * FROM customers 
WHERE email_address = 'rick@raven.com';