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
