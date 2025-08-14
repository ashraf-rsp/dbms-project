<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("title", "Login"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

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
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>