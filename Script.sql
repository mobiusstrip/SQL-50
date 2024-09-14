/* 
LEFT JOIN:Returns all rows from the left table, even if there are no matches in the right table.

RIGHT JOIN:Returns all rows from the right table, even if there are no matches in the left table.

PRIMARY KEY:Unique identifier for each record in a SQL table. 
*/

--#1
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

--#2
SELECT name
FROM Customer
WHERE referee_id!=2 or referee_id is null

--#3
SELECT name, population, area
FROM World
WHERE population>=25000000 or area>=3000000

--#4
SELECT DISTINCT author_id as id
FROM Views
WHERE author_id=viewer_id
ORDER BY id;

--#5
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content)>15

--#6
SELECT EmployeeUNI.unique_id, Employees.name
FROM Employees
LEFT JOIN EmployeeUNI USING(id)

--#7
SELECT customer_id,COUNT(visits.visit_id) AS count_no_trans
FROM Visits
LEFT JOIN Transactions using(visit_id)
where Transactions.transaction_id IS NULL
group by 1; --customer_id

--#8 
SELECT W1.id
FROM Weather W1
JOIN Weather W2
ON W1.recordDate = DATE_ADD(W2.recordDate, INTERVAL 1 DAY)
WHERE W1.temperature > W2.temperature;

--#10
SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b USING(empID)
WHERE b.bonus<1000 OR b.bonus IS NULL

--#11
SELECT a1.machine_id, round(avg(a2.timestamp-a1.timestamp), 3) AS processing_time 
FROM Activity a1
JOIN Activity a2 
ON a1.machine_id=a2.machine_id AND a1.process_id=a2.process_id
AND a1.activity_type='start' AND a2.activity_type='end'
GROUP BY 1

--#12
SELECT s.student_id, s.student_name, su.subject_name, COUNT(e.student_id) as attended_exams
FROM Students s
JOIN Subjects su
LEFT JOIN Examinations e ON s.student_id=e.student_id AND su.subject_name=e.subject_name
GROUP BY s.student_id, su.subject_name
ORDER BY student_id ASC, subject_name ASC

--#13
SELECT e1.name
FROM Employee e1 
JOIN Employee e2 ON e1.id=e2.managerId 
GROUP BY e2.managerId 
HAVING COUNT(e2.managerId) >= 5

--#14
SELECT * 
FROM Cinema
WHERE id%2=1 AND description!="boring"
ORDER BY rating DESC


--#15
SELECT 
s.user_id,
ROUND(AVG(IF(c.action="confirmed",1,0)),2) AS confirmation_rate
FROM Signups AS s
LEFT JOIN Confirmations as c USING(user_id)
GROUP BY 1;


--#16
SELECT p.product_id, IFNULL(ROUND(SUM(units*price)/SUM(units),2),0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u 
ON p.product_id = u.product_id AND
u.purchase_date 
BETWEEN start_date AND end_date
group by product_id

--#17
SELECT continent,
COUNT(name) as countries
FROM world
WHERE population>=10000000
GROUP BY continent
--#WHERE VS HAVING (ALREAD GROUPED)
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000

--#18
SELECT name
FROM actor
JOIN casting on actor.id=casting.actorid
WHERE casting.ord=1
GROUP BY name
HAVING COUNT(name)>14

--#19
SELECT query_name, 
ROUND(AVG(rating/position),2) AS quality,
ROUND(AVG(rating < 3) * 100, 2) AS poor_query_percentage 
FROM Queries
GROUP BY query_name

--#26
SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt 
FROM Teacher t
GROUP BY 1;

--#27
SELECT * FROM Customers
WHERE Country IN ('Germany', 'France', 'UK');
--You can also use IN with a subquery in the WHERE clause.
SELECT * FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders);

--#28
SELECT *,  --need , after  *
IF(x+y>z AND y+z>x AND z+x>y, "Yes", "No") AS triangle
FROM Triangle

--#22
SELECT 
ROUND(AVG(order_date = customer_pref_delivery_date)*100, 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id,order_date) 
IN 
(
SELECT customer_id, min(order_date)
FROM Delivery 
GROUP BY customer_id
)

--#29
SELECT customer_id 
FROM Customer
GROUP BY 1
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM product)

--#23
--List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name
FROM actor
JOIN casting ON id=actorid
WHERE movieid 
IN 
(
SELECT movieid
FROM casting
JOIN actor ON (actorid=id AND name='Art Garfunkel')
)
AND name != 'Art Garfunkel'
GROUP BY name

--#29 --SUBQUERY
SELECT MAX(num) AS num
FROM (SELECT num FROM MyNumbers GROUP BY num HAVING COUNT(num) = 1) AS unique_numbers

--#28
SELECT e1.employee_id,
e1.name,
COUNT(e2.reports_to) AS reports_count,
ROUND(AVG(e2.age)) AS average_age
FROM Employees e1
JOIN Employees e2 ON e1.employee_id=e2.reports_to
GROUP BY 1


----------------------------------------------------------------


