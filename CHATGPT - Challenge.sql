/* 
CREDIT: ChatGPT
BY: RC

			11.14.25

CHALLENGE 1: Top 3 Paid Employees in Department

Write a SQL query to return the 
top 3 highest-paid employees in the IT department, 
ordered from highest salary to lowest.

USING THE FOLLOWING INFORMATION:
*/
/* Requirements:
--Only include rows where Department = 'IT'.
--Return at most 3 rows.
--Order by Salary from highest to lowest.
--If there are fewer than 3 IT employees, just return however many exist.
--Columns to return (in this order): EmployeeID, FullName, Salary.
*/

CREATE TABLE Employees (
			 EmployeeID INT,
			 FullName VARCHAR(100),
			 Department VARCHAR(50),
			 Salary INT
			 );

-- In case I need to nuke the table
/* DROP TABLE Employees; */

SELECT *
FROM Employees;

INSERT INTO Employees (EmployeeID, FullName, Department, Salary)
VALUES (1, 'Alice Brown', 'IT', 90000),
	   (2, 'Bob Smith',  'IT', 85000),
	   (3, 'Carol Johnson', 'IT', 95000),
	   (4, 'David Wilson', 'HR', 70000),
	   (5, 'Emily Davis', 'Sales', 65000);

SELECT TOP 3 *			--Originally was missing TOP and the 3 column that was stated
FROM Employees
WHERE Department = 'IT'
ORDER BY Salary DESC;

--CORRECT VERSION:
SELECT TOP 3 EmployeeID, FullName, Salary
FROM Employees
WHERE Department = 'IT'
ORDER BY Salary DESC;

--CHALLENGE 2: Count Employees Per Department (GROUP BY + HAVING)
/* 
Write a query that shows how many employees are in each department, 
but only for departments that have 2 or more employees, 
ordered from most employees to fewest

Requirements
-Use GROUP BY Department.
-Use COUNT(*) (or COUNT(EmployeeID)) to get the number of employees.
-Use HAVING to keep only departments with 2 or more employees.
-Output columns (in this order):
Department
EmployeeCount (alias your count)
Order by EmployeeCount DESC (largest first).
*/

INSERT INTO Employees (EmployeeID, FullName, Department, Salary)
VALUES (6, 'Frank Moore', 'HR', 72000);

SELECT Department,
	   COUNT(EmployeeID) AS count			--The alias can be written as EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(EmployeeID) >= 2 
ORDER BY COUNT(EmployeeID) DESC;

SELECT *
FROM Employees;

--Challenge 3: Find the Highest-Paid Departments
/*
Display each department and the total salary paid to all employees 
in that department.
*/
--This is wrong:
SELECT department,
	   SUM(Salary)
