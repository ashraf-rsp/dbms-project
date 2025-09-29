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
