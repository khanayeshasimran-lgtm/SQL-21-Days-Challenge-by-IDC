-- Count the total number of patients in the hospital.
SELECT COUNT(*) AS total_patients FROM patients;

-- Calculate the average satisfaction score of all patients.
SELECT ROUND(AVG(satisfaction),1) AS avg_satisfaction
FROM patients;

-- Find the minimum and maximum age of patients.
SELECT MIN(age) AS youngest, MAX(age) AS oldest
FROM patients;

-- ### Daily Challenge:
/*Question:** Calculate the total number of patients admitted, 
total patients refused, and the average patient satisfaction 
across all services and weeks. Round the average satisfaction 
to 2 decimal places.*/
SELECT  
SUM(patients_admitted) AS patients_admitted,
SUM(patients_refused) AS patients_refused,
SUM(patient_satisfaction) AS patient_satisfaction,
ROUND(AVG (patient_satisfaction) ,2) AS patient_satisfaction
FROM services_weekly;
