Design notes:

PK choices:

term_code: This was chosen as a PK name, since start date, and end date may not be unique to one term, while the term code will be unqiue.

set_code: The set table had two attributes and thus two options for the PK: set_code and campus. Campus can have multiple sets attached to it, while the set code is unique to each set, so it was chosen as the PK.

course_code: The title of the course may be unique, but isn't guaranteed to be, while the course code will be unique to each course, so course_code was chosen as the PK.

section_code: Out of the non-FK attributes, only the section_code would uniquely identify each section.

student_id: This was chosen as the PK because it will be unique to each student, while name, email, and set can be the same between different students.

assignment_id: This PK can uniquely identify each student's assignment, since other attributes such as course_code and term_code can be the same (they are FKs).

event_id: Using this as the PK allows for it to be unqiuely identified amongst all other lab events, instead of using FK attributes like section_code, course_code, or term_code (which can be the same between lab events).

user_id: This was chosen as a PK since no user should have the same ID as another, while display names, roles, and/or emails can be shared by multiple users.

progress_id: The table is made up of many attributes that are not unique to a single item on the table (including FKs), so a progress_id number was needed to uniquely identify each entry on the table.

change_id: This PK is able to uniquely identify each change that was added to the table.

Constraints:

Terms:

Name, Start date and End Date were NOT NULL as they are required for a course. A cant never start or end, and needs to be called something

Sets:

Contained no Constriants. As a set has the ability to be split among campuses.

Courses:

Credits and title are NOT NULL as they are required for each course. A course can have 0 credits, but it must be stated.
students

Sections:

Students:

Lab_assignments:

-Course_code and term_code are Not NULL Foreign Keys, as every assignment must belong to a course and term.
sections
-course_code, term_code, and set_code all have the contraints of being a FK, on delete CASCADE, and NOT NULL. As a section is a dependant on all three for its existance.

Lab_events:

- Lab*number, Course* , term* and section* code, are all NOT NULL FKs, as each event is tied to a Lab, in a section, in a course, in a term. The due_date is also NOT NULL as each event must have a due date.

Users:

- the constraints were NOT NULL for role and email, as inorder for a user to be registered, they have to have use their email to enter, as well as having a role that tells the system what they have access to.

Progress:

-student_id, lab_number and event ID are all NOT NULL FK's, as the progress is directly referencing work done by a certian student, for a lab during an event. Attendance and status are both NOT NULL as the student is either here or absent, and eother working or done.

Progress_change_log:

- The constraints for this table were a progress_id as a FK, changed_by being a NOT NULL FK referencing the user who changed the lab, and changed_at, and field are NOT NULL because if something is changed, it has a time, and there is a field that was changed. Also it has a default for the changed_at as the time of the table being updated.

- first name, last name and email are all NOT NULL, as they are neccesarry for a student to have, it also has a SET_code Foreign key that references sets.

Referential actions

students

- This has a action of ON DELETE SET NULL and ON UPDATE CASCADE for its set_code FK. THese are there to allow deletion, of a student if a set is deleted, the student will still exist, just with a NULL set, and if set_code is updated, the update will also apply to the student.
  Sections
- This has 3 FK, with the same referential actions in ON DELETED CASCADE, ON UPDATE CASCADE, so when the FK is deleted, the section referencing it is also deleted, and when the FK is updated, the section table with the old values is also updated.
  Lab Assignments, progress, Lab_events
  -These has the same as type of referential action in ON DELETE CASCADE, ON UPDATE CASCADE. They depend are child entites of another, so when that entity is deleted or changed, they must be a well.
  Progress change log
- this has the ON DELETE SET NULL and ON UPDATE CASCADE for its two FK's. this allows the change log to exist after both users or the progress have been deleted.

Indexing.
there are not explicit indexing, but as PK's automaticaly create them, we used those indexes.
The indexes used are there to specify which data we want to return, and speeds up the process of the data's retrival.

## PK adjustments
