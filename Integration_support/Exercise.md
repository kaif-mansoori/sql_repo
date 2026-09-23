# STEP 1: Table Setup (Realistic Data with Intentional Issues)

## -- Database create karo
CREATE DATABASE integration_practice;
USE integration_practice;

-- ============================================
-- SYSTEM A: Orders Table
-- ============================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(20)
);

INSERT INTO orders VALUES
(1, 'Rahul Sharma', '2024-01-05', 15000.00, 'Completed'),
(2, 'Priya Singh', '2024-01-08', 8500.00, 'Completed'),
(3, 'Amit Verma', '2024-01-10', 22000.00, 'Completed'),
(4, 'Sneha Patel', '2024-01-12', 5000.00, 'Pending'),
(5, 'Rohit Kumar', '2024-01-15', 12000.00, 'Completed'),
(6, 'Neha Gupta', '2024-01-18', 7500.00, 'Completed'),
(7, 'Vikas Jain', '2024-01-20', 30000.00, 'Cancelled'),
(8, 'Anjali Mehta', '2024-01-22', 9000.00, 'Completed'),
(9, 'Suresh Rao', '2024-01-25', 45000.00, 'Completed'),
(10, 'Pooja Nair', '2024-01-28', 6000.00, 'Pending');

-- ============================================
-- SYSTEM B: Payments Table
-- ============================================
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20)
);

INSERT INTO payments VALUES
(101, 1, '2024-01-06', 15000.00, 'Success'),
(102, 2, '2024-01-09', 8500.00, 'Success'),
(103, 3, '2024-01-11', 20000.00, 'Success'),   -- Order me 22000, yaha 20000 (MISMATCH)
(104, 4, '2024-01-13', 5000.00, 'Success'),
-- Order 5 ka payment record hi nahi hai (MISSING)
(105, 6, '2024-01-19', 7500.00, 'Success'),
(106, 7, '2024-01-21', 30000.00, 'Success'),   -- Order 'Cancelled' hai fir bhi payment aa gaya (EDGE CASE)
-- Order 8 ka payment bhi missing hai
(107, 9, '2024-01-26', 45000.00, 'Success');
-- Order 10 'Pending' hai, isliye payment na hona normal hai

-- ============================================
-- Departments Table
-- ============================================
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing');   -- Iss department mein koi employee nahi hai

-- ============================================
-- Employees Table
-- ============================================
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    join_date DATE
);

INSERT INTO employees VALUES
(1, 'Karan Mehta', 1, 45000, '2022-05-10'),
(2, 'Divya Shah', 2, 38000, '2021-08-15'),
(3, 'Arjun Reddy', 1, 52000, '2023-01-20'),
(4, 'Kavita Joshi', 3, 41000, '2022-11-05'),
(5, 'Manish Tiwari', NULL, 30000, '2023-06-01'),   -- dept assign hi nahi hua (NULL issue)
(6, 'Ritu Malhotra', 99, 35000, '2023-09-12'),     -- dept_id 99 exist hi nahi karta (INVALID FK)
(7, 'Sanjay Kapoor', 2, 48000, '2020-03-25'),
(8, 'Deepika Rao', 1, 55000, '2021-12-18');


## Data mein jo issues plant kiye hain (yaad rakho, ye interview mein bhi kaam aayega):

>Issue Type *             	    Kahan
Missing payment	                Order 5, 8
Amount mismatch	                Order 3
Cancelled order but paid	    Order 7
Employee ka department NULL	    Manish Tiwari
Employee ka dept_id invalid     Ritu Malhotra (dept 99)
(orphan FK)	
Department without employees	Marketing


# SCENARIO 1: Basic Data Check
SELECT + WHERE + AND/OR + LIKE + BETWEEN

## Real Office Situation:
Tumhara manager subah bolta hai — "Aaj sirf completed high-value orders check karne hain, aur kuch customers ka naam search karna hai jinki complaint aayi hai." Ye sabse basic daily task hai — filtering.

Query 1 — AND ka use (dono condition true honi chahiye):