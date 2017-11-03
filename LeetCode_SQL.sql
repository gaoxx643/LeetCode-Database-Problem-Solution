# LeedCode - SQL176
SELECT DISTINCT 
	Salary AS SecondHighestSalary
FROM
	Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1	

(SELECT DISTINCT 
	Salary
FROM
	Employee t1
JOIN Employee t2 on t1.Salary <= t2.Salary	
GROUP BY 1
HAVING count(*) = 2) AS SecondHighestSalary


SELECT
(SELECT DISTINCT 
	Salary
From Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1) AS SecondHighestSalary

SELECT 
	(SELECT DISTINCT
	t1.Salary
	FROM Employee t1
	JOIN Employee t2 on t1.Salary <= t2. Salary
	GROUP BY 1
	HAVING COUNT(*) = 2) AS SecondHighestSalary


# LeedCode - SQL177
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write MySQL query statement below.
	  IFNULL(
	  (SELECT DISTINCT Salary
	  FROM Employee
	  ORDER BY Salary DESC
	  LIMIT 1 OFFSET N),
	  NULL)
      );
END

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N = N - 1;
  RETURN (
      # Write MySQL query statement below.
	  SELECT DISTINCT Salary
	  FROM Employee 
	  GROUP BY Salary
	  ORDER BY Salary DESC LIMIT 1 OFFSET N);
END

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write MySQL query statement below.
	  SELECT MAX(Salary)
	  FROM Employee e1
	  WHERE N - 1 = (SELECT COUNT(DISTINCT(e2.Salary)
	  				FROM Employee e2
					WHERE e2.Salary > e1.Salary)
	  );
END

# LeedCode - SQL178
SELECT Score, 
	 (SELECT Count(DISTINCT Score) FROM Scores WHERE Score >= s.Score) RANK
FROM Scores s 
ORDER BY Score DESC

SELECT s.Score, COUNT(DISTINCT t.Score) RANK
FROM Scores s JOIN Scores t ON s.Score <= t.Score
GROUP BY s.Id 
ORDER BY s.Score DESC;

SELECT s.Score, 
	(SELECT COUNT(DISTINCT Score) FROM Scores WHERE Score >= s.Score) RANK
FROM Scores s
ORDER BY s.Score DESC

# LeedCode - SQL180
SELECT DISTINCT 
		l1.Num AS ConsecutiveNums
FROM Logs l1,
	 Logs l2,
	 Logs l3
WHERE
	 l1.Id = l2.Id - 1
	 AND l2.Id = l3.Id -1 
	 AND l1.Num = l2.Num
	 AND l2.Num = l3.Num
	;
 
SELECT DISTINCT
	l1.Num AS ConsecutiveNums
FROM Logs l1 
LEFT JOIN Logs l2 on l1.Id = (l2.Id - 1)
LEFT JOIN Logs l3 on l2.Id = (l3.Id - 1)
WHERE l1.Num = l2.Num
AND l2.Num = l3.Num
;
 
# LeedCode - SQL181	
SELECT a.Name AS Employee
FROM Employee a JOIN Employee b 
ON a.ManagerId = b.Id AND a.Salary > b.Salary

SELECT a.Name AS Employee
FROM Employee a,
	 Employee b
WHERE a.ManagerId = b.Id AND a.Salary > b.Salary

# LeedCode - SQL182
SELECT DISTINCT a.Email AS Email
FROM Person a,
	 Person b
WHERE a.Email = b.Email AND a.Id <> b.Id

SELECT DISTINCT a.Email AS Email
FROM Person a JOIN Person b
ON a.Email = b.Email AND a.Id <> b.Id

SELECT DISTINCT Email
FROM Person
GROUP BY Email
HAVING Count(Email) > 1


# LeedCode - SQL183
SELECT c.Name AS Customers
FROM Customers c
WHERE c.Id NOT IN (SELECT CustomerID FROM Orders)

