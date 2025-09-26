### Simplified Plan for Dynamic Notification Bell:

**Goal:** Implement a dynamic notification bell that shows the unread count and displays a list of notifications when clicked, with minimal UI elements in the header.

**Key Components:**

1.  **Database (`Notifications` table):**
    *   `NotificationID` (Primary Key, Auto-increment)
    *   `UserID` (Foreign Key to `Users` table, linking notification to a specific user. Can be `NULL` for global announcements.)
    *   `UserRole` (VARCHAR, Optional: to target notifications to specific roles if `UserID` is NULL. e.g., 'Admin', 'Teacher', 'Parent', 'Student', or 'All')
    *   `Message` (TEXT: The content of the notification)
    *   `Timestamp` (DATETIME: When the notification was created)
    *   `IsRead` (BOOLEAN, default `FALSE`, to track read status)
    *   `Link` (VARCHAR: Optional, a URL to navigate to when the notification is clicked)
    *   `Type` (VARCHAR: e.g., 'Announcement', 'System', 'GradeUpdate', 'AttendanceAlert', 'CourseUpdate'. Useful for filtering/categorization.)

2.  **MariaDB Triggers (for automatic notification generation):**
    *   **Purpose:** Automatically insert notifications into the `Notifications` table based on specific events in other tables.
    *   **Examples:**
        *   **`Announcements` table:** Trigger on `INSERT` to create a notification for all relevant users (or specific roles).
        *   **`Grades` table:** Trigger on `INSERT` or `UPDATE` to notify a student/parent about a new or changed grade.
        *   **`Attendance` table:** Trigger on `INSERT` to notify a parent about their child's attendance status.
        *   **`Courses` table:** Trigger on `UPDATE` (e.g., course description change) to notify enrolled students/teachers.
        *   **System-generated:** For system-wide alerts (e.g., "Server maintenance tonight"), these would be inserted directly by admin actions or scheduled tasks, not necessarily triggers.

3.  **Backend (JSP/Java Servlets - `notifications_api.jsp`):**
    *   **`action=count`:** Return the number of unread notifications for the logged-in user.
    *   **`action=fetch`:** Return a list of recent notifications (e.g., last 10-20, unread first) for the logged-in user.
    *   **`action=mark_read`:** Mark a specific notification or all notifications as read for the logged-in user.
    *   **Security:** All queries must filter by the `UserID` (and potentially `UserRole`) from the *session*.

4.  **Frontend (HTML/CSS/JavaScript):**
    *   **HTML Structure (`includes/header.jsp`):**
        *   The bell icon (`<i class="fas fa-bell"></i>`).
        *   A `<span>` element for the dynamic notification count (e.g., `<span id="notification-count">0</span>`).
        *   A hidden `<div>` element that will serve as the dropdown/modal for displaying the list of notifications (e.g., `<div id="notifications-dropdown">`).
            *   Inside this dropdown, we'll have a simple list of notification items. The "Mark all as read" action will be implicitly handled when the dropdown is opened and notifications are fetched.
    *   **CSS Styling (`css/components.css` or new `css/notifications.css`):**
        *   Styles for the notification bell, count badge, and the dropdown/modal (positioning, appearance, scrollability).
        *   Styles for individual notification items (read/unread states, hover effects).
    *   **JavaScript (`js/main.js` or new `js/notifications.js`):**
        *   **`updateNotificationCount()`:** Fetches count from `notifications_api.jsp?action=count` and updates the `<span>`.
        *   **`fetchNotifications()`:** Fetches list from `notifications_api.jsp?action=fetch`, dynamically creates HTML elements for each notification, and populates the dropdown. **When this function is called (i.e., when the dropdown is opened), it will also trigger the `mark_read` action for the fetched notifications.**
        *   **Event Listeners:**
            *   Click on bell: Toggles `notifications-dropdown` visibility. If the dropdown is opened, calls `fetchNotifications()`.
            *   Click on individual notification item: Navigates to `Link` if present. (Marking as read is handled by `fetchNotifications` when the dropdown opens).
        *   **Polling:** Implement a `setInterval` to call `updateNotificationCount()` periodically (e.g., every 30-60 seconds) to keep the count fresh.

**Refinement:**

*   **Implicit Mark as Read:** The key simplification is that opening the notification dropdown will automatically mark the displayed notifications as read. This reduces clutter.
*   **No Extra Buttons in Header:** The header will only contain the bell icon and the dynamic count. All notification management (viewing details, marking as read) happens within the dropdown.
