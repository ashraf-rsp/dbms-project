<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>

<%
    int userId = (Integer) session.getAttribute("userId"); // userId is needed
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    if (!"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="<%= theme %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Profile - Academic Center</title>
    <link rel="stylesheet" href="/academic-center/css/themes.css">
    <link rel="stylesheet" href="/academic-center/css/components.css">
    <link rel="stylesheet" href="/academic-center/css/style.css">
    <link rel="stylesheet" href="/academic-center/css/responsive.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="teacher_profile" />
        </jsp:include>
        
        <main class="content-area">
            <div class="container">
                <h2>Teacher Profile Page</h2>
                <p>Welcome, <%= loggedInUser %>!</p>
                <p>Your User ID: <%= userId %></p>
                <p>Your Role: <%= userRole %></p>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>