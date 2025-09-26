# Plan: Real-Time Message Count Update

This document outlines the plan to implement a real-time message count in the header using a database trigger and WebSockets.

## The Goal

When a user receives a new message, the message icon in the header should immediately display an updated count of unread messages without requiring a page refresh.

## The Plan

The implementation is divided into three main parts: the database, the backend, and the frontend.

### 1. Database Layer: The Trigger

The database will be responsible for reliably tracking unread message counts.

#### 1.1. Create a `User_Message_Status` Table

A new helper table will be created to store the unread message count for each user. This is more efficient than recounting messages from the main `Messages` table every time.

**Schema:**
```sql
CREATE TABLE User_Message_Status (
    UserID INT PRIMARY KEY,
    UnreadCount INT DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
```

#### 1.2. Create a Trigger on the `Messages` Table

An `AFTER INSERT` trigger will be created on the `Messages` table. This trigger will automatically update the `User_Message_Status` table whenever a new message is sent.

**Trigger Logic:**
- On a new message `INSERT`, get the `ReceiverUserID`.
- `UPDATE` the `User_Message_Status` table for that `ReceiverUserID` by incrementing the `UnreadCount` by 1.

### 2. Backend Layer (Java): The Real-Time Push

The backend will detect changes in the unread count and push them to the client.

#### 2.1. Implement a WebSocket Endpoint

A WebSocket endpoint will be created using JSR 356 (standard in Tomcat). This endpoint will manage connections from clients. The server will maintain a mapping of `UserID` to their active WebSocket connection.

#### 2.2. Efficiently Detect Changes

A background thread on the server will perform efficient database polling.
- It will query the `User_Message_Status` table every 1-2 seconds for all currently connected users.
- It will compare the new count with the last known count for each user.

#### 2.3. Push Updates to the Client

If the backend detects a change in `UnreadCount` for a user, it will send a JSON message through that user's WebSocket connection.

**Example Message:**
```json
{
  "type": "new_message_count",
  "count": 10
}
```

### 3. Frontend Layer (JavaScript): The UI Update

The frontend will listen for updates and refresh the UI.

#### 3.1. Establish WebSocket Connection

The `header.jsp` or a global `main.js` file will be modified to open a WebSocket connection to the backend when a user is logged in.

#### 3.2. Listen for Messages

The client-side JavaScript will listen for incoming messages on the WebSocket.

#### 3.3. Update the Header UI

When a message with `type: "new_message_count"` is received, the JavaScript will instantly update the message count element in the header.

## Summary of the Flow

1.  **User A sends a message to User B.**
2.  An `INSERT` occurs on the `Messages` table.
3.  The **database trigger fires** and increments the `UnreadCount` for User B in the `User_Message_Status` table.
4.  The **backend listener** polls the `User_Message_Status` table and sees the new count for User B.
5.  The backend finds User B's **WebSocket connection**.
6.  The backend **pushes the new count** to User B's browser.
7.  The **JavaScript** in User B's browser receives the message and updates the message icon's count.
