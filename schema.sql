DROP TABLE IF EXISTS progress_change_log CASCADE;
DROP TABLE IF EXISTS progress CASCADE;
DROP TABLE IF EXISTS lab_events CASCADE;
DROP TABLE IF EXISTS lab_assignments CASCADE;
DROP TABLE IF EXISTS sections CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS sets CASCADE;
DROP TABLE IF EXISTS terms CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    display_name VARCHAR(40),
    "role" VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE terms (
    term_code CHAR(6) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE sets (
    set_code CHAR(1) PRIMARY KEY,
    campus VARCHAR(10)
);

CREATE TABLE students (
    student_id CHAR(4) PRIMARY KEY,
    set_code CHAR(1),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,

    CONSTRAINT set_code_fk
        FOREIGN KEY (set_code)
        REFERENCES sets (set_code)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_code CHAR(8) PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    credits INT NOT NULL
);

CREATE TABLE sections (
    section_code CHAR(3) PRIMARY KEY,
    course_code CHAR(8) NOT NULL,
    term_code CHAR(6) NOT NULL,
    set_code CHAR(1) NOT NULL,
    "type" CHAR(3),
    day_of_week CHAR(3),
    start_time TIME,
    end_time TIME,
    location VARCHAR(20),

    CONSTRAINT c_code_fk
        FOREIGN KEY (course_code)
        REFERENCES courses(course_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT t_code_fk
        FOREIGN KEY (term_code)
        REFERENCES terms(term_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT set_code_fk
        FOREIGN KEY (set_code)
        REFERENCES sets(set_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE lab_assignments (
    assignment_id CHAR(5),
    course_code CHAR(8) NOT NULL,
    term_code CHAR(6) NOT NULL,
    lab_number INT PRIMARY KEY,
    title VARCHAR(30),

    CONSTRAINT c_code_fk
        FOREIGN KEY (course_code)
        REFERENCES courses(course_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT t_code_fk
        FOREIGN KEY (term_code)
        REFERENCES terms(term_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE lab_events (
    event_id CHAR(7) PRIMARY KEY,
    section_code CHAR(3) NOT NULL,
    course_code CHAR(8) NOT NULL,
    term_code CHAR(6) NOT NULL,
    lab_number INT NOT NULL,
    start_datetime TIMESTAMP,
    end_datetime TIMESTAMP,
    due_datetime TIMESTAMP NOT NULL,
    location VARCHAR(20),

    CONSTRAINT course_code_fk
        FOREIGN KEY (course_code)
        REFERENCES courses(course_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT term_code_fk
        FOREIGN KEY (term_code)
        REFERENCES terms(term_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT lab_number_fk
        FOREIGN KEY (lab_number)
        REFERENCES lab_assignments(lab_number)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- Don't know why location is included in this table when it's tied to sections

    -- CONSTRAINT location_fk FOREIGN KEY (location) REFERENCES sections(location) ON DELETE SET NULLON UPDATE CASCADE,

    CONSTRAINT s_code_fk
        FOREIGN KEY (section_code)
        REFERENCES sections(section_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE progress (
    progress_id CHAR(12) PRIMARY KEY,
    student_id CHAR(4) NOT NULL,
    event_id CHAR(7) NOT NULL,
    lab_number INT NOT NULL,
    status VARCHAR(15) NOT NULL,
    prepared BOOLEAN DEFAULT FALSE,
    attendance VARCHAR(10) NOT NULL,
    inlab_submitted_at TIMESTAMP,
    inlab_submission_link TEXT,
    polished_submitted_at TIMESTAMP,
    polished_submission_link TEXT,
    instructor_assessment REAL,
    self_assessment REAL,
    late BOOLEAN DEFAULT FALSE,

    CONSTRAINT progress_student_fk
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT progress_event_fk
        FOREIGN KEY (event_id)
        REFERENCES lab_events(event_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT progress_lab_fk
        FOREIGN KEY (lab_number)
        REFERENCES lab_assignments(lab_number)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE progress_change_log (
    change_id VARCHAR(7) PRIMARY KEY,
    progress_id CHAR(12),
    changed_by VARCHAR(20) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    field VARCHAR(30) NOT NULL,
    old_value VARCHAR(50),
    new_value VARCHAR(50),
    reason TEXT,

    CONSTRAINT progress_change_progress_fk
        FOREIGN KEY (progress_id)
        REFERENCES progress(progress_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT progress_change_user_fk
        FOREIGN KEY (changed_by)
        REFERENCES users(user_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