FROM Employees
GROUP BY Department
HAVING SUM(Salary)			--Having needs a condition((>, <, =, >=, AND/OR/LIKE/BETWEEN/IS NULL/ etc).
ORDER BY SUM(Salary);
/***
These are following that can be combine in a HAVING clause
=  <>  !=  >  <  >=  <= 
AND  OR  NOT
BETWEEN
IN / NOT IN
LIKE / NOT LIKE
IS NULL / IS NOT NULL
HAVING + aggregate (Basics: SUM, COUNT, AVG(), MIN(), MAX() | 
Other aggregates: STRING_AGG(), GROUP_CONCAT(), JSON_ARRAYAGG(), 
APPROX_COUNT_DISTINCT(),VAR() / VARP(), STDEV() / STDEVP()
*/

--Correct version:
SELECT department,
	   SUM(Salary)
FROM Employees
GROUP BY Department
ORDER BY SUM(Salary) DESC;

SELECT *
FROM Employees;

		--11.20.25
/* 
1. Return all employees who make more than 80,000, sorted by salart descending
*/

SELECT EmployeeID, FullName, Department, Salary
FROM Employees
WHERE Salary > 80000
ORDER BY Salary DESC;

/* 
2. Find the number of employees in each department */

SELECT Department,
	   COUNT(EmployeeID) AS EmployeeCount
FROM Employees
GROUP BY Department;

SELECT *
FROM Employees

/*
3. List all department that have more than 1 employee
*/
SELECT Department,
	   COUNT(*) 
FROM Employees
GROUP BY department
HAVING COUNT(*) > 1

SELECT *
FROM Employees

--Correct Version:
SELECT Department,
	   COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY department
HAVING COUNT(*) > 1

/*
4. Insert a new employee into the Employees table */
INSERT INTO Employees (EmployeeID, FullName, Department, Salary)
VALUES (7, 'John Carter', 'Sales', 68000);

SELECT *
FROM Employees

/*
5. Increase all IT salaries by 5% 
*/
UPDATE Employees
SET Salary = Salary * 1.05						--This is bc we are increasing the salary, so we do is 100% + 5%(the % that is given) = 105%. Then, we divide it by 100 = 1.05
WHERE Department = 'IT';	

--This can also be written like this:

UPDATE Employees
SET Salary = Salary + (Salary * 0.05)
/* 
Salary (In here is needed since it indicates which column) =
		Salary + (Salary * 0.05) --Indicates the changes in the values
*/
WHERE Department = 'IT'

--To reduce a Salary by 5%: (Learned on 12.27.25)
UPDATE Employees
SET Salary = Salary - (Salary * 0.05)
WHERE Department = 'IT'

--PREVIEW IT BEFORE UPDATING IT:
SELECT EmployeeID, Salary, Salary * 0.05 AS NewSalary
FROM Employees
WHERE Department = 'IT'; 

--11.21.25

/*
1. Delete Employees Who Makes Less Than 60,000
*/
DELETE FROM Employees
WHERE Salary < 60000;

SELECT *
FROM Employees

/*
2. Return All Unique Department
*/
SELECT DISTINCT Department
FROM Employees;

/*
3. Get the TOP 2 highest paid employees in the entire company
*/
SELECT TOP 2 
		EmployeeID,
		FullName,
		Salary
FROM Employees
ORDER BY Salary DESC;

/*
4. Increase salaries of all HR employees by 2500 
*/
UPDATE Employees
SET Salary = Salary + 2500
WHERE Department = 'HR';

/* 
5. Find the total salaries paid across each department, 
but only show department spending more than 150,000 total
*/

SELECT Department,
	   SUM(Salary)
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 150000
ORDER BY SUM(Salary) DESC;

--Correct version:
SELECT Department,
	   SUM(Salary) AS TotalSalary   --Missing alias
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 150000
ORDER BY SUM(Salary) DESC;

		--11.23.25--
/*
1. Return employees whose salary is NOT between 70,000 and 90,000
*/

SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE Salary NOT BETWEEN 70000 AND 90000
/* 
--OTHER CORRECT VERSION--
WHERE Salary < 70000 OR Salary > 90000
WHERE NOT (Salary BETWEEN 70000 ANS 90000)
*/

/*
---NOT CORRECT OR MEANS SOMETHING ELSE---
WHERE Salary IS 70000 OR 90000   --This is wrong since SQL is interpresting this as (Salary = 70000) OR (90000) 
WHERE Salary = 70000 OR 90000	 --This is correct but is not asking for the exact value or 70,000 or 90,000
WHERE Salary IN (70000, 90000)	 --It's a cleaner version of "WHERE Salary = 70000 OR 90000
*/

ORDER BY Salary;

SELECT *
FROM Employees

--ANOTHER WAY TO EXPRESS THIS:--
--Example 1:
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE Salary < 70000 OR Salary > 90000
ORDER BY Salary;

--Example 2:
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE NOT (Salary BETWEEN 70000 AND 90000)
ORDER BY Salary ASC;

/* 
2. Show each department and the average salary, but only the department where the average
is 80,000 or higher 
*/
--CORRECT
SELECT Department,
	   AVG(Salary) 
FROM Employees
GROUP BY Department
HAVING AVG(Salary) >= 80000
ORDER BY AVG(Salary) DESC;
--NOTE: SQL will strongly indicate that the order of the clause is wrong by saying "Incorrect syntax near [CLAUSE]" 

SELECT *
FROM Employees;

--WRONG:--
SELECT Department,
	   AVG(Salary) 
FROM Employees
WHERE AVG(Salary) >= 80000;
/*
		--RULES FOR AGGREGATES--
-Agregates can't be used with a WHERE since
*AVG( ) is an aggregate function 
*SQL cannot calculate aggregates before rows are grouped
***Any aggregate is used with GROUP BY and HAVING together***
*/

/*
		**NOTE**
WHERE --> Filters rows
Having --> Filters groups
*/

/*
3. Insert a new employee, then update their salary
Part a:
Insert the following:
EmployeeID = 8
FullName = Sarah Thompson
Department = IT
Salary = 8700
*/
INSERT INTO Employees (EmployeeID, FullName, Department, Salary)
VALUES (8, 'Sarah Thompson', 'IT', 87000);

/*
Part b: Update her salary 92000
*/
UPDATE Employees
SET salary = 92000			
WHERE id = 8;	

SELECT *
FROM Employees;

/*
4. Return the top 3 salaries per department without using JOINS
*/ 
---REDO THIS LATER ON---
USE MyDatabase;
SELECT TOP 3 Salary,
		     EmployeeID,
			 FullName,
			 Department
FROM Employees
HAVING Department
GROUP BY Salary

/* CORRECT ANSWER: */
SELECT EmployeeID, FullName, Department, Salary
FROM Employees e
WHERE (
        SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.Department = e.Department
          AND e2.Salary > e.Salary
      ) < 3
ORDER BY Department, Salary DESC;

---11.26.25---
/*
1. Return all employees who works in IT or HR
*/

SELECT EmployeeID,
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Department = 'IT' OR Department = 'HR'
ORDER BY Department ASC;

---ANOTHER WAY TO ANSWER THE SAME QUESTION FROM ABOVE---
SELECT EmployeeID,
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Department IN ('IT', 'HR')
ORDER BY Department ASC;

/*
2. Find the lowesst(Minumum) salary in each department
*/

SELECT Department,
	   MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department
ORDER BY MinSalary ASC;

SELECT *
FROM Employees;

/*
3. Return Employees who make more than the average salary in the company (easy subquery)
*/
SELECT EmployeeID, FullName, Salary
FROM Employees e
WHERE (
        SELECT AVG(Salary)
        FROM Employees e2
        WHERE e2.Department = e.Department
          AND e.Salary > e.Salary
      ) > AVG(Salary)
ORDER BY Department, Salary DESC;


--CORRECT ANSWER--
SELECT EmployeeID, FullName, Salary
FROM Employees
WHERE Salary > (
        SELECT AVG(Salary)
        FROM Employees
      )
ORDER BY Salary DESC;

					--12.2.25--
/*
1. Return all employees whose salary is between 70,000 and 95,000(inclusive)
*/
SELECT EmployeeID,
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Salary BETWEEN 70000 AND 95000;

SELECT *
FROM Employees

/*
2. Show how many employees work in the IT department
*/

SELECT COUNT(*) AS Number_of_employees,
	   Department
FROM Employees
WHERE Department = 'IT'
GROUP BY Department;

--Another way to write this:
SELECT COUNT(*) AS Number_of_employees
FROM Employees
WHERE Department = 'IT';

--It won't include the Department column

/*
3. For each department, return the maximum salary and order departments
from highest max salary to lowest 
*/

SELECT Department, 
	   MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department
ORDER BY MaxSalary DESC;

/*
4. Increase the salary of all employees in the Sales department by 3000
*/
UPDATE Employees
SET Salary = Salary + 3000
WHERE Department = 'Sales';

SELECT *
FROM Employees

/*
5. Delete all employees whose salary is less than 50,000
*/

DELETE FROM Employees
WHERE Salary < 50000;

/*
6. Insert a new employee:
EmployeeID = 9
FullName = 'Mark Ellis'
Department = 'HR'
Salary = 71000
*/
INSERT INTO Employees(EmployeeID, FullName, Department, Salary)
VALUES (9, 'Mark Ellis', 'HR', 71000);

SELECT *
FROM Employees

/*
7. Return all employees in IT whose salary is above the average salary of 
the IT department
*/
SELECT EmployeeID, 
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Salary >
	(
		SELECT AVG(Salary)
		FROM Employees
	);

	--Another way to write this:
SELECT EmployeeID, 
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Department = 'Sale'
AND
Salary >
	(
		SELECT AVG(Salary)
		FROM Employees
		);

/*
8.
Return all employees whose salary is greater than the maximum salary in the HR
department
*/
SELECT EmployeeID, 
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Salary > 
(
	SELECT MAX(Salary) 
	FROM Employees
--Missing this part:
	WHERE Department = 'HR'
	);

/*
9. For each department, show the sum of the salaries, but only the departments
whose total salary is less than 150,000
*/

SELECT Department,
	   SUM(Salary) 
FROM Employees
WHERE Salary < 150000
GROUP BY Department
HAVING SUM(Salary) < 150000;


--CORRECT VERSION:
SELECT Department,
	   SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
HAVING SUM(Salary) < 150000;

--Missing alias and don't need WHERE (We aren't filtering individuals salary)

/*
10. Return the 2 lowest salaries in the whole company
*/

