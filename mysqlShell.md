1) shell open karne ke baad agar waha 'JS' hai tu:-
    ==> go sql mode ==> \sql ==> then connect database ==> \connect root@localhost

2) Databases dekhne ke liye :- SHOW DATABASES;

3) Jo data base ko use karna hai/ aur wo database ke andar jane ke liye :-
    USE name_of_database;

4) Kisi database ke andar kitna tables hai wo dekhne ke liye:-
    show tables;

5) Table me new Coloumn add karne ke liye :-
    ALTER TABLE table_name
    ADD coloumn_name datatype;
    
6) Agar already table hai aur usme ham New coloumn add kare hai, tab usme value add karenge aese:-
method1:- UPDATE table_name
          SET column_name = value(jo hame dena hai)
          Where id = 1(jo id pe dena hai);
    
method 2:- UPDATE students      
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

7) Column ka Data Type Change Karna:-
Pehle:-
emp_id INT

Ab maan lo VARCHAR karna hai:-
ALTER TABLE employee
MODIFY emp_id VARCHAR(20);

8) UNIQUE, Primary key, NOT Null, Default Add Karna:-
# Unique:-
- Pehle column normal tha:
    email VARCHAR(100)

- Ab email duplicate nahi hona chahiye:
    ALTER TABLE employee
    ADD UNIQUE (email);

- Ya constraint name ke saath:
    ALTER TABLE employee
    ADD CONSTRAINT uk_email UNIQUE (email);

# PRIMARY KRY:-
- Agar pehle primary key nahi thi:
    ALTER TABLE employee
    ADD PRIMARY KEY (emp_id);

# NOT NULL :-
- Pehle NULL allow tha:
    ALTER TABLE employee
    MODIFY name VARCHAR(50) NOT NULL;

Ab name blank nahi reh sakta.

# DEFAULT :-
ALTER TABLE employee
MODIFY salary INT DEFAULT 10000;

Agar salary nahi doge to automatically 10000 aa jayegi.

9) Group BY and count Concept:-
SELECT stream, COUNT(*)   - Pahale select ke baad coloumn select kari aur wahi couloumn 
FROM students               group by ke aage denge
GROUP BY stream;          - from ke baad table name

10) yeha ham count ko descending order me kar rahe hai:-
SELECT stream, COUNT(*)
FROM students
GROUP BY stream
ORDER BY COUNT(*) DESC;

11) sum karne ke liye:-
SELECT SUM(obtained_marks)
FROM marks;

12) column me average nikalna:-
SELECT stream, AVG(age)
FROM students
GROUP BY stream;

13)  
SELECT kya dikhana hai

FROM kis table se

WHERE kaunse records chahiye

GROUP BY kis basis par group banana hai

ORDER BY result ko kaise sort karna hai

14) Golden Rule: SELECT mein jo bhi column likho — ya toh wo GROUP BY mein hona chahiye, ya kisi aggregate function ke andar. Bas yahi ek rule yaad rakho. 
-- GALAT ❌
SELECT customer_id, amount, SUM(amount)  -- amount GROUP BY mein nahi hai
FROM orders
GROUP BY customer_id;

-- SAHI ✅
SELECT customer_id, SUM(amount)
FROM orders
GROUP BY customer_id;

15) Real job mein kya hota hai:
Koi bhi business dashboard jo tumne dekha hai — "Total sales this month", "Orders per city", "Average order value" — ye sab GROUP BY se banta hai.
Data Analyst ki job ka 60% kaam sirf yahi hota hai:

"Is cheez ko us cheez ke hisaab se group karo aur kuch calculate karo"

Real scenarios:

Finance team: "Har month ka total revenue kya tha?"
Marketing team: "Har city mein kitne customers hain?"
Product team: "Sabse zyada bikne wala product kaunsa hai?"

16) 
