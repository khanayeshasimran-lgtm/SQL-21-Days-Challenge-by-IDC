-- Find all weeks in services_weekly where no special event occurred.
SELECT week, service, event
FROM services_weekly 
WHERE event IS NULL OR EVENT = 'none';

-- Count how many records have null or empty event values.
SELECT COUNT(*) AS EMPTY_EVENT
FROM services_weekly 
WHERE event IS NULL OR event = 'none';

-- List all services that had at least one week with a special event.
SELECT week, month, service, event 
FROM services_weekly 
WHERE event IS NOT NULL AND event <> 'none'
ORDER BY service;

/* Question: Analyze the event impact by comparing weeks with events 
vs weeks without events. Show: event status ('With Event' or 'No 
Event'),count of weeks, average patient satisfaction, and average 
staff morale. ARANGE BY average patient satisfaction descending.*/
SELECT CASE 
WHEN EVENT IS NULL OR EVENT = 'NONE' THEN 'NO_EVENT'
ELSE EVENT 
END AS EVENT_STATUS,
COUNT(WEEK) AS WEEK_COUNT,
ROUND(AVG(PATIENT_SATISFACTION), 2) AS AVG_PATIENT_SATISFACTION,
ROUND(AVG(STAFF_MORALE), 2) AS AVG_STAFF_MORALE
FROM SERVICES_WEEKLY
GROUP BY EVENT_STATUS
ORDER BY AVG_PATIENT_SATISFACTION DESC;