SELECT TOP 2 EmployeeID,
	   FullName,
	   Salary
FROM Employees
ORDER BY Salary ASC;

--This version is found in SQLITE
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
ORDER BY Salary ASC
LIMIT 2;

--12.3.25
/*
7. Delete all employees in Sales making less than 60,000
*/
DELETE FROM Employees
WHERE Sales < 60000;
--This is for everyone

--CORRECT ANSWER:
DELETE FROM Employees
WHERE Department = 'Sales' AND Salary < 60000
--This is speciificly asking for the Sales dept

/* 
8.
Insert:
EmployeeID = 12
FullName = 'Daniel White'
Department = 'Finance'
Salary = 75000
*/
INSERT INTO Employees(EmployeeID, FullName, Department, Salary)
VALUES (12, 'Daniel White', 'Finance', 75000);

/* 
9.
Return employees whose salary is exactly 90,000
*/
SELECT EmployeeID, 
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Salary = 90000;

/*
10.
Show departments whose total salary is greater than 200,000
*/

SELECT Department,
	   SUM(Salary)
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 200000;

--test
SET Salary(1 + (10/100.0))

SELECT *
FROM Employees

/*							
			12.26.25
Migrating a table to another  */
--Need to have a 2nd table
CREATE TABLE EmployeeArchive (EmpID INT,
							  Name Varchar(50),
							  Dept Varchar(50),
							  SalaryAmount INT);

/* TASK 1: MIGRATING EVERYTHING

Your company wants to archive all current employees into a new table 
making system updates.
Write an SQL statement that copies ALL rows from Employees into EmployeeArchive, 
mapping the column correctly */
SELECT *
FROM Employees;

INSERT INTO EmployeeArchive (EmpID, Name, Dept, SalaryAmount)
SELECT 
	EmployeeID,
	Fullname,
	Department,
	Salary
FROM Employees;

SELECT *
FROM EmployeeArchive;

/* 
TASK 2: MIGRATING ONLY 1 PART

The company wants the IT department imported infto a new system that uses a different 
table layout.
Copy only the IT department into the ITTeam table. All employees copied get a default 
ReviewStatus = 'Pending'
*/

CREATE TABLE ITTEAM (ID INT,
					 EmployeeName VARCHAR(50),
					 BaseSalary INT,
					 ReviewStatus VARCHAR(50)
					 );
--To check if the tables got migrated correctly:
SELECT *
FROM ITTEAM;

SELECT *
FROM Employees;


INSERT INTO ITTEAM (ID, EmployeeName, BaseSalary, ReviewStatus)
SELECT EmployeeID,
	   FullName,
	   Salary,
	   'Pending'
FROM Employees
WHERE Department = 'IT';

--To check:
SELECT *
FROM ITTEAM;

/*
TASK 3: Copy specific part of the old table into a new table + Dynamic results

Management wants a separate table for employees who earn above 95,000 but the new 
table stores transformed data.
Copy employees with Salary > 95,000 into the new table and convert the salary into a 
formatted string such as: '95000 USD'
*/
CREATE TABLE HighSalaryEmployees(EmpID INT,
								 Name VARCHAR(50),
								 Department VARCHAR(50),
								 AnnualSalary VARCHAR(50)
								 );
--Check if table was created:
SELECT *
FROM HighSalaryEmployees;

INSERT INTO HighSalaryEmployees(EmpID, Name, Department, AnnualSalary)
SELECT EmployeeID,
	   FullName,
	   Department,
	   '95000 USD'		--This hard codes the results/answers
FROM Employees
WHERE Salary > 95000;

SELECT *
FROM Employees;

--Correct answer (We do not want it to be hard-coded): Dynamic format is prefer
INSERT INTO HighSalaryEmployees (EmpID, Name, Department, AnnualSalary)
SELECT EmployeeID,
	   FullName,
	   Department,
	   CAST(Salary AS VARCHAR(20)) + 'USD'  ---This makes it dynamic
FROM Employees
WHERE Salary > 95000;

--To Check:
SELECT *
FROM HighSalaryEmployees;


/*
				12.27.25
https://chatgpt.com/share/694f17cf-73e4-8003-9a44-12db8479508e
*/
--Based table:--
SELECT *
FROM Employees;

/*
TASK 1: SIMPLE COPY/MIGRATION
You need to copy all employees into a backuptable with the same column names.
Write an SQL statement to copy all rows from Employees into EmployeesBackup
*/

CREATE TABLE EmployeesBackup (EmployeeID INT, 
							  FullName VARCHAR(50),
							  Department VARCHAR(50),
							  Salary INT);
SELECT *
FROM EmployeesBackup

INSERT INTO EmployeesBackup (EmployeeID, FullName, Department, Salary)
SELECT EmployeeID,
	   FullName,
	   Department,
	   Salary
FROM Employees;

--Check:
SELECT *
FROM EmployeesBackup

SELECT *
FROM Employees

/*
TASK 2: COPY WITH FILTER
HR wants a table that stores only employees from the Sales department.
Insert only Sales employees into SalesEmployees
*/
CREATE TABLE SalesEmployees(EmployeeID INT, 
							FullName VARCHAR(50),
							Salary INT);

SELECT *
FROM SalesEmployees;

INSERT INTO SalesEmployees(EmployeeID, FullName, Salary)
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE Department = 'Sales';

--Check:
SELECT *
FROM SalesEmployees;

SELECT *
FROM Employees;

--Another way to write this query is:
INSERT INTO SalesEmployees(EmployeeID, FullName, Salary)
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE Department = 'Sales'
	  AND
		EmployeeID NOT IN 
			(SELECT						--This looks like a subquery
				EmployeeID
			FROM SalesEmployees);
/* 
This is used to prevent the following:
	-Duplicate rows
	-Primary key violations, if EmployeeID is a PK
	-Data integrity issues
*/

/*TASK 3: ADD A CALCULATED COLUMN
Management wants a table that includes employee salaries after a 10% bonus.
Copy employees into EmployeeBonus, calculating the salary with a 10% increase
*/
CREATE TABLE EmployeeBonuses(EmployeeID INT, 
							 FullName VARCHAR(50), 
							 BonusSalary INT);

SELECT *
FROM EmployeeBonuses

DROP TABLE EmployeeBonuses

--This is wrong:
INSERT INTO EmployeeBonuses(EmployeeID, FullName, BonusSalary)
SELECT *
FROM Employees
SET Salary * 1.10						--SET is not used in SELECT
WHERE Salary >
		(SELECT EmployeeID,				--This is an invalid subquery
				FullName,
				Salary
		 FROM Employees);

