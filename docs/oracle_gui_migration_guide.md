# Guide: Migrating from MySQL to Oracle with SQL Developer

This document provides a step-by-step guide for migrating the project's database from MySQL to Oracle 21c XE using the Oracle SQL Developer graphical tool.

---

### **Phase 1: Prerequisites**

1.  **Install Oracle SQL Developer:** If you don't have it, download and install it from the official Oracle website. It's a free tool.
2.  **Download the MySQL JDBC Driver:**
    *   SQL Developer needs a driver to connect to your MySQL database.
    *   Download the "MySQL Connector/J" driver from the MySQL website. It will be a `.jar` file (e.g., `mysql-connector-java-8.0.x.jar`).

### **Phase 2: Configuration**

1.  **Add the MySQL Driver to SQL Developer:**
    *   Open SQL Developer.
    *   Go to the menu: `Tools` -> `Preferences`.
    *   In the preferences window, navigate to `Database` -> `Third Party JDBC Drivers`.
    *   Click `Add Entry...`, find the MySQL `.jar` file you downloaded, and select it.
    *   Click `OK` and restart SQL Developer.

2.  **Create the Database Connections:**
    *   In the "Connections" panel (usually on the left), click the green `+` icon to create a new connection.
    *   **Create the MySQL Connection:**
        *   **Name:** `MySQL_Source_DB`
        *   **Username:** `dbms_user`
        *   **Password:** `ashraf`
        *   **Hostname:** `localhost`
        *   **Port:** `3306`
        *   **Database:** `dbms_project`
        *   Click `Test`. If it succeeds, click `Save`.
    *   **Create the Oracle Connection:**
        *   **Name:** `Oracle_Target_DB`
        *   **Username:** `c##dbms_project`
        *   **Password:** `ashraf`
        *   **Connection Type:** `Basic`
        *   **Hostname:** `localhost`
        *   **Port:** `1521`
        *   **Service name:** `XEPDB1` (This is the default for Oracle 21c XE. If it fails, try SID: `XE`).
        *   Click `Test`. If it succeeds, click `Save`.

### **Phase 3: The Migration Wizard**

1.  **Associate a Migration Repository:**
    *   This is a one-time setup where SQL Developer stores its migration metadata.
    *   Right-click on your **Oracle connection** (`Oracle_Target_DB`) and select `Migration Repository` -> `Associate Migration Repository`.
    *   A progress bar will appear as it creates the repository tables in your `c##dbms_project` schema.

2.  **Capture the MySQL Source Database:**
    *   Right-click on your **MySQL connection** (`MySQL_Source_DB`) and select `Capture Schema`.
    *   Follow the wizard prompts. This will analyze your MySQL database and create a "captured model" of it.

3.  **Convert the Captured Model:**
    *   In the "Captured Models" panel (you may need to open it from the `View` menu), find your newly captured database.
    *   Right-click on it and select `Convert to Oracle Model`.
    *   The most important screen here is the **Data Type Mapping**. Review the proposed conversions (e.g., `VARCHAR` to `VARCHAR2`, `INT` to `NUMBER`). The defaults are usually good, but you can change them if needed.
    *   Proceed through the wizard to complete the conversion. This creates a "converted model" but does **not** yet create the objects in the database.

4.  **Generate and Run the Oracle DDL:**
    *   Find your "Converted Model" in the navigation panel.
    *   Right-click it and select `Generate`.
    *   This will open a new SQL worksheet with all the `CREATE TABLE`, `CREATE TRIGGER`, etc., statements for Oracle.
    *   Review the script.
    *   Ensure your worksheet is connected to the **Oracle connection** (`Oracle_Target_DB`).
    *   Click the `Run Script` button (looks like a green "play" icon on a document). This will create all the tables, triggers, and other objects in your Oracle database.

### **Phase 4: Data Migration**

1.  **Move the Data:**
    *   Go to the menu: `Tools` -> `Migration` -> `Migrate Data`.
    *   Select your **MySQL connection** as the source and your **Oracle connection** as the target.
    *   Follow the wizard prompts. It will show you a mapping of the source and target tables.
    *   Click `Finish` to begin the data transfer. SQL Developer will move the data row by row from MySQL to Oracle.
