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
-- expect 3

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
    -- expect 6 rows from 6 sets
END$$;

SELECT COUNT(DISTINCT set_code)
from sets;
-- expect 6

-- Check that duplicate set_code cannot be inserted
DO $$
BEGIN
    INSERT INTO sets
    VALUES ('A', 'Burnaby');

EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'duplicate set_code correctly rejected';
WHEN OTHERS THEN
    RAISE EXCEPTION 'Duplicate set_code incorrectly accepted';
END$$;

-- Checks for courses:
DO $$
DECLARE
    course_count int;
BEGIN
    SELECT COUNT(*) INTO course_count FROM courses;
    ASSERT course_count = 2, 'Expected 2 courses but got ' || course_count;
    -- expect 1 row from 1 course
END$$;

SELECT COUNT(DISTINCT course_code)
FROM courses;
-- expect 1

SELECT COUNT(DISTINCT title)
FROM courses;
-- expect 1

-- Check that duplicate course codes cannot be inserted
DO $$
BEGIN
    INSERT INTO courses
    VALUES ('COMP2714', 'Relational Database Systems', 3);

EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'duplicate course_code correctly rejected';
WHEN OTHERS THEN
    RAISE EXCEPTION 'Duplicate course_code incorrectly accepted';
END$$;

-- Check that null titles cannot be inserted
DO $$
BEGIN
    INSERT INTO courses
    VALUES ('COMP9999', NULL, 3);

EXCEPTION WHEN not_null_violation THEN
    RAISE NOTICE 'null course title correctly rejected';
WHEN OTHERS THEN
    RAISE EXCEPTION 'Null course title incorrectly accepted';
END$$;

-- Checks for sections:
DO $$
DECLARE
    section_count int;
BEGIN
    SELECT COUNT(*) INTO section_count FROM sections;
    ASSERT section_count = 6, 'Expected 6 sections but got ' || section_count;
    -- expect 6 rows from 6 sections
END$$;

SELECT COUNT(DISTINCT section_code)
FROM sections;
-- expect 6

-- Check that all sections are for the same course
SELECT COUNT(DISTINCT course_code)
FROM sections;
-- expect 1

-- Check that all sections belong to the same term
SELECT COUNT(DISTINCT term_code)
FROM sections;
-- expect 1

-- Check that each section has a unique set
SELECT COUNT(DISTINCT set_code)
FROM sections;
-- expect 6

-- Check that duplicate section_code cannot be inserted
DO $$
BEGIN
    INSERT INTO sections
    VALUES ('L01','COMP2714',202530,'A','LAB','Mon','09:30','11:20','BBY-SW01-3460');

EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'duplicate section_code correctly rejected';
WHEN OTHERS THEN
    RAISE EXCEPTION 'Duplicate section_code incorrectly accepted';
END$$;

-- Check that every section references a valid course
SELECT COUNT(*)
FROM sections s
LEFT JOIN courses c
ON s.course_code = c.course_code
WHERE c.course_code IS NULL;
-- expect 0

-- Check that every section references a valid term
SELECT COUNT(*)
FROM sections s
LEFT JOIN terms t
ON s.term_code = t.term_code
WHERE t.term_code IS NULL;
-- expect 0

-- Checks for students:
DO $$
DECLARE
    student_count int;
BEGIN
    SELECT COUNT(*) INTO student_count FROM students;
    ASSERT student_count = 18, 'Expected 18 students but got ' || student_count;
    -- expect 18 rows from 18 students
END$$;

SELECT COUNT(DISTINCT student_id)
FROM students;
-- expect 18

-- Check number of sets represented
SELECT COUNT(DISTINCT set_code)
FROM students;
-- expect 6

-- Check that each set has 3 students
DO $$
DECLARE
    min_count int;
    max_count int;
BEGIN
    SELECT MIN(cnt), MAX(cnt)
    INTO min_count, max_count
    FROM (
        SELECT COUNT(*) AS cnt
        FROM students
        GROUP BY set_code
    ) s;

    ASSERT min_count = 3 AND max_count = 3,
        'Each set should have exactly 3 students';
END$$;

-- Check that duplicate student_id cannot be inserted
DO $$
BEGIN
    INSERT INTO students
    VALUES ('A001','A','Test','Student','test@student.ca');

EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'duplicate student_id correctly rejected';
WHEN OTHERS THEN
    RAISE EXCEPTION 'Duplicate student_id incorrectly accepted';
END$$;

-- Check that every student references a valid set
SELECT COUNT(*)
FROM students s
LEFT JOIN sets st
ON s.set_code = st.set_code
WHERE st.set_code IS NULL;
-- expect 0

-- Check that every student email is unique
SELECT COUNT(DISTINCT email)
FROM students;
-- expect 18

-- Checks for lab_assignments:
SELECT COUNT(*) FROM lab_assignments;
-- expect 8

-- Check that every assignment_id is unique
SELECT COUNT(DISTINCT assignment_id)
from lab_assignments;

-- Check that every lab assignment reference a valid course
SELECT COUNT(*)
FROM lab_assignments la
LEFT JOIN courses c 
ON la.course_code = c.course_code
WHERE c.course_code IS NULL;
-- expect 0

-- Checks for lab_events:
SELECT COUNT(*) FROM lab_events;
-- expect 18

-- Check that every event_id is unique
SELECT COUNT(DISTINCT event_id)
from lab_events;
-- expect 18

-- Check that every event belongs to a valid section
SELECT COUNT(*)
from lab_events le
LEFT JOIN section s
ON le.section_coce = s.section_code
WHERE s.section_code IS NULL;
-- expect 0

-- Checks for users:
SELECT COUNT(*) FROM users;
-- expect 3

-- Check that every user_id is unique
SELECT COUNT(DISTINCT user_id)
from users;
-- expect 3

-- Check that every user belongs to a valid user
SELECT COUNT(*)
FROM progress_change_log pcl
LEFT JOIN user u
ON pcl.change_by = u.user_id
WHERE u.user_id IS NULL;
-- expect 0

-- Checks for progress:
SELECT COUNT(*) FROM progress;
-- expect 36

-- Check that every progress_id is unique
SELECT COUNT(DISTINCT progress_id)
from progress;
-- expect 36

-- Check that every progress references a valid event
SELECT COUNT(*)
from progress p
LEFT JOIN lab_events e
ON p.event_id = e.event_id
WHERE e.event_id IS NULL;
-- expect 0

-- Check that every progress record must reference a real student
SELECT COUNT(*)
FROM progress p
LEFT JOIN students s
ON p.student_id = s.student_id
WHERE s.student_id IS NULL;
-- expect 0

-- Checks for progress_change_log:
SELECT COUNT(*) FROM progress_change_log;
-- expect 3

-- Check that every change_id is unique
SELECT COUNT(DISTINCT change_id)
from progress_change_log;
-- expect 3

-- Check that every change log must reference a real progress record. 
SELECT COUNT(*)
FROM progress_change_log pcl
LEFT JOIN progress p
ON pcl.progress_id = p.progress_id
WHERE p.progress_id IS NULL;
-- expect 0