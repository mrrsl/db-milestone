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
DO$$
BEGIN
    INSERT INTO terms
    VALUES (202540, NULL, '2026-01-01', '2026-04-01');

    EXCEPTION WHEN required_attribute_violation THEN
        RAISE NOTICE 'non-null term title correctly rejected';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Null term title incorrectly accepted';
END$$;

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

-- Checks for terms:
SELECT COUNT(*) FROM terms;
-- expect 3

SELECT COUNT(DISTINCT name)
from terms;

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
