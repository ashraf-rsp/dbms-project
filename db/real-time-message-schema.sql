USE dbms_project;

-- This script sets up the database components for real-time message counts.

-- 1. Create the User_Message_Status table
-- This table will store the number of unread messages for each user.
CREATE TABLE IF NOT EXISTS User_Message_Status (
    UserID INT PRIMARY KEY,
    UnreadCount INT DEFAULT 0,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 2. Create the trigger on the Messages table
-- This trigger will automatically update the UnreadCount when a new message is inserted.
DELIMITER //

CREATE TRIGGER After_Message_Insert
AFTER INSERT ON Messages
FOR EACH ROW
BEGIN
    -- Insert or update the unread message count for the receiver.
    -- If the user is already in the status table, increment their count.
    -- If not, add them to the table with a count of 1.
    INSERT INTO User_Message_Status (UserID, UnreadCount)
    VALUES (NEW.ReceiverUserID, 1)
    ON DUPLICATE KEY UPDATE UnreadCount = UnreadCount + 1;
END;
//

DELIMITER ;