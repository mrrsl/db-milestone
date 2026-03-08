design notes (≤1 page) explaining PK choices, constraints, referential actions, indexes, and any adjustments
PK choices

user_id - This was chosen as no user should have the same ID as another, while display names,
roles or emails can be shared by multiple users.

term_code - This was chosen as name, start date, and end date may not be unique to one term, while term code will be unqiue.
set_code - the set table had two options, this and campus. Campus can have multiple sets at it, while the set code is unique to each set

student_id - Was chosen as it will be unique to each student, while name, email and set can be shared.
course_code - title might be unique, but isn't guarenteed to be, while course code will be unique to each course.
section_code - Of the non-FK's only the section_code would uniqly identify each section.
assignment_id - This PK can uniquely identify each assignment
event_id - USing this as the PK allows for it to be unqiuely identified from all other lab events
progress_id - The table is made of many attributs that are not unique to a single item on the table, so an ID number was needed to uniqly identify each entry on the table
change_id - This PK is able to uniquly identify each change that was added to the table.

Constraints

progress_change_log 
- The constraints for this table were a porgress_id as a FK, changed_by being a NOT NULL FK referencing the student who changed the lab, and changed_at and field are NOT NULL as if something is changed, it has a time, and there is a field that was changed.
progress
-Student_id, lab_number and event ID are all Not NULL FK's, as the porgress is directly referencing work done by a certian student, for a lab during an event. Attendance and status are both NOT NULL as the student is either here or absent, and eother working or done.
lab_events 
- Lab_number, Course_ , term_ and section_ code, are all NOT NULL FK's, as each event is tied to a Lab, in a section, in a course, in a term. The due_date is also NOT NULL as each event must have a due date.
lab_assignments 
-COurse_code and term_code are Not NULL Foreign Keys, as every assignment must belong to a course and term.
sections 
-course_code, term_code, and set_code all have the contraints of being a FK, on delete CASCADE, and NOT NULL. As a section is a dependant on all three for its existance.
courses 
-Credits and title are not NULL as they are required for each course. A course can have 0 credits, but it must be stated.
students 
- first name, last name and email are all NOT NULL, as they are neccesarry for a student to have, it also has a SET_code Foreign key that references sets.
sets
- Contained no Constriants. As a set has the ability to be split among campuses.
terms 
- Name, Start date and End Date werer NOT NULL as they are required for a course. A cant never start or end, and needs to be called something
users
- the constraints were NOT NULL for role and email, as inorder for a user to be registered, they have to have use their email to enter, as well as having a role that tells the system what they have access to.

Referential actions

students
- This has a action of ON DELETE SET NULL and ON UPDATE CASCADE for its set_code FK. THese are there to allow deletion, of a student if a set is deleted, the student will still exist, just with a NULL set, and if set_code is updated, the update will also apply to the student.
Sections
- THis has 3 FK, with the same referential actions in ON DELETED CASCADE, ON UPDATE CASCADE, so when the FK is deleted, the section referencing it is also deleted, and when the FK is updated, the section table with the old values is also updated.
Lab Assignments, progress, Lab_events
-These has the same as type of referential action in ON DELETE CASCADE, ON UPDATE CASCADE. They depend are child entites of another, so when that entity is deleted or changed, they must be a well.
Progress change log
- this has the ON DELETE SET NULL and ON UPDATE CASCADE for its two FK's. this allows the change log to exist after both users or the progress have been deleted.

Indexing.
there are not explicit indexing, but as PK's automaticaly create them, we used those indexes.
The indexes used are there to specify which data we want to return, and speeds up the process of the data's retrival.

PK adjustments
-
