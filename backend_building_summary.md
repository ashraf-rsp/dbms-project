## Detailed Backend Building Summary: Academic Center Management System

**Overall Goal:** To implement the backend functionalities for the "Parent-First Academic Center Management System" using only JSP files, adhering strictly to the "no .java file" constraint. This means all database interactions, business logic, and data handling are embedded directly within JSP scriptlets or included JSP fragments (`.jspf`).

**Core Principles & Implications of "No .java file" Constraint:**
*   **Direct Database Interaction:** Instead of separate Java Data Access Objects (DAOs), SQL queries are executed directly within JSP files using `java.sql.*` classes.
*   **Embedded Business Logic:** Business rules and data processing are handled within `<% %>` scriptlets in the JSP pages themselves.
*   **JSP as Controller:** Each JSP page often acts as its own controller, receiving requests, processing data, interacting with the database, and then rendering the view or redirecting.
*   **Data Representation:** Instead of Plain Old Java Objects (POJOs), data is typically handled using `ResultSet` objects directly or simple Java collections (like `ArrayList<Map<String, String>>`) within the JSP scope.
*   **Security:** Paramount importance was given to using `PreparedStatement` for all SQL queries to prevent SQL injection vulnerabilities, as direct string concatenation for queries is highly risky in this model.
*   **Reusability:** Extensive use of `<%@ include file="..." %>` for common code snippets (like database connection and authentication checks) to minimize code duplication.

---

### Section-by-Section Breakdown of Implementation:

#### 1. Database Connection & Initial Setup

*   **Goal:** Establish a reliable connection to the MariaDB database and ensure necessary tables exist for core functionalities.
*   **Implementation Details:**
    *   **`webapp/db_connection.jsp`:** This file was confirmed to contain the `getConnection()` method, which loads the MariaDB JDBC driver and returns a `java.sql.Connection` object. This serves as the central utility for all database connections across the application.
    *   **Table Creation:**
        *   **`Grades` table:** Created with `GradeID`, `EnrollmentID`, `GradePercentage`, `GradeLetter`, `GradedByUserID`, `GradeDate`. This was necessary because the existing database schema lacked a dedicated table for grades, which is fundamental for a grade management system.
        *   **`Messages` table:** Created with `MessageID`, `SenderUserID`, `ReceiverUserID`, `Subject`, `Content`, `Timestamp`, `IsRead`. This was essential for implementing the internal messaging system.
        *   **`Schedules` table:** Created with `ScheduleID`, `CourseID`, `DayOfWeek`, `StartTime`, `EndTime`, `Room`, `TeacherUserID`. This was needed to store and display class schedules dynamically.
*   **Logical Explanation:** Centralizing the connection logic in `db_connection.jsp` promotes reusability and makes it easier to manage database credentials or connection pooling if needed in the future. Creating missing tables was a prerequisite to implement the features that rely on them.

#### 2. User Authentication & Session Management

*   **Goal:** Securely handle user login, logout, and control access to pages based on user authentication and roles.
*   **Implementation Details:**
    *   **`webapp/login_process.jsp`:**
        *   Retrieves `username` and `password` from the login form.
        *   Uses `db_connection.jsp` to get a database connection.
        *   Executes a `SELECT` query on the `Users` table using `PreparedStatement` to find a matching user.
        *   **Crucial Update:** Modified to use `UserID`, `PasswordHash`, and `UserType` column names from the actual `Users` table schema.
        *   On successful login, sets `loggedInUser` (username), `userId`, and `userRole` as session attributes.
        *   Redirects to `dashboard.jsp` on success, or `login.jsp` with an error message on failure.
        *   **Assumption/Note:** Added comments to highlight that `PasswordHash` implies password hashing should be implemented for security, but for now, it compares plain text.
    *   **`webapp/login.jsp`:** Modified to display error messages from `login_process.jsp` by checking `session.getAttribute("loginError")` (as `request` attributes are not preserved across redirects).
    *   **`webapp/logout.jsp`:** Invalidates the user's session (`session.invalidate()`) and redirects to `login.jsp`.
    *   **`webapp/includes/auth_check.jspf`:**
        *   This fragment is designed to be included at the very top of any protected JSP page.
        *   It checks if `loggedInUser` is present in the session. If not, it redirects to `login.jsp`.
        *   It includes optional role-based authorization: if a `requiredRole` is set as a request attribute, it checks if the `userRole` matches. If not, it redirects to `access_denied.jsp`.
    *   **`webapp/access_denied.jsp`:** A simple page to inform users they do not have permission to access a requested resource.
