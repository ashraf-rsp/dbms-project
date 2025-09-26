### Guiding Principles

*   **Student:** Focused, read-only access to their own academic information.
*   **Parent:** Comprehensive view of their child's data, reflecting the "parent-centric" model.
*   **Teacher:** Control over their assigned classes and students.
*   **Admin:** Full control over all aspects of the system.

### Proposed Feature Access by Role

#### 1. Student (View-Only Access)
*   **Dashboard:** View announcements and a summary of their schedule.
*   **Profile:** View their own profile information.
*   **Academics:** View their class schedule, attendance records, and grades.
*   **Finances:** View their payment history.
*   **Communication:** Send and receive messages from their teachers.

#### 2. Parent (Child-Focused View)
*   **Dashboard:** View system-wide announcements and a summary of their child's recent activity (grades, attendance).
*   **Profile:** Manage their own profile.
*   **Student Hub:** Access a detailed view of their child's:
    *   Profile
    *   Class Schedule
    *   Attendance History
    *   Grades
    *   Payment Status
*   **Communication:** Communicate directly with their child's teachers and school administrators.

#### 3. Teacher (Classroom Control)
*   **Dashboard:** View their teaching schedule and a list of their students.
*   **Profile:** Manage their own profile.
*   **Class Management:**
    *   View the profiles of students in their classes.
    *   Take and manage attendance for their classes.
    *   Enter and update student grades.
*   **Communication:** Send messages to students, parents, and administrators. Post announcements for their classes.

#### 4. Admin (System-Wide Control)
*   **Dashboard:** See a high-level overview of the entire system (e.g., user counts, pending registrations).
*   **User Management:** Create, approve, modify, and delete all user accounts (Admins, Teachers, Parents, Students).
*   **Academic Management:**
    *   Create and manage all courses.
    *   Enroll students in courses.
    *   Assign teachers to courses.
*   **Content & Communication:** Post system-wide announcements and oversee messaging.
*   **Full Data Access:** View and manage all data within the system for support and administrative purposes.

### Next Steps

If you approve this plan, I will begin by:

1.  **Auditing the existing JSP pages** against this new access model.
2.  **Implementing strict server-side authorization checks** in each file to enforce these rules.
3.  **Refining the navigation (`sidebar.jsp`)** to dynamically show only the links a user is authorized to see.
