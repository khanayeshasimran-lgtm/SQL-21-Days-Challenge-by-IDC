/* 1. Create a CTE to calculate service statistics, then query from it.*/
WITH service_stats AS (SELECT service,
COUNT(*) AS total_patients,
AVG(satisfaction) AS avg_satisfaction
FROM patients
GROUP BY service)
SELECT *
FROM service_stats;

/*2. Use multiple CTEs to break down a complex query into logical steps.*/
WITH admissions AS (SELECT service,
SUM(patients_admitted) AS total_admitted
FROM services_weekly
GROUP BY service
),
refusals AS (
SELECT service,
SUM(patients_refused) AS total_refused
FROM services_weekly
GROUP BY service
),
combined AS (
SELECT a.service, a.total_admitted, r.total_refused,
ROUND(
100.0 * a.total_admitted / (a.total_admitted + r.total_refused),2) 
AS admission_rate
FROM admissions a
JOIN refusals r ON a.service = r.service
)
SELECT *
FROM combined;

/* 3. Build a CTE for staff utilization and join it with patient data.*/
WITH staff_utilization AS (
SELECT
service,
COUNT(*) AS total_staff
FROM staff
GROUP BY service
)
SELECT * FROM staff_utilization;

/*Daily Challenge: Create a comprehensive hospital performance 
dashboard using CTEs. Calculate: 1) Service-level metrics (total 
admissions, refusals, avg satisfaction), 2) Staff metrics per 
service (total staff, avg weeks present), 3) Patient demographics 
per service (avg age, count). Then combine all three CTEs to create 
a final report showing service name, all calculated metrics, and an 
overall performance score (weighted average of admission rate and 
satisfaction). Order by performance score descending.*/
WITH service_metrics AS (
SELECT
service,
SUM(patients_admitted) AS total_admissions,
SUM(patients_refused) AS total_refusals,
AVG(patient_satisfaction) AS avg_satisfaction
FROM services_weekly
GROUP BY service
),
staff_metrics AS (
SELECT
service,
COUNT(*) AS total_staff
FROM staff
GROUP BY service
),
patient_demographics AS (
SELECT
service,
AVG(age) AS avg_age,
COUNT(*) AS patient_count
FROM patients
GROUP BY service
)
SELECT sm.service, sm.total_admissions, sm.total_refusals,
sm.avg_satisfaction, st.total_staff, pd.avg_age, pd.patient_count,
ROUND(0.6 * (CASE 
WHEN sm.total_refusals = 0 THEN 100
ELSE 100.0 * sm.total_admissions /
(sm.total_admissions + sm.total_refusals)
END
) + 0.4 * sm.avg_satisfaction,2) AS performance_score
FROM service_metrics sm
LEFT JOIN staff_metrics st ON sm.service = st.service
LEFT JOIN patient_demographics pd ON sm.service = pd.service
ORDER BY performance_score DESC;
