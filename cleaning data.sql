SHOW databases
#n the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using.
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

#There is much debate about how much the name (or even the first letter of a company name) matters.
# Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT left(name, 1) AS first, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


#Use the accounts table and a CASE statement to create two groups: one group of company names that start with a
# number and a second group of those company names that start with a letter.
# What proportion of company names start with a letter?
select sum(num) numbers ,sum(letter) letters
from(
SELECT name, CASE WHEN LEFT(name, 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(name, 1)not IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS letter
      FROM accounts)t1
      
     #Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                        THEN 1 ELSE 0 END AS vowels, 
          CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                       THEN 0 ELSE 1 END AS other
         FROM accounts) t1;
         
         
         
 #Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT primary_poc,
LEFT(primary_poc,POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc,LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) AS last_name
FROM accounts a


#Each company in the accounts table wants to create an email address for each primary_poc.
# The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
with t1 as(
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,replace(name,' ','')
 FROM accounts)
select concat(first_name,'.',last_name,'@',replace)
from t1


#We would also like to create an initial password, which they will change after their first log in.
# The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase),
# the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, 
#the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.


with t1 as(
SELECT LEFT(primary_poc,STRPOS(primary_poc, ' ')-1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,replace(name,' ','')
FROM accounts)                                                             
select  left(first_name,1) ||  upper(right(first_name,1))||
upper(left(last_name,1)) ||
upper(right(last_name,1)) ||
length(first_name) || length(last_name) ||
upper(replace)
from t1            
            
            
#The format of the date column is mm/dd/yyyy with times that are not correct also at the end of the date.
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;


            



         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
 
      
