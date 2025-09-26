## Troubleshooting Log - 2025-09-04

### 1. Initial Problem

*   Multiple users (`Admin`, `Teacher`, `Student`) were unable to log in using the credentials documented in `session_overview.md`.
*   Only the `Parent` user (`t_parent`) was able to log in successfully.

### 2. Investigation

*   Initial `curl` tests confirmed the login failures for Admin (`Ashraf`), Teacher (`t_teacher`), and Student (`abc`).
*   Direct database inspection of the `Users` table revealed several issues:
    *   The admin username was `AshrafM`, not `Ashraf`.
    *   The `PasswordHash` for `t_teacher` was not a valid bcrypt hash.
    *   The user `abc` did not exist. Another student user, `Std1`, also had an invalid `PasswordHash`.

### 3. Root Cause Analysis

*   **User Feedback:** The user indicated that the passwords for the failing accounts had been changed via the user profile update page, which pointed to a flaw in the update logic.
*   **Flaw 1: Incorrect Hashing Implementation:**
    *   Code review of `profile_process.jsp`, `forgot_password_process.jsp`, and `change_password_process.jsp` revealed they were all using a non-existent method (`PasswordUtil.hash()` or `PasswordUtil.hashPassword()`) instead of the correct `BCrypt.withDefaults().hashToString()`.
    *   This resulted in invalid password hashes being stored in the database whenever a user updated their password or used the "Forgot Password" feature.
*   **Flaw 2: Overly Restrictive Authentication Filter:**
    *   The `AuthFilter` was mapped to `*.jsp` and was incorrectly blocking access to unauthenticated pages like `forgot_password_process.jsp`.
    *   This prevented the "Forgot Password" flow from working, as the filter would redirect users to the login page before the password reset logic could execute.

### 4. Resolution Steps

1.  **Fixed Hashing Logic:**
    *   Replaced the incorrect `PasswordUtil` import and hashing calls with the correct `at.favre.lib.crypto.bcrypt.BCrypt` implementation in:
        *   `webapp/profile_process.jsp`
        *   `webapp/forgot_password_process.jsp`
        *   `webapp/change_password_process.jsp`
2.  **Corrected AuthFilter:**
    *   Modified `webapp/WEB-INF/classes/com/academic/filters/AuthFilter.java` to include a list of all publicly accessible pages (login, register, forgot password, etc.) that should be excluded from the authentication check.
3.  **Recompiled and Redeployed:**
    *   Recompiled `AuthFilter.java` using `javac`.
    *   Redeployed the entire web application using the `~/redeploy.sh` script to apply all changes.
4.  **Reset Passwords:**
    *   Successfully used the now-functional "Forgot Password" flow for both `t_teacher` and `Std1`.
    *   Captured the system-generated temporary passwords.
    *   Logged in with the temporary passwords and reset the permanent passwords to known values (`tpsw` for `t_teacher` and `abc` for `Std1`).
5.  **Verification:**
    *   Confirmed that the Admin (`AshrafM`), Teacher (`t_teacher`), Parent (`t_parent`), and Student (`Std1`) users can all successfully log in.