--#20
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
country, 
COUNT(id) AS trans_count, 
SUM(IF(state = 'approved',1,0)) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(IF(state = 'approved',amount,0)) AS approved_total_amount
FROM  Transactions
GROUP BY month,country

--#21
SELECT contest_id,
ROUND(COUNT(user_id)*100/(SELECT Count(user_id) from Users),2) AS percentage
FROM Register r
GROUP BY r.contest_id
ORDER BY percentage DESC,contest_id

--#24
SELECT AVG(purchase_value)
CASE WHEN purchase_value > 0 THEN 1 ELSE 0 END as conversion_rate
FROM OrderDetails;

--#28
SELECT s1.product_id,first_year, quantity, price
FROM Sales s1
JOIN (SELECT product_id, MIN(year) first_year FROM Sales GROUP BY 1) s2
ON s1.product_id = s2.product_id AND s1.year=s2.first_year

--#30
WITH CTE AS 
(
SELECT num,
lead(num,1) OVER() num1,
lead(num,2) OVER() num2
FROM logs
)
SELECT DISTINCT num AS ConsecutiveNums FROM cte WHERE (num=num1) AND (num=num2)

--#31
SELECT DISTINCT product_id, 10 AS price FROM Products
WHERE product_id NOT IN
(SELECT distinct product_id FROM Products WHERE change_date <='2019-08-16' )
UNION 
SELECT product_id, new_price AS price FROM Products
WHERE (product_id,change_date) IN 
(SELECT product_id , max(change_date) AS date FROM Products WHERE change_date <='2019-08-16' GROUP BY product_id)

--#32
SELECT person_name FROM
(SELECT person_name, weight, turn, sum(weight) OVER(ORDER BY turn) AS cum_sum
FROM Queue) x
WHERE cum_sum <= 1000
ORDER BY turn DESC
LIMIT 1,1

--#33
SELECT "Low Salary" AS category,
sum(income < 20000) AS accounts_count
FROM Accounts

UNION

SELECT "Average Salary" AS category,
sum(income BETWEEN 20000 AND 50000) AS accounts_count
FROM Accounts

UNION

SELECT "High Salary" AS category,
sum(income > 50000) AS accounts_count
FROM Accounts;

--#33
SELECT 
CASE 
WHEN id = (SELECT MAX(id) FROM seat) AND id % 2 = 1
THEN id 
WHEN id % 2 = 1
THEN id + 1
ELSE id - 1
END AS id,student
FROM seat
ORDER BY id

--#33
(
SELECT name AS results
FROM Users u
JOIN MovieRating m USING(user_id) 
GROUP BY 1
ORDER BY COUNT(rating) DESC, name
LIMIT 1
)
UNION
(
SELECT title as results
FROM Movies 
JOIN MovieRating USING(movie_id)
WHERE MONTH(created_at)="02" AND YEAR(created_at)="2020"
GROUP BY 1
ORDER BY AVG(rating) DESC, title
LIMIT 1
)

--#33
SELECT
visited_on,
(
SELECT SUM(amount)
FROM customer
WHERE visited_on BETWEEN
DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on) AS amount,
ROUND((SELECT SUM(amount) / 7
FROM customer
WHERE visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY) AND c.visited_on
),2) AS average_amount
FROM customer c
WHERE visited_on >= 
(SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY)
FROM customer)
GROUP BY visited_on;

--#33
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN 
(
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN 
(
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)

--#33
SELECT Department, employee, salary 
FROM 
(
SELECT d.name AS Department,
e.name AS employee,
e.salary,
DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS drk
FROM Employee e JOIN Department d ON e.DepartmentId= d.Id
) 
t WHERE t.drk <= 3
--#33



--------------------------------------------------

--#34
SELECT user_id,
CONCAT(UPPER(SUBSTR(name,1,1)) , LOWER(SUBSTR(name,2,length(name)))) AS name
FROM Users ORDER BY user_id;

--#35
SELECT patient_id,patient_name,conditions
FROM Patients
WHERE conditions LIKE "%DIAB1%"

--#36
SELECT *
FROM your_table_name
WHERE name LIKE '%c%';

--#37
DELETE p1
FROM person p1,person p2 
WHERE p1.email=p2.email AND p1.id>p2.id;

--#38
SELECT
(
SELECT DISTINCT salary 
FROM Employee
ORDER BY 1 DESC
LIMIT 1,1
)
AS SecondHighestSalary

--#39
SELECT sell_date, count(DISTINCT product) AS num_sold ,
GROUP_CONCAT( DISTINCT product separator ',' ) AS products
FROM Activities
GROUP BY 1
ORDER BY 1 ASC;

--#40
SELECT p.product_name AS product_name, sum(o.unit) AS unit FROM Products p
JOIN Orders o USING (product_id)
WHERE YEAR(o.order_date)='2020' AND MONTH(o.order_date)='02'
GROUP BY p.product_id
HAVING SUM(o.unit)>=100

--#41
SELECT *
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_\.\-]*@leetcode(\\?com)?\\.com$';
