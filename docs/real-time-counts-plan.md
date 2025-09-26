# Real-Time Notification and Message Count Implementation Plan

This document outlines the plan to implement a high-performance, real-time notification and message count feature using a database trigger-centric approach.

## 1. Concept Overview

To avoid performance-intensive counting queries on every page load, we will adopt a trigger-based system.

1.  **Counter Tables:** We will create two new tables, `user_notification_counts` and `user_message_counts`, to store the pre-calculated counts for each user.
2.  **Database Triggers:** Triggers will be attached to the `Notifications` and `Messages` tables. These will automatically update the counter tables in real-time whenever a notification or message is inserted, updated (e.g., marked as read), or deleted.
3.  **Frontend Fetching:** The user interface will fetch counts from these new, efficient counter tables instead of performing expensive calculations.

## 2. Backend Implementation (MySQL/MariaDB)

### Step 2.1: Create Counter Tables

These tables will hold the aggregated counts.

```sql
-- Notification counter table
CREATE TABLE user_notification_counts (
    user_id INT PRIMARY KEY,
    unread_count INT DEFAULT 0,
    total_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Message counter table
CREATE TABLE user_message_counts (
    user_id INT PRIMARY KEY,
    unread_count INT DEFAULT 0,
    total_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(UserID) ON DELETE CASCADE
);
```

### Step 2.2: Initialize Counter Tables

Populate the new tables with data from existing notifications and messages.

```sql
-- Populate notification counts
INSERT INTO user_notification_counts (user_id, unread_count, total_count)
SELECT
    UserID,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Notifications
GROUP BY UserID;

-- Populate message counts
INSERT INTO user_message_counts (user_id, unread_count, total_count)
SELECT
    ReceiverUserID as user_id,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Messages
GROUP BY ReceiverUserID;
```

### Step 2.3: Create Triggers for Notifications

These triggers will keep the `user_notification_counts` table synchronized.

```sql
DELIMITER $$

-- Trigger for when a new notification is inserted
CREATE TRIGGER trg_notification_insert
AFTER INSERT ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO user_notification_counts (user_id, unread_count, total_count)
    VALUES (NEW.UserID, 1, 1)
    ON DUPLICATE KEY UPDATE
        unread_count = unread_count + 1,
        total_count = total_count + 1;
END$$

-- Trigger for when a notification is updated (marked as read/unread)
CREATE TRIGGER trg_notification_update
AFTER UPDATE ON Notifications
FOR EACH ROW
BEGIN
    IF OLD.IsRead != NEW.IsRead THEN
        IF NEW.IsRead = 1 THEN
            -- Marked as read
            UPDATE user_notification_counts
            SET unread_count = unread_count - 1
            WHERE user_id = NEW.UserID;
        ELSE
            -- Marked as unread
            UPDATE user_notification_counts
            SET unread_count = unread_count + 1
            WHERE user_id = NEW.UserID;
        END IF;
    END IF;
END$$

-- Trigger for when a notification is deleted
CREATE TRIGGER trg_notification_delete
AFTER DELETE ON Notifications
FOR EACH ROW
BEGIN
    UPDATE user_notification_counts
    SET
        total_count = total_count - 1,
        unread_count = unread_count - (CASE WHEN OLD.IsRead = 0 THEN 1 ELSE 0 END)
    WHERE user_id = OLD.UserID;

    -- Clean up if counts reach zero
    DELETE FROM user_notification_counts
    WHERE user_id = OLD.UserID AND total_count <= 0;
END$$

DELIMITER ;
```

### Step 2.4: Create Triggers for Messages

These triggers will keep the `user_message_counts` table synchronized.

