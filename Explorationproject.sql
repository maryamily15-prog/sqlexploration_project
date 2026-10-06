--Exploring the order table
SELECT 
COUNT(*) AS Everything,
SUM(total_amount) AS Total_Revenue,
AVG(total_amount) AS Average_Revenue,
MIN(total_amount) AS lower_amount,
MAX(total_amount) AS Hightest
FROM Orders


--Explore the customer table,Examine each location of the customer using the right query
SELECT country,COUNT (*) AS Total_category
FROM PROJECT.dbo.Customers
GROUP BY country
ORDER BY country ASC

--Explore the product table,examine to understand how product are in each category and the pricing structure on each category
SELECT category, COUNT (*) AS Total_category
FROM PROJECT.dbo.Products
GROUP BY category
ORDER BY category DESC

SELECT Category,
AVG (price) AS avg_price,
MIN (price) AS lowest_price,
MAX (price) AS highesr_price
FROM PROJECT.dbo.Products
GROUP BY category
ORDER BY avg_price DESC
--Having VIEW for it
CREATE VIEW pricing_structure AS
SELECT Category,
AVG (price) AS avg_price,
MIN (price) AS lowest_price,
MAX (price) AS highesr_price
FROM PROJECT.dbo.Products
GROUP BY category


--Knowing the highest value order
SELECT 
order_id,customer_id,order_date,total_amount
FROM PROJECT.dbo.Orders
WHERE total_amount >= 1000

SELECT*
FROM PROJECT.dbo.Orders
WHERE total_amount BETWEEN 500 AND 900
ORDER BY total_amount ASC 

--Looping into 3 countries to know customers
SELECT *
FROM PROJECT.dbo.Customers
WHERE country IN ('Mexico','Nigeria','Italy')
ORDER BY country ASC

-- Order by date range
SELECT *
FROM PROJECT.dbo.Orders
WHERE order_date BETWEEN '2025-01-10' AND '2025-03-15'
ORDER BY order_date ASC

--Join 2 table to find out how many order each customer made and revenue per each customer
SELECT
CU.customer_id,
CU.customer_name,
ORD.order_id,
ORD.order_date,
ORD.total_amount
FROM PROJECT.dbo.Customers CU
JOIN PROJECT.dbo.Orders ORD
ON CU.customer_id = ORD.customer_id
ORDER BY total_amount DESC

-- group customers based on their spending using ctE AND CASE
WITH CTE_customerspending AS
( SELECT 
CUS.customer_id,
CUS.customer_name,
SUM(ORD.total_amount)  AS total_spending
FROM PROJECT.DBO.Customers CUS
JOIN PROJECT.dbo.Orders ORD
ON CUS.customer_id = ORD.customer_id
GROUP BY
CUS.customer_id,
CUS.customer_name
)
SELECT *,
CASE 
WHEN total_spending >= 2800 THEN 'VIP'
WHEN total_spending >= 1000 THEN 'STANDARD'
ELSE 'Regular'
END AS  CUSTOMER_PACKAGE
FROM CTE_customerspending
ORDER BY CUSTOMER_PACKAGE DESC

DROP TABLE IF EXISTS #CUSTOMER_ORDER 
CREATE TABLE #CUSTOMER_ORDER
(
Customer_ID INT,
Customer_name VARCHAR (100),
Country VARCHAR (100),
Total_orders INT,
Total_revenue DECIMAL (18,2),
Average_ordervalue DECIMAL (18,2),
)

INSERT INTO #CUSTOMER_ORDER
(
Customer_ID,
Customer_name,
Country,
Total_orders,
Total_revenue,
Average_ordervalue
)
SELECT 
CUS.customer_id,
CUS.customer_name,
CUS.country,
COUNT(ORD.Order_id) AS Total_orders,
SUM(ORD.total_amount)  AS Total_revenue,
AVG(ORD.total_amount) AS Average_ordervalue
FROM PROJECT.DBO.Customers CUS
JOIN PROJECT.dbo.Orders ORD
ON CUS.customer_id = ORD.customer_id
GROUP BY
CUS.customer_id,
CUS.customer_name,
CUS.country

-- LET SEE HIGH VALUE CUSTOMERS
SELECT *
FROM #CUSTOMER_ORDER
WHERE Total_revenue >=2800
ORDER BY Total_revenue DESC

CREATE VIEW Highvaluecustomer AS 
WITH CTE_customerspending AS
( SELECT 
CUS.customer_id,
CUS.customer_name,
SUM(ORD.total_amount)  AS total_spending
FROM PROJECT.DBO.Customers CUS
JOIN PROJECT.dbo.Orders ORD
ON CUS.customer_id = ORD.customer_id
GROUP BY
CUS.customer_id,
CUS.customer_name
)
SELECT *,
CASE 
WHEN total_spending >= 2800 THEN 'VIP'
WHEN total_spending >= 1000 THEN 'STANDARD'
ELSE 'Regular'
END AS  CUSTOMER_PACKAGE
FROM CTE_customerspending