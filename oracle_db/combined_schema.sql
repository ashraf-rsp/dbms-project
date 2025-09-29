CREATE TABLE alert_log (
    AlertID NUMBER(11) NOT NULL,
    ParentID NUMBER(11) DEFAULT NULL,
    Message CLOB DEFAULT NULL,
    "Timestamp" TIMESTAMP DEFAULT NULL,
    Title VARCHAR2(255) NOT NULL,
    Content CLOB DEFAULT NULL,
    PRIMARY KEY (AlertID)
);

CREATE SEQUENCE alert_log_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER alert_log_trigger
BEFORE INSERT ON alert_log
FOR EACH ROW
BEGIN
    SELECT alert_log_seq.NEXTVAL
    INTO :new.AlertID
    FROM dual;
END;
/

CREATE TABLE attendance (
    AttendanceID NUMBER(11) NOT NULL,
    EnrollmentID NUMBER(11) DEFAULT NULL,
    SessionDate DATE DEFAULT NULL,
    Status VARCHAR2(20) DEFAULT NULL,
    PRIMARY KEY (AttendanceID)
);

CREATE SEQUENCE attendance_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER attendance_trigger
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    SELECT attendance_seq.NEXTVAL
    INTO :new.AttendanceID
    FROM dual;
END;
/

CREATE TABLE course_sessions (
    CourseSessionID NUMBER(11) NOT NULL,
    CourseID NUMBER(11) DEFAULT NULL,
    SessionID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (CourseSessionID)
);

CREATE SEQUENCE course_sessions_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER course_sessions_trigger
BEFORE INSERT ON course_sessions
FOR EACH ROW
BEGIN
    SELECT course_sessions_seq.NEXTVAL
    INTO :new.CourseSessionID
    FROM dual;
END;
/

CREATE TABLE courses (
    CourseID NUMBER(11) NOT NULL,
    CourseName VARCHAR2(100) DEFAULT NULL,
    CourseDescription CLOB DEFAULT NULL,
    CourseFee NUMBER(10,2) DEFAULT NULL,
    CourseCode VARCHAR2(50) DEFAULT NULL,
    CreditHours NUMBER(11) DEFAULT NULL,
    SemesterID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (CourseID)
);

CREATE SEQUENCE courses_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER courses_trigger
BEFORE INSERT ON courses
FOR EACH ROW
BEGIN
    SELECT courses_seq.NEXTVAL
    INTO :new.CourseID
    FROM dual;
END;
/

CREATE TABLE enrollments (
    EnrollmentID NUMBER(11) NOT NULL,
    StudentID VARCHAR2(255) DEFAULT NULL,
    CourseID NUMBER(11) DEFAULT NULL,
    EnrollmentDate DATE DEFAULT NULL,
    Status VARCHAR2(50) DEFAULT 'Enrolled',
    SessionID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (EnrollmentID)
);

CREATE SEQUENCE enrollments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER enrollments_trigger
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    SELECT enrollments_seq.NEXTVAL
    INTO :new.EnrollmentID
    FROM dual;
END;
/

CREATE TABLE events (
    EventID NUMBER(11) NOT NULL,
    CourseID NUMBER(11) DEFAULT NULL,
    EventName VARCHAR2(100) DEFAULT NULL,
    EventType VARCHAR2(50) DEFAULT NULL,
    EventDate DATE DEFAULT NULL,
    PRIMARY KEY (EventID)
);

CREATE SEQUENCE events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER events_trigger
BEFORE INSERT ON events
FOR EACH ROW
BEGIN
    SELECT events_seq.NEXTVAL
    INTO :new.EventID
    FROM dual;
END;
/

CREATE TABLE grades (
    GradeID NUMBER(11) NOT NULL,
    EnrollmentID NUMBER(11) DEFAULT NULL,
    GradePercentage NUMBER(5,2) DEFAULT NULL,
    GradeLetter VARCHAR2(5) DEFAULT NULL,
    GradedByUserID NUMBER(11) DEFAULT NULL,
    GradeDate DATE DEFAULT NULL,
    PRIMARY KEY (GradeID)
);

CREATE SEQUENCE grades_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER grades_trigger
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    SELECT grades_seq.NEXTVAL
    INTO :new.GradeID
    FROM dual;
