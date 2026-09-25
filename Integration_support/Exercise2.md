# SCENARIO 2: Missing Data Dhundna
LEFT JOIN + IS NULL

## Real Office Situation:
Finance team ka email aata hai — "Kuch orders ka payment System B mein show nahi ho raha, list bhejo jinka payment miss hai." Ye Integration Support ka sabse common daily task hai — do systems ke beech "gap" dhundna.

## Query:

SELECT o.order_id, o.customer_name, o.amount, o.status
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

## Logic samjho:

- LEFT JOIN matlab — orders table ki saari rows rakho, payments jo match kare wo attach karo, jo match na kare wahan NULL aa jayega.
- WHERE p.payment_id IS NULL — matlab sirf wo rows chahiye jinke liye koi matching payment row hi nahi mili.

## Expected Output:

order_id	customer_name	amount	    status
5	        Rohit Kumar	    12000.00	Completed
8	        Anjali Mehta	9000.00	    Completed

- Notice karo — Order 10 (Pending) yahan nahi aaya, kyunki Pending order ka payment na hona normal hai, real issue sirf Completed status wale orders ke liye hai. Isliye real scenario mein query aise refine karoge:

SELECT o.order_id, o.customer_name, o.amount, o.status
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL
AND o.status = 'Completed';

- Ye "genuine issue" list hai jo tum client ko bhejoge.

> Interview mein kaise poochha jaata hai:

"Do tables hain, System A aur System B. Aapko wo records dhundne hain jo A mein hain but B mein missing hain — query likho."
Ye almost hamesha LEFT JOIN + IS NULL pattern se poochha jata hai. Interviewer kabhi-kabhi ye bhi poochta hai — "LEFT JOIN aur INNER JOIN mein farak kya hai?" — jawab: INNER JOIN sirf matching rows deta hai, LEFT JOIN left table ki saari rows deta hai chahe match ho ya na ho.


# SCENARIO 3: Data Mismatch Dhundna
INNER JOIN + Amount Comparison

## Real Office Situation:
Client complaint karta hai — "Maine 22000 pay kiya tha, but system mein 20000 dikha raha hai." Yahan dono systems mein record to hai, lekin values match nahi kar rahi. Ye reconciliation ka core kaam hai.

Query:

SELECT o.order_id, o.customer_name, 
       o.amount AS order_amount, 
       p.amount AS payment_amount,
       (o.amount - p.amount) AS difference
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id
WHERE o.amount <> p.amount;

## Logic samjho:

- INNER JOIN — sirf wo records chahiye jo dono tables mein exist karte hain (matching order_id).
- <> matlab "not equal to" — jahan dono amounts alag hain wahi rows chahiye.
- difference column banaya taaki turant pata chale kitna farak hai — ye real work mein bahut useful hota hai kyunki client ko exact gap batana padta hai.

## Expected Output:

order_id	customer_name	order_amount	payment_amount	difference
3	        Amit Verma	    22000.00	    20000.00	    2000.00

- Bonus check — Cancelled order but payment mila (Order 7):

SELECT o.order_id, o.customer_name, o.status, p.amount, p.payment_status
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'Cancelled' AND p.payment_status = 'Success';

- Ye ek aur real-world red flag hai — order cancel ho gaya but payment phir bhi successful hai, refund pending ho sakta hai.

> Interview mein kaise poochha jaata hai:
"Do tables mein common records hain, but ek column ki value dono mein alag-alag hai. Un mismatched rows ko nikalo."
Interviewer yaha check karta hai ki tumhe INNER JOIN aur comparison operators ka combination pata hai ya nahi — aur kya tum "difference" jaisa calculated column bana sakte ho.