--Correct way of doing this:
INSERT INTO EmployeeBonuses(EmployeeID, FullName, BonusSalary)
SELECT EmployeeID,
	   FullName,
	   Salary + (Salary * 0.10)			--This is how we calculate the 10% increase
FROM Employees;

--OR
INSERT INTO EmployeeBonuses(EmployeeID, FullName, BonusSalary)
SELECT EmployeeID,
	   FullName,
	   Salary * 1.10  --This can be written like this in a migrating statement			
/* Here you do not need to have it as: Salary = Salary + (Salary * 1.10) as seen 
with SET */
FROM Employees;

--Check:
SELECT *
FROM EmployeeBonuses;

/*
TASK 4: DEFAULT VALUE + RENAME COLUMNS
A new system tracks employees and assigns everyone a default status.
Insert all employees into EmployeeStatus, setting Status to 'Active' for every row.
*/
CREATE TABLE EmployeeStatus(ID INT, 
							Name VARCHAR(50), 
							Department VARCHAR(50), 
							Status VARCHAR(50)
							);
SELECT *
FROM EmployeeStatus;

--Based table:
SELECT *
FROM Employees;

INSERT INTO EmployeeStatus(ID, Name, Department, Status)
SELECT EmployeeID,
	   FullName,
	   Department,
	   'Active'
FROM Employees;

--Check:
SELECT *
FROM EmployeeStatus;

/*
TASK 5: SUBQUERY MIGRATION
You need a table that stores employees who earn more than the company average salary.
Insert only employees whose salary is greater than the average salary of all employees.
*/
CREATE TABLE AboveAverageEarners (EmployeeID INT, 
								  FullName VARCHAR(50), 
								  Salary INT);
SELECT *
FROM AboveAverageEarners;

--Base table:
SELECT *
FROM Employees


INSERT INTO AboveAverageEarners(EmployeeID, FullName, Salary)
SELECT EmployeeID,
       FullName,
	   Salary
FROM Employees
WHERE Salary <				--Sign was incorrect 
	  (SELECT AVG(Salary)
	   FROM Employees
	   );

		--Correct:--
INSERT INTO AboveAverageEarners(EmployeeID, FullName, Salary)
SELECT EmployeeID,
       FullName,
	   Salary
FROM Employees
WHERE Salary >				
	  (SELECT AVG(Salary)
	   FROM Employees
	   );

--Check:
SELECT *
FROM AboveAverageEarners;

					--1.1.26--
/* 
https://chatgpt.com/share/6956db66-9e54-8003-9a9c-543fba256e34

TASK 1: SIMPLE COPY
A new table only needs employees names and departments. 
Insert all employees into EmployeeDirectory using only the required information
*/
CREATE TABLE EmployeeDirectory (FullName VARCHAR(50), 
								Department VARCHAR(50));
SELECT *
FROM EmployeeDirectory


INSERT INTO EmployeeDirectory(FullName, Department)
SELECT FullName,
	   Department
FROM Employees;

SELECT *
FROM Employees;

--To Check:
SELECT *
FROM EmployeeDirectory;

/*
TASK 2: COPY WITH FILTER
HR wants a table that stores only employees from the Sales department.
Inser only Sales employees into SalesEmployees
*/
CREATE TABLE SalesEmployees(EmployeeID INT,
							FullName VARCHAR(50),
							Salary INT);
SELECT *
FROM SalesEmployees

/*
Note: This table already exists with 2 entries:
Emily Davis and John Carter
--Will migrate everything from the BASE table AND DELETE/FILTER repeated stuffs)
*/

INSERT INTO SalesEmployees(EmployeeID, FullName, Salary)
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees

/*
Note: Since the 2 previous name entries already exist on the SalesEmployees db,
we will see duplicates 
These duplicates can be deleted with the following statement
DELETE FROM SalesEmployees
WHERE EmployeeID = 5 OR EmployeeID = 7
--This can also be WRITTEN like this:

			DELETE FROM SalesEmployees
			WHERE EmployeeID IN (5,7);

--It will delete all of them
SO is best to just use DISTINCT in here
*/

DELETE FROM SalesEmployees
WHERE EmployeeID = 5 OR EmployeeID = 7
--Deletes all rows that meets the conditions in here

SELECT *
FROM SalesEmployees

--Fixing what was previously deleted on the duplicates
INSERT INTO SalesEmployees(EmployeeID, FullName, Salary)
VALUES (5, 'Emily Davis', 65000),
	   (7, 'John Carter', 68000);

/*
				1.3.26
TASK 3: Conditional Migration
Finance wants to track only employees earning $70,000 or more.
Insert only employees whose salar is >= 70,000
*/

CREATE TABLE HighEarners (EmployeeID INT, 
						  FullName VARCHAR(50),
						  Salary INT)
SELECT *
FROM HighEarners;

INSERT INTO HighEarners(EmployeeID, FullName, Salary)
SELECT EmployeeID, FullName, Salary
FROM Employees
WHERE Salary >= 70000;

SELECT *
FROM Employees;

/*
TASK 4: Aggregation Migration
Management wants a summary table showing average salary per department.
Insert one row per department with it average salary
*/
CREATE TABLE DepartmentAverages(Department VARCHAR(50),
								AvgSalary INT);
SELECT *
FROM DepartmentAverages


INSERT INTO DepartmentAverages(Department, AvgSalary)
SELECT Department, AVG(Salary)
FROM Employees
GROUP BY Department

--Check:
SELECT *
FROM DepartmentAverages

/*
TASK 5: Derived Value + Filter
A compensation table tracks adjusted salaries only for IT employees after a 15% raise.
Insert only IT employees and calculate their salary after a 15% increase
*/

CREATE TABLE ITAdjustedSalaries(EmployeeID INT,
								FullName VARCHAR(50),
								AdjustedSalary INT);
SELECT *
FROM ITAdjustedSalaries

INSERT INTO ITAdjustedSalaries(EmployeeID, FullName, AdjustedSalary)
SELECT EmployeeID, 
	   FullName, 
	   Salary AS AdjustedSalary
FROM Employees

UPDATE Employees
SET Salary = Salary + (Salary * 0.15)
WHERE Department = 'IT'

--Explaination:--
/* By doing UPDAT, we are modifying the table and is not what we want. 
We want the table not to change

So we DO NOT DO THIS:
	UPDATE Employees
	SET Salary = Salary + (Salary * 0.15)
	WHERE Department = 'IT'

The CORRECT SOLUTION IS:
*/
INSERT INTO ITAdjustedSalaries(EmployeeID,
							   FullName, 
							   AdjustedSalary)
SELECT EmployeeID,
	   FullName,
	   Salary * 1.15 AS AdjustedSalary
