# DDL (Data Definition Language)
> Why DDL use karte hain?

- DDL commands database ka structure/skeleton define karte hain — tables, columns, data types. Ye woh commands hain jo database ka blueprint banate hain, actual data nahi. Jab tak structure sahi nahi hoga, data dalna hi possible nahi hoga.

## Command 1: CREATE DATABASE
How:

CREATE DATABASE school_management;
USE school_management;

- When: Sabse pehla step, jab naya project shuru kar rahe ho.

- Beginner mistake: CREATE DATABASE ke baad USE bhool jaate hain, phir confusion hota hai ki tables kis database mein ban rahe hain. MySQL Workbench mein left panel mein schema pe double-click karke bhi "active" kar sakte ho.

## Command 2: CREATE TABLE
How:

CREATE TABLE students (
    student_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    admission_date DATE
);

- Why: Table define karta hai ki har row mein kaunsa data, kis type mein store hoga.

- When: Jab tumhe pata ho entity kya hai (yahan: Student) aur uske attributes kya honge.

- Beginner mistakes:

- Data type galat choose karna — jaise date_of_birth ko VARCHAR bana dena. Dates ke liye hamesha DATE type use karo, warna sorting/filtering mushkil ho jaati hai.
- VARCHAR ki length bilkul soch samajh ke na dena — bahut chhoti (jaise VARCHAR(5) for name) data truncate kar degi.

Filhaal humne Primary Key ya constraints nahi lagaye — wo Step 2 mein sikhenge. Abhi sirf basic structure samjho.

Let's continue banate hain baaki tables bhi (bina constraints ke, abhi ke liye):

CREATE TABLE teachers (
    teacher_id INT,
    teacher_name VARCHAR(50),
    subject_specialization VARCHAR(50),
    joining_date DATE,
    salary DECIMAL(10,2)
);

CREATE TABLE classes (
    class_id INT,
    class_name VARCHAR(20),
    teacher_id INT
);

CREATE TABLE subjects (
    subject_id INT,
    subject_name VARCHAR(50),
    class_id INT
);

CREATE TABLE marks (
    mark_id INT,
    student_id INT,
    subject_id INT,
    marks_obtained INT,
    exam_date DATE
);

- Practice karo: Ye sab tables apne MySQL Workbench mein banao. Phir check karo:

SHOW TABLES;
DESCRIBE students;

- DESCRIBE (ya DESC) command bahut kaam aayega — ye table ki structure dikhata hai (columns, types).

## Command 3: ALTER TABLE

- Why: Table bann chuka hai, lekin agar mistake ho gayi ya requirement badal gayi — column add/remove/modify karna padta hai.

> How (multiple use-cases):
-- Column add karna
ALTER TABLE students ADD COLUMN email VARCHAR(100);

-- Column ka data type modify karna
ALTER TABLE students MODIFY COLUMN gender VARCHAR(15);

-- Column ka naam change karna
ALTER TABLE students CHANGE COLUMN gender sex VARCHAR(15);

-- Column drop karna
ALTER TABLE students DROP COLUMN email;

- When: Jab table already bana hua hai (with or without data) aur structure change karna hai without deleting the table.

> Beginner mistakes:
- MODIFY aur CHANGE mein confuse hote hain — MODIFY sirf data type change karta hai (naam same rehta hai), CHANGE naam bhi change kar sakta hai (isliye usme naya naam + type dono dena padta hai).

- Column drop karne se pehले ye nahi sochte ki uss column pe dependent data ya constraints ho sakte hain (jaise agar wo Foreign Key hai).

## Command 4: DROP TABLE
How:

DROP TABLE subjects;

- Why: Poori table (structure + data + sab kuch) permanently delete karne ke liye.

- When: Jab table ki zaroorat hi nahi rahi — bohot rare situation, production mein bahut soch samajh ke use karte hain.

- Beginner mistake — ye sabse important hai: DROP TABLE aur DELETE/TRUNCATE mein confuse hote hain. DROP table ka structure hi khatam kar deta hai — wapas nahi aa sakta (rollback nahi hota kyunki DDL auto-commit hota hai). Isliye kabhi bhi DROP production database pe bina backup ke mat chalao.

- Chalo abhi ke liye maan lo galti se drop ho gaya — hum isko dubara banayenge next step mein.

## Command 5: TRUNCATE TABLE
How:

TRUNCATE TABLE marks;

- Why: Table ka saara data delete karna hai lekin structure rakhni hai (columns waise hi rahenge, bas rows empty ho jaayengi).

- When: Jab table dubara use karni hai but purana data clear karna hai — jaise naya academic session start hote waqt attendance table clear karna.

> Beginner mistakes:
- Sochte hain TRUNCATE aur DELETE same hain — DELETE (DML command hai) row-by-row delete karta hai aur WHERE clause ke saath specific rows bhi delete kar sakta hai, jabki TRUNCATE poori table ek saath empty kar deta hai aur WHERE clause support nahi karta.

- TRUNCATE bhi DDL hai isliye rollback normally possible nahi (auto-commit ho jaata hai) — is baare mein detail Step 8 (TCL) mein karenge.

## Command 6: RENAME TABLE
How:

RENAME TABLE classes TO class_info;

-- Wapas original naam pe:
RENAME TABLE class_info TO classes;

- Why: Table ka naam change karna without touching data or structure.

- When: Jab naming convention improve karni ho ya requirement change ho jaaye.

- Beginner mistake: Table rename karne ke baad application code ya existing queries mein purana naam reference reh jaata hai, jisse errors aate hain — isliye rename karte waqt dependencies check karo.

# 📝 Ab tumhara practice task:
1) school_management database banao
2) Saari 5 tables banao (students, teachers, classes, subjects, marks)
3) subjects table ko drop karo, phir dubara create karo
4) students table mein ek naya column phone_number VARCHAR(15) add karo
5) marks table ko truncate karo (agar koi data nahi bhi hai to bhi command practice karo)
6) classes table ko rename karke class_details karo, phir wapas classes kar do