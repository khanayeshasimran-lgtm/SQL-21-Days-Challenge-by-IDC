/*Join patients, staff, and staff_schedule to show patient service 
and staff availability.*/
SELECT 
P.patient_id,
P.service,
S.staff_id,
S.staff_name,
SS.week,
SS.present AS staff_present
FROM patients P
LEFT JOIN staff S
ON P.service = S.service
LEFT JOIN staff_schedule SS
ON S.staff_id = SS.staff_id;

/*Combine services_weekly with staff and staff_schedule for 
comprehensive service analysis.*/
SELECT SW.service,
SUM(SW.patients_admitted) AS total_admitted,
SUM(SW.patients_refused) AS total_refused,
AVG(SW.patient_satisfaction) AS avg_satisfaction,
COUNT(DISTINCT S.staff_id) AS staff_assigned,
SUM(CASE WHEN SS.present = 1 THEN 1 ELSE 0 END) AS staff_present
FROM services_weekly SW
LEFT JOIN staff S
ON SW.service = S.service
LEFT JOIN staff_schedule SS
ON S.staff_id = SS.staff_id
AND SS.week = SW.week
GROUP BY SW.service;

/*Create a multi-table report showing patient admissions with staff 
information.*/
SELECT
SW.week,
SW.service,
SW.patients_admitted,
SW.patients_refused,
S.staff_id,
S.staff_name,
SS.present AS staff_present
FROM services_weekly SW
LEFT JOIN staff S
ON SW.service = S.service
LEFT JOIN staff_schedule SS
ON S.staff_id = SS.staff_id
AND SS.week = SW.week
ORDER BY SW.week, SW.service;

/*Question: Create a comprehensive service analysis report for week
20 showing: service name, total patients admitted that week, total 
patients refused, average patient satisfaction, count of staff 
assigned to service, and count of staff present that week. Order 
by patients admitted descending.*/
SELECT SW.service AS service_name,
SUM(SW.patients_admitted) AS total_patient_admitted,
SUM(SW.patients_refused) AS total_patient_refused,
ROUND(AVG(patient_satisfaction),2) AS avg_patient_satisfaction,
COUNT(DISTINCT S.staff_id) AS staff_assigned_count,
SUM(CASE WHEN SS.present = 1 THEN 1 ELSE 0 END) 
AS staff_present_count
FROM services_weekly AS SW
LEFT JOIN staff AS S
ON SW.service = S.service
LEFT JOIN staff_schedule AS SS
ON S.staff_id = SS.staff_id
AND SS.week = 20
WHERE SW.week = 20
GROUP BY SW.service
ORDER BY total_patient_admitted DESC;