FROM Employees
WHERE Department = 'IT'

--ANOTHER WAY TO WRITE THIS--
INSERT INTO ITAdjustedSalaries(EmployeeID,
							   FullName, 
							   AdjustedSalary)
SELECT EmployeeID,
	   FullName,
	   Salary + (Salary * 0.15) AS AdjustedSalary
FROM Employees
WHERE Department = 'IT';

SELECT *
FROM ITAdjustedSalaries

DROP TABLE ITAdjustedSalaries

/*
							1.5.26
New Batch of questions:
https://chatgpt.com/share/6956db66-9e54-8003-9a9c-543fba256e34

TASK 1: Simple Rename Mapping
A legacy system uses different column labels.
Insert all Employees into StaffList, mapping columns correctly
*/

CREATE TABLE StaffList(StaffID INT,
					   StaffName VARCHAR(50),
					   Team VARCHAR(50));
--Check if this table was created correctly
SELECT *
FROM StaffList

INSERT INTO StaffList(StaffID, StaffName, Team)
SELECT EmployeeID, 
	   FullName, 
	   Department
FROM Employees

--To check if the table migration was done correctly
SELECT *
FROM StaffList

/*
TASK 2: Filter + Rename
Finance wants only non-IT employees stored in a reporting table.
Insert all employees except IT into NonITStaff
*/

CREATE TABLE NonITStaff(ID INT,
						Name VARCHAR(50),
						DeptName VARCHAR(50),
						BasePay INT);
--To check if the table exist
SELECT *
FROM NonITStaff;

INSERT INTO NonITStaff(ID, Name, DeptName, BasePay)
SELECT EmployeeID,
	   FullName,
	   Department,
	   Salary
FROM Employees
WHERE Department != 'IT';			--Do not forget " " when we see strings
--Can also be written like WHERE Department != 'IT' OR Department IS NULL--

--To check if the table migration went well
SELECT *
FROM NonITStaff;

/*
TASK 3: Derived Column + Rename
A compensation system stores monthly pay instead of annual salary.
Insert all employees and calculate monthly salary during migration
*/
CREATE TABLE MonthlyPayroll(EmpID INT,
							EmployeeName VARCHAR(50),
							MonthlyPay INT);
--Table verification
SELECT *
FROM MonthlyPayroll;

INSERT INTO MonthlyPayroll(EmpID, EmployeeName, MonthlyPay)
SELECT EmployeeID,
	   FullName,
	   Salary / 12		--Turn the numerical value into a decimal to be safe
FROM Employees;

/*
*****COMING BACK TO THIS LATER ON*******

--Another way to write this:
SELECT EmployeeID,
       FullName,
       CAST(Salary AS DECIMAL(10,2)) / 12		--Have not covered CAST
FROM Employees;

*****COMING BACK TO THIS LATER ON*******
*/
--ORIGINALLY I had this:
INSERT INTO MonthlyPayroll(EmpID, EmployeeName, MonthlyPay)
SELECT EmployeeID,
	   FullName,
	   Salary
FROM Employees
WHERE Salary = Salary/12		
/*
--This:[ Salary = Salary/12 ] should had been calculated directly in the SELECT clause
--This query had 0 rows being affected. So is not correct
--We are not filtering so we do not need WHERE clause

NOTE:
We use: Salary = Salary/12
		Salary = Salary + (Salary * 0.05)
		Salary = Salary * 1.05
--All of this applies when we are UPDATING the table by Including the name of the 
column = same column and the math calculation. 

--If we are not UPDATING the table, we calculate this directly in the SELECT clause
Like so:
		 Salary/12 
		 Salary + (Salary * 0.05)
		 Salary * 1.05

TASK 4: AGGREATION + RENAME
Leadership wants to see the highest salary per department.
Insert one row per department showing the maximum salary
*/

CREATE TABLE DepartmentTopEarners (DeptName VARCHAR(50),
								   MaxSalary INT);
--To Check Table
SELECT *
FROM DepartmentTopEarners;


INSERT INTO DepartmentTopEarners(DeptName, MaxSalary)
SELECT Department,
	   MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department;

/*
				1.6.26
*******************TO REVIEW*******************
TASK 5: Conditional Logic + Rename
HR categorizes employees based on salary tiers
Insert all employees and assign a PayGrade using SQL logic
Additional information:
				'High' if Salary >= 90000	
		--Translate to: WHEN Salary >= 90000 THEN 'High'
				'Medium' if 70000-89999
		--Translate to: WHEN Salary BETWEEN 70000 AND 89999 THEN 'Medium'
				'Low' otherwise
		--Translate to: ELSE 'Low'
***We use CASE to make it easie. Instead of doing multiple INSERT

*/
CREATE TABLE EmployeePayGrades(EmpID INT, 
				 Name VARCHAR(50),
				 PayGrade VARCHAR(50) );

--Check if this is correct:
SELECT *
FROM EmployeePayGrades;

/*

		STEP 1:

CASE 
	WHEN Salary >= 90000 THEN 'High'
	WHEN Salary BETWEEN 70000 AND 89999 THEN 'Medium'
	ELSE 'Low'
END

		STEP 2:
*/
INSERT INTO EmployeePayGrades(EmpID, Name, PayGrade)
SELECT EmployeeID,
	   FullName,
	   CASE
			WHEN Salary >= 90000 THEN 'High'
			WHEN Salary Between 70000 AND 89999 THEN 'Medium'
			ELSE 'Low'
		END AS PayGrade		--Can use an ALIAS in here
FROM Employees

--Check:
SELECT *
FROM EmployeePayGrades;

/*
NOTE: If we do not use CASE to solve this, we will need to do multiple INSERT statement
Looks like this:
*/
---'High' if Salary >= 90000	
INSERT INTO EmployeePayGrades(EmpID, Name, PayGrade)
SELECT EmployeeID, FullName, 'High'
FROM Employees
WHERE Salary >= 90000;

---'Medium' if 70000-89999
INSERT INTO EmployeePayGrades(EmpID, Name, PayGrade)
SELECT EmployeeID, FullName, 'Medium'
FROM Employees
WHERE Salary BETWEEN 70000 AND 89999;

--'Low' otherwise
INSERT INTO EmployeePayGrades(EmpID, Name, PayGrade)
SELECT EmployeeID, FullName, 'Low'
FROM Employees
WHERE Salary < 70000;

/*
						1.9.26
		--Mapping/Migrating table with different names in their column
https://chatgpt.com/share/6956db66-9e54-8003-9a9c-543fba256e34

TASK 1: RENAME + SUBSET
A contact directory only tracks basic identity info.
Insert all employees into EmployeeContacts
*/
CREATE TABLE EmployeeContacts(ContactID INT,
							  ContactName VARCHAR);

