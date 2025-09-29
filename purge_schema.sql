-- IMPORTANT: This script will delete all objects in the user's schema.
DECLARE
  is_12c_or_higher NUMBER;
BEGIN
  -- Check Oracle version to see if USER_SEQUENCES.GENERATOR column exists
  SELECT COUNT(*) INTO is_12c_or_higher FROM all_tab_columns 
  WHERE owner = 'SYS' AND table_name = 'USER_SEQUENCES' AND column_name = 'GENERATOR';

  -- Drop all tables (and their constraints)
  FOR i IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || i.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;

  -- Drop all user-created sequences
  IF is_12c_or_higher > 0 THEN
    FOR i IN (SELECT sequence_name FROM user_sequences WHERE generator = 'N') LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE "' || i.sequence_name || '"';
    END LOOP;
  ELSE -- Fallback for older versions
    FOR i IN (SELECT sequence_name FROM user_sequences WHERE sequence_name NOT LIKE 'ISEQ_$') LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE "' || i.sequence_name || '"';
    END LOOP;
  END IF;

  -- Drop all views
  FOR i IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW "' || i.view_name || '"';
  END LOOP;

  -- Purge the recycle bin
  EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
END;
/
EXIT;
