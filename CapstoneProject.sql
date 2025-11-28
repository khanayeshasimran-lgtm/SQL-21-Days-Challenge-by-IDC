-- SQL_Murder_Mystery
-- Step 1: Check evidence details
SELECT * FROM evidence;
-- Confirms the murder occurred in the CEO Office around 21:00 on 2025-10-15.

-- Step 2: Who accessed the CEO Office during the crime window?
SELECT kl.employee_id, e.name, kl.entry_time, kl.exit_time
FROM keycard_logs kl
JOIN employees e ON kl.employee_id = e.employee_id
WHERE kl.room = 'CEO Office'
  AND entry_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00';
-- David Kumar is the ONLY person present during the murder.

-- Step 3: Compare claimed alibis to real keycard logs
WITH claimed AS (
SELECT * 
FROM alibis
WHERE claim_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00'
),
actual AS (
SELECT * 
FROM keycard_logs
WHERE room = 'CEO Office'
AND entry_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00'
)
SELECT c.employee_id, e.name, 
c.claimed_location, c.claim_time,
a.room AS actual_location, 
a.entry_time AS actual_entry_time, 
a.exit_time AS actual_exit_time
FROM claimed c
JOIN actual a ON c.employee_id = a.employee_id
JOIN employees e ON e.employee_id = c.employee_id;
-- David Kumar lied in his alibi → Suspicion strengthened.

-- Step 4: Calls made near the murder time
SELECT c.caller_id, c.receiver_id, e.name,
c.call_time, c.duration_sec AS call_duration
FROM calls c
JOIN employees e ON c.caller_id = e.employee_id
WHERE c.call_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00';
-- David Kumar made calls minutes before the murder.

-- Step 5: Consolidating evidence + movements + alibis + calls
SELECT ev.room, ev.description, ev.found_time,
e.name AS suspect_name,
a.claimed_location, 
kl.room AS actual_location,
a.claim_time, 
kl.entry_time AS actual_entry_time,
kl.exit_time AS actual_exit_time,
ca.call_time
FROM evidence ev
JOIN keycard_logs kl ON ev.room = kl.room
JOIN alibis a ON kl.employee_id = a.employee_id
JOIN employees e ON e.employee_id = kl.employee_id
JOIN calls ca ON ca.caller_id = e.employee_id
WHERE ev.room = 'CEO Office'
AND kl.entry_time BETWEEN '2025-10-15 20:45:00' AND '2025-10-15 21:15:00';
-- All traces (evidence, presence, lies, calls) match David Kumar.

-- FINAL QUERY: Determine the killer by combining all evidence
WITH
present AS (
SELECT employee_id
FROM keycard_logs
WHERE room = 'CEO Office'
AND (
entry_time BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00'
OR exit_time  BETWEEN '2025-10-15 20:30:00' AND '2025-10-15 21:30:00'
)),
lied AS (
SELECT employee_id
FROM alibis
WHERE claim_time BETWEEN '2025-10-15 20:45:00' AND '2025-10-15 21:15:00'
AND claimed_location != 'CEO Office'
),
calls_nearby AS (
SELECT caller_id AS employee_id
FROM calls
WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:05:00'
),
suspects AS (
SELECT employee_id FROM present
INTERSECT
SELECT employee_id FROM lied
INTERSECT
SELECT employee_id FROM calls_nearby
)
SELECT emp.name AS killer
FROM suspects s
JOIN employees emp ON emp.employee_id = s.employee_id;
-- 🎉 OUTPUT: David Kumar

-- Case Closed: All evidence triangulates to one person.