END;
/

CREATE TABLE messages (
    MessageID NUMBER(11) NOT NULL,
    SenderUserID NUMBER(11) DEFAULT NULL,
    ReceiverUserID NUMBER(11) DEFAULT NULL,
    Subject VARCHAR2(255) DEFAULT NULL,
    Content CLOB DEFAULT NULL,
    "Timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsRead NUMBER(1) DEFAULT 0,
    DeletedBySender NUMBER(1) DEFAULT 0 NOT NULL,
    DeletedByReceiver NUMBER(1) DEFAULT 0 NOT NULL,
    PRIMARY KEY (MessageID)
);

CREATE SEQUENCE messages_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER messages_trigger
BEFORE INSERT ON messages
FOR EACH ROW
BEGIN
    SELECT messages_seq.NEXTVAL
    INTO :new.MessageID
    FROM dual;
END;
/

CREATE TABLE notifications (
    NotificationID NUMBER(11) NOT NULL,
    UserID NUMBER(11) DEFAULT NULL,
    UserRole VARCHAR2(50) DEFAULT NULL,
    Message CLOB DEFAULT NULL,
    "Timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsRead NUMBER(1) DEFAULT 0,
    Link VARCHAR2(255) DEFAULT NULL,
    "Type" VARCHAR2(50) DEFAULT NULL,
    AlertID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (NotificationID)
);

CREATE SEQUENCE notifications_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER notifications_trigger
BEFORE INSERT ON notifications
FOR EACH ROW
BEGIN
    SELECT notifications_seq.NEXTVAL
    INTO :new.NotificationID
    FROM dual;
END;
/

CREATE TABLE parents (
    ParentID NUMBER(11) NOT NULL,
    FirstName VARCHAR2(50) DEFAULT NULL,
    LastName VARCHAR2(50) DEFAULT NULL,
    Phone VARCHAR2(20) DEFAULT NULL,
    UserID NUMBER(11) DEFAULT NULL,
    PhotoURL VARCHAR2(255) DEFAULT NULL,
    PRIMARY KEY (ParentID),
    UNIQUE (UserID)
);

CREATE SEQUENCE parents_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER parents_trigger
BEFORE INSERT ON parents
FOR EACH ROW
BEGIN
    SELECT parents_seq.NEXTVAL
    INTO :new.ParentID
    FROM dual;
END;
/

CREATE TABLE payments (
    PaymentID NUMBER(11) NOT NULL,
    EnrollmentID NUMBER(11) DEFAULT NULL,
    Amount NUMBER(10,2) DEFAULT NULL,
    PaymentDate DATE DEFAULT NULL,
    PRIMARY KEY (PaymentID)
);

CREATE SEQUENCE payments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER payments_trigger
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    SELECT payments_seq.NEXTVAL
    INTO :new.PaymentID
    FROM dual;
END;
/

CREATE TABLE schedules (
    ScheduleID NUMBER(11) NOT NULL,
    CourseID NUMBER(11) DEFAULT NULL,
    DayOfWeek VARCHAR2(10) DEFAULT NULL,
    StartTime VARCHAR2(8) DEFAULT NULL,
    EndTime VARCHAR2(8) DEFAULT NULL,
    Room VARCHAR2(50) DEFAULT NULL,
    TeacherUserID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (ScheduleID)
);

CREATE SEQUENCE schedules_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER schedules_trigger
BEFORE INSERT ON schedules
FOR EACH ROW
BEGIN
    SELECT schedules_seq.NEXTVAL
    INTO :new.ScheduleID
    FROM dual;
END;
/

CREATE TABLE semesters (
    SemesterID NUMBER(11) NOT NULL,
    SemesterName VARCHAR2(50) NOT NULL,
    SemesterLevel NUMBER(11) NOT NULL,
    PRIMARY KEY (SemesterID)
);

CREATE SEQUENCE semesters_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER semesters_trigger
BEFORE INSERT ON semesters
FOR EACH ROW
BEGIN
    SELECT semesters_seq.NEXTVAL
    INTO :new.SemesterID
    FROM dual;
END;
/