```sql
DELIMITER $$

-- Trigger for when a new message is inserted
CREATE TRIGGER trg_message_insert
AFTER INSERT ON Messages
FOR EACH ROW
BEGIN
    INSERT INTO user_message_counts (user_id, unread_count, total_count)
    VALUES (NEW.ReceiverUserID, 1, 1)
    ON DUPLICATE KEY UPDATE
        unread_count = unread_count + 1,
        total_count = total_count + 1;
END$$

-- Trigger for when a message is updated (marked as read/unread)
CREATE TRIGGER trg_message_update
AFTER UPDATE ON Messages
FOR EACH ROW
BEGIN
    IF OLD.IsRead != NEW.IsRead THEN
        IF NEW.IsRead = 1 THEN
            UPDATE user_message_counts
            SET unread_count = unread_count - 1
            WHERE user_id = NEW.ReceiverUserID;
        ELSE
            UPDATE user_message_counts
            SET unread_count = unread_count + 1
            WHERE user_id = NEW.ReceiverUserID;
        END IF;
    END IF;
END$$

-- Trigger for when a message is deleted
CREATE TRIGGER trg_message_delete
AFTER DELETE ON Messages
FOR EACH ROW
BEGIN
    UPDATE user_message_counts
    SET
        total_count = total_count - 1,
        unread_count = unread_count - (CASE WHEN OLD.IsRead = 0 THEN 1 ELSE 0 END)
    WHERE user_id = OLD.ReceiverUserID;

    DELETE FROM user_message_counts
    WHERE user_id = OLD.ReceiverUserID AND total_count <= 0;
END$$

DELIMITER ;
```

## 3. Frontend Implementation

### Step 3.1: Create JSP Endpoints for Fetching Counts

Create two simple JSP files to act as fast API endpoints for retrieving the counts.

**`get_notification_count.jsp`:**
```jsp
<%@ page import="java.sql.*" %>
<%@ include file="includes/db_connection.jsp" %>
<%
    response.setContentType("text/plain");
    int count = 0;
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null) {
        try {
            String sql = "SELECT COALESCE(unread_count, 0) FROM user_notification_counts WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            // Log error, but don't break the page
            e.printStackTrace();
        }
    }
    out.print(count);
%>
```

**`get_message_count.jsp`:**
```jsp
<%@ page import="java.sql.*" %>
<%@ include file="includes/db_connection.jsp" %>
<%
    response.setContentType("text/plain");
    int count = 0;
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null) {
        try {
            String sql = "SELECT COALESCE(unread_count, 0) FROM user_message_counts WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            // Log error
            e.printStackTrace();
        }
    }
    out.print(count);
%>
```

### Step 3.2: Update Header and JavaScript for Real-Time Polling

Modify `header.jsp` to include containers for the counts and update `main.js` to poll for new counts.

**`includes/header.jsp` (Example Snippet):**
```html
<!-- Inside your header, where the icons are -->
<a href="notifications.jsp" class="header-icon">
    <i class="fas fa-bell"></i>
    <span class="notification-count-badge" id="notification-count">0</span>
</a>

<a href="messages.jsp" class="header-icon">
    <i class="fas fa-envelope"></i>
    <span class="message-count-badge" id="message-count">0</span>
</a>
```

**`js/main.js` (Add this new functionality):**
```javascript
document.addEventListener('DOMContentLoaded', function() {
    // ... (existing code)

    const notificationCountElement = document.getElementById('notification-count');
    const messageCountElement = document.getElementById('message-count');

    function fetchCounts() {
        // Fetch Notification Count
        fetch('get_notification_count.jsp')
            .then(response => response.text())
            .then(count => {
                updateCount(notificationCountElement, count);
            })
            .catch(error => console.error('Error fetching notification count:', error));

        // Fetch Message Count
        fetch('get_message_count.jsp')
            .then(response => response.text())
            .then(count => {
                updateCount(messageCountElement, count);
            })
            .catch(error => console.error('Error fetching message count:', error));
    }

    function updateCount(element, count) {
        if (!element) return;
        const currentCount = parseInt(element.textContent, 10);
        const newCount = parseInt(count, 10);

        if (newCount > 0) {
            element.textContent = newCount;
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }

        // Optional: Add a small animation if the count changes
        if (newCount !== currentCount) {
            element.classList.add('updated');
            setTimeout(() => {
                element.classList.remove('updated');
            }, 500);
        }
    }

    // Fetch counts immediately on page load
    fetchCounts();

    // Poll for new counts every 10 seconds
    setInterval(fetchCounts, 10000);
});
```

**`css/components.css` (Add styles for the badge):**
```css
.notification-count-badge, .message-count-badge {
    position: absolute;
    top: -5px;
    right: -10px;
    background-color: red;
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 12px;
    font-weight: bold;
    display: none; /* Hidden by default */
}

/* Animation for when the count updates */
.updated {
    animation: pulse 0.5s;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); }
}
```
