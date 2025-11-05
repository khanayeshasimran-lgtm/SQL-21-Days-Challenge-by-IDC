-- List all patients sorted by age in descending order.
SELECT * FROM patients ORDER BY age DESC;

/*Show all services_weekly data sorted by week number 
ascending and patients_request descending.*/
-- First by week, then patients_request within each week
SELECT * FROM services_weekly
ORDER BY week ASC, patients_request DESC;

-- Display staff members sorted alphabetically by their names.
SELECT staff_name FROM staff
ORDER BY staff_name ASC;

/*Question: Retrieve the top 5 weeks with the highest patient 
refusals across all services, showing week, service, 
patients_refused, and patients_request. Sort by patients_refused
in descending order*/
SELECT  week, service, patients_refused, patients_request
FROM services_weekly
ORDER BY patients_refused DESC
LIMIT 5;
