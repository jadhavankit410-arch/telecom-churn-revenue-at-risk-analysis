-- 04_business_queries.sql
-- 13 business questions on the churn_data view (churn rate, revenue lost, segments, reasons, revenue at risk).
USE telecom_churn;


-- QUESTION: 1) What % of customers left?
SELECT COUNT(*) AS customers,
       SUM(customer_status = 'Churned') AS churned,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data;



-- QUESTION: 2) How much monthly and yearly revenue did we lose from churned customers?
SELECT ROUND(SUM(monthly_charge), 2) AS monthly_lost,
       ROUND(SUM(monthly_charge) * 12, 2) AS yearly_lost
FROM churn_data
WHERE customer_status = 'Churned';

-- QUESTION: 3) Which contract type has the highest churn?
SELECT contract,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY contract
ORDER BY churn_pct DESC;


-- QUESTION: 4) Do new customers churn more? (churn % by tenure group)
SELECT CASE WHEN tenure_in_months <= 6  THEN '1) 0-6 months'
            WHEN tenure_in_months <= 12 THEN '2) 7-12 months'
            WHEN tenure_in_months <= 24 THEN '3) 13-24 months'
            ELSE '4) 25+ months' END AS tenure_group,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY tenure_group
ORDER BY tenure_group;


-- QUESTION:  5) Which internet type has the highest churn? (empty = no internet)
SELECT IFNULL(internet_type, 'No Internet') AS internet_type,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY internet_type
ORDER BY churn_pct DESC;


-- QUESTION:6) Which payment method has the highest churn?
SELECT payment_method,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY payment_method
ORDER BY churn_pct DESC;


-- QUESTION: 7) Which age group churns the most?
SELECT CASE WHEN age <= 30 THEN '1) up to 30'
            WHEN age <= 45 THEN '2) 31-45'
            WHEN age <= 60 THEN '3) 46-60'
            ELSE '4) 60+' END AS age_group,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY age_group
ORDER BY age_group;



-- QUESTION: 8) Which 10 cities have the highest churn? (cities with 30+ customers)
SELECT city,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
GROUP BY city
HAVING COUNT(*) >= 30
ORDER BY churn_pct DESC
LIMIT 10;


-- QUESTION: 9)  Why did customers leave? (churn category: customers and revenue lost)
SELECT churn_category,
       COUNT(*) AS customers,
       ROUND(SUM(monthly_charge), 2) AS monthly_revenue_lost
FROM churn_data
WHERE customer_status = 'Churned'
GROUP BY churn_category
ORDER BY monthly_revenue_lost DESC;

-- QUESTION: 10)  What are the top 10 churn reasons by revenue lost?
SELECT churn_reason,
       COUNT(*) AS customers,
       ROUND(SUM(monthly_charge), 2) AS monthly_revenue_lost
FROM churn_data
WHERE customer_status = 'Churned'
GROUP BY churn_reason
ORDER BY monthly_revenue_lost DESC
LIMIT 10;



-- QUESTION: 11) Do customers with Premium Tech Support churn less? (internet customers only)
SELECT premium_tech_support,
       COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct
FROM churn_data
WHERE internet_service = 'Yes'
GROUP BY premium_tech_support;




-- QUESTION: 12) How risky is Month-to-Month + Fiber Optic + first-year customers?
SELECT COUNT(*) AS customers,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct,
       ROUND(SUM(CASE WHEN customer_status = 'Churned' THEN monthly_charge END), 2) AS monthly_revenue_lost
FROM churn_data
WHERE contract = 'Month-to-Month'
  AND internet_type = 'Fiber Optic'
  AND tenure_in_months <= 12;
  
  
  
  
-- QUESTION: 13) How much yearly revenue is at risk for each contract type?
-- Revenue at risk = yearly revenue of customers still with us x past churn rate of that contract.
-- Assumption: the past churn rate is used as an estimate for the future.
SELECT contract,
       ROUND(AVG(customer_status = 'Churned') * 100, 2) AS churn_pct,
       ROUND(SUM(CASE WHEN customer_status = 'Stayed' THEN monthly_charge END) * 12, 2) AS yearly_revenue_active,
       ROUND(SUM(CASE WHEN customer_status = 'Stayed' THEN monthly_charge END) * 12
             * AVG(customer_status = 'Churned'), 2) AS revenue_at_risk
FROM churn_data
GROUP BY contract
ORDER BY revenue_at_risk DESC; 

