SELECT * FROM bank_data;

-- ************ Customer & Financial Analysis **********

-- What is the distribution of customers by job type, marital status, and education level?

SELECT job, COUNT(*) AS job_counts, AVG(balance) AS average_balance
FROM bank_data
GROUP BY job
ORDER BY 2 DESC, 3 DESC;

SELECT marital, COUNT(*) AS marital_counts, AVG(balance) AS average_balance
FROM bank_data
GROUP BY marital
ORDER BY 2 DESC, 3 DESC;

SELECT education, COUNT(*) AS education_counts, AVG(balance) AS average_balance
FROM bank_data
GROUP BY education
ORDER BY 2 DESC, 3 DESC;


-- What percentage of customers have a negative balance?

SELECT CASE
		WHEN balance < 0 THEN 'Negative Balance'
		WHEN balance BETWEEN 0 AND 5000 THEN 'Low Balance'
		WHEN balance BETWEEN 5001 AND 20000 THEN 'Medium Balance'
		ELSE 'High Balance'
	END AS balance_category,
	COUNT(*) AS customer_count,
	ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM bank_data), 2) AS percentage
FROM bank_data
GROUP BY balance_category
ORDER BY percentage DESC;


-- What percentage of customers with personal loans (loan = yes) also have a history of credit default (default = yes)?

SELECT COUNT(*) AS total_customers,
		SUM(CASE WHEN loan = 'yes' THEN 1 ELSE 0 END) AS loan_defaulters,
       	ROUND((SUM(CASE WHEN loan = 'yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS percentage
FROM bank_data;


--  Find the average balance for each job category and rank them in descending order.

SELECT job, ROUND(AVG(balance), 2) AS avg_balance, 
		RANK() OVER(ORDER BY ROUND(AVG(balance), 2) DESC) AS rnk
FROM bank_data
GROUP BY job
ORDER BY avg_balance DESC;


--  What percentage of customers subscribed to a term deposit (`y = 'yes'`) across different age groups?

SELECT 
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age >= 18 AND age <= 28 THEN 'Adult'
        WHEN age >= 29 AND age < 50 THEN 'Mid-aged'
        WHEN age >= 50 THEN 'Old'
    END AS age_group, 
	(COUNT(*) * 100/(SELECT COUNT(*) FROM bank_data WHERE y='yes')) AS subscription_rate
FROM bank_data
WHERE y = 'yes'
GROUP BY age_group
ORDER BY 2 DESC;


-- Find customers who subscribed and had high balances

SELECT 
    job, education, marital, 
    ROUND(AVG(balance),2) AS avg_balance, 
    COUNT(*) AS success_count
FROM bank_data
WHERE y = 'yes' AND balance > (SELECT AVG(balance) FROM bank_data)
GROUP BY job, education, marital
ORDER BY avg_balance DESC
LIMIT 5;



-- ************ Marketing Campaign Performance **********

-- Calculate the overall success rate of the marketing campaign (y = 'yes'). How does it vary across different job categories?

SELECT 
	job,
	COUNT(*) AS total_customers,
	SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_conversions,
    ROUND((SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_rate
FROM bank_data
GROUP BY job
ORDER BY success_rate DESC;	


-- How does the number of previous contacts (previous) affect the likelihood of a successful campaign (y = yes)?

SELECT 
    previous, COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate
FROM bank_data
WHERE previous IS NOT NULL
GROUP BY previous
HAVING COUNT(*) >= 5
ORDER BY previous;


-- Identify the best month and day to contact customers based on the highest conversion rate (y = yes)

SELECT 
    month,
    day,
    ROUND(100.0 * SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS conversion_rate
FROM bank_data
GROUP BY month, day
ORDER BY conversion_rate DESC
LIMIT 1;


-- On which days were calls most effective in converting subscriptions?

WITH daily_data AS(
	SELECT day, COUNT(*) AS total,
	SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS total_y
	FROM bank_data
	GROUP BY day
)

SELECT day, round((total_y*100.00/total),2) AS subscription_rate
FROM daily_data
ORDER BY subscription_rate DESC;


-- What is the success rate of the campaign based on the number of previous contacts (`previous`) or days since last contact (`pdays`)?

WITH success_contacts AS (
	SELECT pdays, COUNT(*) AS yes_subscriptions
	FROM bank_data
	WHERE y = 'yes'
	GROUP BY pdays
)

SELECT a.pdays, COUNT(a.customer_id) AS customers_contacted, 
		(yes_subscriptions *  100 / COUNT(a.customer_id)) AS subscription_rate
FROM bank_data a
JOIN success_contacts b 
ON a.pdays = b.pdays
GROUP BY a.pdays, yes_subscriptions
order by a.pdays;


--  Find the distribution of successful conversions (y = yes) across different months.

SELECT month, COUNT(*) AS successful_conversions
FROM bank_data
WHERE y = 'yes'
GROUP BY month
ORDER BY successful_conversions DESC;


-- For customers who previously subscribed, what percentage subscribed again in the current campaign?

SELECT 
    ROUND((SUM(CASE WHEN poutcome = 'success' AND y = 'yes' THEN 1 ELSE 0 END) * 100.0 / 
     SUM(CASE WHEN poutcome = 'success' THEN 1 ELSE 0 END)),2) AS retention_rate
FROM bank_data;

-- ********** Actionable Insights *********

-- What is the relationship between call duration and subscription success? Is there an optimal call duration range?

WITH duration_ranges AS (
  SELECT 
    CASE 
      WHEN duration BETWEEN 0 AND 30 THEN '0-30 seconds'
      WHEN duration BETWEEN 31 AND 60 THEN '31-60 seconds'
      WHEN duration BETWEEN 61 AND 120 THEN '61-120 seconds'
      WHEN duration BETWEEN 121 AND 300 THEN '121-300 seconds'
      WHEN duration > 300 THEN '300+ seconds'
    END AS duration_range,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_calls
  FROM bank_data
  GROUP BY 
    CASE 
      WHEN duration BETWEEN 0 AND 30 THEN '0-30 seconds'
      WHEN duration BETWEEN 31 AND 60 THEN '31-60 seconds'
      WHEN duration BETWEEN 61 AND 120 THEN '61-120 seconds'
      WHEN duration BETWEEN 121 AND 300 THEN '121-300 seconds'
      WHEN duration > 300 THEN '300+ seconds'
    END
)
SELECT 
  duration_range,
  total_calls,
  successful_calls,
  ROUND((successful_calls * 100.0 / total_calls), 2) AS subscription_rate
FROM duration_ranges
ORDER BY duration_range;


-- How does customer default status (`default`) affect subscription rates?

WITH default_data AS (
  SELECT 
    'default',
    COUNT(*) AS total_customers,
    SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_subscriptions
  FROM bank_data
  GROUP BY 1
)
SELECT 
  'default',
  total_customers,
  successful_subscriptions,
  ROUND((successful_subscriptions * 100.0 / total_customers), 2) AS subscription_rate
FROM default_data
ORDER BY subscription_rate DESC;


-- Month-over-Month Growth in Campaign Success

WITH monthly_success AS (
    SELECT 
        month, 
        COUNT(*) AS total_calls,
        SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) AS successful_conversions,
        ROUND((SUM(CASE WHEN y = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS success_rate
    FROM bank_data
    GROUP BY month
)
SELECT 
    month, 
    total_calls, 
    successful_conversions, 
    success_rate,
    LAG(success_rate) OVER (ORDER BY month) AS previous_month_success_rate,
    (success_rate - LAG(success_rate) OVER (ORDER BY month)) AS success_rate_change
FROM monthly_success
ORDER BY success_rate DESC;

