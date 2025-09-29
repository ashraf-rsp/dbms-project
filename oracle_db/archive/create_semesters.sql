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
