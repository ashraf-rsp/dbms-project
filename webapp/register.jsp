<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<% request.setAttribute("additionalCss", "login"); %>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Register - ThinkSpire Academy</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <main class="content-area">
            <div class="login-page-wrapper">
                <div class="login-container">
                    <%-- Display registration error/success messages --%>
                    <% 
                        String regMessage = (String) session.getAttribute("regMessage");
                        if (regMessage != null) {
                            out.println("<p style='color:green;'>" + regMessage + "</p>");
                            session.removeAttribute("regMessage");
                        }
                        String regError = (String) session.getAttribute("regError");
                        if (regError != null) {
                            out.println("<p style='color:red;'>" + regError + "</p>");
                            session.removeAttribute("regError");
                        }
                    %>
                    <h2>Register New Account</h2>
                    <form action="register_process.jsp" method="post">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" class="input-field" required>
                        
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" class="input-field" required>
                        
                        <label for="confirm_password">Confirm Password:</label>
                        <input type="password" id="confirm_password" name="confirm_password" class="input-field" required>
                        
                        <label for="user_type">User Type:</label>
                        <select id="user_type" name="user_type" class="input-field" required>
                            <option value="">Select User Type</option>
                            <option value="Parent">Parent</option>
                            <option value="Teacher">Teacher</option>
                            <option value="Student">Student</option>
                            <option value="Admin">Admin</option>
                        </select>
                        
                        <button type="submit" class="button">Register</button>
                    </form>
                    <p>Already have an account? <a href="login.jsp">Login here</a></p>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>