SELECT c.Name AS 'Customers'
FROM Customers c LEFT JOIN Orders o
ON c.Id = o.CustomerId
WHERE o.CustomerId IS NULL

# LeedCode - SQL184
SELECT DISTINCT d.Name AS 'Department', 
		e.Name AS 'Employee',
		e.Salary AS 'Salary'
FROM Employee e
JOIN Department d
ON e.DepartmentId = d.Id
WHERE (e.DepartmentId, e.Salary) IN
     (SELECT DepartmentId, Max(Salary) FROM Employee GROUP BY DepartmentId)
	 
SELECT d.name AS 'Department',
	   e.name AS 'Employee',
	   e.Salary AS 'Salary'
From Employee e,
	Department d
WHERE e.DepartmentId = d.ID AND
	(e.DepartmentId, e.Salary) IN
	(SELECT DepartmentId, Max(Salary) FROM Employee GROUP BY DepartmentID)
	
# LeedCode - SQL185
SELECT DISTINCT d.Name AS 'Department', 
		e1.Name AS 'Employee',
		e1.Salary AS 'Salary'
FROM Employee e1
JOIN Department d
ON e1.DepartmentId = d.Id  
WHERE 3 >(SELECT COUNT(DISTINCT e2.Salary) FROM Employee e2 WHERE e2.Salary > e1.Salar AND
		e1.DepartmentId = e2.DepartmentId)
; 

# how to return top 3 salaries regardless department
SELECT e1.Name AS 'Employee', e1.Salary AS 'Salary'
FROM Employee e1
WHERE 3 > (SELECT COUNT(DISTINCT e2.Salary)
			FROM Employee e2 WHERE e2.Salary > e1.Salary)

# how to return top 3 salaries by department
SELECT e1.Name AS 'Employee', e1.Salary AS 'Salary'
FROM Employee e1
WHERE 3 > (SELECT COUNT(DISTINCT e2.Salary)
			FROM Employee e2
			WHERE e2.Salary > e1.Salary AND e2.Department = e1.Department)
		; 

# LeedCode - SQL196
# keep unique email with small Id
SELECT DISTINCT p.Email as 'Email', p.Id as 'Id'
FROM Person p,
	Perspn q
WHERE p.Email = q.Email AND p.Id < q.Id

# Delete duplicate email with large Id
Delete p1.*	FROM Person p1,
			Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id

# LeedCode - SQL197
SELECT w.Id
FROM Weather w,
	Weather q
WHERE DATEDIFF(w.Date, q.Date) = 1 AND w.Temperature > q.Temperature

SELECT w.Id
FROM Weather w 
JOIN Weather q
 ON DATEDIFF(w.Date, q.Date) = 1 AND w.Temperature > q.Temperature
 
 # LeedCode - SQL262
SELECT t.Request_at AS 'Day',
		ROUND(SUM(IF(t.Status = 'completed', 0, 1))/COUNT(*), 2) AS 'Cancellation Rate'
From Trips t
LEFT JOIN Users u
ON t.Client_Id = u.Users_Id
WHERE u.Banned = 'No' AND t.Request_at between '2013-10-01' AND '2013-10-03'
GROUP BY t.Request_at

# LeedCode - SQL569
SELECT e.ID AS 'ID',
	e.Company AS 'Company',
	e.Salary AS 'Salary'
FROM Employee e,
	Employee e1
WHERE e.Company = e1.Company
GROUP BY e.Company, e.Salary
HAVING  SUM(CASE WHEN e.Salary = e1.Salary THEN 1 ELSE 0 END) >=
		ABS(SUM(SIGN(e.Salary - e1.Salary)))
ORDER BY e.Id

# LeedCode - SQL570
SELECT e.Name AS 'Name'
FROM Employee e
WHERE e.Id IN
		(SELECT
			 e1.ManagerId
		 FROM
		 	 Employee e1
		  GROUP BY e1.ManagerId
		  HAVING Count(e1.ManagerId) >= 5)
		  
