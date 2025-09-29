# Troubleshooting: ORA-01400 Error During Migration Capture

This document explains how to solve the `ORA-01400: cannot insert NULL into ... MD_PROJECTS` error that can occur during the "Capture" phase of a database migration in Oracle SQL Developer.

---

### What the Error Means

The error `ORA-01400: cannot insert NULL into ("..."MD_PROJECTS" , "ID")` is an internal error within the SQL Developer migration tool itself.

*   `MD_PROJECTS` is a metadata table that belongs to the Migration Repository you created.
*   The tool is trying to start the "Capture" process by creating a new project entry for itself in that table.
*   It's failing because it's trying to insert `NULL` for the project `ID`, which is a required field.

This typically happens when the Migration Repository is in a corrupt or inconsistent state, even if you just created it.

### The Solution: A "Full Reset"

The most reliable way to fix this is to perform a "full reset" of your Oracle user schema. This will completely wipe any old or broken repository objects, allowing you to start the wizard again on a perfectly clean slate.

Here are the steps:

**Step 1: Drop the Repository in the GUI**

*   First, try the standard cleanup method.
*   In SQL Developer, right-click your **Oracle connection** (e.g., `Oracle_Target_DB`).
*   Go to `Migration Repository` and click **`Drop Migration Repository`**.

**Step 2: Run the "Purge Schema" Script**

*   After dropping the repository, you must ensure everything is gone.
*   Open a new **SQL Worksheet** for your `Oracle_Target_DB` connection. **Ensure it is connected as the `c##dbms_project` user.**
*   Copy and paste the following script into the worksheet:

```sql
-- IMPORTANT: Run this script while connected as the C##DBMS_PROJECT user!
BEGIN
  -- Drop all tables (and their constraints)
  FOR i IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || i.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;

  -- Drop all sequences
  FOR i IN (SELECT sequence_name FROM user_sequences) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE "' || i.sequence_name || '"';
  END LOOP;

  -- Drop all views
  FOR i IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW "' || i.view_name || '"';
  END LOOP;

  -- Purge the recycle bin
  EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
END;
/
```

*   Run the script by clicking the green "play" icon in the worksheet toolbar. This will delete every object inside the `c##dbms_project` schema.

**Step 3: Restart the Migration Wizard**

*   Now that the schema is completely empty, go back to the "Connections" panel.
*   Right-click your `MySQL_Source_DB` connection and select **`Migrate To Oracle...`** again.
*   Proceed through the wizard exactly as you did before. It will create a fresh, clean repository, and the "Capture" step should now succeed without the `ORA-01400` error.
