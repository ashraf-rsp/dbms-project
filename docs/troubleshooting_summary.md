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

---

# Troubleshooting Summary: Hamburger Menu on `view_grades.jsp`

This section details the troubleshooting and resolution of the non-functional hamburger menu specifically on the `view_grades.jsp` page in mobile view.

## The Problem

The hamburger menu on `view_grades.jsp` was not opening the sidebar in mobile view, while it functioned correctly on other pages. Initial investigation showed that the JavaScript responsible for toggling the sidebar classes (`active` and `sidebar-open`) was present and seemingly correct.

A key observation was that clicking the hamburger menu on `view_grades.jsp` resulted in two `console.log` messages for each click, whereas on other pages, only one message appeared. This indicated that the JavaScript file (`js/main.js`) was being executed twice on `view_grades.jsp`, leading to the event listener being attached twice. Consequently, each click would trigger the class toggles twice, effectively adding and then immediately removing the classes, making it appear as if the menu was not working.

## The Solution

The root cause was the double execution of `js/main.js`. While the explicit `<script>` tag for `main.js` was removed from `view_grades.jsp` in an earlier attempt to fix a redundant load, the `includes/footer.jsp` file also contained a `<script>` tag for `main.js`. The double `console.log` suggested that `main.js` was still being loaded twice, likely due to `footer.jsp` being included twice, or some other subtle mechanism.

To provide an immediate and robust solution, a defensive check was added to `js/main.js` to ensure the event listener for the mobile menu toggle is attached only once, regardless of how many times the script is executed.

1.  **Modified `js/main.js`:** A condition was added to the JavaScript code that attaches the event listener. This condition checks for a custom `dataset` attribute (`listenerAttached`) on the `mobileMenuToggle` element. If this attribute is not present, the event listener is attached, and the attribute is then set. This prevents subsequent executions of the script from attaching duplicate listeners.

    ```javascript
    if (mobileMenuToggle && sidebar && mainContainer && !mobileMenuToggle.dataset.listenerAttached) {
        mobileMenuToggle.addEventListener('click', function() {
            console.log('Hamburger menu clicked!');
            sidebar.classList.toggle('active');
            mainContainer.classList.toggle('sidebar-open');
        });
        mobileMenuToggle.dataset.listenerAttached = 'true'; // Set a flag
    }
    ```

2.  **Deployed the changes:** The `deploy.sh` script was executed to synchronize the updated `main.js` file with the Tomcat server.

3.  **Verified the fix:** After deployment and clearing the browser cache, the hamburger menu on `view_grades.jsp` now functions correctly, and the `console.log` message appears only once per click, confirming that the double event listener issue has been mitigated.