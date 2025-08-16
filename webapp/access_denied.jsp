<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Access Denied</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        h1 { color: #dc3545; }
        p { color: #6c757d; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <main class="content-area">
            <h1>Access Denied</h1>
            <p>You do not have permission to view this page.</p>
            <p><a href="dashboard.jsp">Go to Dashboard</a></p>
            <p><a href="logout.jsp">Logout</a></p>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