CREATE TABLE sessions (
    SessionID NUMBER(11) NOT NULL,
    SessionName VARCHAR2(50) NOT NULL,
    "Year" NUMBER(11) NOT NULL,
    Term VARCHAR2(20) NOT NULL,
    PRIMARY KEY (SessionID)
);

CREATE SEQUENCE sessions_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER sessions_trigger
BEFORE INSERT ON sessions
FOR EACH ROW
BEGIN
    SELECT sessions_seq.NEXTVAL
    INTO :new.SessionID
    FROM dual;
END;
/

CREATE TABLE student_parent_link (
    LinkID NUMBER(11) NOT NULL,
    StudentID VARCHAR2(255) DEFAULT NULL,
    ParentID NUMBER(11) DEFAULT NULL,
    PRIMARY KEY (LinkID)
);

CREATE SEQUENCE student_parent_link_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER student_parent_link_trigger
BEFORE INSERT ON student_parent_link
FOR EACH ROW
BEGIN
    SELECT student_parent_link_seq.NEXTVAL
    INTO :new.LinkID
    FROM dual;
END;
/

CREATE TABLE students (
    StudentID VARCHAR2(255) NOT NULL,
    UserID NUMBER(11) DEFAULT NULL,
    StudentName VARCHAR2(255) NOT NULL,
    Phone VARCHAR2(20) DEFAULT NULL,
    DOB DATE DEFAULT NULL,
    RegistrationCode VARCHAR2(255) DEFAULT NULL,
    Status VARCHAR2(50) DEFAULT 'Pending',
    ParentNameProvided VARCHAR2(255) DEFAULT NULL,
    ParentEmailProvided VARCHAR2(255) DEFAULT NULL,
    ParentPhoneProvided VARCHAR2(255) DEFAULT NULL,
    PhotoURL VARCHAR2(255) DEFAULT NULL,
    PRIMARY KEY (StudentID),
    UNIQUE (UserID),
    UNIQUE (RegistrationCode)
);

CREATE TABLE teachers (
    TeacherID VARCHAR2(255) NOT NULL,
    UserID NUMBER(11) DEFAULT NULL,
    TeacherName VARCHAR2(255) NOT NULL,
    SubjectTaught VARCHAR2(255) DEFAULT NULL,
    Email VARCHAR2(255) DEFAULT NULL,
    Phone VARCHAR2(20) DEFAULT NULL,
    DOB DATE DEFAULT NULL,
    RegistrationCode VARCHAR2(255) DEFAULT NULL,
    Status VARCHAR2(50) DEFAULT 'Pending',
    PhotoURL VARCHAR2(255) DEFAULT NULL,
    PRIMARY KEY (TeacherID),
    UNIQUE (UserID),
    UNIQUE (RegistrationCode)
);

CREATE TABLE user_message_counts (
    user_id NUMBER(11) NOT NULL,
    unread_count NUMBER(11) DEFAULT 0,
    total_count NUMBER(11) DEFAULT 0,
    PRIMARY KEY (user_id)
);

CREATE TABLE user_message_status (
    UserID NUMBER(11) NOT NULL,
    UnreadCount NUMBER(11) DEFAULT 0,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (UserID)
);

CREATE TABLE user_notification_counts (
    user_id NUMBER(11) NOT NULL,
    unread_count NUMBER(11) DEFAULT 0,
    total_count NUMBER(11) DEFAULT 0,
    PRIMARY KEY (user_id)
);

CREATE TABLE users (
    UserID NUMBER(11) NOT NULL,
    Username VARCHAR2(50) DEFAULT NULL,
    PasswordHash VARCHAR2(255) DEFAULT NULL,
    UserType VARCHAR2(20) DEFAULT NULL,
    ParentID NUMBER(11) DEFAULT NULL,
    RegistrationCode VARCHAR2(255) DEFAULT NULL,
    AdminName VARCHAR2(255) DEFAULT NULL,
    Email VARCHAR2(255) DEFAULT NULL,
    IsActive NUMBER(1) DEFAULT 1,
    PRIMARY KEY (UserID),
    UNIQUE (Username),
    UNIQUE (RegistrationCode),
    UNIQUE (Email)
);

CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER users_trigger
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    SELECT users_seq.NEXTVAL
    INTO :new.UserID
    FROM dual;
END;
/
