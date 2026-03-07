-- INTEGRITY CHECKS (JOINS, COUNTS, CONSTRAINT TESTS)

-- Checks for terms:
DO $$
DECLARE 
    term_count integer;
BEGIN
    SELECT COUNT(*) INTO term_count FROM terms;
    ASSERT term_count = 3, 'Expected 3 rows in terms but got ' || term_count;
    -- expect 3 rows from 3 terms

    SELECT COUNT(*) INTO term_count
    FROM (
        SELECT * FROM terms
        WHERE start_date >= '2025-01-01'
        AND start_date < '2026-01-01'
    );
    ASSERT term_count = 3 , 'Expected 3 terms between 2025-01-01 and 2026-01-01 but got ' || term_count;
END$$;
-- expect 3

SELECT COUNT(DISTINCT name)
FROM terms;

-- Check that we can't enter duplicate term codes
DO $$
BEGIN
    INSERT INTO terms
    VALUES (202510, 'Winter', '2025-01-06', '2025-04-11');

    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'unique key violation correctly raised';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Duplicate term_code incorrectly accepted';
END$$;

-- Check that null term names can't be inserted
DO $$
BEGIN
    INSERT INTO terms
    VALUES (202540, NULL, '2026-01-01', '2026-04-01');

    EXCEPTION WHEN not_null_violation THEN
        RAISE NOTICE 'non-null term title correctly rejected';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Null term title incorrectly accepted';
END$$;

-- Checks for sets:
DO $$
DECLARE
    set_count int;
BEGIN
    SELECT COUNT(*) INTO set_count FROM sets;
    ASSERT set_count = 6, 'Expected 6 items in sets, got ' || set_count;
END$$;

SELECT COUNT(DISTINCT set_code)
from sets;

-- Checks for courses:
SELECT COUNT(*) FROM courses;
-- expect 1

SELECT COUNT(DISTINCT title)
from courses;

-- Checks for sections:
SELECT COUNT(*) FROM sections;
-- expect 6

SELECT COUNT(DISTINCT section_code)
from sections;

-- Checks for students:
SELECT COUNT(*) FROM students;
-- expect 18

SELECT COUNT(DISTINCT student_id)
from students;

-- Checks for lab_assignments:
SELECT COUNT(*) FROM lab_assignments;
-- expect 8

SELECT COUNT(DISTINCT assignment_id)
from lab_assignments;

-- Checks for lab_events:
SELECT COUNT(*) FROM lab_events;
-- expect 18

SELECT COUNT(DISTINCT event_id)
from lab_events;

-- Checks for users:
SELECT COUNT(*) FROM users;
-- expect 3

SELECT COUNT(DISTINCT user_id)
from users;

-- Checks for progress:
SELECT COUNT(*) FROM progress;
-- expect 37

SELECT COUNT(DISTINCT progress_id)
from progress;

-- Checks for progress_change_log:
SELECT COUNT(*) FROM progress_change_log;
-- expect 3

SELECT COUNT(DISTINCT change_id)
from progress_change_log;
