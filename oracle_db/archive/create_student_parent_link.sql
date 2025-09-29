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
