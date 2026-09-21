1) SELECT + WHERE ---> Data fetch karna aur filter karna
                       Client ka data check karna ho, issue reproduce karna ho — yahi pehla step hai

2) JOIN ---> Multiple tables ka data ek saath dekhna
             Integration mein 2-3 systems ka data milana padta hai — INNER JOIN, LEFT JOIN must hai

3) INSERT / UPDATE ---> Data fix karna ya daalna
                        Integration fail ho gayi, data missing hai — manually fix karna padta hai

4) AND, OR, LIKE, IN, BETWEEN
        - Smart filtering
        - Specific records dhundne ke liye — "is user ka record kahan gaya?"

5) ORDER BY + LIMIT
        - Latest records ya top N records dekhna
        - Last 10 failed transactions ya latest logs dekhna

6) IS NULL / IS NOT NULL
        - Empty/missing data dhundna
        - Integration issue mostly NULL data ki wajah se hota hai — yeh check karna zaroori

CREATE DATABASE integration_db;
USE integration_db;

-- System A: Orders table
CREATE TABLE orders (
  order_id     INT AUTO_INCREMENT PRIMARY KEY,
  customer     VARCHAR(50) NOT NULL,
  amount       DECIMAL(8,2),
  status       VARCHAR(20) DEFAULT 'pending',
  created_at   DATE
);

-- System B: Payments table
CREATE TABLE payments (
  payment_id   INT AUTO_INCREMENT PRIMARY KEY,
  order_id     INT,
  paid_amount  DECIMAL(8,2),
  paid_at      DATE,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO orders (customer, amount, status, created_at) VALUES
('Rahul',   1500.00, 'completed', '2024-01-01'),
('Priya',   2300.00, 'completed', '2024-01-02'),
('Amit',    800.00,  'pending',   '2024-01-03'),
('Sneha',   4500.00, 'completed', '2024-01-04'),
('Ravi',    1200.00, 'failed',    '2024-01-05'),
('Pooja',   900.00,  'pending',   '2024-01-06');

INSERT INTO payments (order_id, paid_amount, paid_at) VALUES
(1, 1500.00, '2024-01-01'),
(2, 2300.00, '2024-01-02'),
(4, 4500.00, '2024-01-04');
-- Notice: order 3,5,6 ka payment nahi aaya!