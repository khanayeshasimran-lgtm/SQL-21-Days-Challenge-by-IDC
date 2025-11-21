-- Find patients who are in services with above-average staff count.
SELECT name AS patient_name, service
FROM patients
WHERE service IN (
SELECT service
FROM staff
GROUP BY service
HAVING COUNT(staff_id) >
(SELECT AVG(staff_count)
FROM (SELECT COUNT(staff_id) AS staff_count
FROM staff
GROUP BY service) AS t)
);

-- List staff who work in services that had any week with patient satisfaction below 70.
SELECT staff_name, service
FROM staff
WHERE service IN (
SELECT service
FROM services_weekly
WHERE patient_satisfaction < 70
);

-- Show patients from services where total admitted patients exceed 1000.
SELECT name AS patient_name, service
FROM patients
WHERE service IN (
SELECT service
FROM services_weekly
GROUP BY service
HAVING SUM(patients_admitted) > 1000
);
/*Question: Find all patients who were admitted to services that had 
at least one week where patients were refused AND the average patient 
satisfaction for that service was below the overall hospital average 
satisfaction. Show patient_id, name, service, and their personal 
satisfaction score.*/
SELECT patient_id,
name AS patient_name, service, satisfaction
FROM patients
WHERE service IN (
SELECT DISTINCT service
FROM services_weekly
WHERE patients_refused > 0)
AND service IN (
SELECT service
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction) <
(SELECT AVG(patient_satisfaction) FROM services_weekly)
);
