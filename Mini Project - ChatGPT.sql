
--										5.8.26
--					?? Mini SQL Project — Online Retail Store Analysis

--			This project is designed around the exact SQL topics you’ve practiced:
--			SELECT
--			FROM
--			WHERE
--			ORDER BY
--			GROUP BY
--			HAVING
--			DISTINCT
--			Aggregates
--			INNER JOIN
--			LEFT JOIN
--			RIGHT JOIN
--			FULL JOIN concepts

--			No advanced SQL yet.

------------------------------------------------------------------
--			 ?? Scenario

--	You are a junior data analyst for an online retail company.

--	Management wants insights about:
--	customers
--	products
--	orders
--	departments

--	Your job is to write SQL queries to answer business questions.

--------------------------------------------------------------------

--	?? Create Database Tables:

		--	Table 1: customers	--
USE MyDatabase

CREATE TABLE customers_2 (customer_id INT PRIMARY KEY,
						customer_name VARCHAR(50),
						city VARCHAR(50) 
						);
INSERT INTO customers_2 
VALUES (101, 'Alice', 'New York'),
	   (102, 'Bob', 'Chicago'),
	   (103, 'Charlie', 'Boston'),
	   (104, 'Diana', 'Seattle');

SELECT *
FROM customers_2

DROP TABLE Customers_2
--	Dropped the table. There was an exisiting table

--							5.13.26
					--	Table 2: Products	--
Create TABLE products (product_id INT PRIMARY KEY,
					  product_name VARCHAR(50),
					  category VARCHAR(50),
					  price INT);

INSERT INTO products 
VALUES (1, 'Laptop', 'Tech', 1000),
	   (2, 'Mouse', 'Tech', 50),
	   (3, 'Desk', 'Furniture', 300),
	   (4, 'Chair', 'Furniture', 150),
	   (5, 'Monitor', 'Tech', 200);

SELECT *
FROM products

						--	Table 3: Orders --
CREATE TABLE orders_3 (order_id INT PRIMARY KEY,
					   customer_id INT,
					   product_id INT,
					   quantity INT);

INSERT INTO orders_3
VALUES (1001, 101, 1, 1),
	   (1002, 101, 2, 2),
	   (1003, 102, 3, 1),
	   (1004, 103, 5, 2),
	   (1005, 105, 4, 1);

SELECT *
FROM orders_3

--					Project questions
--	Question 1: Write a query to display:
--				All customers
--				Sort alphabetically by customer name

SELECT *
FROM customers_2
ORDER BY customer_name ASC;

--	Question 2: Write a query to display:
--				Product name
--				Price
--	But only include products where:
--			Price is greater than 200
--			Sort results from highest price to lowest

SELECT product_name,
	   price
FROM products
WHERE price > 200
ORDER BY price DESC

--	Question 3: Write a query to show:
--			Category
--			Average product price per category
--	But only include categories where:
--		Average price is greater than 300

SELECT category,
	   AVG(price) AS average_price
FROM products
GROUP BY category
HAVING AVG(price) > 300;

--	Question 4: Write a query to show:
--				Customer name
--				Product name
--				Quantity ordered
--	Requirements:
--			Include all orders
--			Match customer/product information where possible

SELECT customers_2.customer_name,
	   products.product_name,
	   orders_3.quantity
FROM customers_2
FULL JOIN orders_3
ON customer_2.customer_id = orders_3.customer_id

---	It's wrong. Correct answer:

SELECT customers_2.customer_name,
	   products.product_name,
	   orders_3.quantity
FROM orders_3
LEFT JOIN customers_2
ON orders_3.customer_id = customers_2.customer_id
LEFT JOIN products
ON orders_3.product_id = products.product_id

				--	Note	--
/* 
Use the LEFT JOIN b/c the questions is asking to include 
ALL ORDERS (making this the main table that will be seen in 'ON' | 
Also this table is the only one with columns that can be linked to the 
other tables)
and include matched customer/product information where is possible 
* The order of the table matters with this join 
* It also preserve all orders

*/


--			?? Question 5 — Aggregation + JOIN

--	Write a query to show:
--			customer name
--			total quantity of items ordered by each customer

