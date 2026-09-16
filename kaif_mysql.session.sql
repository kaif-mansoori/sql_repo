use practise;

SELECT o.customer_id, o.amount, c.customer_name, c.city
from orders o
left join customers c on c.customer_id = o.customer_id;


SELECT o.customer_id, c.customer_name, o.amount
from orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id;

SELECT c.customer_id, c.customer_name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT * from orders;
SELECT * from customers;
SELECT * from products;

SELECT p.product_id, p.product_name, o.order_id, o.qty
from products p
LEFT JOIN order_items o ON o.product_id = p.product_id;

SELECT p.product_id, p.product_name, o.order_id, o.qty
from products p
LEFT JOIN order_items o ON o.product_id = p.product_id
where o.order_id is NULL;


SELECT c.customer_name, o.order_id, oi.product_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id;


SELECT c.customer_name, c.city, o.order_id, o.amount
FROM customers c
RIGHT JOIN orders o ON o.customer_id = c.customer_id;

SELECT p.product_id, p.product_name, p.price, o.order_id
FROM products p
RIGHT JOIN order_items o ON o.product_id = p.product_id;

SELECT c.customer_id, c.customer_name, o.order_id
FROM orders o   
RIGHT JOIN customers c ON c.customer_id=o.customer_id
where o.order_id is NULL;

SELECT c.customer_id, c.customer_name, c.city, o.order_id
FROM orders o 
RIGHT JOIN customers c ON c.customer_id=o.customer_id
WHERE c.city IN ('Mumbai','Chennai')
AND o.order_id is NULL;

SELECT p.product_id, p.product_name, p.category, o.order_id
FROM order_items o
RIGHT JOIN products p ON p.product_id=o.product_id
WHERE p.category = 'Electronics';

SELECT p.product_id, p.product_name, p.category,p.price, o.order_id
FROM order_items o
RIGHT JOIN products p ON p.product_id = o.product_id
where p.price > 5000;

SELECT p.product_id, p.product_name, oi.order_id, o.amount
FROM orders o
RIGHT JOIN order_items oi ON oi.order_id = o.order_id
RIGHT JOIN products p ON p.product_id = oi.product_id;

SELECT c.customer_id, c.customer_name, p.product_name, oi.qty
FROM orders o 
RIGHT JOIN order_items oi ON oi.order_id = o.order_id
RIGHT JOIN products p ON p.product_id = oi.product_id
RIGHT JOIN customers c ON c.customer_id = o.customer_id;

SELECT c.customer_id, c.customer_name, c.city, o.order_id
FROM orders o 
RIGHT JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_id is NULL
ORDER BY c.city;

SELECT count(*) FROM order_items;
SELECT sum(price) FROM products;
SELECT AVG(price) FROM products


SELECT stream, count(*)
from students
GROUP BY stream;

SELECT stream, count(*)
from students
GROUP BY stream
ORDER BY count(*);

SELECT * from marks;

SELECT SUM(obtained_marks)
from marks;

SELECT stream, ROUND(AVG(age), 1)
FROM students
GROUP BY stream;

SELECT * from students;

SELECT stream, count(*)
from students
where age >= 22
GROUP BY stream;

SELECT stream, count(*)
from students
GROUP BY stream;

SELECT age, count(*)
from students
GROUP BY age;

SELECT * from students;
SHOW TABLES;
SELECT * from subject;

SELECT stream, ROUND(AVG(age), 1)
from students
GROUP BY stream;

SELECT stream, count(*)
from students
WHERE age >= 22 
GROUP BY stream;

SELECT stream
from students
WHERE Address = 'Mumbai'
GROUP BY stream;

SELECT stream, ROUND(AVG(age), 1)
from students
WHERE age > 21
Group by stream;

show tables;
SELECT * from students;
SELECT * from subject;
SELECT * from marks;


alter table students
add subject_name varchar(20);

UPDATE students
SET subject_name = case id
    WHEN 2 then 'Mathematics'
    WHEN 3 THEN 'English'
    WHEN 4 then 'Computer'
    WHEN 5 THEN 'History'
    WHEN 6 THEN 'science'
    WHEN 7 THEN 'Mathematics'
    WHEN 8 THEN 'English'
END
WHERE id IN (2, 3, 4, 5, 6, 7, 8);




alter table subject
add id int;

UPDATE subject SET id = 1 WHERE subject_ID = 1;
UPDATE subject SET id = 2 WHERE subject_ID = 2;
UPDATE subject SET id = 3 WHERE subject_ID = 3;
UPDATE subject SET id = 4 WHERE subject_ID = 4;
UPDATE subject SET id = 5 WHERE subject_ID = 5;


SELECT subject_name, count(*)
FROM students
GROUP BY subject_name;

SELECT si.subject_name, COUNT(*)
FROM students s
INNER JOIN subject si ON si.id = s.id
GROUP BY si.subject_name;

SELECT s.subject_name, count(m.subject_id) AS student_count
FROM subject s  
INNER JOIN marks m ON s.subject_ID = m.subject_id
GROUP BY s.subject_name;


