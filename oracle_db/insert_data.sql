--- Disabling Constraints and Triggers ---
ALTER TABLE alert_log DISABLE CONSTRAINT fk_alert_log_parent;
ALTER TABLE attendance DISABLE CONSTRAINT fk_attendance_enrollment;
ALTER TABLE course_sessions DISABLE CONSTRAINT fk_cs_course;
ALTER TABLE course_sessions DISABLE CONSTRAINT fk_cs_session;
ALTER TABLE enrollments DISABLE CONSTRAINT fk_enrollments_course;
ALTER TABLE events DISABLE CONSTRAINT fk_events_course;
ALTER TABLE grades DISABLE CONSTRAINT fk_grades_enrollment;
ALTER TABLE grades DISABLE CONSTRAINT fk_grades_user;
ALTER TABLE messages DISABLE CONSTRAINT fk_messages_sender;
ALTER TABLE messages DISABLE CONSTRAINT fk_messages_receiver;
ALTER TABLE notifications DISABLE CONSTRAINT fk_notifications_user;
ALTER TABLE notifications DISABLE CONSTRAINT fk_notifications_alert;
ALTER TABLE parents DISABLE CONSTRAINT fk_parents_user;
ALTER TABLE payments DISABLE CONSTRAINT fk_payments_enrollment;
ALTER TABLE schedules DISABLE CONSTRAINT fk_schedules_course;
ALTER TABLE schedules DISABLE CONSTRAINT fk_schedules_teacher;
ALTER TABLE student_parent_link DISABLE CONSTRAINT fk_spl_parent;
ALTER TABLE student_parent_link DISABLE CONSTRAINT fk_spl_student;
ALTER TABLE user_message_counts DISABLE CONSTRAINT fk_umc_user;
ALTER TABLE user_message_status DISABLE CONSTRAINT fk_ums_user;
ALTER TABLE user_notification_counts DISABLE CONSTRAINT fk_unc_user;
ALTER TABLE users DISABLE CONSTRAINT fk_users_parent;

ALTER TRIGGER alert_log_trigger DISABLE;
ALTER TRIGGER attendance_trigger DISABLE;
ALTER TRIGGER course_sessions_trigger DISABLE;
ALTER TRIGGER courses_trigger DISABLE;
ALTER TRIGGER enrollments_trigger DISABLE;
ALTER TRIGGER events_trigger DISABLE;
ALTER TRIGGER grades_trigger DISABLE;
ALTER TRIGGER messages_trigger DISABLE;
ALTER TRIGGER notifications_trigger DISABLE;
ALTER TRIGGER parents_trigger DISABLE;
ALTER TRIGGER payments_trigger DISABLE;
ALTER TRIGGER schedules_trigger DISABLE;
ALTER TRIGGER semesters_trigger DISABLE;
ALTER TRIGGER sessions_trigger DISABLE;
ALTER TRIGGER student_parent_link_trigger DISABLE;
ALTER TRIGGER users_trigger DISABLE;

--- Inserting Data ---

