# Database Information for Academic Center Management System

This document summarizes the database credentials and schema for the `academic_center_db`.

## 1. Database Credentials

These credentials were found in `webapp/db_connection.jsp`:

*   **DB_URL:** `jdbc:mariadb://localhost:3306/academic_center_db`
*   **DB_USER:** `academic_user`
*   **DB_PASSWORD:** `ashraf`

## 2. Database Schema Overview

The `academic_center_db` contains the following tables with their primary keys (PK) and foreign key (FK) relationships:

*   **`Alert_Log`**
    *   `AlertID` (PK)
    *   `ParentID` (FK to `Parents.ParentID`)

*   **`Attendance`**
    *   `AttendanceID` (PK)
    *   `EnrollmentID` (FK to `Enrollments.EnrollmentID`)

*   **`Courses`**
    *   `CourseID` (PK)

*   **`Enrollments`**
    *   `EnrollmentID` (PK)
    *   `StudentID` (FK to `Students.StudentID`)
    *   `CourseID` (FK to `Courses.CourseID`)

*   **`Events`**
    *   `EventID` (PK)
    *   `CourseID` (FK to `Courses.CourseID`)

*   **`Grades`**
    *   `GradeID` (PK)
    *   `EnrollmentID` (FK to `Enrollments.EnrollmentID`)
    *   `GradedByUserID` (FK to `Users.UserID`)

*   **`Messages`**
    *   `MessageID` (PK)
    *   `SenderUserID` (FK to `Users.UserID`)
    *   `ReceiverUserID` (FK to `Users.UserID`)

*   **`Parents`**
    *   `ParentID` (PK)
    *   `Email` (Unique)

*   **`Payments`**
    *   `PaymentID` (PK)
    *   `EnrollmentID` (FK to `Enrollments.EnrollmentID`)

*   **`Schedules`**
    *   `ScheduleID` (PK)
    *   `CourseID` (FK to `Courses.CourseID`)
    *   `TeacherUserID` (FK to `Users.UserID`)

*   **`Student_Parent_Link`**
    *   `LinkID` (PK)
    *   `StudentID` (FK to `Students.StudentID`)
    *   `ParentID` (FK to `Parents.ParentID`)

*   **`Students`**
    *   `StudentID` (PK)

*   **`Users`**
    *   `UserID` (PK)
    *   `Username` (Unique)
    *   `PasswordHash`
    *   `UserType`
    *   `ParentID` (FK to `Parents.ParentID`)

## 3. Key Relationships and Observations

*   The `Users` table is fundamental for authentication and role-based access control (`UserType` column).
*   `Enrollments` serves as a central linking table for students and courses, influencing `Attendance`, `Grades`, and `Payments`.
*   `Student_Parent_Link` explicitly defines the relationship between students and their parents.
*   `Schedules` links courses to specific teachers (users).

This information will be crucial for developing and integrating the backend APIs.