*   **Logical Explanation:** Using session attributes for user state ensures persistence across multiple page requests. `auth_check.jspf` centralizes authorization logic, preventing code duplication and ensuring consistent security. `PreparedStatement` is vital for preventing SQL injection during login.

#### 3. Dashboard (`webapp/dashboard.jsp`)

*   **Goal:** Display dynamic content tailored to the logged-in user's role.
*   **Implementation Details:**
    *   Includes `auth_check.jspf` for security.
    *   Retrieves `userId` and `userRole` from the session.
    *   Uses `if-else` blocks to render different sections based on `userRole` (`Parent`, `Student`, `Teacher`, `Admin`).
    *   **Parent Dashboard:** Retains and refines the existing logic to fetch recent attendance, upcoming events, and fee status by linking `Users.ParentID` to `Student_Parent_Link` and then to `Students`.
    *   **Student Dashboard:**
        *   **Key Assumption:** Assumes `Users.UserID` is directly equivalent to `Students.StudentID` for users with `UserType='Student'`. This was a necessary assumption due to the lack of a direct `UserID` column in the `Students` table.
        *   Reuses the attendance, events, and fee status logic from the Parent dashboard, but directly using the `studentId` derived from `userId`.
    *   **Teacher Dashboard:**
        *   **Key Challenge:** No `Teachers` table was found, and no direct link from `Users.UserID` to teacher-specific data.
        *   **Implementation:** Displays a generic "Teacher Dashboard" message. Further functionality would require clarification on how teachers are linked to courses or students.
    *   **Admin Dashboard:** Displays a generic placeholder for system overview.
*   **Logical Explanation:** Role-based content ensures a personalized user experience. The assumptions made for Student and Teacher linking were necessary to proceed, but highlight areas for potential future database schema refinement if these assumptions are incorrect.

#### 4. Student Profile Management (`webapp/student_profile.jsp` & `webapp/student_profile_process.jsp`)

*   **Goal:** Allow students (or their parents) to view and update student personal information.
*   **Implementation Details:**
    *   **`webapp/student_profile.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Determines `studentId`: If `UserType='Student'`, `studentId = userId`. If `UserType='Parent'`, it tries to get `studentId` from a request parameter or the first linked student.
        *   Fetches student details from `Students`, parent details from `Parents` (via `Student_Parent_Link`), and enrollment/class details from `Enrollments` and `Courses`.
        *   Populates an editable HTML form with fetched data.
        *   Includes JavaScript to toggle the visibility of the edit form.
        *   Displays status/message alerts from `student_profile_process.jsp`.
    *   **`webapp/student_profile_process.jsp`:**
        *   Handles form submissions from `student_profile.jsp`.
        *   Retrieves `studentId`, `firstName`, `lastName`, `dateOfBirth`.
        *   Performs an `UPDATE` query on the `Students` table using `PreparedStatement`.
        *   Redirects back to `student_profile.jsp` with a `status` and `message` parameter.
*   **Logical Explanation:** Separating display and processing logic into two JSPs (though both contain Java) improves organization. Using `PreparedStatement` is crucial for safe updates.

#### 5. Course Management (`webapp/course_management.jsp` & `webapp/course_management_process.jsp`)

*   **Goal:** Allow Admins and Teachers to manage (add, edit, delete) courses.
*   **Implementation Details:**
    *   **`webapp/course_management.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Authorizes access only for `Admin` and `Teacher` roles.
        *   Fetches and displays all courses from the `Courses` table dynamically.
        *   Provides "Add New Course" form, and hidden "Edit Course" and "Delete Course" forms.
        *   Includes JavaScript to handle form toggling and submission for edit/delete actions.
        *   Displays status/message alerts from `course_management_process.jsp`.
    *   **`webapp/course_management_process.jsp`:**
        *   Handles `add`, `edit`, and `delete` actions based on a hidden `action` parameter.
        *   Performs `INSERT`, `UPDATE`, or `DELETE` queries on the `Courses` table using `PreparedStatement`.
        *   Redirects back to `course_management.jsp` with `status` and `message`.
*   **Logical Explanation:** Centralizing course management logic in one process JSP simplifies handling multiple actions. JavaScript enhances the user experience by dynamically showing/hiding forms.

#### 6. Grades Management (`webapp/view_grades.jsp` & `webapp/update_grades_process.jsp`)