--Correct statement
/* Forgot to give a numerical value to VARCHAR. By forgetting, 
I got this error: 
"String or binary data would be truncated in table 'MyDatabase.dbo.EmployeeContacts',
column 'ContactName. Truncated value: 'A'."
Had to recreate the table by using 
DROP TABLE EmployeeContacts;
*/
CREATE TABLE EmployeeContacts(ContactID INT,
							  ContactName VARCHAR(50) );

--Check
SELECT *
FROM EmployeeContacts;

--Before we start the migration, always look at the original table to see the structure
SELECT *
FROM Employees;

INSERT INTO EmployeeContacts(ContactID, ContactName)
SELECT EmployeeID AS ContactID,
	   FullName AS ContactName
FROM Employees;

--Check
SELECT *
FROM EmployeeContacts;

/*
TASK 2: Filter + Rename
Operations want a table for HR employees only.
Insert only employees from the HR department
*/

CREATE TABLE HRTeam(HR_ID INT,
					HR_Name VARCHAR(50),
					SalaryAmount INT);
--Check:
SELECT *
FROM HRTeam;

SELECT *
FROM Employees;

INSERT INTO HRTeam(HR_ID, HR_Name, SalaryAmount)
SELECT EmployeeID AS HR_ID, 
	   FullName AS HR_Name, 
	   Salary AS SalaryAmount
FROM Employees
WHERE Department = 'HR';

/*					1.10.26
https://chatgpt.com/share/6956db66-9e54-8003-9a9c-543fba256e34

TASK 3: Transformation + Rename
Accounting tracks bi-weekly pay instead of annual salary.
Insert all employees and calculate bi-weekly pay.
*/
CREATE TABLE BiWeeklyPayroll(EmpCode INT,
							 Name VARCHAR(50),		--Make sure to spel VARCHAR() correctly | Originally had VARCHER()
							 BiWeeklyPay INT);
--Check:
SELECT *
FROM BiWeeklyPayroll;

INSERT INTO BiWeeklyPayroll(EmpCode, Name, BiWeeklyPay)
SELECT EmployeeID, 
	   FullName AS Name,
	   Salary/26 AS BiWeeklyPay						--26 is the # of paycheck ppl receive per year
FROM Employees;

/*
TASK 4: Aggregation + Rename
Leadership wants to see the lowest salary per department.
Insert one row per department showing the maximun salary
***A similar question like this already exist, so we changed it into lowest salary per dept)

CREATE TABLE DepartmentTopEarners(DeptName VARCHAR(50),
								  LowestSalary INT);
-Table already exist. It was further verified with 

--Check 
SELECT *
FROM DepartmentTopEarners;
*/

SELECT *
FROM Employees;

INSERT INTO DepartmentTopEarners
SELECT Department AS DeptName,
	   MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY Department;

--Check 
SELECT *
FROM DepartmentTopEarners;
/* It is also showing the highest salary from before along with the lowest salary from now */

--Wrong
SELECT Department AS DeptName,
	   Salary AS LowestSalary
FROM Employees
ORDER BY LowestSalary ASC;	   
--Not trying to sort them from lowest to highest

/*
TASK 5: Subquery migration
HR wants a table of employees who earn above their department's average salary.
Insert only employees whose salary is greater than the average salary of their department.
*/

SELECT *
FROM DeptAboveAverage

CREATE TABLE DeptAboveAverage(EmpID INT, 
							  Name VARCHAR(50),
							  Dept VARCHAR(50),
							  Salary INT);


--WRONG but very close
INSERT INTO DeptAboveAverage(EmpID, Name, Dept, Salary)
SELECT EmployeeID, 
	   FullName AS Name,
	   Department,
	   AVG(Salary)			--Write this first part of SELECT like a normal table migration
FROM Employees
/* Since we are querrying within the same table, it's best to give an alias in FROM to avoid confusion */
WHERE AVG(Salary) <				--Can't use aggregates in here when doing subquery
		(SELECT *
		FROM Employees);

		--CORRECT VERSION:
INSERT INTO DeptAboveAverage(EmpID, Name, Dept, Salary)
SELECT EmployeeID,				--From here to WHERE clause is, it's considered outer query
	   FullName AS Name,
	   Department,
	   Salary
FROM Employees AS e1
WHERE Salary <				
		(SELECT AVG(Salary)					--From here to the end is inner query(Subquery)
		FROM Employees
		WHERE Department = e1.Department);
  --Needs to include the name of the table again since is referencing(querying) itself
  --It is called a correlated subquery(where the inner subquery needs to refer back to the current row of the outer query)
--Check
SELECT *
FROM DeptAboveAverage


	--Migration with 'CASE' clauses--
/*
TASK 1: SIMPLE CASE LABEL
A reporting system labels employees as High Pay or Standard Pay.
Insert all employees and assign:
	'High Pay' if Salary >= 90000
	'Standard Pay' otherwise
*/

SELECT *
FROM EmployeePayLabels

CREATE TABLE EmployeePayLabels(EmpID INT,
							   Name VARCHAR(50),
							   PayLabel VARCHAR(50));

/*
	--WRONG but close
INSERT INTO EmployeePayLabels(EmpID, Name, PayLabel)
SELECT EmployeeID,
	   FullName AS Name,
	   Salary				--This needs to be removed since we aren't matching them
FROM Employees				---This needs to go after CASE
CASE 
	WHEN Salary >= 90000 THEN 'High Pay'
	ELSE 'otherwise'		--This should be 'Standard Pay', not 'otherwise'	
--Originally: 'Standard Pay' otherwise
END AS PayLabel				--It's to label tehe new column generated in the table
FROM Employees;
*/

--CORRECTED VERSION--
INSERT INTO EmployeePayLabels(EmpID, Name, PayLabel)
SELECT EmployeeID,
	   FullName AS Name,			--Comma is needed
CASE 
	WHEN Salary >= 90000 THEN 'High Pay'
	ELSE 'Standard Pay'
END AS PayLabel
FROM Employees;
---****REVIEW THIS****---
		
/*					
						1.11.26
https://chatgpt.com/share/6956db66-9e54-8003-9a9c-543fba256e34

TASK 2: CASE WITH DEPARTMENT LOGIC
Employees are classified as technical or non-Technical
Insert all employees and assign:
	'Technical' if Department = 'IT'
	'Non-Technical' otherwise
*/
CREATE TABLE EmployeeCategories(EmployeeID INT, 
								FullName VARCHAR(50),
								Category VARCHAR(50));
--Check
SELECT *
FROM EmployeeCategories;

