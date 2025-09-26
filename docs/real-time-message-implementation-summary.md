# Real-Time Message Count Implementation Summary

This document summarizes the steps taken to implement the real-time unread message count feature in the application.

## Goal

To display an immediate, real-time count of unread messages in the header's message icon for logged-in users.

## Implementation Steps

### 1. Database Setup

-   **`User_Message_Status` Table:** Created a new table to store the `UserID` and their `UnreadCount`.
    ```sql
    CREATE TABLE IF NOT EXISTS User_Message_Status (
        UserID INT PRIMARY KEY,
        UnreadCount INT DEFAULT 0,
        LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
    );
    ```
-   **`After_Message_Insert` Trigger:** Created a trigger on the `Messages` table that fires `AFTER INSERT`. This trigger increments the `UnreadCount` for the `ReceiverUserID` in the `User_Message_Status` table.
    ```sql
    DELIMITER //
    CREATE TRIGGER After_Message_Insert
    AFTER INSERT ON Messages
    FOR EACH ROW
    BEGIN
        INSERT INTO User_Message_Status (UserID, UnreadCount)
        VALUES (NEW.ReceiverUserID, 1)
        ON DUPLICATE KEY UPDATE UnreadCount = UnreadCount + 1;
    END;
    //
    DELIMITER ;
    ```
-   **Database Name Correction:** Corrected the database name from `academic_center_db` to `dbms_project` in the SQL script.

### 2. Backend Implementation (Java)

A single Java file, `RealtimeManager.java`, was created to handle both the WebSocket endpoint and the background polling.

-   **File:** `webapp/WEB-INF/classes/com/academic/RealtimeManager.java`
-   **Components:**
    -   **WebSocket Endpoint:** Annotated with `@ServerEndpoint("/message-updates/{userId}"), it manages user WebSocket sessions.
    -   **Background Poller (`ServletContextListener`):** Implements `ServletContextListener` to start a background thread on application startup. This thread polls the `User_Message_Status` table every 2 seconds and uses the WebSocket to push updates to users with new unread messages.
-   **Compilation:** The `RealtimeManager.java` file was successfully compiled into `RealtimeManager.class` using `javac` with the appropriate classpath (`javax.servlet-api.jar` and `javax.websocket-api.jar`).

### 3. `web.xml` Configuration

The `webapp/WEB-INF/web.xml` file was updated to register the `RealtimeManager` as a `ServletContextListener`, ensuring it starts automatically with the web application.

```xml
<listener>
    <listener-class>com.academic.RealtimeManager</listener-class>
</listener>
```

### 4. Frontend Integration (JavaScript in `header.jsp`)

The `webapp/includes/header.jsp` file was modified to integrate the real-time updates.

-   **Message Count Element:** A `<span>` element with `id="message-count"` was added next to the message icon to display the unread count.
-   **WebSocket JavaScript:** JavaScript code was added to:
    -   Establish a WebSocket connection to `/message-updates/{userId}`.
    -   Listen for incoming messages from the server.
    -   Parse messages of type `"new_message_count"` and update the `message-count` `<span>` accordingly.

## Troubleshooting

If you encounter issues with the real-time message count, consider the following:

### 1. WebSocket Connection Issues

-   **Symptom:** The browser console shows errors related to WebSocket connection (e.g., `WebSocket connection to 'ws://...' failed`).
-   **Possible Causes:**
    -   **Incorrect WebSocket URL:** Double-check the `websocketUrl` in `header.jsp` to ensure it matches the `@ServerEndpoint` path (`/message-updates/{userId}`).
    -   **Tomcat Not Running/Configured:** Ensure Tomcat is running and properly configured for WebSocket support. Modern Tomcat versions (9+) should support JSR 356 WebSockets out-of-the-box.
    -   **Firewall:** A firewall might be blocking the WebSocket connection. Check your system's firewall settings.
    -   **`RealtimeManager.class` Not Deployed/Compiled:** Ensure `RealtimeManager.java` was successfully compiled into `RealtimeManager.class` and is located in `webapp/WEB-INF/classes/com/academic/`.

### 2. No Real-time Updates (Count Not Changing)

-   **Symptom:** The WebSocket connects successfully, but the message count in the header does not update when new messages are sent.
-   **Possible Causes:**
    -   **Database Trigger Not Firing:** The `After_Message_Insert` trigger might not be working correctly. You can manually test it:
        ```sql
        -- To manually check the trigger:
        INSERT INTO Messages (SenderUserID, ReceiverUserID, Subject, Content)
        VALUES (1, 2, 'Test Subject', 'Test Content');
        SELECT UserID, UnreadCount FROM User_Message_Status WHERE UserID = 2;
        ```
    -   **`BackgroundPoller` Not Running/Failing:** Check your Tomcat server logs (`D:\Java\tomcat\logs\catalina.log` or similar) for any errors or exceptions from `com.academic.RealtimeManager`. Look for stack traces from the `contextInitialized` method:
        ```java
        // Relevant part of RealtimeManager.java (contextInitialized method)
        public void contextInitialized(ServletContextEvent event) {
            scheduler = Executors.newSingleThreadScheduledExecutor();
            scheduler.scheduleAtFixedRate(() -> {
                try {
                    // ... database connection and query ...
                    while (rs.next()) {
                        String userId = rs.getString("UserID");
                        int unreadCount = rs.getInt("UnreadCount");
                        sendMessageToUser(userId, "{\"type\": \"new_message_count\", \"count\": " + unreadCount + "}");
                    }
                    // ... close connection ...
                } catch (Exception e) {
                    e.printStackTrace(); // Check server logs for these stack traces
                }
            }, 0, 2, TimeUnit.SECONDS);
        }
        ```
    -   **`RealtimeManager` Not Pushing:** The `sendMessageToUser` method might not be correctly identifying or sending messages to the active WebSocket sessions. Ensure the `userId` passed to the WebSocket endpoint matches the `userId` used in the `sendMessageToUser` call.
    -   **Frontend JavaScript Issue:** The JavaScript in `header.jsp` might not be correctly parsing the incoming WebSocket message or updating the DOM element. Use your browser's developer tools (Network tab -> WS filter) to inspect the WebSocket messages being received. Pay attention to the `onmessage` handler:
        ```javascript
        // Relevant part of header.jsp (WebSocket onmessage handler)
        websocket.onmessage = function(event) {
            const message = JSON.parse(event.data);
            if (message.type === "new_message_count") {
                messageCountSpan.textContent = message.count;
                if (message.count > 0) {
                    messageCountSpan.classList.add('has-messages');
                } else {
                    messageCountSpan.classList.remove('has-messages');
                }
            }
        };
        ```

### 3. Database Access Errors During Setup

-   **Symptom:** Errors like "Access denied" or "Unknown database" when trying to execute the SQL script.
-   **Solution:**
    -   **Credentials:** Verify the MySQL/MariaDB username (`root`) and password (`a187`) are correct.
    -   **Database Name:** Ensure the database name (`dbms_project`) is spelled correctly and exists on your MySQL server.
    -   **Privileges:** Confirm that the user (`root`) has sufficient privileges to create tables and triggers on the `dbms_project` database.

## Next Steps

To see the implemented changes, please redeploy the application. After redeployment, you can test the functionality by sending a message to a user and observing if the message count updates in real-time in the header.