*   **Goal:** Allow students/parents to view grades, and teachers/admins to add/edit grades.
*   **Implementation Details:**
    *   **`Grades` table:** Created as it was missing, linking `EnrollmentID` to store grade details.
    *   **`webapp/view_grades.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Authorizes access for `Student`, `Parent`, `Teacher`, `Admin` roles.
        *   Determines `studentId` (similar to `student_profile.jsp`).
        *   Fetches and displays grades by joining `Grades`, `Enrollments`, and `Courses` tables.
        *   Provides "Add New Grade" and "Edit Grade" forms (visible only to Teachers/Admins).
        *   Includes JavaScript for form toggling.
        *   Displays status/message alerts.
    *   **`webapp/update_grades_process.jsp`:**
        *   Handles `add` and `edit` actions.
        *   Performs `INSERT` or `UPDATE` queries on the `Grades` table.
        *   Records `GradedByUserID` (the `userId` of the logged-in teacher/admin) and `GradeDate`.
        *   Redirects back to `view_grades.jsp` with `status` and `message`.
*   **Logical Explanation:** Creating the `Grades` table was fundamental. Linking grades to enrollments ensures proper context. Recording `GradedByUserID` provides an audit trail.

#### 7. Attendance Management (`webapp/view_attendance.jsp` & `webapp/mark_attendance_process.jsp`)

*   **Goal:** Allow students/parents to view attendance, and teachers/admins to mark/edit attendance.
*   **Implementation Details:**
    *   **`webapp/view_attendance.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Authorizes access for `Student`, `Parent`, `Teacher`, `Admin` roles.
        *   Determines `studentId` (similar to `student_profile.jsp`).
        *   Fetches and displays attendance records by joining `Attendance`, `Enrollments`, and `Courses` tables.
        *   Provides "Mark Attendance" and "Edit Attendance" forms (visible only to Teachers/Admins).
        *   Includes JavaScript for form toggling.
        *   Displays status/message alerts.
    *   **`webapp/mark_attendance_process.jsp`:**
        *   Handles `add` and `edit` actions.
        *   Performs `INSERT` or `UPDATE` queries on the `Attendance` table.
        *   Redirects back to `view_attendance.jsp` with `status` and `message`.
*   **Logical Explanation:** Similar to grades, this provides a complete CRUD-like interface for attendance records.

#### 8. Announcements (`webapp/announcements.jsp` & `webapp/announcements_process.jsp`)

*   **Goal:** Display announcements to all users, and allow Admins/Teachers to manage them.
*   **Implementation Details:**
    *   **`webapp/announcements.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Fetches announcements from the `Alert_Log` table.
        *   **Assumption:** The `Message` column in `Alert_Log` stores both title and content, separated by a newline. The first line is extracted as the title.
        *   Provides "Add New Announcement", "Edit Announcement", and "Delete Announcement" forms (visible only to Admins/Teachers).
        *   Includes JavaScript for form toggling and deletion confirmation.
        *   Displays status/message alerts.
    *   **`webapp/announcements_process.jsp`:**
        *   Handles `add`, `edit`, and `delete` actions.
        *   Combines `title` and `content` into the `Message` field for `INSERT`/`UPDATE`.
        *   Performs `INSERT`, `UPDATE`, or `DELETE` queries on the `Alert_Log` table.
        *   Redirects back to `announcements.jsp` with `status` and `message`.
*   **Logical Explanation:** Reusing the `Alert_Log` table for announcements was efficient. The simple title/content parsing from the `Message` column is a practical solution given the "no .java file" constraint.

#### 9. Messages (`webapp/messages.jsp`, `webapp/send_message_process.jsp`, `webapp/get_message_content.jsp`)

*   **Goal:** Implement an internal messaging system for users to send and receive messages.
*   **Implementation Details:**
    *   **`Messages` table:** Created to store message details, including sender, receiver, subject, content, timestamp, and read status.
    *   **`webapp/messages.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Fetches messages for the logged-in `ReceiverUserID`, joining with `Users` to display `SenderUsername`.
        *   Provides a "Compose New Message" form.
        *   Includes a modal for viewing message details.
        *   Includes JavaScript for modal display, and AJAX calls to `get_message_content.jsp` and `send_message_process.jsp` (for marking as read).
        *   Displays status/message alerts.
    *   **`webapp/send_message_process.jsp`:**
        *   Handles `send`, `delete`, and `mark_read` actions.
        *   **Send:** Retrieves `receiverUsername`, looks up `ReceiverUserID` from `Users`, then inserts the message into `Messages`.
        *   **Delete:** Deletes a message, ensuring only the `ReceiverUserID` can delete their own message.
        *   **Mark Read:** Updates `IsRead` status, ensuring only the `ReceiverUserID` can mark their own message as read.
        *   Redirects back to `messages.jsp` with `status` and `message`.
    *   **`webapp/get_message_content.jsp`:**
        *   Called via AJAX to fetch the full `Content` of a message.
        *   Ensures the `messageId` belongs to the `ReceiverUserID` for security.
        *   Prints the content directly to the response.
