<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<% request.setAttribute("additionalCss", "login"); %>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Login - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <%-- No sidebar for login page --%>
        
        <main class="content-area">
            <div class="login-page-wrapper">
                <div class="login-container">
                    <%
                        String loginError = (String) session.getAttribute("loginError");
                        if (loginError != null) {
                            out.println("<p style='color:red;'>" + loginError + "</p>");
                            session.removeAttribute("loginError"); // Clear the error after displaying
                        }
                    %>
                    <h2>Parent Login</h2>
                    <form action="login_process.jsp" method="post">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="input-field" required>
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="input-field" required>
                        <button type="submit" class="button">Login</button>
                    </form>
                    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
                    <p><a href="forgot_password.jsp">Forgot Password?</a></p>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>