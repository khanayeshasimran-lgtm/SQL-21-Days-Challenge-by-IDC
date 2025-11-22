/*1. Show each patient with their service's average satisfaction as 
an additional column.*/
SELECT p.patient_id, p.name AS patienct_name, 
p.service, p.satisfaction AS patient_satisfaction,
(SELECT ROUND(AVG(sw.patient_satisfaction),2)
FROM services_weekly sw
WHERE p.service = sw.service GROUP BY service) AS avg_satisfaction
FROM patients p;

-- 2. Create a derived table of service statistics and query from it.
SELECT
sw.week, sw.month, sw.patients_admitted, ss.staff_assigned, 
ss.staff_present, sw.staff_morale, sw.service
FROM services_weekly sw
JOIN (SELECT week, service, COUNT(staff_id) AS staff_assigned,
SUM(present) AS staff_present
FROM staff_schedule
GROUP BY week, service) ss
ON ss.week = sw.week AND ss.service = sw.service;

/*3. Display staff with their service's total patient count as a 
calculated field.*/ 
SELECT SS.WEEK,
SS.STAFF_NAME,
SS.ROLE,
SS.SERVICE,
(SELECT COUNT(P.PATIENT_ID)
FROM PATIENTS P
WHERE EXTRACT (WEEK FROM P.ARRIVAL_DATE) = SS.WEEK) 
AS PATIENTS_COUNT
FROM STAFF_SCHEDULE SS
ORDER BY SS.WEEK;

/*Question:** Create a report showing each service with: service 
name, total patients admitted, the difference between their total 
admissions and the average admissions across all services, and a 
rank indicator ('Above Average', 'Average', 'Below Average'). Order 
by total patients admitted descending.*/
SELECT svc.service AS service_name,
svc.total_patients AS total_patients_admitted,
ROUND(svc.total_patients - avg_table.avg_patients, 2) 
AS difference_between_total_and_avg,
CASE
WHEN svc.total_patients > avg_table.avg_patients THEN 'Above Average'
WHEN svc.total_patients = avg_table.avg_patients THEN 'Average'
ELSE 'Below Average'
END AS rank_indicator
FROM(
SELECT service, SUM(patients_admitted) AS total_patients
FROM services_weekly
GROUP BY service
) AS svc,
( SELECT AVG(total_patients) AS avg_patients
FROM (
SELECT SUM(patients_admitted) AS total_patients
FROM services_weekly
GROUP BY service
) AS inner_avg
) AS avg_table
ORDER BY svc.total_patients DESC;
