# Oracle Database Setup Guide

This guide provides step-by-step instructions for setting up the Oracle database for this project on a new machine using the provided SQL scripts.

## Prerequisites

1.  **Oracle Database:** Oracle Database (e.g., 21c Express Edition) installed and running.
2.  **SQL*Plus:** The Oracle SQL*Plus command-line tool must be available in your system's PATH.
3.  **Project Files:** You must have the project code, including the `create_user.sql` file and the `oracle_db` directory.

---

## Setup Steps

Follow these steps in order to correctly initialize and populate the database.

### Step 1: Create the Database User

This step creates the `c##dbms` user and grants it the necessary permissions. You will need to connect as a privileged user (e.g., `SYS`) to perform this action.

1.  Open a terminal or command prompt.
2.  Navigate to the root directory of this project.
3.  Run the following command:

    ```sh
    sqlplus / as sysdba @create_user.sql
    ```

### Step 2: Create Tables, Sequences, and Triggers

This step runs the main schema script to create all the necessary database objects.

1.  Run the following command from the project root, using the password `ashraf` for the `c##dbms` user:

    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/combined_schema.sql
    ```

### Step 3: Add Foreign Key Constraints

This script links all the tables together by creating the foreign key relationships.

1.  Run the following command:

    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/add_foreign_keys.sql
    ```

### Step 4: Populate the Database with Data

This final script inserts all the initial data into the tables. It includes logic to temporarily disable constraints and triggers to ensure the data loads correctly.

1.  Run the following command:

    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/insert_data.sql
    ```

---

After completing these steps, the Oracle database will be fully configured and populated for the application.