INSERT INTO EmployeeCategories(EmployeeID, FullName, Category)
SELECT EmployeeID, 
	   FullName,  
CASE 
	WHEN Department = 'IT' THEN 'Technical'
	ELSE 'Non-Technical'
		END AS Category
FROM Employees;

--Check 2:
SELECT *
FROM EmployeeCategories;

/*
TASK 3: MULTI-CONDITION CASE
HR assigns salary tiers.
Insert all employees and assign:
	-'Tier 1' if Salary >= 100000
	-'Tier 2' if Salary between 80000 and 99999
	-'Tier 3' otherwise
*/

SELECT *
FROM SalaryTiers;

CREATE TABLE SalaryTiers(EmpID INT,
						 FullName VARCHAR(50),
						 Tier VARCHAR(50));

					/* WRONG */
INSERT INTO SalaryTiers(EmpID, FullName, Tier)
SELECT EmployeeID, 
	   FullName			--Missing comma in here|It will give an error
CASE
	WHEN Salary >= 100000 THEN 'Tier 1'
	WHEN Salary BETWEEN 80000 AND 99999 THEN 'Tier 2'
	ELSE 'Tier 3'  
		END 
FROM Employees;

			/*		CORRECT VERSION		*/
INSERT INTO SalaryTiers(EmpID, FullName, Tier)
SELECT EmployeeID, 
	   FullName,		
CASE
	WHEN Salary >= 100000 THEN 'Tier 1'
	WHEN Salary BETWEEN 80000 AND 99999 THEN 'Tier 2'
	ELSE 'Tier 3'  
		END 
FROM Employees;

/*
TASK 4: CASE With Calculated Value
Finance applies different bonus percentages by department.
Insert all employees and calculate bonus:
		-IT → 15% of Salary
		-HR → 10% of Salary
		-All others → 5% of Salary
*/
--Checked if the table was created
SELECT *
FROM EmployeeBonuses;

--**TABLE exist** so going to delete it and recreate */
DROP TABLE EmployeeBonuses;

--RECREATING THE TABLE
CREATE TABLE EmployeeBonuses(EmployeeID INT, 
							 FullName VARCHAR(50), 
							 BonusSalary INT);

						 /*			WRONG		*/
INSERT INTO EmployeeBonuses(EmployeeID, FullName, BonusSalary)
SELECT EmployeeID,
	   FullName,
CASE	
	WHEN Salary = Salary + (Salary * 0.15) THEN 'IT'		--I have this reverse; see solution
/* This: Salary = Salary + (Salary * 0.15) Will never be true	*/
	WHEN Salary = Salary + (Salary * 0.10) THEN 'HR'
	ELSE Salary = Salary + (Salary * 0.05) THEN 'All others'
/* NO need to write: Salary = Salary + (Salary * 0.15)  */
		END AS BonusSalary
FROM Employees

		/*		CORRECT SOLUTION		*/
INSERT INTO EmployeeBonuses(EmployeeID, FullName, BonusSalary)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Department = 'IT' THEN Salary * 0.15
	WHEN Department = 'HR' THEN Salary * 0.10
	ELSE Salary * 0.05
/*  In here, we write it like so since is inquiring about the rest of the dept  */
		END AS BonusSalary
FROM Employees;

--Check if the migration is right/done
SELECT *
FROM EmployeeBonuses;

/*
TASK 5: CASE + AGGREGATION
Leadership wants departments classified by total payroll size.
Insert one row per department and assign:
	-'Large Budget' if total salary > 300000
	-'Medium Budget' if total salary between 150000 and 300000
	-'Small Budget' otherwise
*/
--Verification if this table was in DB:
SELECT *
FROM DepartmentPayrollCategory;

CREATE TABLE DepartmentPayrollCategory(Department VARCHAR(50),	
										PayrollCategory VARCHAR(50));
--Check if the table was created:
SELECT *
FROM DepartmentPayrollCategory;

/*		WRONG:		*/
--Hard CASE + aggregate "trap"
INSERT INTO DepartmentPayrollCategory(Department, PayrollCategory)
SELECT Department,
	   SUM(Salary),
/* This should not be inserted in here but inside the CASE */
	CASE 
		WHEN Salary > 300000 THEN 'Large Budget'
		WHEN Salary BETWEEN 150000 AND 300000 THEN 'Medium Budget'
		ELSE 'Small Budget'
FROM Employees
GROUP BY Department
FROM Employees;

/* Line 1663 to 1665 are causing a duplicate FROM Employees. 
Can only use it once and not like this */

			--CORRECT SOLUTION--
INSERT INTO DepartmentPayrollCategory(Department, PayrollCategory)
SELECT Department,
	CASE 
		WHEN SUM(Salary) > 300000 THEN 'Large Budget'
		WHEN SUM(Salary) BETWEEN 150000 AND 300000 THEN 'Medium Budget'
		ELSE 'Small Budget'
			END AS PayrollCategory
FROM Employees
GROUP BY Department;

--Check if the table was migrated correctly:
SELECT *
FROM DepartmentPayrollCategory;

/*
					1.13.26
https://chatgpt.com/share/69645034-64a4-8003-960d-25435f31f1a1
-Did 3 on paper and they weren't right. Doing it again since I barely remb

TASK: Case Status Flag
A system flags employees as Active or Review based on salary.
Insert all empliyees and assign:
	-'Active' If Salary >= 70000
	-'Review' Otherwise

TABLE: EmployeeStatus
*/

SELECT *
FROM EmployeeStatus
--It already exist so nuking it:

DROP TABLE EmployeeStatus;

INSERT INTO EmployeeStatus(ID, Name, Status)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Salary >= 70000 THEN 'Active'
	ELSE 'Review'		--ELSE is extra and is not needed, just END statement
END AS Status			--SQLite, we need quotations in here
FROM Employees;

SELECT *
FROM Employees

/* 
					1.8.26
Note: Was doing practice question in Codecademy with a study budy for the days I wasn't doing this

TASK 2: Case With Department Mapping
Departments are mapped to internal codes.
Insert all employees and assign:
	-'TECH' if Department = 'IT'
	-'PEOPLE' if Department = 'HR'
	-'OPS' for all other departments

TABLE: DepartmentCodes
*/
SELECT *
FROM DepartmentCodes

CREATE TABLE DepartmentCodes(EmployeeID INT,		    --In SQLite, INT needs to be spelled out
							 FullName VARCHAR(50),
							 DeptCode VARCHAR(50));		--This is a target column so it doesn't need to be included in SELECT

INSERT INTO DepartmentCodes(EmployeeID, FullName, DeptCode)
SELECT EmployeeID, 
	   FullName, 
