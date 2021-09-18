# the total amount of poster_qty paper ordered in the orders table.
select sum(poster_qty)
from orders o


# the total amount of standard_qty paper ordered in the orders table.
select sum(standard_qty )
from orders o

# the standard_amt_usd per unit of standard_qty paper. 
select (sum(standard_amt_usd )/sum(standard_qty ))
from orders o


# the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

#How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1, 2
HAVING COUNT(*) > 5
ORDER BY 3;


#the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;
 
 
 #Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
 SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

#Write a query to display the number of orders in each of three categories, based on the total number of items in each order
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

