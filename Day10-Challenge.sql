/*Categorise patients as 'High', 'Medium', or 'Low' satisfaction 
based on their scores.*/
SELECT name, satisfaction,
CASE WHEN satisfaction >= 75 THEN 'High'        
WHEN satisfaction >= 50 THEN 'Medium'        
ELSE 'Needs Improvement'    
END AS satisfaction_category
FROM patients;

-- Label staff roles as 'Medical' or 'Support' based on role type.
SELECT staff_id, staff_name, role,
CASE
WHEN role IN ('doctor', 'nurse') THEN 'Medical'
ELSE 'Support'
END AS role_category
FROM staff;


-- Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT name, age,
CASE
WHEN age BETWEEN 0 AND 18 THEN 'Child'
WHEN age BETWEEN 19 AND 40 THEN 'Young'
WHEN age BETWEEN 41 AND 65 THEN 'Adult'
ELSE '65+ (Senior)'
END AS age_group
FROM patients;

/*Question: Create a service performance report showing service name, 
total patients admitted, and a performance category based on the 
following: 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 
'Fair' if >= 65, otherwise 'Needs Improvement'. Order by average 
satisfaction descending.*/
SELECT service,
COUNT(patient_id) AS total_patients,
ROUND(AVG(satisfaction), 2) AS avg_satisfaction,
CASE
WHEN AVG(satisfaction) >= 85 THEN 'Excellent'
WHEN AVG(satisfaction) >= 75 THEN 'Good'
WHEN AVG(satisfaction) >= 65 THEN 'Fair'
ELSE 'Needs Improvement'
END AS performance_category
FROM patients
GROUP BY service
ORDER BY avg_satisfaction DESC;
