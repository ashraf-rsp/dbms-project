# Troubleshooting Summary: `student-profile.jsp`

This document summarizes the troubleshooting steps taken to resolve the issues with accessing the `student-profile.jsp` page.

## The Problems

The issue was multi-layered, involving an incorrect URL, errors in the JSP code, and a deployment problem.

1.  **Initial `404 Not Found` Error:** The first attempts to access `student-profile.jsp` failed because the URL was incorrect. The web application was deployed under the context path `/academic-center`, which was missing from the initial `curl` command.

2.  **Subsequent `500 Internal Server` Error:** After correcting the URL, a new error appeared. This was caused by two issues in the JSP files:
    *   A typo in the `contentType` directive in `student-profile.jsp` (`text://html` instead of `text/html`).
    *   A duplicate `contentType` directive in `includes/meta.jsp`, which is not allowed when a JSP is included in another.

3.  **Changes Not Being Deployed:** After fixing the code, the error persisted because the changes were not being reflected on the server. A `deploy.sh` script was responsible for copying the application files to the Tomcat server, but it had not been run after the code changes.

## The Solution

The solution involved a step-by-step process of diagnosis and resolution:

1.  **Corrected the URL:** The correct context path was identified by inspecting the Tomcat `webapps` directory, and the URL was updated to `http://localhost:8081/academic-center/student-profile.jsp`.

2.  **Fixed the JSP files:** The duplicate `contentType` directive was removed from `includes/meta.jsp`, and the typo in `student-profile.jsp` was corrected.

3.  **Deployed the changes:** The `deploy.sh` script was executed to synchronize the updated files with the Tomcat server.

4.  **Restarted Tomcat:** The Tomcat server was restarted to ensure that the changes were loaded and the JSPs were recompiled.

5.  **Verified the fix:** A final `curl` command was used to verify that the `student-profile.jsp` page was accessible and returned a 200 OK status, confirming the resolution of the issue.
