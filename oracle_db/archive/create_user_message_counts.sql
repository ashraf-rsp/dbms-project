CREATE TABLE user_message_counts (
    user_id NUMBER(11) NOT NULL,
    unread_count NUMBER(11) DEFAULT 0,
    total_count NUMBER(11) DEFAULT 0,
    PRIMARY KEY (user_id)
);
