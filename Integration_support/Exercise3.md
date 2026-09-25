# SCENARIO 4: Summary Report
COUNT + SUM + GROUP BY + HAVING

## Real Office Situation:
Manager weekly meeting ke liye bolta hai — "Status-wise total kitne orders hain aur unka total value kitna hai, aur jo groups 3 se zyada orders wale hain sirf wahi dikhao." Ye aggregation/reporting ka kaam hai.

## Query 1 — Basic summary:

SELECT status, 
       COUNT(*) AS total_orders, 
       SUM(amount) AS total_amount
FROM orders
GROUP BY status;

### Expected Output:

status	    total_orders	total_amount
Completed	7	            137500.00
Pending	    2	            11000.00
Cancelled	1	            30000.00

## Query 2 — HAVING ka use (group filter):

SELECT status, COUNT(*) AS total_orders, SUM(amount) AS total_amount
FROM orders
GROUP BY status
HAVING COUNT(*) > 3;

### Logic samjho — WHERE vs HAVING (interview ka favorite question):

- WHERE — row-level filter hota hai, GROUP BY se pehle apply hota hai.
- HAVING — group-level filter hota hai, GROUP BY ke baad apply hota hai. Aggregate functions (COUNT, SUM, AVG) pe filter sirf HAVING se lagta hai.

### Expected Output (HAVING wali query ka):

status	    total_orders	total_amount
Completed	7	            137500.00

### Interview mein kaise poochha jaata hai:

"WHERE aur HAVING mein kya farak hai, ek example ke saath samjhao."
Iska best jawab hamesha ek query likh ke dena — jaise upar diya — kyunki interviewer verbal answer se zyada practical proof dekhna pasand karta hai.

# SCENARIO 5: Complex Issue — Sab Ek Saath
JOIN + NULL + CASE WHEN

## Real Office Situation:
Ye asli Integration Support ka "hero query" hai — ek hi report mein har order ka status flag dikhana hai: payment mila ya nahi, match kiya ya nahi, sab kuch ek jagah. Client/manager ko baar-baar alag-alag query nahi bhejni — ek dashboard-style output chahiye.

Query:

sql
SELECT 
    o.order_id,
    o.customer_name,
    o.amount AS order_amount,
    p.amount AS payment_amount,
    o.status AS order_status,
    CASE
        WHEN p.payment_id IS NULL THEN 'Payment Missing'
        WHEN o.amount <> p.amount THEN 'Amount Mismatch'
        WHEN o.status = 'Cancelled' AND p.payment_status = 'Success' THEN 'Cancelled but Paid'
        ELSE 'OK'
    END AS issue_flag
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
ORDER BY issue_flag;

## Logic samjho:

LEFT JOIN use kiya (INNER Nahi) kyunki hume missing payments bhi dikhne chahiye — agar INNER JOIN karte to Order 5 aur 8 gayab ho jaate.
CASE WHEN ek "if-else ladder" ki tarah kaam karta hai — top se bottom condition check hoti hai, jo pehli true mile wahi flag lag jaata hai. Isliye order of conditions important hai (pehle NULL check, phir mismatch, phir cancelled-but-paid).
ELSE 'OK' — agar koi issue nahi mila to sab normal hai.

## Expected Output (sample rows):

order_id	customer_name	order_amount	payment_amount	order_status	issue_flag
3	        Amit Verma	    22000.00	    20000.00	    Completed	    Amount Mismatch
7	        Vikas Jain	    30000.00	    30000.00	    Cancelled	    Cancelled but Paid
5	        Rohit Kumar	    12000.00	    NULL	        Completed	    Payment Missing
8	        Anjali Mehta	9000.00	        NULL	        Completed	    Payment Missing
1	        Rahul Sharma	15000.00	    15000.00	    Completed	    OK

## Interview mein kaise poochha jaata hai:

"Aapko ek query likhni hai jo bata de ki kaunsa order OK hai, kaunsa mismatch hai, aur kaunsa payment missing hai — sab ek column mein."
Ye question directly judge karta hai ki tum real Integration Support scenario handle kar sakte ho ya nahi — kyunki asli job mein interviewer yahi expect karta hai: multiple checks ek query mein combine karna.

# 5 Practice Tasks (Khud Solve Karo)
1) Employees + Departments join: Un employees ki list nikalo jinka dept_id departments table mein exist hi nahi karta (orphan record — jaise Ritu Malhotra, dept_id 99). Hint: LEFT JOIN + IS NULL use karoge, lekin employees ko left rakhoge.

2) NULL department wale employees: Un employees ko dhundo jinka dept_id NULL hai, aur unka naam + salary dikhao. Fir socho — agar WHERE dept_id = NULL likhoge to kya hoga, aur kya use karna sahi hai?

3) Department without employees: departments table mein wo department dhundo jisme koi bhi employee assign nahi hai (jaise Marketing). Hint: LEFT JOIN departments se employees, phir IS NULL check.

4) Salary range report: employees table se un logo ko nikalo jinki salary 35000 aur 50000 ke beech hai, AND jo IT department (dept_id = 1) mein hain. WHERE + AND + BETWEEN combine karna hai.

5) Combined issue report (hardest): Ek query banao jo orders aur payments ko join kare aur CASE WHEN use karke ye 4 categories dikhaye: "Payment Missing", "Amount Mismatch", "Refund Needed" (Cancelled + Success payment), aur "Payment OK". Phir GROUP BY karke har category ke total orders count bhi nikalo (ye Scenario 4 + 5 ka combination hoga).