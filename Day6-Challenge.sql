-- Count the number of patients by each service.
SELECT service, COUNT(*) AS patient_count
FROM patients
GROUP BY service;

-- Calculate the average age of patients grouped by service.
SELECT service,
ROUND(AVG(age),2) AS avg_age
FROM patients
GROUP BY service;

-- Find the total number of staff members per role.
SELECT role, 
COUNT(staff_id) AS total_staff
FROM staff
GROUP BY role;

/* For each hospital service, calculate the total number of 
patients admitted, total patients refused, and the admission 
rate (percentage of requests that were admitted). Order by 
admission rate descending.*/
SELECT service,
SUM(patients_admitted) AS Total_Patients_Admitted,
SUM(patients_refused) AS Total_Patients_Refused,
ROUND((SUM(patients_admitted) * 100.0 / 
SUM(patients_request)),2) AS Admission_Rate
FROM services_weekly
GROUP BY service
ORDER BY Admission_Rate DESC;
