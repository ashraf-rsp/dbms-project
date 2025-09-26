# Real-Time Backend Plan (Final)

This document outlines the final, simplified plan for implementing the real-time messaging feature. This approach uses a single Java file to ensure reliability and maintainability.

## The Goal

To create a reliable backend system that:
1.  Detects new messages in the database in real-time.
2.  Pushes notifications to the correct users via WebSockets.

## The Components

This plan involves creating one single Java file that contains all the necessary backend logic.

### 1. The `RealtimeManager.java` File

A single Java file will be created to manage everything.

**File:** `webapp/WEB-INF/classes/com/academic/RealtimeManager.java`

**Purpose:**
This file will contain two main components:

#### a. The WebSocket Endpoint

-   A class annotated with `@ServerEndpoint("/message-updates/{userId}")` will handle WebSocket connections.
-   It will manage all active user sessions, mapping each `UserID` to their specific WebSocket connection.

#### b. The Background Poller (`ServletContextListener`)

-   The `RealtimeManager` class will implement `ServletContextListener`.
-   **On Application Startup:** It will start a new background thread.
-   **The Thread's Job:** Every 2-3 seconds, the thread will:
    1.  Query the `User_Message_Status` table.
    2.  For each user with an update, it will use the WebSocket endpoint (which is in the same file) to send the new unread message count to that user's browser.
-   **On Application Shutdown:** It will gracefully stop the background thread.

### 2. `web.xml` Configuration

The `web.xml` file will be updated to register the `RealtimeManager` as a listener.

```xml
<listener>
    <listener-class>com.academic.RealtimeManager</listener-class>
</listener>
```

### 3. Compilation

After the `RealtimeManager.java` file is created, it will need to be compiled. This will require running a single `javac` command from the terminal.

### 4. Frontend Update

Once the backend is in place and compiled, the `header.jsp` file will be updated with JavaScript to connect to the WebSocket and handle incoming messages.

## Why This Approach is Best

-   **Reliable:** It uses standard Java EE features to ensure the background process runs correctly.
-   **Simple:** All the backend logic is in one place.
-   **Maintainable:** The code is clean, organized, and easy to understand.
