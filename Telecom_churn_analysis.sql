create database Customer_churn;
use customer_churn;

-- show all data 
SELECT * FROM customer_churn.telco_customer_churn;

-- show top 5 rows
SELECT * FROM customer_churn.telco_customer_churn
ORDER BY customerID asc limit 5;

-- show last 5 rows
SELECT *
FROM customer_churn.telco_customer_churn
ORDER BY customerID DESC
LIMIT 5;

-- to see odd data based on customerid
SELECT * FROM customer_churn.telco_customer_churn
WHERE CAST(RIGHT(customerID, LENGTH(customerID) - 1) AS UNSIGNED) % 2 = 1;

 -- to see even data based on customerid
SELECT * FROM customer_churn.telco_customer_churn
WHERE CAST(RIGHT(customerID, LENGTH(customerID) - 1) AS UNSIGNED) % 2 = 0;

SELECT
    NTH_VALUE(TotalCharges, 2) OVER (ORDER BY TotalCharges) AS SecondSalary
FROM customer_churn.telco_customer_churn;
-- 2nd max based on total charge
SELECT *
FROM customer_churn.telco_customer_churn
ORDER BY TotalCharges DESC
LIMIT 1 , 1;
-- duplicate data

select count(*) FROM customer_churn.telco_customer_churn;
SELECT customerID, COUNT(*)
FROM customer_churn.telco_customer_churn
GROUP BY customerID
HAVING COUNT(*) >1;



-- Distribution of gender among customers

SELECT gender,COUNT(*) AS count
FROM customer_churn.telco_customer_churn
GROUP BY gender;

-- Number of senior citizens in the customer base:
SELECT 
    SUM(CASE WHEN SeniorCitizen = 1 THEN 1 ELSE 0 END) AS senior_citizens,
    SUM(CASE WHEN SeniorCitizen = 0 THEN 1 ELSE 0 END) AS not_senior_citizens
FROM customer_churn.telco_customer_churn;

-- SELECT sum(SeniorCitizen) AS senior_citizens;

-- Proportion and count of customers who have partners:

SELECT Partner,COUNT(*) AS count,
    COUNT(*) / (SELECT COUNT(*) FROM customer_churn.telco_customer_churn) AS proportion
FROM customer_churn.telco_customer_churn
GROUP BY Partner ;

-- Number of customers who have dependents:
SELECT Dependents,COUNT(*) AS count
FROM customer_churn.telco_customer_churn
GROUP BY Dependents;


