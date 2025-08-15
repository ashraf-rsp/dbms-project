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
                        String error = request.getParameter("error");
                        if (error != null && error.equals("1")) {
                            out.println("<p style='color:red;'>Invalid username or password.</p>");
                        }
                        if (error != null && error.equals("2")) {
                            out.println("<p style='color:red;'>An error occurred. Please try again.</p>");
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
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>