-- Foreign Keys for ALERT_LOG
ALTER TABLE alert_log ADD CONSTRAINT fk_alert_log_parent FOREIGN KEY (ParentID) REFERENCES parents(ParentID);

-- Foreign Keys for ATTENDANCE
ALTER TABLE attendance ADD CONSTRAINT fk_attendance_enrollment FOREIGN KEY (EnrollmentID) REFERENCES enrollments(EnrollmentID);

-- Foreign Keys for COURSE_SESSIONS
ALTER TABLE course_sessions ADD CONSTRAINT fk_cs_course FOREIGN KEY (CourseID) REFERENCES courses(CourseID);
ALTER TABLE course_sessions ADD CONSTRAINT fk_cs_session FOREIGN KEY (SessionID) REFERENCES sessions(SessionID);

-- Foreign Keys for ENROLLMENTS
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_course FOREIGN KEY (CourseID) REFERENCES courses(CourseID);

-- Foreign Keys for EVENTS
ALTER TABLE events ADD CONSTRAINT fk_events_course FOREIGN KEY (CourseID) REFERENCES courses(CourseID);

-- Foreign Keys for GRADES
ALTER TABLE grades ADD CONSTRAINT fk_grades_enrollment FOREIGN KEY (EnrollmentID) REFERENCES enrollments(EnrollmentID);
ALTER TABLE grades ADD CONSTRAINT fk_grades_user FOREIGN KEY (GradedByUserID) REFERENCES users(UserID);

-- Foreign Keys for MESSAGES
ALTER TABLE messages ADD CONSTRAINT fk_messages_sender FOREIGN KEY (SenderUserID) REFERENCES users(UserID);
ALTER TABLE messages ADD CONSTRAINT fk_messages_receiver FOREIGN KEY (ReceiverUserID) REFERENCES users(UserID);

-- Foreign Keys for NOTIFICATIONS
ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user FOREIGN KEY (UserID) REFERENCES users(UserID);
ALTER TABLE notifications ADD CONSTRAINT fk_notifications_alert FOREIGN KEY (AlertID) REFERENCES alert_log(AlertID) ON DELETE SET NULL;

-- Foreign Keys for PARENTS
ALTER TABLE parents ADD CONSTRAINT fk_parents_user FOREIGN KEY (UserID) REFERENCES users(UserID);

-- Foreign Keys for PAYMENTS
ALTER TABLE payments ADD CONSTRAINT fk_payments_enrollment FOREIGN KEY (EnrollmentID) REFERENCES enrollments(EnrollmentID);

-- Foreign Keys for SCHEDULES
ALTER TABLE schedules ADD CONSTRAINT fk_schedules_course FOREIGN KEY (CourseID) REFERENCES courses(CourseID);
ALTER TABLE schedules ADD CONSTRAINT fk_schedules_teacher FOREIGN KEY (TeacherUserID) REFERENCES users(UserID);

-- Foreign Keys for STUDENT_PARENT_LINK
ALTER TABLE student_parent_link ADD CONSTRAINT fk_spl_parent FOREIGN KEY (ParentID) REFERENCES parents(ParentID);
ALTER TABLE student_parent_link ADD CONSTRAINT fk_spl_student FOREIGN KEY (StudentID) REFERENCES students(StudentID);

-- Foreign Keys for USER_MESSAGE_COUNTS
ALTER TABLE user_message_counts ADD CONSTRAINT fk_umc_user FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE;

-- Foreign Keys for USER_MESSAGE_STATUS
ALTER TABLE user_message_status ADD CONSTRAINT fk_ums_user FOREIGN KEY (UserID) REFERENCES users(UserID) ON DELETE CASCADE;

-- Foreign Keys for USER_NOTIFICATION_COUNTS
ALTER TABLE user_notification_counts ADD CONSTRAINT fk_unc_user FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE;

-- Foreign Keys for USERS
ALTER TABLE users ADD CONSTRAINT fk_users_parent FOREIGN KEY (ParentID) REFERENCES parents(ParentID);
