<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Forgot Password - Academic Center</title>
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/components.css">
</head>
<body>
    <div class="main-container">
        <main class="content-area">
            <div class="login-page-wrapper">
                <div class="login-container">
                    <h2>Forgot Password</h2>
                    <p>Enter your username to reset your password.</p>
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
                    <form action="forgot_password_process.jsp" method="post">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="input-field" required>
                        <button type="submit" class="button">Reset Password</button>
                    </form>
                    <p><a href="login.jsp">Back to Login</a></p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>