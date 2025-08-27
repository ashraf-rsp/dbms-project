<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/auth_check.jspf" %>
<html>
<head>
    <title>Session Test</title>
</head>
<body>
    <h1>Session Test Page</h1>
    <%
        String loggedInUser = (String) session.getAttribute("loggedInUser");
        String userRole = (String) session.getAttribute("userRole");
    %>
    <p>Logged In User: <%= loggedInUser %></p>
    <p>User Role: <%= userRole %></p>
</body>
</html>