CREATE DATABASE IF NOT EXISTS telecom_churn;
USE telecom_churn;

CREATE TABLE locations (
    zip_code   INT PRIMARY KEY,
    city       VARCHAR(100),
    latitude   DECIMAL(10,6),
    longitude  DECIMAL(10,6)
);

CREATE TABLE customers (
    customer_id          VARCHAR(20) PRIMARY KEY,
    gender               VARCHAR(10),
    age                  INT,
    married              VARCHAR(5),
    number_of_dependents INT,
    number_of_referrals  INT,
    tenure_in_months     INT,
    offer                VARCHAR(30),
    zip_code             INT,
    FOREIGN KEY (zip_code) REFERENCES locations(zip_code)
);

CREATE TABLE services (
    customer_id                       VARCHAR(20) PRIMARY KEY,
    phone_service                     VARCHAR(5),
    avg_monthly_long_distance_charges DECIMAL(10,2),
    multiple_lines                    VARCHAR(5),
    internet_service                  VARCHAR(5),
    internet_type                     VARCHAR(30),
    avg_monthly_gb_download           INT,
    online_security                   VARCHAR(5),
    online_backup                     VARCHAR(5),
    device_protection_plan            VARCHAR(5),
    premium_tech_support              VARCHAR(5),
    streaming_tv                      VARCHAR(5),
    streaming_movies                  VARCHAR(5),
    streaming_music                   VARCHAR(5),
    unlimited_data                    VARCHAR(5),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE billing (
    customer_id                  VARCHAR(20) PRIMARY KEY,
    contract                     VARCHAR(20),
    paperless_billing            VARCHAR(5),
    payment_method               VARCHAR(30),
    monthly_charge               DECIMAL(10,2),
    total_charges                DECIMAL(10,2),
    total_refunds                DECIMAL(10,2),
    total_extra_data_charges     DECIMAL(10,2),
    total_long_distance_charges  DECIMAL(10,2),
    total_revenue                DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE churn_status (
    customer_id     VARCHAR(20) PRIMARY KEY,
    customer_status VARCHAR(10),
    churn_category  VARCHAR(30),
    churn_reason    VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


USE telecom_churn;
SHOW TABLES;