SELECT e.Name AS 'Name'
FROM Employee e JOIN
	(SELECT ManagerId
		FROM Employee
		GROUP BY ManagerId
		HAVING COUNT(ManagerId) >= 5) AS e1
ON e.Id = e1.ManagerId


# LeedCode - SQL571
SELECT AVG(Number) AS median
FROM (SELECT Number, Frequency, AccFreq, SumFreq 
		FROM (SELECT Number,
					Frequency, @curFreq := @curFreq + Frequency AS AccFreq
					FROM Numbers n, (SELECT @curFreq := 0) r 
					ORDER BY Number) t1,
		(SELECT SUM(Frequency) SumFreq FROM Numbers) t2
		) t
WHERE AccFreq BETWEEN SumFreq / 2 AND SumFreq / 2 + Frequency

# LeedCode - SQL574
SELECT Name AS 'Name'
FROM Candidate c JOIN 
					(SELECT Candidateid
					FROM Vote v
					GROUP BY Candidateid
					ORDER BY COUNT(*) DESC
					LIMIT 1) AS 'w'
WHERE c.id = w.Candidateid

SELECT Name AS 'Name'
FROM Candidate c JOIN Vote v
ON c.id = v.Candidatedid
GROUP BY v.Candidateid
ORDER BY COUNT(*) DESC LIMIT 1

# LeedCode - SQL577
SELECT e.name AS 'name', 
		b.bonus AS 'bonus'
FROM Employee e LEFT JOIN Bonus b
ON e.empId = b.empId
WHERE bonus < 1000 OR bonus IS NULL

# LeedCode - SQL578
SELECT question_id AS 'survey_log'
FROM (SELECT question_id,
	SUM(CASE action = 'answer' THEN 1 ELSE 0 END) AS num_answer,
	SUM(CASE action = 'show' THEN 1 ELSE 0 END) AS num_show
	FROM survey_log
	GROUP BY question_id
	) as tb1
ORDER BY (num_answer/num_show) DESC LIMIT 1
		
SELECT question_id AS 'survey_log'
FROM survey_log
GROUP BY question_id
ORDER BY COUNT(answer_id)/COUNT(IF(action = 'show', 1, 0)) DESC LIMIT 1

# LeedCode - SQL579
## Get the cumulative sum of an employee salary over 2 mons by joining the table with itself
SELECT *
FROM Employee E1
LEFT JOIN Employee E2
ON (E1.id = E2.id AND E2.month = E1.month - 1)
ORDER BY E1.id ASC, E1.month DESC

## Then we can add the salary to get the cumulatibe sum for 2 mons
SELECT E1.id,
	   E1.month,
	   (IFNULL(E1.salary,0) + IFNULL(E2.salary,0)) AS 'Salary'
FROM Employee E1
	LEFT JOIN Employee E2
	ON (E2.id = E1.id AND E2.month = E1.month - 1)
ORDER BY E1.id ASC, E1.month DESC

## Similarly, join this table one more time to get the cumulative sum for 3 mons
SELECT E1.id,
	   E1.month,
	   (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary, 0)) AS 'Salary'
FROM Employee E1
	 LEFT JOIN Employee E2
	 ON (E2.id = E1.id AND E2.month = E1.month - 1)
	 LEFT JOIN Employee E3
	 ON (E3.id = E1.id AND E3.month = E1.month -2)
ORDER BY E1.id ASC, E1.month DESC

## generate a table including every id and most recent month
SELECT id, Max(month) AS month
FROM Employee
GROUP BY id
HAVING COUNT(*) > 1

## Put all the sub-queries above together
SELECT E1.id,
	   E1.month,
	   (IFNULL(E1.salary,0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary,0)) AS Salary
