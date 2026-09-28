# Why DML?

Ab tak sirf khaali dabbe (tables) the. DML se hum data ke saath kaam karte hain: naya data daalna (INSERT), badalna (UPDATE), hatana (DELETE). (SELECT Step 4 mein aayega, wo DQL hai.)

## Command 1: INSERT

- Important rule: Foreign Key ki wajah se order matter karta hai. Pehle parent table, phir child table:

teachers → classes → subjects → students → marks

- Agar classes mein teacher_id = 1 daalna hai aur teachers mein teacher 1 hai hi nahi, to MySQL error dega.

## Syntax:
INSERT INTO table_name (col1, col2) VALUES (val1, val2);

- AUTO_INCREMENT wale ID column ko hum insert mein likhte hi nahi, MySQL khud number deta hai.

## Ab practically chalao, ek ek block:

### -- 1. Teachers (single row pehle)
INSERT INTO teachers (teacher_name, subject_specialization, joining_date, salary)
VALUES ('Rajesh Sharma', 'Mathematics', '2015-06-15', 55000.00);

-- Multiple rows ek saath (ye zyada common hai)
INSERT INTO teachers (teacher_name, subject_specialization, joining_date, salary)
VALUES
('Priya Deshmukh', 'Science', '2018-07-01', 48000.00),
('Amit Patil', 'English', '2019-06-10', 45000.00),
('Sneha Kulkarni', 'Computer Science', '2020-08-20', 52000.00);

### -- 2. Classes
INSERT INTO classes (class_name, teacher_id)
VALUES ('10-A', 1), ('10-B', 2), ('9-A', 3);

### -- 3. Subjects
INSERT INTO subjects (subject_name, class_id)
VALUES
('Mathematics', 1), ('Science', 1), ('English', 1),
('Mathematics', 2), ('Science', 2),
('Computer Science', 3);

### -- 4. Students (Rohan aur Meera ka phone NULL rakha hai, ye baad mein kaam aayega)
INSERT INTO students (first_name, last_name, date_of_birth, gender, admission_date, phone_number, class_id)
VALUES
('Aarav', 'Mehta', '2009-03-12', 'Male', '2020-06-15', '9876543210', 1),
('Diya', 'Shah', '2009-07-25', 'Female', '2020-06-15', '9876543211', 1),
('Rohan', 'Joshi', '2009-11-02', 'Male', '2020-06-16', NULL, 1),
('Ananya', 'Iyer', '2010-01-18', 'Female', '2021-06-14', '9876543213', 2),
('Kabir', 'Singh', '2009-09-30', 'Male', '2020-06-15', '9876543214', 2),
('Meera', 'Nair', '2010-05-05', 'Female', '2021-06-14', NULL, 2),
('Vivaan', 'Gupta', '2011-02-14', 'Male', '2022-06-13', '9876543216', 3),
('Ishita', 'Rao', '2011-08-21', 'Female', '2022-06-13', '9876543217', 3);

### -- 5. Marks
INSERT INTO marks (student_id, subject_id, marks_obtained, exam_date)
VALUES
(1, 1, 85, '2025-03-10'), (1, 2, 78, '2025-03-10'), (1, 3, 90, '2025-03-10'),
(2, 1, 92, '2025-03-10'), (2, 2, 88, '2025-03-10'), (2, 3, 76, '2025-03-10'),
(3, 1, 45, '2025-03-10'), (3, 2, 58, '2025-03-10'), (3, 3, 67, '2025-03-10'),
(4, 4, 72, '2025-03-10'), (4, 5, 81, '2025-03-10'),
(5, 4, 64, '2025-03-10'), (5, 5, 55, '2025-03-10'),
(6, 4, 89, '2025-03-10'), (6, 5, 93, '2025-03-10'),
(7, 6, 70, '2025-03-10'), (8, 6, 95, '2025-03-10');

- Har block ke baad check karo (SELECT ka full syllabus Step 4 mein hai, abhi bas dekhne ke liye):

SELECT * FROM students;
- When: Naya record add karna ho: admission, naya teacher, exam result.

### Beginner mistakes:

- Column list likhna skip karna (INSERT INTO students VALUES (...)). Ye chal jaata hai, lekin agar baad mein ALTER se column add ho gaya to query toot jaayegi. Hamesha column names likho.
- ext aur date ko quotes mein na likhna. 'Aarav' aur '2009-03-12' quotes mein hote hain, numbers nahi.
- Date format galat dena. MySQL ka format 'YYYY-MM-DD' hai, '12-03-2009' nahi.
- Parent se pehle child mein insert karna. Error 1452 aata hai, is wajah se:

-- Ye jaan-boojh ke fail karo, error samajhne ke liye:
INSERT INTO students (first_name, last_name, class_id)
VALUES ('Test', 'Student', 99);
-- Error 1452: Cannot add or update a child row: a foreign key constraint fails

## Command 2: UPDATE

> Syntax:

UPDATE table_name SET col1 = val1, col2 = val2 WHERE condition;

> Examples:

-- Rohan ka phone number add karo
UPDATE students SET phone_number = '9876543212' WHERE student_id = 3;

-- Teacher ki salary 10% badhao
UPDATE teachers SET salary = salary * 1.10 WHERE teacher_id = 1;

-- Ek saath multiple columns
UPDATE teachers
SET subject_specialization = 'Advanced Mathematics', salary = 60000
WHERE teacher_id = 1;

- When: Existing data mein correction ya change: phone badla, marks re-evaluate hue, salary hike.

### Beginner mistakes:

WHERE bhool jaana. Ye sabse khatarnak galti hai. UPDATE teachers SET salary = 0; saare teachers ki salary 0 kar dega. Isliye MySQL Workbench mein Safe Update Mode on hota hai aur Error 1175 deta hai. Isko bypass karne se pehle sochna. Best practice ye hai ki pehle SELECT ... WHERE ... chala ke dekho ki kaunsi rows affect hongi, phir wahi WHERE UPDATE mein lagao.
WHERE mein PRIMARY KEY ke bajaye first_name use karna. Do Rohan hue to dono update ho jaayenge.

## Command 3: DELETE

> Syntax:

DELETE FROM table_name WHERE condition;

> Examples:

-- Ek galat marks entry hatao
DELETE FROM marks WHERE mark_id = 17;

-- Foreign Key ka effect dekho (ye fail hoga):
DELETE FROM students WHERE student_id = 1;
-- Error 1451: Cannot delete or update a parent row

- Student 1 ke marks marks table mein hain, isliye MySQL usko delete nahi karne deta. Pehle child rows delete karni padti hain, phir parent:

DELETE FROM marks WHERE student_id = 8;
DELETE FROM students WHERE student_id = 8;

- When: Specific records hatane hain: student ne school chhod diya, duplicate entry hai.

### Beginner mistakes:

- WHERE bhool jaana. DELETE FROM students; saari rows uda dega, table bachega.
- DELETE aur TRUNCATE ka farak: DELETE ke baad naya insert karo to AUTO_INCREMENT counter wahin se aage badhta hai (ID 9 milegi, 8 nahi), jab ki TRUNCATE counter reset kar deta hai.
- Parent row pehle delete karne ki koshish. Error 1451 aata hai. (Zyada advanced solution ON DELETE CASCADE hai, wo baad mein.)