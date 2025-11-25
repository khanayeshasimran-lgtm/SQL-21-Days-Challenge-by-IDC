-- 1. Rank patients by satisfaction score within each service.
SELECT patient_id, name, service, satisfaction,
RANK() OVER (
PARTITION BY service
ORDER BY satisfaction DESC
) AS satisfaction_rank
FROM patients;

-- 2. Assign row numbers to staff ordered by their name.
SELECT staff_id, staff_name,
ROW_NUMBER() OVER (ORDER BY staff_name ASC) AS row_num
FROM staff;

-- 3. Rank services by total patients admitted.
SELECT service,
SUM(patients_admitted) AS total_admitted,
RANK() OVER (ORDER BY SUM(patients_admitted) DESC) 
AS admission_rank FROM services_weekly
GROUP BY service;

/* Daily Challenge: Question: For each service, rank the weeks 
by patient satisfaction score (highest first). Show service, 
week, patient_satisfaction, patients_admitted, and the rank. 
Include only the top 3 weeks per service.*/
SELECT *
FROM (SELECT service, week, patient_satisfaction,
patients_admitted,
RANK() OVER (
PARTITION BY service
ORDER BY patient_satisfaction DESC
) AS satisfaction_rank
FROM services_weekly
) AS ranked_data
WHERE satisfaction_rank <= 3
ORDER BY service, satisfaction_rank, week;