-- Service Usage:
-- Percentage of customers with phone service
SELECT (COUNT(CASE WHEN PhoneService = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_phone_service
FROM customer_churn.telco_customer_churn;

-- count of customers with phone service
SELECT COUNT(CASE WHEN PhoneService = 'Yes' THEN 1 END) as customers_with_phone_service
FROM customer_churn.telco_customer_churn;

-- Number of customers with multiple lines:
SELECT COUNT(CASE WHEN MultipleLines = 'Yes' THEN 1 END) AS customers_with_multiple_lines
FROM customer_churn.telco_customer_churn;


-- Popularity of internet service among customers
SELECT InternetService,COUNT(*) AS count
FROM customer_churn.telco_customer_churn
GROUP BY InternetService;


-- Percentage of customers subscribed to specific services
SELECT 
    (COUNT(CASE WHEN OnlineSecurity = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_online_security,
    (COUNT(CASE WHEN OnlineBackup = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_online_backup,
    (COUNT(CASE WHEN DeviceProtection = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_device_protection,
    (COUNT(CASE WHEN TechSupport = 'Yes' THEN 1 END) / COUNT(*)) * 100 AS percentage_with_tech_support
FROM customer_churn.telco_customer_churn;

-- Number of customers subscribing to streaming TV and streaming movies services
SELECT 
    COUNT(CASE WHEN StreamingTV = 'Yes' THEN 1 END) AS customers_with_streaming_tv,
    COUNT(CASE WHEN StreamingMovies = 'Yes' THEN 1 END) AS customers_with_streaming_movies
FROM customer_churn.telco_customer_churn;

-- Contract and Billing
-- Different types of contracts customers are on
SELECT Contract,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY Contract;


-- Distribution of paperless billing among customers
SELECT PaperlessBilling,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY PaperlessBilling;

-- Most commonly used payment methods by customers
SELECT PaymentMethod,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY PaymentMethod
ORDER BY count_of_customers DESC;

-- checking for any missing values
select * from telco_customer_churn
where totalcharges = " "; 

-- removing missing values
DELETE FROM customer_churn.telco_customer_churn
WHERE TotalCharges = " ";

-- Financial Metrics
-- Range of monthly charges for customers
SELECT MIN(MonthlyCharges) AS min_monthly_charge,MAX(MonthlyCharges) AS max_monthly_charge
FROM customer_churn.telco_customer_churn;

-- Range of total charges for customers
SELECT MIN(TotalCharges) AS min_total_charge, MAX(TotalCharges) AS max_total_charge
FROM customer_churn.telco_customer_churn;

-- OR if column has null value, empty string or any other values other than the actual value  then it can be done in other ways like example below
SELECT 
    MIN(CAST(TotalCharges AS float)) AS min_total_charge, 
    MAX(CAST(TotalCharges AS float)) AS max_total_charge
FROM 
    customer_churn.telco_customer_churn
WHERE 
    TotalCharges IS NOT NULL 
    AND TotalCharges != '' 
    AND TotalCharges REGEXP '^[0-9]+(\.[0-9]+)?$';
    

-- Correlation between tenure and total charges
SELECT 
    (COUNT(*) * SUM(tenure * TotalCharges) - SUM(tenure) * SUM(TotalCharges)) /
    (SQRT((COUNT(*) * SUM(tenure * tenure) - SUM(tenure) * SUM(tenure))) * 
     SQRT((COUNT(*) * SUM(TotalCharges * TotalCharges) - SUM(TotalCharges) * SUM(TotalCharges)))
    ) AS correlation_tenure_total_charges
FROM customer_churn.telco_customer_churn;

-- Churn Analysis
-- Overall churn rate in the dataset
SELECT AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn;

SELECT churn,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY Churn;

-- Difference in churn rates between different contract types
SELECT Contract,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY Contract;


-- Common characteristics among churned customers
SELECT gender,SeniorCitizen,Partner,Dependents,tenure,PhoneService,MultipleLines,InternetService,OnlineSecurity,
    OnlineBackup,DeviceProtection,TechSupport,StreamingTV,StreamingMovies,Contract,PaperlessBilling,
    PaymentMethod,MonthlyCharges,TotalCharges
FROM customer_churn.telco_customer_churn
WHERE Churn = 'Yes';

select * FROM customer_churn.telco_customer_churn
WHERE Churn = 'No';

select count(*) FROM customer_churn.telco_customer_churn
WHERE Churn = 'No';
select count(*) FROM customer_churn.telco_customer_churn
WHERE Churn = 'Yes';

-- Distribution of tenure among customers
SELECT tenure,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by count_of_customers desc;

SELECT tenure,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by count_of_customers ;

SELECT tenure,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by tenure desc;

SELECT tenure,COUNT(*) AS count_of_customers
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by tenure ;

-- relation between tenure and churn
SELECT tenure,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY tenure;

SELECT tenure,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by churn_rate desc;

SELECT tenure,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by churn_rate ;

SELECT tenure,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by churn_rate 
limit 5;

SELECT tenure,AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY tenure
order by churn_rate desc
limit 5;


-- Monthly Charges Analysis:

-- Average monthly charge for customers who churned versus those who didn't
SELECT Churn,AVG(MonthlyCharges) AS avg_monthly_charge
FROM customer_churn.telco_customer_churn
GROUP BY Churn;

-- Difference in monthly charges between different internet service types
SELECT InternetService,AVG(MonthlyCharges) AS avg_monthly_charge
FROM customer_churn.telco_customer_churn
GROUP BY InternetService;

-- Churn Rate by Tenure Category:
-- Group customers into different tenure categories 
-- ( short-term, medium-term, long-term) and analyze churn rates within each category.

SELECT tenure_category,COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM (SELECT *,
        CASE
            WHEN tenure < 12 THEN 'Short-term'
            WHEN tenure >= 12 AND tenure < 36 THEN 'Medium-term'
            ELSE 'Long-term'
        END AS tenure_category
    FROM customer_churn.telco_customer_churn
) AS categorized_customers
GROUP BY tenure_category;

-- Churn Rate by Service Subscriptions:
-- Analyze how different service subscriptions ( online security, streaming services) correlate with churn rate.
SELECT OnlineSecurity,COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM customer_churn.telco_customer_churn
GROUP BY OnlineSecurity ;