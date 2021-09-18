#Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
with t2 as(
SELECT s.name rep,r.name region,sum(o.total_amt_usd) 
FROM accounts a
join sales_reps s
on a.sales_rep_id = s.id
join region r
on r.id = s.region_id
join orders o
on a.id = o.account_id
group by 1,2
order by 3 desc
  ), t1 as (
select region,max(sum) from(
SELECT s.name rep,r.name region,sum(o.total_amt_usd) 
FROM accounts a
join sales_reps s
on a.sales_rep_id = s.id
join region r
on r.id = s.region_id
join orders o
on a.id = o.account_id
group by 1,2
order by 3 desc
  ) tt
 group by 1
 order by 2
)
select t2.*
from t2
join t1 
on t2.sum = t1.max


#For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
with t1 as(
select r.name,sum(total_amt_usd)
FROM accounts a
join sales_reps s
on a.sales_rep_id = s.id
join region r
on r.id = s.region_id
join orders o
on a.id = o.account_id
group by 1
order by 2 DESC
limit 1  )
select r.name,count(o.*)
FROM accounts a
join sales_reps s
on a.sales_rep_id = s.id
join region r
on r.id = s.region_id
join orders o
on a.id = o.account_id
join t1 
on t1.name = r.name
group by 1



#How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) t2)
             ) t1;



#  For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?           

with t1 as(
select a.name,sum(o.total_amt_usd)
FROM accounts a
join sales_reps s
on a.sales_rep_id = s.id
join region r
on r.id = s.region_id
join orders o
on a.id = o.account_id
group by 1  order by 2 DESC
limit 1 )
select a.name,w.channel,count(w.*)
from web_events w
join accounts a on w.account_id = a.id
join t1 on a.name = t1.name
group by 1,2 order by 3 DESC


#What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) t1 ;





#What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, 
#on average, than the average of all orders
select avg(avg) from(
select o.account_id,avg(o.total_amt_usd)
from orders o
group by 1                     
having avg(o.total_amt_usd)>(select avg(o.total_amt_usd) av from orders o)
order by 2 )t1

