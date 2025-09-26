-- This script creates the triggers for the real-time notification and message counts.

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
