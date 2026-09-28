# Constraints
> Why Constraints use karte hain?

- Constraints database mein rules enforce karte hain taaki galat ya duplicate data na aa sake. Step 1 mein humne tables banayi thi bina kisi restriction ke — matlab koi bhi duplicate student_id daal sakta tha, ya NULL name bhi allow ho jaata. Constraints ye sab rokte hain — data integrity maintain karte hain.

- Chalo humari tables ko properly banate hain constraints ke saath. Pehle purani tables drop karte hain aur fresh, sahi tariके se banate hain (real projects mein tum ALTER bhi use kar sakte ho, dono tareeke dikhaunga).

# Constraint 1: PRIMARY KEY

- Why: Har row ko uniquely identify karne ke liye. Har table mein ek column (ya combination) chahiye jo kabhi repeat na ho aur kabhi NULL na ho.

How:
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    admission_date DATE
);

- When: Har table mein hona hi chahiye — bina Primary Key ke table design incomplete maana jaata hai.

## Beginner mistakes:

- Ek table mein do Primary Keys try karna — ek table mein sirf ek Primary Key ho sakti hai (though wo multiple columns ka combination ho sakti hai — usse "Composite Key" bolte hain).
- Primary Key ke liye aisi column choose karna jiski value future mein change ho sakti hai (jaise email ya phone number) — hamesha ek fixed, meaningless ID (jaise student_id) use karo.

# Constraint 2: AUTO_INCREMENT
- Why: Primary Key ki value manually type karna time-waste aur error-prone hai (duplicate ho sakta hai). AUTO_INCREMENT automatically next number generate kar deta hai.

How:
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    admission_date DATE
);

- When: Jab bhi Primary Key numeric ho aur uski value manually decide karne ki zaroorat na ho.

## Beginner mistakes:

- Insert karte waqt student_id ki value manually dena aur phir confuse hona ki auto-increment kaam nahi kar raha — jab AUTO_INCREMENT ho, to us column ko INSERT statement mein chhod do ya NULL pass karo, wo khud number assign karega (Step 3 mein practically dekhenge).
- Row delete karne ke baad sochna ki number wapas reuse hoga — nahi hota, AUTO_INCREMENT sequence continue rehta hai (gaps aa sakte hain, ye normal hai).

# Constraint 3: NOT NULL

- Why: Kuch columns aisi hoti hain jo kabhi khaali nahi honi chahiye — jaise student ka naam. NOT NULL lagane se database force karta hai ki value zaroor do.

How:
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,

- When: Jo bhi column business-critical hai (jiske bina row ka matlab hi nahi banta) uspe NOT NULL lagao.

## Beginner mistakes:
- Har column pe NOT NULL laga dena bina soche — kuch fields genuinely optional hoti hain (jaise middle name, phone number), unpe zabardasti NOT NULL lagane se INSERT karte waqt dikkat hoti hai.
- Default value dena bhool jaana — agar NOT NULL hai aur value nahi di, to error aayega (jab tak DEFAULT na ho).

# Constraint 4: UNIQUE
- Why: Kuch columns Primary Key nahi hoti but unki value phir bhi repeat nahi honi chahiye — jaise email ya phone number. Do students same email se register nahi ho sakte.

How:
email VARCHAR(100) UNIQUE,
phone_number VARCHAR(15) UNIQUE,

- When: Jab column identify karne ke liye nahi hai (wo kaam Primary Key ka hai) but duplicate values business logic ke against hain.

## Beginner mistakes:

- UNIQUE aur PRIMARY KEY mein farak na samajhna — UNIQUE columns NULL allow karti hain (multiple NULLs bhi), lekin PRIMARY KEY kabhi NULL allow nahi karti. Ek table mein multiple UNIQUE columns ho sakte hain, Primary Key sirf ek hi.

# Constraint 5: DEFAULT
- Why: Agar INSERT karte waqt koi value nahi di gayi, to ek predefined value automatically set ho jaaye.

How:
admission_date DATE DEFAULT (CURRENT_DATE),
gender VARCHAR(10) DEFAULT 'Not Specified',

- When: Jab kisi column ki ek common/typical value ho jo mostly same rehti hai, but tum har baar manually type nahi karna chahte.

