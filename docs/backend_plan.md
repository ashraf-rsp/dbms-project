# Backend Implementation Plan for Academic Center Management System

This document outlines the plan for implementing the backend for the Academic Center Management System using MariaDB.

## 1. User Roles and Permissions

We will have three user roles with the following permissions:

*   **Admin:**
    *   Manage users (add, edit, delete teachers and parents).
    *   Manage courses (add, edit, delete courses).
    *   Assign teachers to courses.
    *   View all system data (students, parents, teachers, courses, attendance, grades, payments).
    *   Manage announcements and system-wide messages.
    *   Handle payment updates and view financial reports.

*   **Teacher:**
    *   View their assigned courses and student lists.
    *   Mark student attendance.
    *   Update student grades.
    *   Send messages to parents of their students.
    *   View announcements.

*   **Parent:**
    *   View their child's profile, attendance, and grades.
    *   View their child's class schedule.
    *   Communicate with their child's teachers.
    *   View announcements and messages.
    *   View and manage their payment status.

## 2. Database Schema

The existing `schema.sql` provides a good foundation. We will use it as is, with the following considerations:

*   **Users Table:** The `Users` table will be central to authentication. We will need to ensure the `PasswordHash` field stores securely hashed passwords (e.g., using bcrypt or Argon2). The `UserType` will be used to enforce role-based access control.
*   **Relationships:** The existing relationships between tables seem appropriate. We will leverage these relationships to retrieve and manipulate data efficiently.

## 3. Backend API Endpoints

We will create a set of API endpoints to handle the application's business logic. These endpoints will be implemented as JSP pages that process requests and return data in JSON format where appropriate.

### 3.1. Authentication

*   **`POST /login_process.jsp`:** Authenticates users and creates a session.
*   **`GET /logout.jsp`:** Logs out the user and destroys the session.

### 3.2. Admin Endpoints

*   **`GET /api/users`:** Get a list of all users.
*   **`POST /api/users`:** Create a new user.
*   **`PUT /api/users/{userId}`:** Update a user's information.
*   **`DELETE /api/users/{userId}`:** Delete a user.
*   **`GET /api/courses`:** Get a list of all courses.
*   **`POST /api/courses`:** Create a new course.
*   **`PUT /api/courses/{courseId}`:** Update a course's information.
*   **`DELETE /api/courses/{courseId}`:** Delete a course.
*   **`POST /api/courses/{courseId}/assign-teacher`:** Assign a teacher to a course.

### 3.3. Teacher Endpoints

*   **`GET /api/teacher/courses`:** Get the courses assigned to the logged-in teacher.
*   **`GET /api/teacher/courses/{courseId}/students`:** Get the list of students in a course.
*   **`POST /api/attendance`:** Mark student attendance.
*   **`POST /api/grades`:** Update student grades.
*   **`POST /api/messages`:** Send a message to a parent.

### 3.4. Parent Endpoints

*   **`GET /api/parent/children`:** Get the logged-in parent's children.
*   **`GET /api/student/{studentId}/profile`:** Get a student's profile.
*   **`GET /api/student/{studentId}/attendance`:** Get a student's attendance.
*   **`GET /api/student/{studentId}/grades`:** Get a student's grades.
*   **`GET /api/student/{studentId}/schedule`:** Get a student's class schedule.
*   **`GET /api/messages`:** Get messages for the logged-in parent.
*   **`GET /api/payments`:** Get the payment status for the logged-in parent.

## 4. Authentication and Authorization

*   **Authentication:** User authentication will be handled by the `login_process.jsp` page. Upon successful login, a session will be created for the user, and their `userId` and `userRole` will be stored in the session.
*   **Authorization:** For each API endpoint, we will check the user's session and their `userRole` to ensure they have the necessary permissions to perform the requested action. This will be implemented using a filter or by including a check at the beginning of each restricted JSP page.

## 5. Technologies

*   **Backend:** Java Servlets and JSP
*   **Database:** MariaDB
*   **Authentication:** Session-based authentication
*   **API Format:** JSON for data exchange between the frontend and backend.

This plan provides a roadmap for the backend implementation. The next step is to start implementing the API endpoints as defined in this document.