FROM
	(SELECT id, MAX(month) AS month
	FROM Employee
	GROUP BY id
	HAVING COUNT(*) > 1) AS maxmonth
		LEFT JOIN
	Employee E1 ON (maxmonth.id = E1.id 
		AND maxmonth.month > E1.month)
		LEFT JOIN
	Employee E2 ON (E2.id = E1.id
		AND E2.month = E1.month - 1)
		LEFT JOIN
	Employee E3 ON (E3.id = E1.id
		AND E3.month = E1.month - 2)
ORDER BY id ASC, month DESC
; 
	
# LeedCode - SQL580
SELECT d.dept_name AS 'dept_name',
		COUNT(s.student_id) AS 'student_number'
FROM department d 
LEFT OUTER JOIN student s ON
		  d.dept_id = s.dept_id
GROUP BY d.dept_name
ORDER BY student_number DESC, d.dept_name
; 
	
# LeedCode - SQL584
SELECT name
FROM customer
where referee_id <> 2 OR referee_id IS NULL

SELECT name
FROM customer
WHERE referee_id != 2 OR referee_id IS NULL

# LeedCode - SQL585
SELECT SUM(i.TIV_2016) as 'TIV_2016'
FROM insurance i
WHERE i.TIV_2015 IN
	(
	SELECT
		TIV_2015
	FROM 
		insurance
	GROUP BY TIV_2015
	HAVING COUNT(*) > 1
	)
   AND CONCAT(i.LAT, i.LON) IN
   (
   SELECT 
   		CONCAT(LAT, LON)
   FROM 
   		insurance
   GROUP BY LAT, LON
   HAVING COUNT(*) = 1
   )
 ; 
 
# Leedcode problem - SQL 586
SELECT customer_number AS 'customer_number'
FROM orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC LIMIT 1
;  

# Leedcode problem - SQL 595
SELECT name,
	   population,
	   area
FROM World
WHERE area > 3000000 OR population > 25000000
ORDER BY name

# Leedcode problem - SQL 596
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5

## by sub-query
SELECT class
FROM 
	(SELECT 
		  class, COUNT(DISTINCT student) AS num
	 FROM courses
	 GROUP BY class) AS temp_table
WHERE num >= 5
; 

# Leedcode problem - SQL 597

 
 SELECT ROUND(
			 IFNULL(
			 (SELECT COUNT(*) FROM (SELECT DISTINCT requester_id, accepter_id FROM request_accepted) AS A)
			 /
             (SELECT COUNT(*) FROM (SELECT DISTINCT sender_id, send_to_id FROM friend_request) AS B),
			 0)
			 , 2) as accept_rate
; 

SELECT ROUND(
			IFNULL(
			(SELECT COUNT(DISTINCT requester_id, accepter_id) FROM request_accepted) /
			(SELECT COUNT(DISTINCT sender_id, send_to_id) FROM friend_request),
			0), 2) AS accept_rate
; 


# Leedcode problem - SQL 601
SELECT distinct s1.*
from stadium s1,
	 stadium s2,
	 stadium s3
WHERE s1.people >= 100 and s2.people >= 100 and s3.people >= 100
AND (
	 (s1.id - s2.id = 1 AND s1.id - s3.id = 2 AND s2.id - s3.id = 1)
	  or
	 (s2.id - s1.id = 1 AND s2.id - s3.id = 2 AND s1.id - s3.id = 1)
	  or
	 (s3.id - s2.id = 1 AND s3.id - s1.id = 2 AND s2.id - s1.id = 1)
	 )
ORDER BY s1.id
; 

 
 # Leedcode problem - SQL 602
 SELECT ids AS 'id', 
 		cnt AS 'num'
 FROM 
 	(SELECT ids, count(*) as 'cnt'
 	 FROM 
 		(SELECT requester_id AS 'ids' FROM requested_accepted
 		 UNION ALL
 		 SELECT accepter_id FROM requested_acepted) AS tb1
  	 GROUP BY ids) AS tb2
 ORDER BY cnt DESC LIMIT 1
 ; 
 
 SELECT ids AS 'id', count(*) AS 'num'
 FROM
 	 (SELECT requester_id AS 'ids' FROM requested_accepted
	  UNION ALL
	  SELECT accepter_id FROM requested_accepted
	  )
 GROUP BY ids
 ORDER BY ids DESC 
 LIMIT 1
 ; 

 # Leedcode problem - SQL 603
 SELECT DISTINCT c1.seat_id AS 'seat_id'	
 FROM cinema c1,
 	  cinema c2,