## Beginner mistakes:
- Sochte hain DEFAULT value NOT NULL ke bina bhi kaam karegi haan wo karti hai, lekin log inko together confuse kar dete hain — DEFAULT sirf "value missing hone par ye daal do" bolta hai, NOT NULL "value zaroor do" bolta hai. Dono alag purpose serve karte hain.

# Constraint 6: CHECK
- Why: Column mein sirf valid range/condition wali values aayein — jaise marks 0-100 ke beech hi ho, salary negative na ho.

How:
marks_obtained INT CHECK (marks_obtained BETWEEN 0 AND 100),
salary DECIMAL(10,2) CHECK (salary > 0),

- When: Jab column ki value ek specific logical range/condition follow karni chahiye.

## Beginner mistakes:
- CHECK constraint MySQL ke purane versions (5.7 se pehle) mein silently ignore ho jaata tha (bina error diye) — MySQL 8.0+ mein properly enforce hota hai. Apna MySQL version check kar lena.
- Bahut complex CHECK conditions likhna jo readable na ho — simple aur clear rakho.

# Constraint 7: FOREIGN KEY (sabse important — relationships banata hai)
- Why: Ye do tables ko connect karta hai. Jaise marks table mein student_id hona chahiye jo students table mein already exist karta ho — koi fake/invalid student_id na daal sake.

How:
CREATE TABLE marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    marks_obtained INT CHECK (marks_obtained BETWEEN 0 AND 100),
    exam_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

- When: Jab bhi ek table ka column doosri table ki Primary Key ko reference kare — ye relational database ka core concept hai.

## Beginner mistakes:

- Order of table creation galat rakhna — jis table ko reference kiya ja raha hai (parent table, jaise students), wo pehle create honi chahiye us table se pehle jo usko reference karti hai (child table, jaise marks).
- Foreign Key hone ke bawajood parent table se row delete karne ki koshish karna jab child table mein uska data already exist karta ho — MySQL error dega (unless ON DELETE CASCADE use kiya ho).
- Data type match nahi karna — Foreign Key column ka data type parent table ki Primary Key se exactly match hona chahiye (INT se INT, VARCHAR se VARCHAR).

# Ab poora schema banate hain — properly, constraints ke saath
DROP DATABASE IF EXISTS school_management;
CREATE DATABASE school_management;
USE school_management;

-- Parent tables pehle
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_name VARCHAR(50) NOT NULL,
    subject_specialization VARCHAR(50),
    joining_date DATE DEFAULT (CURRENT_DATE),
    salary DECIMAL(10,2) CHECK (salary > 0)
);

CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(20) NOT NULL UNIQUE,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10) DEFAULT 'Not Specified',
    admission_date DATE DEFAULT (CURRENT_DATE),
    email VARCHAR(100) UNIQUE,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(50) NOT NULL,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Child table sabse last mein (dono ko reference karti hai)
CREATE TABLE marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    marks_obtained INT CHECK (marks_obtained BETWEEN 0 AND 100),
    exam_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

- Notice karo table creation ka order: teachers → classes → students & subjects → marks. Ye isliye kyunki har table sirf usi table ko reference kar sakti hai jo pehle se exist karti ho.

# 📝 Ab tumhara practice task:
1) Upar wala poora schema apne MySQL Workbench mein run karo
2) DESCRIBE students; chala kar dekho — constraints kaise dikhte hain structure mein
3) Try karo (jaan-boojh kar error create karo, samajhne ke liye):
    - students table mein koi row insert karo bina first_name diye — dekho kya error aata hai (NOT NULL violation)
    - classes table mein ek teacher_id daalne ki koshish karo jo teachers table mein exist hi nahi karta — dekho Foreign Key kaise rokta hai
    - Same class_name do baar insert karne ki koshish karo — UNIQUE constraint ka error dekho

(Insert syntax hum Step 3 mein detail se karenge, but abhi basic INSERT INTO students (first_name) VALUES ('Test'); try kar sakte ho error dekhne ke liye)

4) ALTER TABLE se ek constraint add karke bhi dikhao — jaise:

ALTER TABLE teachers ADD CONSTRAINT chk_salary CHECK (salary >= 10000);