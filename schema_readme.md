Design notes:

PK choices:

term_code:
This was chosen as a PK name, since start date, and end date may not be unique to one term, while the term code will be unique.

set_code:
The set table had two attributes and thus two options for the PK: set_code and campus. Campus can have multiple sets attached to it, while the set code is unique to each set, so it was chosen as the PK.

course_code:
The title of the course may be unique, but isn't guaranteed to be, while the course code will be unique to each course, so course_code was chosen as the PK.

section_code:
Out of the non-FK attributes, only the section_code would uniquely identify each section.

student_id:
This was chosen as the PK because it will be unique to each student, while name, email, and set can be the same between different students.

lab_number:
This was chosen as the primary key for the lab_assignments table because it uniquely identifies each lab assignment. Other attributes such as course_code and term_code are foreign keys and may repeat across different assignments, so they cannot uniquely identify each record.

user_id:
This was chosen as a PK since no user should have the same ID as another, while display names, roles, and/or emails can be shared by multiple users.

progress_id:
The progress table is made up of many attributes that are not unique to a single item on the table (including FKs), so a progress_id number was needed to uniquely identify each entry on the table.

change_id:
This PK is able to uniquely identify each change that was added to the table.

Constraints:

Terms:
name, start_date and end_date are NOT NULL as they are required for a term. Each term has a year-and-season-associated name and start and end dates.

Sets:
Sets are split across campuses (A to D belong to Burnaby, E to F belong to Downtown). Both attributes are NOT NULL.

Courses:
credits and title are NOT NULL because they are required for each course (even if there are zero credits for a course, for example, this must be defined).

Sections:
Every attribute in this table is NOT NULL. Each section must be assigned an ID, has a type, takes place on a certain day of the week (same day for every week), starts and ends at a specific time (same time for every week), takes place at a location (same location each week), and is tied to a certain set, term, and course. course_code, term_code, and set_code are all FKs, and a section is a dependant on all three for its existance.

Students:
Every attribute in this table is NOT NULL. Every student has an ID, belongs to a set, has a first and last name, and is assigned a BCIT student email.

Lab_assignments:
course_code and term_code are NOT NULL FKs, as every assignment is associated with a course and term. The other non-PK attributes of lab_number and title are also NOT NULL, since each lab must be numbered and has a title describing it.

Lab_events:
lab_number, course_code, term_code, and section_code are NOT NULL FKs because each lab event belongs to a specific lab assignment within a course section and term. start_datetime, end_datetime, and due_datetime is also NOT NULL since every lab event must have a scheduled made available, availability ending, and submission deadline. location is NOT NULL since every lab must take place somewhere.

Users:
role, display_name, and email are NOT NULL, because in order for a user to be registered, they have to enter their email address. They must have a role that tells the system what they have access to. A display name is necessary to denote which user is accessing the system at a given point.

Progress:
student_id, lab_number and event_id are all NOT NULL FKs, as the progress is directly referencing work done by a certain student, for a lab during an event. attendance and status are both NOT NULL as the student is either present or absent, and either working or finished their work.

Progress_change_log:
progress_id is a FK referencing the progress table. changed_by is a NOT NULL FK referencing users(user_id) to record which user made the change. changed_at and field are NOT NULL because each change must recorded when it occurred and which field was modified. changed_at has a default value of the current timestamp.

Referential actions

Students:
The set_code foreign key uses ON DELETE SET NULL and ON UPDATE CASCADE. If a set is deleted, the stuent's set_code will be set to NULL so the student record can still exist. If the set_code value is updated, in the sets table, the change will automatically propagate to the students table.

Sections:
The foreign keys course_code, term_code, and set_code use ON DELETE CASCADE and ON UPDATE CASCADE. Since sections depend on these parent tables, deleting a referenced record will also delete related section rows. Updates to the parent keys will automatically update the corresponding values in the sections table.

Lab Assignments, progress, Lab_events:
These tables use ON DELETE CASCADE and ON UPDATE CASCADE for their foreign keys. They are dependent child entities of other tables, so if a parent record is deleted or updated, the related rows in these tables will also be deleted or updated to maintain referential integrity.

Progress change log:
This table uses ON DELETE SET NULL and ON UPDATE CASCADE for its foreign keys. This allows the change log to remain in the database even if the associated user or progress record is removed, while still updating the foreign key values if the parent keys change.

Indexing:

No explicit indexes were added. However, primary keys automatically create indexes, and those indexes help with lookups, joins, and primary key enforcement.

PK adjustments:

Initially, assignment_id seemed like a natural choice for the primary key of lab_assignments, but in the final schema lab_number was used as the primary key instead. This was done because the implemented table defines lab_number as the primary key, while assignment_id remains a regular attribute.

For the other tables, the original primary key choices were kept because each chosen key uniquely identifies a row and matches the implemented schema.