WHERE c1.free = 1 AND c2.free = 1
AND (c2.seat_id - c1.seat_id = 1 OR c1.seat_id - c2.seat_id = 1)
ORDER BY seat_id
;  

SELECT DISTINCT c1.seat_id AS 'seat_id'
FROM cinema c1
JOIN c1nema c2
ON abs(c1.seat_id - c2.seat_id) = 1
AND c1.free = 1 AND c2.free = 1
ORDER BY c1.seat_id
; 

# Leedcode problem - SQL 607
SELECT s.name
FROM salesperson s
WHERE s.sales_id NOT IN
		(SELECT o.sales_id
		FROM orders o
		WHERE o.com_id = 1)

## Approach 2
SELECT s.name AS 'name'
FROM salesperson s
WHERE s.sales_id NOT IN
				(SELECT o.sales_id
				FROM orders o LEFT JOIN company c
				ON o.com_id = c.com_id
				WHERE 
					c.name = "RED")

 # Leedcode problem - SQL 608
 ## define 'Root'
 SELECT id, 'Root' AS 'Type'
 FROM tree
 WHERE p_id IS NULL
 
 ## define leaf 
 SELECT id, 'leaf' AS 'Type'
 FROM tree
 WHERE p_id NOT IN (
 					SELECT DISTINCT p_id
					FROM tree
					WHERE p_id IS NOT NULL)
		AND p_id IS NOT NULL
		
## define inner
SELECT id, 'inner' AS 'Type'
FROM tree
WHERE p_id IN (
			   SELECT DISTINCT p_id
			   FROM tree
			   WHERE p_id IS NOT NULL)
		 AND p_id IS NOT NULL
	
## combine these queries together using union
SELECT id, 'Root' AS 'Type'
 FROM tree
 WHERE p_id IS NULL
UNION
 SELECT id, 'leaf' AS 'Type'
 FROM tree
 WHERE p_id NOT IN (
 					SELECT DISTINCT p_id
					FROM tree
					WHERE p_id IS NOT NULL)
		AND p_id IS NOT NULL
UNION
SELECT id, 'inner' AS 'Type'
FROM tree
WHERE p_id IN (
			   SELECT DISTINCT p_id
			   FROM tree
			   WHERE p_id IS NOT NULL)
		 AND p_id IS NOT NULL
ORDER BY id
; 

## Approach two by using case when
SELECT t1.id,
		CASE WHEN t1.id = (SELECT t2.id FROM tree t2 WHERE t2.p_id IS NULL)
		THEN 'Root'
		WHEN t1.id IN (SELECT t2.p_id FROM tree t2)
		THEN 'Inner'
		ELSE 'Leaf'
		END AS Type
FROM tree t1
ORDER BY t1.id
; 

## Approach three by using if
SELECT t1.id,
	  IF(ISNULL(t1.p_id), 'Root',
	  IF(t1.id IN (SELECT t2.p_id FROM tree t2), 'Inner', 'Leaf')) AS 'Type'
FROM tree t1
ORDER BY t1.id
; 
 	
# Leedcode problem - SQL 610
SELECT x, y, z
	   CASE x + y > z AND x + z > y AND y + z > x THEN 'Yes'
	   ELSE 'No'
	   END AS 'triangle'
FROM triangle

# Leedcode problem - SQL 612
SELECT ROUND(SQRT(MIN(POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2))),2) AS 'shortest'
FROM point_2d p1
JOIN point_2d p2 ON p1.x != p2.x or p1.y != p2.y

