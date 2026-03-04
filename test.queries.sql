-- INTEGRITY CHECKS (JOINS, COUNTS, CONSTRAINT TESTS)

-- Checks for term:

SELECT COUNT(*) FROM term;
-- expect 3 rows from 3 terms

SELECT COUNT(*)
FROM term
WHERE start_date >= '2025-01-01'
AND start_date < '2026-01-01';
-- expect 3

SELECT COUNT(DISTINCT name)
FROM term;

INSERT INTO term
VALUES (202510, 'Duplicate Winter', '2025-01-06', '2025-04-11');
-- expect fail

INSERT INTO term
VALUES (202540, NULL, '2026-01-01', '2026-04-01');
-- expect fail

-- Checks for sets:
SELECT COUNT(*) FROM sets;
-- expect 6

INSERT INTO sets
VALUES()

SELECT COUNT(DISTINCT name)
from sets;


-- Checks for courses:
SELECT COUNT(*) FROM courses;
-- expect 1

SELECT COUNT(DISTINCT name)
from courses;

-- Checks for sections:
SELECT COUNT(*) FROM sections;
-- expect 6

SELECT COUNT(DISTINCT name)
from sections;

-- Checks for students:
SELECT COUNT(*) FROM students;
-- expect 18

SELECT COUNT(DISTINCT name)
from students;

-- Checks for lab_assignments:
SELECT COUNT(*) FROM lab_assignments;
-- expect 8

SELECT COUNT(DISTINCT name)
from lab_assignments;

-- Checks for lab_events:
SELECT COUNT(*) FROM lab_events;
-- expect 18

SELECT COUNT(DISTINCT name)
from lab_events;

-- Checks for users:
SELECT COUNT(*) FROM users;
-- expect 3

SELECT COUNT(DISTINCT name)
from users;

-- Checks for progress:
SELECT COUNT(*) FROM progress;
-- expect 37

SELECT COUNT(DISTINCT name)
from progress;

-- Checks for progress_change_log:
SELECT COUNT(*) FROM progress_change_log;
-- expect 3

SELECT COUNT(DISTINCT name)
from progress_change_log;
