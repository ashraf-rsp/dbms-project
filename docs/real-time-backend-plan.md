# Real-Time Backend Plan (Revised)

This document outlines the robust and reliable plan for implementing the backend of the real-time messaging feature. This approach uses standard Java web application components and is a significant improvement over the previous "JSP-only" idea, which has major technical limitations.

## The Goal

To create a reliable backend system that:
1.  Detects new messages in the database in real-time.
2.  Pushes notifications to the correct users via WebSockets.

## The Components

This plan involves creating two small, focused Java classes. This is the standard and correct way to implement this functionality.

### 1. The WebSocket Endpoint (`MessageWebsocket.java`)

Instead of embedding the WebSocket logic in a JSP file, we will create a dedicated Java class for it. This makes the code clean, reusable, and easy to manage.

*   **Proposed File:** `WEB-INF/classes/com/academic/websockets/MessageWebsocket.java`
*   **Purpose:**
    *   This class will be annotated with `@ServerEndpoint("/message-updates")` to serve as the WebSocket connection point.
    *   It will manage all active user sessions, mapping each `UserID` to their specific WebSocket connection.
    *   It will provide a static method, like `sendMessageToUser(String userId, String message)`, that can be called from other parts of the application to send a message to a specific user.

### 2. The Background Poller (`BackgroundPoller.java`)

This class will be a `ServletContextListener`, which is the standard Java EE component for running code when a web application starts and stops.

*   **Proposed File:** `WEB-INF/classes/com/academic/listeners/BackgroundPoller.java`
*   **Purpose:**
    *   **On Application Startup:** It will start a new background thread. This thread will run continuously while the application is live.
    *   **The Thread's Job:** Every 2-3 seconds, the thread will:
        1.  Query the `User_Message_Status` table for any users with an `UnreadCount` greater than their last known count.
        2.  For each user with an update, it will call the `MessageWebsocket.sendMessageToUser()` method to instantly send the new unread message count to that user's browser.
    *   **On Application Shutdown:** It will gracefully stop the background thread to prevent memory leaks.

### 3. `web.xml` Configuration

To enable the `BackgroundPoller`, a small entry needs to be added to the `webapp/WEB-INF/web.xml` file.

```xml
<listener>
    <listener-class>com.academic.listeners.BackgroundPoller</listener-class>
</listener>
```

### Why This Approach is Superior

*   **Reliability:** The background task is guaranteed to start and stop correctly with the web application.
*   **Maintainability:** The code is properly organized into logical classes, making it much easier to understand, debug, and maintain in the future.
*   **Solves Technical Hurdles:** This approach avoids the communication problems between components that the "JSP-only" method creates.