--	BUT:
--	only include customers whose total quantity ordered is greater than 2

--	Tables involved
--		orders
--		customers

SELECT customers_2.customer_name,
	   SUM(orders_3.quantity) AS order_quantity
FROM  customers_2					--Doesn't matter if orders_3 TABLE is in here or with the clause JOIN
LEFT JOIN orders_3					--Both switch of the table will yield the same results due to the filter 
ON customers_2.customer_id = orders_3.customer_id
GROUP BY customers_2.customer_name
HAVING SUM(orders_3.quantity) > 2;

/* 
If the question asks include customers even if they never ordered anything

			FROM customers_2
			LEFT JOIN orders_3
Would be a better choice */

--						?? Question 6 — DISTINCT + ORDER BY	
--	Write a query to display:
--		Unique product categories only
--		Sort them alphabetically.

SELECT DISTINCT category
FROM products
ORDER BY category ASC

--				?? Question 7 — JOIN Decision Challenge
--	Write a query to show:
--		customer name
--		order ID
--		quantity

--	Requirements:
--		include ALL customers
--		show matching orders where possible

SELECT customers_2.customer_name,
	   orders_3.order_id,
	   orders_3.quantity
FROM customers_2
LEFT JOIN orders_3
ON customers_2.customer_id = orders_3.customer_id;
	   
--	This will yield the same results, except how the results are view:
SELECT customers_2.customer_name,
	   orders_3.order_id,
	   orders_3.quantity
FROM orders_3
LEFT JOIN customers_2
ON customers_2.customer_id = orders_3.customer_id;
	   
--					?? Final Project Question (Capstone)
--		?? Question 8 (Capstone)
--	Write a query to show:
--		customer name
--		total revenue per customer
--		Revenue formula:
--		quantity × product price

--	Requirements:
--		include only customers with revenue > 500
--		include all matching orders

--	Tables involved
--		customers
--		orders
--		products

SELECT customers_2.customer_name,
	   (orders_3.quantity * products.price) 
FROM orders_3
LEFT JOIN customers_2
ON orders_3.customer_id = customers_2.customer_id
LEFT JOIN orders_3				--Once the table(orders_3) had been used before, can't use it again like this
ON orders_3.product_id = products.product_id
GROUP BY customers_2.customer_name
HAVING (orders_3.quantity * products.price) > 500 

--	CORRECT ANSWER:
SELECT customers_2.customer_name,
       SUM(orders_3.quantity * products.price) AS total_revenue
FROM orders_3
LEFT JOIN customers_2
ON orders_3.customer_id = customers_2.customer_id
LEFT JOIN products
ON orders_3.product_id = products.product_id
GROUP BY customers_2.customer_name
HAVING SUM(orders_3.quantity * products.price) > 500;

--To know what I am seeing and to see if the tables exist, do this:

SELECT *
FROM customers_2;

SELECT *
FROM products;

SELECT * 
FROM orders_3

/* 
SUMMARY:
-Make sure the name of the tables/columns are spelled correctly. 
	-Otherwise, there will be syntax error or errors in general
-Optional + Habits = use alias as often as possible 
-Table can be bounded once. Then, rotate to another tables that binds it
	Like: orders_3 to customers_2 | products to orders_3

EXAMPLE OF MULTIPLE JOINS  */
--Example 1
SELECT customers_2.customer_name,
	   products.product_name,
	   orders_3.quantity
FROM orders_3
LEFT JOIN customers_2
ON orders_3.customer_id = customers_2.customer_id
LEFT JOIN products			--This table differs from the 1st LEFT JOIN
ON orders_3.product_id = products.product_id

--Example 2:
SELECT customers_2.customer_name,
       SUM(orders_3.quantity * products.price) AS total_revenue
FROM orders_3
LEFT JOIN customers_2
ON orders_3.customer_id = customers_2.customer_id
LEFT JOIN products			--Same pattern as the 1st example
ON orders_3.product_id = products.product_id
GROUP BY customers_2.customer_name
HAVING SUM(orders_3.quantity * products.price) > 500;


--				SQL project completed on 5.17.26
--	Getting the hang of multi JOINS | Will do more practice