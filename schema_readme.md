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
progress
lab_events 
lab_assignments 
sections 
courses 
students 
sets
terms 
users