-- Data for: alert_log
INSERT INTO alert_log (AlertID, ParentID, Message, "Timestamp", Title, Content) VALUES (2, 1, 'Your parent-teacher meeting is scheduled for next week.', TO_TIMESTAMP('2025-08-21 08:22:22', 'YYYY-MM-DD HH24:MI:SS'), 'Your parent-teacher meeting is scheduled for next week.', '');
INSERT INTO alert_log (AlertID, ParentID, Message, "Timestamp", Title, Content) VALUES (3, NULL, 'Test Announcement
This is a test announcement from curl.', TO_TIMESTAMP('2025-08-26 16:13:41', 'YYYY-MM-DD HH24:MI:SS'), 'Test Announcement', 'This is a test announcement from curl.');
INSERT INTO alert_log (AlertID, ParentID, Message, "Timestamp", Title, Content) VALUES (4, NULL, 'Test Announcement
This is a test announcement.', TO_TIMESTAMP('2025-08-31 04:14:22', 'YYYY-MM-DD HH24:MI:SS'), 'Test Announcement', 'This is a test announcement.');
INSERT INTO alert_log (AlertID, ParentID, Message, "Timestamp", Title, Content) VALUES (5, NULL, NULL, TO_TIMESTAMP('2025-09-26 17:52:33', 'YYYY-MM-DD HH24:MI:SS'), 'test', 'test notification');
INSERT INTO alert_log (AlertID, ParentID, Message, "Timestamp", Title, Content) VALUES (8, NULL, NULL, TO_TIMESTAMP('2025-09-26 19:20:14', 'YYYY-MM-DD HH24:MI:SS'), 'we are happy', 'because of holiday');

-- Data for: attendance
INSERT INTO attendance (AttendanceID, EnrollmentID, SessionDate, Status) VALUES (13, 1, TO_DATE('2025-08-30', 'YYYY-MM-DD'), 'Present');
INSERT INTO attendance (AttendanceID, EnrollmentID, SessionDate, Status) VALUES (14, 1, TO_DATE('2025-09-01', 'YYYY-MM-DD'), 'Absent');
INSERT INTO attendance (AttendanceID, EnrollmentID, SessionDate, Status) VALUES (15, 1, TO_DATE('2025-09-03', 'YYYY-MM-DD'), 'Late');

-- Data for: courses
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (1, 'Chemistry', NULL, 50.00, 'CHE 1111-0531', 3, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (2, 'Chemistry Lab', NULL, 50.00, 'CHE 1112-0531', 1, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (3, 'Structured Programming Language', NULL, 50.00, 'CSE 1213-0613', 3, NULL);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (4, 'Structured Programming Language Lab', NULL, 50.00, 'CSE 1214-0613', 1, NULL);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (5, 'Organizational Behaviors', NULL, 50.00, 'HUM 1111-0031', 3, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (6, 'Bangladesh Studies', NULL, 50.00, 'HUM 1113-0222', 3, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (7, 'Mathematics-I', NULL, 50.00, 'MATH 1111-0541', 3, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (8, 'Physics', NULL, 50.00, 'PHY 1111-0533', 3, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (9, 'Physics Lab', NULL, 50.00, 'PHY 1112-0533', 1, 1);
INSERT INTO courses (CourseID, CourseName, CourseDescription, CourseFee, CourseCode, CreditHours, SemesterID) VALUES (10, 'Discrete Mathematics', NULL, 50.00, 'CSE 1203-0611', 3, 2);

-- Data for: enrollments
INSERT INTO enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Status, SessionID) VALUES (1, 'test-student-01', 3, TO_DATE('2025-08-31', 'YYYY-MM-DD'), 'Enrolled', NULL);
INSERT INTO enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Status, SessionID) VALUES (2, '25S010003', 1, TO_DATE('2025-09-01', 'YYYY-MM-DD'), 'Enrolled', NULL);
INSERT INTO enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Status, SessionID) VALUES (3, '33', 1, TO_DATE('2025-09-05', 'YYYY-MM-DD'), 'Enrolled', NULL);
INSERT INTO enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Status, SessionID) VALUES (4, '33', 2, TO_DATE('2025-09-05', 'YYYY-MM-DD'), 'Enrolled', NULL);
INSERT INTO enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, Status, SessionID) VALUES (5, '33', 8, TO_DATE('2025-09-06', 'YYYY-MM-DD'), 'Enrolled', NULL);

-- Data for: events
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (1, 1, 'Midterm Exam', 'Test', TO_DATE('2025-09-01', 'YYYY-MM-DD'));
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (2, 1, 'Project Deadline', 'Deadline', TO_DATE('2025-09-15', 'YYYY-MM-DD'));
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (3, NULL, 'Summer Break', 'Holiday', TO_DATE('2025-08-20', 'YYYY-MM-DD'));
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (4, NULL, 'iupc', 'Contest', NULL);
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (5, 1, 'Midterm Exam', 'Exam', TO_DATE('2025-10-15', 'YYYY-MM-DD'));
INSERT INTO events (EventID, CourseID, EventName, EventType, EventDate) VALUES (6, 2, 'Book Report Due', 'Assignment', TO_DATE('2025-09-30', 'YYYY-MM-DD'));

-- Data for: grades
INSERT INTO grades (GradeID, EnrollmentID, GradePercentage, GradeLetter, GradedByUserID, GradeDate) VALUES (4, 1, 6.00, '', 9, TO_DATE('2025-09-03', 'YYYY-MM-DD'));

-- Data for: parents
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (1, 'Test', 'Parent', '123-456-7890', NULL, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (2, 'John', 'Doe', '123-456-7890', NULL, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (3, 'Jane', 'Smith', '098-765-4321', NULL, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (4, 'Peter', 'Jones', '111-222-3333', NULL, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (5, 'Abc', 'Parents ', '012454547', 10, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (6, 'Jane', 'Smith', '987-654-3210', NULL, NULL);
INSERT INTO parents (ParentID, FirstName, LastName, Phone, UserID, PhotoURL) VALUES (7, 'Test', 'Parent', '9998887777', 1, NULL);

-- Data for: payments
INSERT INTO payments (PaymentID, EnrollmentID, Amount, PaymentDate) VALUES (6, 1, 150.00, TO_DATE('2025-08-31', 'YYYY-MM-DD'));

-- Data for: schedules
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (1, 1, 'Monday', '09:00:00', '10:30:00', 'Room 101', 4);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (2, 1, 'Wednesday', '09:00:00', '10:30:00', 'Room 101', 4);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (3, 2, 'Tuesday', '11:00:00', '12:30:00', 'Room 102', 4);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (4, 2, 'Thursday', '11:00:00', '12:30:00', 'Room 102', 4);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (5, 1, 'TBD', '00:00:00', '00:00:00', 'TBD', 5);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (6, 3, 'Mon/Wed', '14:00:00', '15:00:00', 'Room 103', 9);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (7, 1, 'TBD', '00:00:00', '00:00:00', 'TBD', 9);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (8, 8, 'TBD', '00:00:00', '00:00:00', 'TBD', 9);
INSERT INTO schedules (ScheduleID, CourseID, DayOfWeek, StartTime, EndTime, Room, TeacherUserID) VALUES (9, 6, 'TBD', '00:00:00', '00:00:00', 'TBD', 13);

-- Data for: semesters
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (1, '1st Semester - Freshman', 1);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (2, '2nd Semester - Freshman', 2);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (3, '3rd Semester - Sophomore', 3);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (4, '4th Semester - Sophomore', 4);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (5, '5th Semester - Junior', 5);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (6, '6th Semester - Junior', 6);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (7, '7th Semester - Senior', 7);
INSERT INTO semesters (SemesterID, SemesterName, SemesterLevel) VALUES (8, '8th Semester - Senior', 8);

-- Data for: sessions
INSERT INTO sessions (SessionID, SessionName, "Year", Term) VALUES (1, 'Fall 2023', 2023, 'Fall');
INSERT INTO sessions (SessionID, SessionName, "Year", Term) VALUES (2, 'Summer 2024', 2024, 'Summer');
INSERT INTO sessions (SessionID, SessionName, "Year", Term) VALUES (3, 'Fall 2024', 2024, 'Fall');

-- Data for: student_parent_link
INSERT INTO student_parent_link (LinkID, StudentID, ParentID) VALUES (6, '25S010001', 1);
INSERT INTO student_parent_link (LinkID, StudentID, ParentID) VALUES (7, '25S010003', 5);
INSERT INTO student_parent_link (LinkID, StudentID, ParentID) VALUES (8, 'test-student-01', 5);
INSERT INTO student_parent_link (LinkID, StudentID, ParentID) VALUES (9, '33', 2);

-- Data for: students
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('25S010001', 18, 'Test Student', '1234567890', TO_DATE('2005-01-01', 'YYYY-MM-DD'), 'REG-TEST-12345', 'Active', 'Test Parent', 'parent@example.com', '0987654321', NULL);
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('25S010002', 26, 'Test Student', '1234567890', TO_DATE('2005-01-01', 'YYYY-MM-DD'), 'manual_reg_code', 'Active', 'Test Parent', 'parent@example.com', '0987654321', NULL);
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('25S010003', 14, 'New Student Name Again', '1234567890', TO_DATE('2010-01-01', 'YYYY-MM-DD'), 'REG-ABC-12345', 'Active', 'Test Parent', 'parent@example.com', '0987654321', NULL);
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('33', 33, 'Student 1', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('test-student-01', NULL, 'Test Student', NULL, TO_DATE('2010-01-01', 'YYYY-MM-DD'), NULL, 'Pending', NULL, NULL, NULL, NULL);
INSERT INTO students (StudentID, UserID, StudentName, Phone, DOB, RegistrationCode, Status, ParentNameProvided, ParentEmailProvided, ParentPhoneProvided, PhotoURL) VALUES ('TEST_ID_2', 999, 'Test Student Name', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL);

-- Data for: teachers
INSERT INTO teachers (TeacherID, UserID, TeacherName, SubjectTaught, Email, Phone, DOB, RegistrationCode, Status, PhotoURL) VALUES ('T001', 9, 'Test Teacher', 'Math', 't_teacher@example.com', '1112223333', TO_DATE('1980-01-01', 'YYYY-MM-DD'), 'REG-T001', 'Active', NULL);

-- Data for: user_message_counts
INSERT INTO user_message_counts (user_id, unread_count, total_count) VALUES (1, 0, 1);
INSERT INTO user_message_counts (user_id, unread_count, total_count) VALUES (4, 1, 1);
INSERT INTO user_message_counts (user_id, unread_count, total_count) VALUES (9, 0, 13);
INSERT INTO user_message_counts (user_id, unread_count, total_count) VALUES (10, 0, 6);
INSERT INTO user_message_counts (user_id, unread_count, total_count) VALUES (15, 0, 4);

-- Data for: user_message_status
INSERT INTO user_message_status (UserID, UnreadCount, LastUpdated) VALUES (9, 3, TO_TIMESTAMP('2025-09-26 16:17:42', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO user_message_status (UserID, UnreadCount, LastUpdated) VALUES (10, 5, TO_TIMESTAMP('2025-09-28 16:35:28', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO user_message_status (UserID, UnreadCount, LastUpdated) VALUES (15, 4, TO_TIMESTAMP('2025-09-28 14:50:51', 'YYYY-MM-DD HH24:MI:SS'));

-- Data for: user_notification_counts
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (1, 11, 11);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (3, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (4, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (5, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (7, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (8, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (9, 0, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (10, 0, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (13, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (14, 0, 9);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (15, 0, 9);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (16, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (32, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (33, 8, 8);
INSERT INTO user_notification_counts (user_id, unread_count, total_count) VALUES (34, 8, 8);

-- Data for: users
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (1, 'parent1', '$2a$12$1OMkGfc3296g/I7z8vyKUeb4fS68xooOayTrDDenEPeG12x2IytQK', 'Parent', 1, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (3, 'jane.smith', '$2a$12$QGVcl2Z6TQdfZb.40KWc9OHjZ7zcz3YlZOK27YLG1bSw5RnuSAHSy', 'Parent', 2, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (4, 'peter.jones', '$2a$12$h5bQZca5SX7M4SkdNJnF4ejuWrcwoC4Wb8Xedkt0o5VyD2lEr8KH.', 'Parent', 3, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (5, 'teacher.susan', '$2a$12$SX6jH/X3cKlHkneQkQ7KXe/O3nDzB2dkh8Bp/ajTTCIrZ7UNw7yJm', 'Teacher', NULL, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (7, 'test_parent_user_123', '$2a$12$/NpehSB/2Ry/Oqh3944.6udrvgFPxcP/Cy7zJDICroOaFHvCGuGlG', 'Parent', NULL, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (8, 'admin', '$2a$12$Euqe6jdns0XsDbaPHYwfS.6SRaid20UHaUhi5QkgU4Yb5euOsqIMS', 'admin', NULL, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (9, 't_teacher', '$2a$12$VYTZaDSjbzLXUTMH65zi0uLKCN.ggd95XweSi89e3vABv.YmxxBkG', 'Teacher', NULL, NULL, NULL, 'abc@gmail.com', 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (10, 't_parent', '$2a$12$l6QDGMUubadA4BVdtCEIb.TI238AknWVApt9.Jug86oPfZC14u4by', 'Parent', 5, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (13, 'new_teacher', '$2a$12$9FDFOkRJbMXbdVgDnpswouaJsnpMeXeJ//PwDzpkT3qrvO4BPQ4hy', 'Teacher', NULL, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (14, 'Std1', '$2a$12$mwHPc.DA7MjpIznDtREGk.kLg/BpkP0jfTjZd7g3.pBzJvbWAuUiK', 'Student', 5, NULL, NULL, 'std1@test.com', 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (15, 'AshrafM', '$2a$12$r/Kbjlc2.e0SbPOkw2dflev5CjesCjd377jm4.WSwywcGcd9hntiC', 'Admin', NULL, NULL, 'Shuvo', 'ashraf@test.com', 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (16, 'MGR', '$2a$12$MQi6CRqRPNc7KvJlJ9buy.TBlNNxXKhjL10wJxXkiWYpKwNXZ7X46', 'Student', NULL, 'e07f5ed7-0224-4735-90a8-384348cc0a99', NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (32, 'teacher ', '$2a$12$pZOL8IeYl3oB88w3ospPneUklbzrc6kJ8gTRdBVxzDxVph.0DTKLS', 'Teacher', NULL, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (33, 'testStd', '$2a$12$IdHlYZSK7pJNVLmX8DWHaeQU3ZA5Ew.ZDtF/.XpwMvFm53r9jVNau', 'Student', 2, NULL, NULL, NULL, 1);
INSERT INTO users (UserID, Username, PasswordHash, UserType, ParentID, RegistrationCode, AdminName, Email, IsActive) VALUES (34, 'gemini_admin', '$2a$12$LrPY/a/VnpoBFK6zHcuPye3XhuN/k2dyEE9ATn.//uMtvapOiiEi2', 'Admin', NULL, NULL, NULL, NULL, 1);


--- Enabling Constraints and Triggers ---
ALTER TABLE alert_log ENABLE CONSTRAINT fk_alert_log_parent;
ALTER TABLE attendance ENABLE CONSTRAINT fk_attendance_enrollment;
ALTER TABLE course_sessions ENABLE CONSTRAINT fk_cs_course;
ALTER TABLE course_sessions ENABLE CONSTRAINT fk_cs_session;
ALTER TABLE enrollments ENABLE CONSTRAINT fk_enrollments_course;
ALTER TABLE events ENABLE CONSTRAINT fk_events_course;
ALTER TABLE grades ENABLE CONSTRAINT fk_grades_enrollment;
ALTER TABLE grades ENABLE CONSTRAINT fk_grades_user;
ALTER TABLE messages ENABLE CONSTRAINT fk_messages_sender;
ALTER TABLE messages ENABLE CONSTRAINT fk_messages_receiver;
ALTER TABLE notifications ENABLE CONSTRAINT fk_notifications_user;
ALTER TABLE notifications ENABLE CONSTRAINT fk_notifications_alert;
ALTER TABLE parents ENABLE CONSTRAINT fk_parents_user;
ALTER TABLE payments ENABLE CONSTRAINT fk_payments_enrollment;
ALTER TABLE schedules ENABLE CONSTRAINT fk_schedules_course;
ALTER TABLE schedules ENABLE CONSTRAINT fk_schedules_teacher;
ALTER TABLE student_parent_link ENABLE CONSTRAINT fk_spl_parent;
ALTER TABLE student_parent_link ENABLE CONSTRAINT fk_spl_student;
ALTER TABLE user_message_counts ENABLE CONSTRAINT fk_umc_user;
ALTER TABLE user_message_status ENABLE CONSTRAINT fk_ums_user;
ALTER TABLE user_notification_counts ENABLE CONSTRAINT fk_unc_user;
ALTER TABLE users ENABLE CONSTRAINT fk_users_parent;

ALTER TRIGGER alert_log_trigger ENABLE;
ALTER TRIGGER attendance_trigger ENABLE;
ALTER TRIGGER course_sessions_trigger ENABLE;
ALTER TRIGGER courses_trigger ENABLE;
ALTER TRIGGER enrollments_trigger ENABLE;
ALTER TRIGGER events_trigger ENABLE;
ALTER TRIGGER grades_trigger ENABLE;
ALTER TRIGGER messages_trigger ENABLE;
ALTER TRIGGER notifications_trigger ENABLE;
ALTER TRIGGER parents_trigger ENABLE;
ALTER TRIGGER payments_trigger ENABLE;
ALTER TRIGGER schedules_trigger ENABLE;
ALTER TRIGGER semesters_trigger ENABLE;
ALTER TRIGGER sessions_trigger ENABLE;
ALTER TRIGGER student_parent_link_trigger ENABLE;
ALTER TRIGGER users_trigger ENABLE;
