-- List all unique services in the patients table.
SELECT DISTINCT service 
FROM patients;

-- Find all unique staff roles in the hospital.
SELECT DISTINCT role 
FROM staff;

-- Get distinct months from the services_weekly table.
SELECT DISTINCT month
FROM services_weekly;

/* Question: Find all unique combinations of service and 
event type from the services_weekly table where events are not
null or none, along with the count of occurrences for each 
combination. Order by count descending.*/
SELECT DISTINCT service, event, COUNT(week) AS occurrences
FROM services_weekly
WHERE event IS NOT NULL
AND event != 'none'
GROUP BY service, event
ORDER BY occurrences DESC;