*   **Logical Explanation:** A dedicated `Messages` table is essential. The AJAX call for message content provides a smoother user experience without full page reloads. Strict checks on `ReceiverUserID` prevent unauthorized message access/modification.

#### 10. Teacher List (`webapp/teacher_list.jsp`)

*   **Goal:** Display a list of all teachers.
*   **Implementation Details:**
    *   **`webapp/teacher_list.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Fetches `UserID` and `Username` from the `Users` table where `UserType` is 'Teacher'.
        *   **Challenge:** No `Teachers` table or direct link for additional teacher details (Subject, Email, Phone).
        *   **Implementation:** Displays `Username` and uses "N/A" as placeholders for missing details.
*   **Logical Explanation:** This highlights a potential area for future database schema expansion if more detailed teacher profiles are required. For now, it fulfills the basic requirement of listing teachers.

#### 11. Class Schedule (`webapp/class_schedule.jsp`)

*   **Goal:** Display class schedules based on the user's role.
*   **Implementation Details:**
    *   **`Schedules` table:** Created to store schedule details (Course, Day, Time, Room, Teacher).
    *   **`webapp/class_schedule.jsp`:**
        *   Includes `db_connection.jsp` and `auth_check.jspf`.
        *   Determines `studentId` or `teacherId` based on `userRole` (using the same assumptions as `dashboard.jsp`).
        *   Fetches schedule data by joining `Schedules`, `Courses`, and `Users` tables.
        *   Filters schedules based on `studentId` (for Student/Parent) or `teacherId` (for Teacher). Admins see all schedules.
        *   Populates both a grid view and a detailed list view.
*   **Logical Explanation:** A dedicated `Schedules` table provides the necessary structure. Role-based filtering ensures users only see relevant schedules.

---

**General Considerations Applied Throughout:**

*   **Error Handling:** `try-catch-finally` blocks are used extensively for database operations. `System.err.println()` is used for server-side logging of exceptions, and generic error messages are displayed to the user to avoid exposing sensitive details.
*   **Input Validation:** Basic checks for null/empty strings and `NumberFormatException` are included. More robust, comprehensive validation (e.g., regex for emails, length constraints) would typically be added for production-grade applications.
*   **Security:** `PreparedStatement` is used for *all* database queries involving user input to prevent SQL injection. This is the most critical security measure in this "no .java file" context.
*   **Reusability:** `db_connection.jsp` and `auth_check.jspf` are included in almost every JSP that requires database access or authentication, significantly reducing code duplication.
*   **User Experience:** Status and message parameters are passed via redirects to provide feedback to the user after form submissions.
*   **JavaScript:** Used for client-side interactions like form toggling, modal displays, and confirmation dialogs, enhancing the user experience without full page reloads.

---

**Assumptions & Future Work:**

*   **Password Hashing:** The current implementation compares plain text passwords. For production, passwords should be hashed (e.g., using BCrypt) before storage and comparison.
*   **Student/Teacher Linking:** The assumptions made about `UserID` being `StudentID` for student users, and the lack of a dedicated `Teachers` table, might need re-evaluation if the intended database schema or linking mechanism is different. If more detailed teacher profiles are needed, a `Teachers` table would be beneficial.
*   **Comprehensive Input Validation:** While basic validation is in place, a more thorough validation layer (e.g., for email formats, phone numbers, date ranges) would improve robustness.
*   **Error Logging:** `System.err.println()` is used for logging. For a production environment, a proper logging framework (like Log4j or SLF4J) should be integrated.
*   **User Management (Admin):** The Admin dashboard is currently a placeholder. Full user management (add/edit/delete users, assign roles) would be a significant next step.
*   **GPA Calculation:** The GPA calculation in `view_grades.jsp` is a placeholder and would require more complex logic.
*   **Filtering/Sorting:** The current implementation fetches all data and relies on basic client-side filtering. For large datasets, server-side filtering and pagination would be necessary.
*   **UI/UX Refinements:** Further styling and interactive elements could enhance the user experience.
