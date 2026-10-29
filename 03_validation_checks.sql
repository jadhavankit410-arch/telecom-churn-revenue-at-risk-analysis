-- 03_validation_checks.sql
-- Run after loading the data from Python (03_python/02_load_to_mysql.ipynb).
USE telecom_churn;

-- 1) Row counts of all 5 tables (expected: locations 1626, others 7043)
SELECT 'locations'    AS table_name, COUNT(*) AS row_count FROM locations
UNION ALL SELECT 'customers',    COUNT(*) FROM customers
UNION ALL SELECT 'services',     COUNT(*) FROM services
UNION ALL SELECT 'billing',      COUNT(*) FROM billing
UNION ALL SELECT 'churn_status', COUNT(*) FROM churn_status;

-- 2) Customer status split (expected: Stayed 4720, Churned 1869, Joined 454)
SELECT customer_status, COUNT(*) AS customers
FROM churn_status
GROUP BY customer_status;

-- 3) The view must exclude Joined customers (expected: 6589)
SELECT COUNT(*) AS rows_in_view FROM churn_data;
