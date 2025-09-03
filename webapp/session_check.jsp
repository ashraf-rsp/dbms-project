<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sessionId = session.getId();
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Session Check</title>
</head>
<body>
    <h1>Session Information</h1>
    <p>Session ID: <%= sessionId %></p>
    <p>Logged In User: <%= loggedInUser %></p>
    <p>User Role: <%= userRole %></p>
    <p><a href="dashboard.jsp">Go to Dashboard</a></p>
</body>
</html>