CASE
	WHEN Department = 'IT' THEN 'TECH'
	WHEN Department = 'HR' THEN 'PEOPLE' 
	ELSE 'OPS'
END AS DeptCode
FROM Employees;

SELECT *
FROM DepartmentCodes;

/*
TASK 3: CASE With Salary Adjustment
A new payroll table stores adjusted salaries based on department rules.
Insert all employees and calculate NewSalary:
	-IT --> Salary + 20%
	-HR --> Salary + 10%
	-Others --> Salary + 5%

Target table: AdjustedSalaries
*/
SELECT *
FROM AdjustedSalaries;

CREATE TABLE AdjustedSalaries(EmpID INT, 
							  FullName VARCHAR(50),
							  NewSalary INT);

INSERT INTO AdjustedSalaries (EmpID, FullName, NewSalary)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Department = 'IT' THEN Salary + 0.20			
	--We aren't adding them, even if we see it like that. We need to multiply it. See below for the correct solution
	WHEN Department = 'HR' THEN Salary + 0.10
	ELSE Salary + 0.05
END AS NewSalary
FROM Employees;

--CHECK:
SELECT *
FROM AdjustedSalaries

DROP TABLE AdjustedSalaries

/*			CORRECT VERSION		*/
INSERT INTO AdjustedSalaries (EmpID, FullName, NewSalary)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Department = 'IT' THEN Salary + (Salary * 0.20)			
	WHEN Department = 'HR' THEN Salary + (Salary * 0.10)
	ELSE Salary + (Salary * 0.05)
END AS NewSalary
FROM Employees;

--CAN ALSO BE WRITTEN AS:
INSERT INTO AdjustedSalaries (EmpID, FullName, NewSalary)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Department = 'IT' THEN Salary * 1.20			
	WHEN Department = 'HR' THEN Salary * 1.10
	ELSE Salary * 1.05
END AS NewSalary
FROM Employees;

/*
TASK 3: CASE With Ranges + Label
Employees are assigned compensation bands.
Insert all employees and assign:
	-'Executive' if Salary >= 120000
	-'Senior' if Salary between 90000 and 119999
	-'Mild' if Salary between 60000 and 89999
	-'Junior' Otherwise

Target Table: CompensationBands
*/
SELECT *
FROM CompensationBands;

CREATE TABLE CompensationBands(EmployeeID INT,
							   FullName VARCHAR(50),
							   Band VARCHAR(50));

INSERT INTO CompensationBands(EmployeeID,FullName, Band)
SELECT EmployeeID,
	   FullName,
CASE
	WHEN Salary >= 120000 THEN 'Executive'
	WHEN Salary BETWEEN 90000 AND 119999 THEN 'Senior'
	WHEN Salary BETWEEN 60000 AND 89999 THEN 'Mid'
	ELSE 'Junior'
END AS Band
FROM Employees;
		
/*
TASK 5: CASE + GROUP BY Migration
Each department is categorized by average salary
Insert one row per derpatment and assign:
	-'High Paying if AVG(Salary) >= 90000
	-'Moderate Paying' if AVG(Salary) between 70000 and 89999
	-'Low Paying' otherwise

Target Table: DepartmentSalaryLevel
*/

SELECT *
FROM DepartmentSalaryLevel;

CREATE TABLE DepartmentSalaryLevel(Department VARCHAR(50),
								   SalaryLevel VARCHAR(50));

INSERT INTO DepartmentSalaryLevel(Department, SalaryLevel)
SELECT Department,
CASE
	WHEN AVG(Salary) >= 90000 THEN 'High Paying'
	WHEN AVG(Salary) BETWEEN 70000 AND 89999 THEN 'Moderate Paying'
	ELSE 'Low Paying'
END AS SalaryLevel
FROM Employees
GROUP BY Department

--CHECK
SELECT *
FROM DepartmentSalaryLevel;

/*						2.2.26
-Being practicing SQL with ChatGPT, Codecademy and learning to create an SQL 
baseline with Terry. Notes will be uploaded to Git later on 
*/

/*						2.28.26
INNER JOIN + AGGREGATES
Write a query to:
-Show first_name			-Show total score per customer
-Only include customers whose total score is greater than 400

**Couldn't use the information on the existing tables to do the INNER JOIN.
It would had created a SELF JOIN. Created a new sets of tables**
SELECT first_name,
---	   SUM(score)
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id
GROUP BY country
HAVING SUM(score) > 400;


	  SELECT *
	  FROM orders

	  SELECT *
	  FROM Customers
*/
/*
INNER JOIN + AGGREGATES
Write a query to:
-Show CustomerName		-Show total amount spent per customer
-Only include customers whose total spending is greater than 400
			--2 ways to write it--
			--Need to create the 2 based tables--
*/
--BASED TABLE 1:
CREATE TABLE Customers_2(CustomerID INT, 
						CustomerName VARCHAR(100))
INSERT INTO Customers_2(CustomerID, CustomerName)
VALUES (1, 'Alex'),
	   (2, 'Brianna'),
	   (3, 'Carlos'),
	   (4, 'Dianna');

SELECT *
FROM Customers_2

/*			
Had to nuke the 1st table to fix the error and do it again.
Used the following statement:
DROP TABLE Customers_2
2nd base table				*/

--BASED TABLE 2:
CREATE TABLE Orders_2(OrdersID INT, CustomerID INT, Amount INT)
INSERT INTO Orders_2(OrdersID, CustomerID, Amount)
VALUES(101, 1, 500),
	  (102, 2, 300),
	  (103, 1, 200),
	  (104, 4, 400);

SELECT *
FROM Orders_2;


/*
INNER JOIN + AGGREGATES
Write a query to:
-Show CustomerName		-Show total amount spent per customer
-Only include customers whose total spending is greater than 400
*/
			--2 ways to write it--
/*
1) Without indicating the table the columns are from:	*/
SELECT CustomerName,
	   SUM(Amount) AS Total_spent
FROM Customers_2
INNER JOIN Orders_2
ON Customers_2.CustomerID = Orders_2.CustomerID
GROUP BY CustomerName
HAVING SUM(Amount) > 400;

/* 
2) Indicating the table where the columns comes from	*/
SELECT Customers_2.CustomerName,
	   SUM(Orders_2.Amount) AS Total_spent
FROM Customers_2
INNER JOIN Orders_2
ON Customers_2.CustomerID = Orders_2.CustomerID
GROUP BY Customers_2.CustomerName
HAVING SUM(Orders_2.Amount) > 400;

/*  Can't be written as Orders_2.SUM(Amouont) AS Total_spent  */



USE MyDatabase
SELECT *
FROM Employees
