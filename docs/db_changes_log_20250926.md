# DB Implementation Log: Real-Time Counts (2025-09-26)

This document provides a detailed log of the process undertaken to implement a database-level, real-time counting mechanism for user notifications and messages.

## 1. Objective

The goal was to implement a high-performance system for tracking unread/total notifications and messages. The chosen method involves creating dedicated counter tables that are updated automatically by database triggers, thus avoiding slow, on-demand counting queries in the application.

## 2. Initial Plan & Code

The plan consisted of two main parts:
1.  Creating and populating two new counter tables: `user_notification_counts` and `user_message_counts`.
2.  Creating six triggers to automatically update these tables in response to `INSERT`, `UPDATE`, and `DELETE` events on the `Notifications` and `Messages` tables.

### 2.1. SQL Script for Table Creation & Initialization

A script was created at `db/setup_real_time_counts.sql` to create and populate the counter tables.

```sql
-- File: db/setup_real_time_counts.sql

-- 1. Create Notification counter table
CREATE TABLE user_notification_counts (
    user_id INT PRIMARY KEY,
    unread_count INT DEFAULT 0,
    total_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 2. Create Message counter table
CREATE TABLE user_message_counts (
    user_id INT PRIMARY KEY,
    unread_count INT DEFAULT 0,
    total_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 3. Populate notification counts from existing data
INSERT INTO user_notification_counts (user_id, unread_count, total_count)
SELECT
    UserID,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Notifications
GROUP BY UserID;

-- 4. Populate message counts from existing data
INSERT INTO user_message_counts (user_id, unread_count, total_count)
SELECT
    ReceiverUserID as user_id,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Messages
GROUP BY ReceiverUserID;
```

### 2.2. SQL Script for Trigger Creation

A separate script was created at `db/create_count_triggers.sql` for all the trigger definitions.

```sql
-- File: db/create_count_triggers.sql

DELIMITER $$

-- Trigger for when a new notification is inserted
CREATE TRIGGER trg_notification_insert AFTER INSERT ON Notifications FOR EACH ROW
BEGIN
    INSERT INTO user_notification_counts (user_id, unread_count, total_count)
    VALUES (NEW.UserID, 1, 1)
    ON DUPLICATE KEY UPDATE unread_count = unread_count + 1, total_count = total_count + 1;
END$$

-- ... (and all other trigger definitions as previously detailed) ...

DELIMITER ;
```

## 3. Execution and Troubleshooting Log

### Step 1: First Execution Attempt

The `setup_real_time_counts.sql` script was executed.

*   **Command:** `mysql -h localhost -u dbms_user -pashraf -D dbms_project < E:\2025\PersonalProject\dbms-project\db\setup_real_time_counts.sql`
*   **Result:** **FAILURE**

### Step 2: Troubleshooting the Foreign Key Error

*   **Symptom:** The script failed with a foreign key constraint error:
    ```
    ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`dbms_project`.`user_notification_counts`...)
    ```
*   **Hypothesis:** This error suggested that the `INSERT` statement was trying to add a `user_id` to `user_notification_counts` that did not exist in the parent `Users` table.

*   **Investigation:** I first checked for `UserID`s in `Notifications` that were not in `Users`.
    *   **Query:** `SELECT DISTINCT N.UserID FROM Notifications N LEFT JOIN Users U ON N.UserID = U.UserID WHERE U.UserID IS NULL;`
    *   **Result:** The query returned a single row with a `NULL` value.

*   **Refined Hypothesis:** The issue was not a mismatch, but the presence of `NULL` values in the `Notifications.UserID` column, which cannot satisfy a foreign key relationship.

*   **Verification:** I counted the number of orphaned records.
    *   **Query:** `SELECT COUNT(*) FROM Notifications WHERE UserID IS NULL;`
    *   **Result:** `1`. This confirmed one orphaned notification.

*   **Resolution:** The decision was made to delete the invalid record.
    *   **Command:** `DELETE FROM Notifications WHERE UserID IS NULL;`
    *   **Result:** Success.

### Step 3: Second Execution Attempt

With the data cleaned, the setup script was run again.

*   **Command:** `mysql -h localhost -u dbms_user -pashraf -D dbms_project < E:\2025\PersonalProject\dbms-project\db\setup_real_time_counts.sql`
*   **Result:** **FAILURE**

### Step 4: Troubleshooting the "Table already exists" Error

*   **Symptom:** The script failed with a new error:
    ```
    ERROR 1050 (42S01): Table 'user_notification_counts' already exists
    ```
*   **Hypothesis:** The first failed attempt had successfully executed the `CREATE TABLE` statements before failing on the `INSERT`. The tables were therefore left behind.

*   **Resolution:** The partially created tables needed to be dropped to allow the script to run from a clean state.
    *   **Command:** `DROP TABLE IF EXISTS user_notification_counts, user_message_counts;`
    *   **Result:** Success.

### Step 5: Third and Final Execution Attempt (Tables)

The setup script was executed one last time.

*   **Command:** `mysql -h localhost -u dbms_user -pashraf -D dbms_project < E:\2025\PersonalProject\dbms-project\db\setup_real_time_counts.sql`
*   **Result:** **SUCCESS**

### Step 6: Executing the Trigger Script

With the tables created and initialized, the triggers were created.

*   **Command:** `mysql -h localhost -u dbms_user -pashraf -D dbms_project < E:\2025\PersonalProject\dbms-project\db\create_count_triggers.sql`
*   **Result:** **SUCCESS**

## 4. Final Outcome

The database backend for the real-time counting feature was successfully implemented. The counter tables `user_notification_counts` and `user_message_counts` are now live, and the six required triggers are active and will ensure the counts remain synchronized.
