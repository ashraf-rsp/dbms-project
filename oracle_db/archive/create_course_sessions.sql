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
