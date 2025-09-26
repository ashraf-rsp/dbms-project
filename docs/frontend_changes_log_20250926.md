# Frontend Implementation Log: Real-Time Counts (2025-09-26)

This document provides a detailed log of the frontend changes made to implement the real-time notification and message count feature.

## 1. Objective

The goal was to create the user-facing components for the real-time counting system. This involved creating lightweight data endpoints, updating the UI to display the counts, and adding JavaScript to fetch the data periodically.

## 2. Implementation Steps & Code

### Step 1: Create JSP Endpoints for Count Fetching

Two new JSP files were created in the `webapp` directory to serve as simple, fast API endpoints for retrieving the unread counts from the database.

**`webapp/get_notification_count.jsp`:**
```jsp
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("text/plain");
    int count = 0;
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null && conn != null) {
        try {
            String sql = "SELECT COALESCE(unread_count, 0) FROM user_notification_counts WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    out.print(count);
%>
```

**`webapp/get_message_count.jsp`:**
```jsp
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("text/plain");
    int count = 0;
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null && conn != null) {
        try {
            String sql = "SELECT COALESCE(unread_count, 0) FROM user_message_counts WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    out.print(count);
%>
```

### Step 2: Update Header UI

The `webapp/includes/header.jsp` file was modified to add a badge for notifications and to standardize the HTML structure for both the notification and message icons. The existing WebSocket script was also removed to make way for the new polling logic.

**Change Summary:**
*   The notification `<div>` was converted into an `<a>` tag.
*   A `<span>` with the class `count-badge` and a unique ID was added to both the notification and message icons.
*   The old WebSocket `<script>` block was removed.

### Step 3: Add CSS for Count Badges

A new file was created at `webapp/css/components.css` to style the new count badges and provide an animation for updates.

```css
/* File: webapp/css/components.css */

.header-icon {
    position: relative;
    margin: 0 15px;
}

.count-badge {
    position: absolute;
    top: -8px;
    right: -12px;
    background-color: #ff4d4f; /* A vibrant red */
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 12px;
    font-weight: bold;
    line-height: 1;
    border: 2px solid var(--header-bg, #fff); /* Match header background */
    display: none; /* Hidden by default */
}

/* Animation for when the count updates */
.count-badge.updated {
    animation: pulse 0.5s;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); }
}
```

### Step 4: Implement JavaScript Polling Logic

The file `webapp/js/main.js` was updated to include the client-side logic for fetching and displaying the counts.

**Logic Added:**
*   A `fetchCounts` function was created to make asynchronous requests to the new JSP endpoints.
*   An `updateCount` function was created to update the badge's text and visibility, and to trigger a CSS animation if the count changes.
*   `fetchCounts` is called once on page load and then every 10 seconds via `setInterval` to poll for updates.

```javascript
// Appended to webapp/js/main.js

// --- Real-Time Count Polling ---
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
    const newCount = parseInt(count, 10);

    if (newCount > 0) {
        element.textContent = newCount;
        element.style.display = 'block';
    } else {
        element.style.display = 'none';
    }
    
    // ... animation logic ...
}

if (notificationCountElement && messageCountElement) {
    fetchCounts(); // Initial fetch
    setInterval(fetchCounts, 10000); // Poll every 10 seconds
}
```

## 3. Final Outcome

All necessary frontend components for the real-time count feature have been implemented. The system is now ready for deployment. The final step is to run the `redeploy.bat` script to apply all changes to the running Tomcat server.
