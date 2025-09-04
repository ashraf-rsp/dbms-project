<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Change Password - Academic Center</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/components.css">
</head>
<body>
    <div class="main-container">
        <main class="content-area">
            <div class="login-page-wrapper">
                <div class="login-container">
                    <h2>Change Your Password</h2>
                    <p>Please set a new password for your account.</p>
                    <% 
                        String status = (String) session.getAttribute("status");
                        String message = (String) session.getAttribute("message");
                        if (status != null && message != null) {
                            String alertClass = "";
                            if (status.equals("success")) {
                                alertClass = "alert-success";
                            } else if (status.equals("error")) {
                                alertClass = "alert-danger";
                            }
                    %>
                    <div class="alert <%= alertClass %>">
                        <%= message %>
                    </div>
                    <% 
                            session.removeAttribute("status");
                            session.removeAttribute("message");
                        }
                    %>
                    <form action="change_password_process.jsp" method="post">
                        <label for="newPassword">New Password:</label>
                        <input type="password" id="newPassword" name="newPassword" class="input-field" required>
                        <label for="confirmPassword">Confirm New Password:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="input-field" required>
                        <button type="submit" class="button">Set New Password</button>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>