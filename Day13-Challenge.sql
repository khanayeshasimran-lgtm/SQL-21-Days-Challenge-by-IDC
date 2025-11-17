/*Join patients and staff based on their common service field 
(show patient and staff who work in same service).*/
SELECT p.patient_id,p.name,p.service,s.staff_name
FROM patients AS p
INNER JOIN staff AS s
on p.service = s.service;

/*Join services_weekly with staff to show weekly service data with 
staff information.*/
SELECT s.staff_id,s.staff_name,s.role,s.service,sw.week
FROM staff AS s
INNER JOIN services_weekly AS sw
on s.service = sw.service;

/*Create a report showing patient information along with staff 
assigned to their service.*/
SELECT p.patient_id,p.name,p.service,s.staff_id,s.staff_name,s.role
FROM patients AS p
INNER JOIN staff AS s
on p.service = s.service;


/*Create a comprehensive report showing patient_id, patient 
name, age, service, and the total number of staff members available 
in their service. Only include patients from services that have 
more than 5 staff members. Order by number of staff descending, 
then by patient name.*/
SELECT p.patient_id,p.name,p.age,p.service,
COUNT(s.staff_id) AS total_staff
FROM patients AS p
INNER JOIN staff AS s
on p.service = s.service
GROUP BY p.patient_id,p.name,p.age,p.service
HAVING COUNT(s.staff_id)>5
ORDER BY total_staff desc,p.name;
