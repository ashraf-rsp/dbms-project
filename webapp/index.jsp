<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Parent Login - Academic Center</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
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
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="submit">Login</button>
            </div>
        </form>
    </div>
</body>
</html>
