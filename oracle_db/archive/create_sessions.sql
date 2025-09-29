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