# Leedcode problem - SQL 613
SELECT MIN(ABS(p1.x - p2.x)) AS 'shortest'
FROM point p1 LEFT JOIN point p2
ON p1.x != p2.x

# Leedcode problem - SQL 614
SELECT f1.follower, COUNT(DISTINCT f2.follower) AS 'num'
FROM follow f1 
INNER JOIN follow f2 ON f1.followr = f2.followee
GROUP BY f1.follower

# Leedcode problem - SQL 615
## calculate average salary of the whole company
 SELECT AVG(amount) AS company_avg,
 		date_format(pay_date, '%Y-%m') AS pay_month
 FROM salary
 GROUP BY date_formate(pay_date, '%Y-%m')

## calculate avgerage salary by dept
SELECT AVG(s.amount) AS dept_avg,
	   date_format(pay_date, '%Y-%m') AS pay_month
FROM salary s LEFT JOIN employee e
			ON s.employee_id = e.employee_id
GROUP BY department_id, pay_month 

## SELECT pay_month,
		  department_id,
		  CASE WHEN dept_avg > company_avg THEN 'higher'
		  	   WHEN dept_avg < company_avg THEN 'lower'
			   ELSE 'same'
		  END AS comparison
FROM   (
		SELECT AVG(s.amount) AS dept_avg,
	   			date_format(pay_date, '%Y-%m') AS pay_month
		FROM salary s LEFT JOIN employee e
			ON s.employee_id = e.employee_id
		GROUP BY department_id, pay_month 
		) AS dept_salary
JOIN   (
		SELECT AVG(amount) AS company_avg,
 			date_format(pay_date, '%Y-%m') AS pay_month
 		FROM salary
 		GROUP BY date_formate(pay_date, '%Y-%m')
		) AS company_salary
ON dept_salary.pay_month = company_salary.pay_month	
		   
# Leedcode problem - SQL 618
## put students into groups per their continent
SELECT 
	America, Asia, Europe
FROM
	(SELECT @as:=0, @am:=0, @eu:=0) t,
	(SELECT
		@as:=@as + 1 AS asid, name AS Asia
	FROM 
		student
	WHERE 
		continent = 'Asia'
	ORDER BY Asia) AS t1
	RIGHT JOIN
	(SELECT 
		@am:=@am + 1 AS amid, name AS America
		FROM
			student
		WHERE continent = 'America'
		ORDER BY America) AS t2 on asid = amid
	LEFT JOIN
	(SELECT
		@eu:=@eu + 1 AS euid, name AS Europe
		FROM 
			student
		WHERE continent = 'europe'
		ORDER BY Europe) AS t3 on amid = euid
; 
		
# Leedcode problem - SQL 619
SELECT IFNULL((SELECT MAX(num)
FROM (SELECT num
		FROM number 
		GROUP BY num
		HAVING COUNT(*) = 1) AS a), NULL) AS 'num'


# Leedcode problem - SQL 620
SELECT * 
FROM cinema
WHERE MOD(id, 2) =1 AND description != 'boring' 
ORDER BY rating DESC
; 

# Leedcode problem - SQL 626
SELECT  
	(CASE 
		WHEN MOD(id, 2) !=0 AND counts != id THEN id + 1
	 	WHEN MOD(id, 2) !=0 AND counts = id THEN id
		ELSE id - 1
	 END) AS id,
	 student
FROM seat,
	(SELECT 
	  COUNT(*) AS counts
	FROM 
	  seat) AS seat_counts
ORDER BY id ASC; 

SElECT s1.id, COALESCE(s2.student, s1.student) AS student
FROM seat s1
	LEFT JOIN seat s2 ON ((s1.id + 1)^1) - 1 = s2.id
ORDER BY s1.id
; 

# Leedcode problem - SQL 627
UPDATE salary
SET 
	sex = CASE sex WHEN 'm' THEN 'f'
				   ELSE 'm'
		  END;
		  
   
