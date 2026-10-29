-- 02_create_view_churn_data.sql
-- Joins the 5 tables once and removes Joined (new) customers. Returns 6,589 rows.

USE telecom_churn;

CREATE OR REPLACE VIEW churn_data AS
SELECT c.customer_id, c.age, c.gender, c.married, c.tenure_in_months, c.number_of_referrals,
       l.city,
       s.internet_service, s.internet_type, s.premium_tech_support, s.online_security,
       b.contract, b.payment_method, b.monthly_charge,
       cs.customer_status, cs.churn_category, cs.churn_reason
FROM customers c
JOIN locations l     ON c.zip_code = l.zip_code
JOIN services s      ON c.customer_id = s.customer_id
JOIN billing b       ON c.customer_id = b.customer_id
JOIN churn_status cs ON c.customer_id = cs.customer_id
WHERE cs.customer_status <> 'Joined';
