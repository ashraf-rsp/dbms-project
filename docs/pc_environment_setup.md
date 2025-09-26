# PC Environment Setup Guide

This document outlines the steps taken to transition the project from a Termux-based environment to a local Windows PC environment.

## 1. Version Control: Branching

- Created a new Git branch named `pc-env` to isolate the environment-specific changes.

## 2. Database Configuration

1.  **User and Schema Creation:**
    -   A new MySQL user, `dbms_user`, was created with the password `ashraf`.
    -   A new database schema named `dbms_project` was created.

2.  **Data Import and Collation Fix:**
    -   The initial attempt to import the database schema from `schema.sql` failed due to an `Unknown collation: 'utf8mb4_uca1400_ai_ci'` error. This is common when moving between different database server versions.
    -   The issue was resolved by replacing all instances of `utf8mb4_uca1400_ai_ci` with the more widely compatible `utf8mb4_general_ci`.
    -   It was discovered that `schema.sql` only contained the database structure. The file `academic_center_db_full_backup.sql` was identified as containing both the schema and the data.
    -   The same collation fix was applied to `academic_center_db_full_backup.sql`.
    -   The `dbms_project` database was dropped and recreated to ensure a clean slate, and the full backup was successfully imported.

## 3. Web Server Deployment (Tomcat)

1.  **Tomcat Setup:**
    -   We decided to use the existing Tomcat 10 installation located at `D:\Java\tomcat` to match the version used in the original environment.

2.  **Automated Redeployment Script:**
    -   Inspired by the existing `redeploy.sh` script, a new Windows batch script, `redeploy.bat`, was created to automate the deployment process.
    -   The script performs the following actions:
        1.  Stops the Tomcat server.
        2.  Clears the old application's work directory.
        3.  Copies the `webapp` directory to the Tomcat `webapps/dbms-project` directory using `robocopy`.
        4.  Starts the Tomcat server.

3.  **Environment Variable Fix:**
    -   The initial run of `redeploy.bat` failed because the `CATALINA_HOME` environment variable was not set.
    -   The script was updated to set this variable internally (`set CATALINA_HOME=D:\Java\tomcat`), allowing the Tomcat startup and shutdown scripts to function correctly.

After these steps, the application was successfully deployed and is now running on the local Tomcat server.
