Q1: The total number of order place?
USE salesanalysis;

SELECT * FROM `orders.csv_orders.csv`;

SELECT COUNT(*) AS total_orders
FROM `orders.csv_orders.csv`;


Q2: The total revenue generated from pizza sales?

select * from `pizzas.csv_pizzas.csv`;

SELECT SUM(quantity * price) AS total_revenue
FROM `pizzas.csv_pizzas.csv`,`order_details.csv_order_details.csv` ;



Q3: The highest priced pizza?

SELECT *
FROM `pizzas.csv_pizzas.csv`
ORDER BY price DESC
LIMIT 1;


Q4: The most common pizza size ordered.

SELECT size, COUNT(*)
FROM `pizzas.csv_pizzas.csv`
GROUP BY size;

SELECT size
FROM `pizzas.csv_pizzas.csv`
GROUP BY size
ORDER BY COUNT(*) DESC
LIMIT 1;

Q5: The top 5 most ordered pizza types along their quantities.

SELECT pizza_type_id, COUNT(*) AS quantity
FROM `pizzas.csv_pizzas.csv`
GROUP BY pizza_type_id
ORDER BY quantity DESC
LIMIT 5;

Q6: The quantity of each pizza categories ordered.

SELECT category, COUNT(*) AS quantity
FROM `pizza_types.csv_pizza_types.csv`
GROUP BY category;


Q7: The distribution of orders by hours of the day.

SELECT
    HOUR(CONCAT(date, ' ', time)) AS order_hour,
    COUNT(*) AS order_count
FROM
    `orders.csv_orders.csv`
GROUP BY
    order_hour
ORDER BY
    order_hour;

Q8: The category-wise distribution of pizzas.

SELECT
    category,
    COUNT(*) AS total_orders
FROM
    `pizza_types.csv_pizza_types.csv`
GROUP BY
    category
ORDER BY
    total_orders DESC;
    
    
Q9: The average number of pizzas ordered per day.    

SELECT
  COUNT(*) / COUNT( DISTINCT 'date') AS avg_pizzas_per_day
FROM
 `pizza_types.csv_pizza_types.csv`;
 
 
Q10: Top 3 most ordered pizza type base on revenue.



SELECT 
    pt.name AS pizza_type_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM 
    salesanalysis.`order_details.csv_order_details.csv` od
JOIN 
    salesanalysis.`pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
JOIN 
    salesanalysis.`pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    total_revenue DESC
LIMIT 3;


#Q11: The percentage contribution of each pizza type to revenue.


WITH RevenueData AS (
    SELECT 
        pt.name AS pizza_type_name,
        SUM(od.quantity * p.price) AS total_revenue
    FROM 
        salesanalysis.`order_details.csv_order_details.csv` od
    JOIN 
        salesanalysis.`pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
    JOIN 
        salesanalysis.`pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY 
        pt.name
),TotalRevenue AS (
    SELECT 
        SUM(total_revenue) AS overall_revenue
    FROM 
        RevenueData
)
SELECT 
    rd.pizza_type_name,
    rd.total_revenue,
    (rd.total_revenue / tr.overall_revenue) * 100 AS percentage_contribution
FROM 
    RevenueData rd
CROSS JOIN 
    TotalRevenue tr;



#Q12: The cumulative revenue generated over time

 
WITH DailyRevenue AS (
    SELECT 
        o.date,
        SUM(od.quantity * p.price) AS daily_revenue
    FROM 
        salesanalysis.`order_details.csv_order_details.csv` od
    JOIN 
        salesanalysis.`pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
    JOIN 
        salesanalysis.`orders.csv_orders.csv` o ON od.order_id = o.order_id
    GROUP BY 
        o.date
),
CumulativeRevenue AS (
    SELECT 
        date,
        daily_revenue,
        SUM(daily_revenue) OVER (ORDER BY date) AS cumulative_revenue
    FROM 
        DailyRevenue
)
SELECT 
    date,
    daily_revenue,
    cumulative_revenue
FROM 
    CumulativeRevenue
ORDER BY 
    date;

#Q13: The top 3 most ordered pizza type based on revenue for each pizza category.

SELECT
    pt.category,
    pt.name AS pizza_type_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM
    salesanalysis.`order_details.csv_order_details.csv` od
JOIN
    salesanalysis.`pizzas.csv_pizzas.csv` p ON od.pizza_id = p.pizza_id
JOIN
    salesanalysis.`pizza_types.csv_pizza_types.csv` pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY
    pt.category, pt.name
ORDER BY
    pt.category, total_revenue DESC;