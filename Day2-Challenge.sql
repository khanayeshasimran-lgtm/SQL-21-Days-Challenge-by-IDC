SELECT *FROM patients;

-- Find all patients who are older than 60 years.
SELECT * FROM patients WHERE age > 60;

-- Retrieve all staff members who work in the 'Emergency' service.
SELECT * FROM patients
WHERE service = 'emergency';

/*List all weeks where more than 100 patients 
requested admission in any service.*/
SELECT week, service, SUM(patients_request) AS total_requests
FROM services_weekly
GROUP BY week, service
HAVING SUM(patients_request) > 100;

/*Daily Challenge: Question: Find all patients 
admitted to 'Surgery' service with a satisfaction 
score below 70, showing their patient_id, name, 
age, and satisfaction score.*/
SELECT patient_id, name, age, satisfaction 
FROM patients
WHERE service = 'surgery' AND satisfaction < 70;
