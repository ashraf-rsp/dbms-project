<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<% request.setAttribute("additionalCss", "login"); %>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Forgot Password - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <%-- No sidebar for this page --%>
        
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
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>