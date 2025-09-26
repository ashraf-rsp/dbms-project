# Project Recap

## Project Overview
- **Name:** "Parent-First" Academic Center Management System
- **Purpose:** Final project for a MariaDB learning course.
- **Key Requirement:** Design for easy portability to Oracle DB.
- **Completed Phases:**
    - Schema Design (DDL)
    - Data Population & Querying (DML)
    - Advanced Features (Stored Procedures, Functions, Triggers)
    - Conceptual Python Application Integration Example

## Technical Environment
- **Platform:** Termux on Android
- **Database Administration:** Adminer served via Apache on port 8081 (using PHP-FPM).
- **Deployment Target:** Apache Tomcat

## Key Troubleshooting History
- **`chmod` on Shared Storage:** We confirmed that `chmod` does not work on `/storage/emulated/0` due to Android's filesystem restrictions. The workaround is to place executable scripts in the Termux home directory (`~/`).
- **Shell Script Execution:** We addressed issues with running shell scripts, ensuring they were executable and had the correct shebang line (`#!/usr/bin/env bash`).
- **Gemini Tool Capability:** We clarified that my initial uncertainty about the `run_shell_command` tool was unfounded, and we confirmed it works reliably in your environment.

## Regular Development Workflow

The typical development process follows a simple 3-step cycle: **Edit -> Deploy -> Test**.

### Step 1: Edit Your Code

You will work exclusively within your project directory:
`/storage/emulated/0/LearnTmx/IUS/DBMS/academic-center/webapp/`

-   Modify your `.jsp` files to change the HTML structure or add Java logic.
-   Modify your `css/style.css` file to change the visual appearance.

### Step 2: Deploy Your Changes

Whenever you want to see your changes live, open your Termux terminal and run your deployment script:

```bash
~/deploy.sh
```

This single command will instantly copy all your modifications to the Tomcat server.

### Step 3: Test Your Application

Open your web browser and go to your application's URL:

**`http://localhost:8080/academic-center/`**

-   Refresh the page to see your latest changes.
-   If your changes involved the database, you can verify the data by opening Adminer in another tab: **`http://localhost:8081`**.

---

## Server Management

### Tomcat Start/Stop Commands

Use these commands from your Termux terminal to control the Tomcat server.

-   **Start Server:**
    ```bash
    ~/apache-tomcat-10.1.44/bin/startup.sh
    ```

-   **Stop Server:**
    ```bash
    ~/apache-tomcat-10.1.44/bin/shutdown.sh
    ```

### When to Restart Tomcat

You **do not** need to restart Tomcat for every change.

-   **NO RESTART NEEDED** for:
    -   Changes to `.jsp` files.
    -   Changes to `.css`, `.html`, or other static files.
    -   *Workflow: Edit -> `~/deploy.sh` -> Refresh Browser.*

-   **RESTART IS REQUIRED** for:
    -   Changing `web.xml`.
    -   Adding, removing, or updating `.jar` files in `WEB-INF/lib`.
    -   Changing compiled Java code (e.g., Servlets in `WEB-INF/classes`).
    -   *Workflow: Edit -> `~/deploy.sh` -> Stop Server -> Start Server -> Test.*

### How to Change Tomcat's Port

If you ever need to change the port Tomcat runs on, you need to edit its main configuration file.

1.  **The File:** The setting is in `server.xml`, located at:
    `~/apache-tomcat-10.1.44/conf/server.xml`

2.  **The Line:** Inside the file, find the `<Connector>` element and change the `port` attribute. For example, to change from `8080` to `8082`:

    *Find this:*
    ```xml
    <Connector port="8080" protocol="HTTP/1.1" ... />
    ```
    *Change it to this:*
    ```xml
    <Connector port="8082" protocol="HTTP/1.1" ... />
    ```

3.  **Restart Required:** A change to `server.xml` is a core configuration update. You **must** stop and start Tomcat for the change to take effect.
