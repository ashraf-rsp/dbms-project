# Complete Setup Guide for a New Machine

This guide provides end-to-end instructions for setting up and running the entire project on a new machine, from cloning the repository to running the web application.

## Prerequisites

Before you begin, ensure you have the following software installed:

1.  **Git:** For cloning the project repository.
2.  **Java JDK:** The project is configured for JDK 23.
3.  **Apache Tomcat:** The server for the web application.
4.  **Oracle Database:** Oracle Database Express Edition (XE) is recommended. SQL*Plus should be available from your command line.

---

## Step 1: Clone the Repository

Open your terminal or command prompt and clone the project to your local machine.

```sh
git clone https://github.com/ashraf-rsp/dbms-project.git
cd dbms-project
```

## Step 2: Download Oracle JDBC Driver

The application requires the Oracle JDBC driver to communicate with the database.

1.  Download the driver (e.g., `ojdbc11.jar`). A direct link to a compatible version is:
    [https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.9.0.25.07/ojdbc11-23.9.0.25.07.jar](https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.9.0.25.07/ojdbc11-23.9.0.25.07.jar)
2.  Place the downloaded `.jar` file into your Tomcat installation's `lib` directory (e.g., `D:\Java\tomcat\lib`).

## Step 3: Set Up the Oracle Database

These commands will create the user, build the schema, and populate the database. Run them from the project's root directory.

1.  **Create the Database User** (requires privileged access):
    ```sh
    sqlplus / as sysdba @create_user.sql
    ```

2.  **Create Tables and Sequences**:
    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/combined_schema.sql
    ```

3.  **Add Foreign Key Constraints**:
    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/add_foreign_keys.sql
    ```

4.  **Insert All Data**:
    ```sh
    sqlplus c##dbms/ashraf@//localhost:1521/XE @oracle_db/insert_data.sql
    ```

## Step 4: Configure and Run the Application

The provided scripts automate the deployment process.

1.  **Configure the Tomcat Path:**
    *   Open the file `scripts/redeploy.bat` in a text editor.
    *   Find and edit the line `set CATALINA_HOME=D:\Java\tomcat` to match your Tomcat installation path.

2.  **Run the Deployment Script:**
    *   In your command prompt, run the script:
    ```sh
    scripts\redeploy.bat
    ```

## Step 5: Access the Application

Once the script finishes, the application will be running. You can access it in your web browser at:

[http://localhost:8080/dbms-project](http://localhost:8080/dbms-project)

(This assumes your Tomcat is running on the default port `8080`).