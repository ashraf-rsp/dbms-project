DECLARE
  v_sid NUMBER;
  v_serial NUMBER;
BEGIN
  -- Find the session to kill
  SELECT sid, serial# INTO v_sid, v_serial
  FROM v$session
  WHERE username = 'C##DBMS_PROJECT_NEW' AND ROWNUM = 1;

  -- Kill the session
  EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION \'' || v_sid || ',' || v_serial || '\' IMMEDIATE';

  -- Wait a moment for the session to terminate
  DBMS_LOCK.SLEEP(5);

  -- Drop the user
  EXECUTE IMMEDIATE 'DROP USER c##dbms_project_new CASCADE';

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- If no session was found, just drop the user
    EXECUTE IMMEDIATE 'DROP USER c##dbms_project CASCADE';
END;
/
EXIT;
