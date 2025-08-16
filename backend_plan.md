# Backend Development Plan: Academic Center Management System

**Constraint:** All backend logic will be implemented directly within JSP files using scriptlets (`<% %>`) or included JSP fragments (`.jspf`). No separate `.java` files will be created for Servlets, DAOs, or POJOs.

---

## Core Principles:
*   All Java code will reside within JSP files using scriptlets (`<% %>`) or within included JSP fragments (`.jspf`).
*   `webapp/db_connection.jsp` will be the central point for establishing database connections.
*   `PreparedStatement` will be used for all SQL queries to prevent SQL injection.
*   Each JSP will largely act as its own controller, processing requests and rendering views.

---

## Roadmap by Feature/Module:

### 1. Database Connection & Initial Setup
*   **Status:** `webapp/db_connection.jsp` is ready.
*   **Action:** Ensure your MariaDB database (`academic_center_db`) and necessary tables (e.g., `Users` with `user_id`, `username`, `password`, `role`) are created and populated for testing.

### 2. User Authentication & Session Management
*   **Status:** Login flow (`login.jsp`, `login_process.jsp`) is implemented.
*   **Action:**
    *   **Logout:** Create `webapp/logout.jsp` to invalidate the user's session and redirect to `login.jsp`.
    *   **Basic Authorization:** Implement an `includes/auth_check.jspf` to be included at the top of protected JSPs. This fragment will check if a user is logged in and, optionally, if they have the required role for the page. If not authorized, it will redirect to `login.jsp` or an access denied page.

### 3. Dashboard (`webapp/dashboard.jsp`)
*   **Action:** Fetch and display dynamic content relevant to the logged-in user's role (e.g., recent announcements, upcoming classes, quick links). This will involve direct database queries within `dashboard.jsp` or an included `.jspf`.

### 4. Student Profile Management (`webapp/student_profile.jsp`)
*   **Action:**
    *   Fetch and display the logged-in student's profile details from the database.
    *   Create `webapp/student_profile_process.jsp` to handle form submissions for updating student information.

### 5. Course Management (`webapp/course_management.jsp`)
*   **Action:**
    *   Display a list of all courses (for teachers/admins).
    *   Implement functionality to add, edit, and delete courses. This will likely involve a `webapp/course_management_process.jsp` to handle form submissions.

### 6. Grades Management (`webapp/view_grades.jsp`)
*   **Action:**
    *   For students: Fetch and display their grades for enrolled courses.
    *   For teachers: Fetch and display grades for their students in their courses, with options to input/update grades. This will require a `webapp/update_grades_process.jsp`.

### 7. Attendance Management (`webapp/view_attendance.jsp`, `webapp/mark_absent.jsp`)
*   **Action:**
    *   For students: View their attendance records.
    *   For teachers: Mark attendance for their classes. This will involve a `webapp/mark_attendance_process.jsp`.

### 8. Announcements (`webapp/announcements.jsp`)
*   **Action:**
    *   Fetch and display all announcements.
    *   Implement functionality for admins/teachers to create, edit, and delete announcements. This will require a `webapp/announcements_process.jsp`.

### 9. Messages (`webapp/messages.jsp`)
*   **Action:**
    *   Implement an internal messaging system (send/receive messages).
    *   Fetch and display messages for the logged-in user.
    *   Implement `webapp/send_message_process.jsp`.

### 10. Teacher List (`webapp/teacher_list.jsp`)
*   **Action:** Fetch and display a list of all teachers.

### 11. Class Schedule (`webapp/class_schedule.jsp`)
*   **Action:** Fetch and display class schedules based on the user's role (student's schedule, teacher's schedule).

---

## General Considerations Across All Modules:
*   **Error Handling:** Implement consistent error display and logging within JSPs.
*   **Input Validation:** Perform server-side input validation within JSPs for all form submissions.
*   **Security:** Always use `PreparedStatement` for database interactions. Be mindful of Cross-Site Scripting (XSS) by properly escaping all user-generated or database-fetched output displayed on pages.
*   **Reusability:** Maximize the use of `<%@ include file="..." %>` for common code snippets (e.g., database connection, authorization checks, utility functions).
