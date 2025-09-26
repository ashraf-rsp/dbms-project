-- This script creates and initializes the counter tables for real-time notifications and messages.

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
-- Note: This will only work if you have existing data in the Notifications table.
INSERT INTO user_notification_counts (user_id, unread_count, total_count)
SELECT
    UserID,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Notifications
GROUP BY UserID;

-- 4. Populate message counts from existing data
-- Note: This will only work if you have existing data in the Messages table.
INSERT INTO user_message_counts (user_id, unread_count, total_count)
SELECT
    ReceiverUserID as user_id,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as unread_count,
    COUNT(*) as total_count
FROM Messages
GROUP BY ReceiverUserID;
