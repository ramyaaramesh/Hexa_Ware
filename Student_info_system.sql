---Tak1
CREATE DATABASE SISDB2;
GO

USE SISDB2;
GO

---a. Students  

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

---b. Teachers

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

--c. Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_code VARCHAR(20),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

-- d.Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- e.Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    student_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


---Insert Data

INSERT INTO Students VALUES
(1, 'John', 'Doe', '1995-08-15', 'john.doe@example.com', '1234567890'),
(2, 'Jane', 'Smith', '1997-03-12', 'jane.smith@example.com', '9876543210'),
(3, 'Mike', 'Williams', '1996-01-22', 'mike.williams@example.com', '1212121212');


INSERT INTO Teacher VALUES
(1, 'Sarah', 'Smith', 'sarah.smith@example.com'),
(2, 'Alan', 'Walker', 'alan.walker@example.com');


INSERT INTO Courses VALUES
(101, 'Introduction to Programming', 'CSE101', 2),
(102, 'Mathematics 101', 'MTH101', 1),
(103, 'Advanced Database Management', 'CS302', 1),
(104, 'Computer Science 101', 'CS101', NULL); -- unassigned

INSERT INTO Enrollments VALUES
(1001, 1, 101, '2025-04-01'),
(1002, 1, 102, '2025-04-02'),
(1003, 2, 101, '2025-04-03'),
(1004, 2, 102, '2025-04-04');


INSERT INTO Payments VALUES
(501, 1, 500.00, '2025-04-10'),
(502, 2, 600.00, '2025-04-11');











---Task 2: Insert, Update, Delete, Select Queries

---1. Insert new student (John Doe again, ID: 4)
INSERT INTO Students (student_id, first_name, last_name, date_of_birth, email, phone_number)
VALUES (4, 'John', 'Doe', '1995-08-15', 'john.doe2@example.com', '1234567891');

--- 2. Enroll student in a course (ID 4 into course 101)
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (1005, 4, 101, '2025-04-10');

---Update teacher email
UPDATE Teacher
SET email = 'sarah.smith@newmail.com'
WHERE teacher_id = 1;

---Delete enrollment
DELETE FROM Enrollments
WHERE enrollment_id = 1005;

--- Assign teacher to a course
UPDATE Courses
SET teacher_id = 2
WHERE course_id = 104;

--- Delete student and their enrollments
DELETE FROM Enrollments WHERE student_id = 4;
DELETE FROM Payments WHERE student_id = 4;
DELETE FROM Students WHERE student_id = 4;

---Update payment amount
UPDATE Payments
SET amount = 550.00
WHERE payment_id = 501;









---Task 3

---Total payments made by a specific student 
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_payment
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
WHERE s.student_id = 1
GROUP BY s.first_name, s.last_name;

---List of courses with student enrollment count
SELECT c.course_name, COUNT(e.enrollment_id) AS student_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

--- Students who have not enrolled in any course
SELECT s.student_id, s.first_name, s.last_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

---List of students and the courses they are enrolled in
SELECT s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;


---Teachers and the courses they are assigned to
SELECT t.first_name AS teacher_first_name, t.last_name AS teacher_last_name, c.course_name
FROM Teacher t
JOIN Courses c ON t.teacher_id = c.teacher_id;

---Students and their enrollment dates for a specific course (e.g., 'Introduction to Programming')
SELECT s.first_name, s.last_name, e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Introduction to Programming';

---Students who have not made any payments
SELECT s.student_id, s.first_name, s.last_name
FROM Students s
LEFT JOIN Payments p ON s.student_id = p.student_id
WHERE p.payment_id IS NULL;

---Courses with no enrollments
SELECT c.course_id, c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

---Students enrolled in more than one course
SELECT s.student_id, s.first_name, s.last_name, COUNT(e.course_id) AS course_count
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(e.course_id) > 1;

--Teachers not assigned to any course
SELECT t.teacher_id, t.first_name, t.last_name
FROM Teacher t
LEFT JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE c.teacher_id IS NULL;










----Task 4

---Average number of students enrolled in each course
SELECT AVG(student_count) AS average_enrollment
FROM (
    SELECT course_id, COUNT(student_id) AS student_count
    FROM Enrollments
    GROUP BY course_id
) AS course_enrollments;

---Student(s) who made the highest payment
SELECT s.student_id, s.first_name, s.last_name, p.amount
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
WHERE p.amount = (
    SELECT MAX(amount)
    FROM Payments
);

---Course(s) with the highest number of enrollments
SELECT c.course_id, c.course_name, COUNT(e.enrollment_id) AS total_enrollments
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) = (
    SELECT MAX(course_count)
    FROM (
        SELECT COUNT(enrollment_id) AS course_count
        FROM Enrollments
        GROUP BY course_id
    ) AS course_counts
);

---Total payments made to courses taught by each teacher
SELECT t.teacher_id, t.first_name, t.last_name,
    (
        SELECT SUM(p.amount)
        FROM Payments p
        JOIN Enrollments e ON p.student_id = e.student_id
        JOIN Courses c2 ON e.course_id = c2.course_id
        WHERE c2.teacher_id = t.teacher_id
    ) AS total_teacher_payments
FROM Teacher t;

---Students enrolled in all available courses
SELECT student_id
FROM Enrollments
GROUP BY student_id
HAVING COUNT(DISTINCT course_id) = (SELECT COUNT(*) FROM Courses);

---Teachers not assigned to any course
SELECT teacher_id, first_name, last_name
FROM Teacher
WHERE teacher_id NOT IN (
    SELECT DISTINCT teacher_id FROM Courses WHERE teacher_id IS NOT NULL
);

---Average age of all students
SELECT AVG(DATEDIFF(YEAR, date_of_birth, GETDATE())) AS average_age
FROM Students;

---Courses with no enrollments (subquery version)
SELECT course_id, course_name
FROM Courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id FROM Enrollments
);

---Total payments made by each student per course
SELECT s.student_id, s.first_name, c.course_name,
       SUM(p.amount) AS total_paid
FROM Payments p
JOIN Students s ON s.student_id = p.student_id
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.first_name, c.course_name;

---Students who have made more than one payment
SELECT s.student_id, s.first_name, s.last_name, COUNT(p.payment_id) AS payment_count
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(p.payment_id) > 1;

---Total payments made by each student
SELECT s.student_id, s.first_name, s.last_name, SUM(p.amount) AS total_payment
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
GROUP BY s.student_id, s.first_name, s.last_name;

---Course names with count of enrolled students
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled_count
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

---Average payment amount made by students
SELECT AVG(p.amount) AS avg_payment
FROM Students s
JOIN Payments p ON s.student_id = p.student_id;