SELECT subject_name, count(id) AS student_count
FROM students
GROUP BY subject_name;


SELECT s.subject_name, count(m.student_id)
FROM marks m
INNER JOIN subject s ON s.subject_ID = m.subject_id
GROUP BY s.subject_name;

SELECT s.subject_name, ROUND(AVG(m.obtained_marks), 1)
FROM marks m
INNER JOIN subject s ON s.subject_ID = m.subject_id
GROUP BY s.subject_name;

SELECT s.subject_name, MAX(m.obtained_marks)
FROM marks m
INNER JOIN subject s ON s.subject_ID = m.subject_id
GROUP BY s.subject_name;

SELECT s.subject_name, count(m.student_id) AS student_count
FROM marks m
INNER JOIN subject s ON s.subject_ID = m.subject_id
GROUP BY s.subject_name
ORDER BY student_count DESC 
LIMIT 2;

SELECT s.name, m.obtained_marks AS mark
FROM students s
INNER JOIN subject su ON su.id = s.id
INNER JOIN marks m ON m.subject_id = su.subject_ID
ORDER BY mark DESC;

SELECT s.name, su.subject_name, m.obtained_marks AS mark
FROM students s
INNER JOIN subject su ON su.id = s.id
INNER JOIN marks m ON m.student_id = su.subject_ID 
ORDER BY mark DESC;

SELECT s.name, su.subject_name, m.obtained_marks AS mark
FROM students s
INNER JOIN subject su ON su.id = s.id
INNER JOIN marks m ON m.student_id = su.subject_ID 
ORDER BY mark DESC
LIMIT 3;

SELECT s.subject_name, count(st.name) AS name
FROM students st
INNER JOIN subject s ON st.id = s.id
GROUP BY s.subject_name;

SELECT s.stream, COUNT(s.id) AS total_students
FROM students s
GROUP BY s.stream;

DESC students;


SELECT stream, COUNT(*) AS total_students
FROM students
GROUP BY stream;


ALTER TABLE students ADD COLUMN stream VARCHAR(50);


ALTER TABLE students DROP COLUMN stream;

SELECT stream, COUNT(*) AS total_students
FROM practise.students
GROUP BY stream;

SELECT s.address, COUNT(s.id) AS total_students
FROM practise.students s
GROUP BY s.address;

SELECT s.subject_name, ROUND(AVG(m.obtained_marks), 1) AS Average_marks
FROM practise.subject s
INNER JOIN practise.marks m ON m.subject_ID = s.subject_id
GROUP BY s.subject_name;

SELECT s.subject_name, MAX(m.obtained_marks) AS Highest_marks
FROM practise.subject s
INNER JOIN practise.marks m ON m.subject_ID = s.subject_id
GROUP BY s.subject_name;

SELECT st.name, s.subject_name, m.obtained_marks
FROM practise.students st
INNER JOIN practise.subject s ON s.id = st.id
INNER JOIN practise.marks m ON m.subject_id = s.subject_ID
ORDER BY m.obtained_marks DESC
LIMIT 1;

SELECT s.subject_name, count(m.student_id) AS STUDENTS
FROM practise.subject s
INNER JOIN practise.marks m ON m.subject_id = s.subject_ID
GROUP BY s.subject_name
ORDER BY STUDENTS DESC
LIMIT 3;

SELECT st.name, s.subject_name, m.obtained_marks
FROM students st
INNER JOIN subject s ON s.id = st.id
INNER JOIN marks m ON m.subject_id = s.subject_ID
ORDER BY m.obtained_marks DESC
LIMIT 5;


SELECT st.stream, SUM(m.obtained_marks) AS total_marks
FROM practise.students st
INNER JOIN practise.subject s ON s.id = st.id
INNER JOIN practise.marks m ON m.subject_id = s.subject_ID
GROUP BY st.stream 
ORDER BY total_marks DESC
LIMIT 1;

SELECT st.stream, ROUND(AVG(m.obtained_marks)) AS avg_marks
FROM students st
INNER JOIN subject s ON s.id = st.id
INNER JOIN marks m ON m.subject_id = s.subject_ID
GROUP BY st.stream;


SELECT st.Address, MAX(m.obtained_marks)
FROM students st
INNER JOIN subject s ON s.id = st.id
INNER JOIN marks m ON m.subject_id = s.subject_ID
GROUP BY st.Address;


SELECT st.stream, ROUND(AVG(m.obtained_marks)) AS avg_marks
FROM students st
INNER JOIN subject s ON s.id = st.id
INNER JOIN marks m ON m.subject_id = s.subject_ID
GROUP BY st.stream
ORDER BY avg_marks DESC
LIMIT 3;


SELECT s.subject_name, count(st.id) AS total_students,
MAX(m.obtained_marks) AS Highest_marks,
ROUND(AVG(m.obtained_marks), 1) AS Average_marks
FROM students st
INNER JOIN subject s ON s.id = st.id
INNER JOIN marks m ON m.subject_id = s.subject_ID
GROUP BY s.subject_name;


