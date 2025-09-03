<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Dashboard - Academic Center</title>
</head>
<body>
    <% request.setAttribute("title", "Dashboard"); %>
    <%@ include file="includes/header.jsp" %>

    <div class="main-container">
        <%
            request.setAttribute("activePage", "dashboard");
        %>
        <jsp:include page="includes/sidebar.jsp" />

        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-tachometer-alt"></i> <%= (String) request.getAttribute("userRole") %> Dashboard</h2>
                </div>

                <div class="summary-cards-grid">
                    <div class="summary-card">
                        <h3>Welcome, <%= (String) request.getAttribute("loggedInUser") %>!</h3>
                        <p>Here's a quick overview of your academic status.</p>
                    </div>
                </div>

                <%-- Role-based Dashboard Content --%>
                <% if ("Parent".equals((String) request.getAttribute("userRole"))) { %>
                    <%@ include file="dashboards/parent_dashboard.jsp" %>
                <% } else if ("Student".equals((String) request.getAttribute("userRole"))) { %>
                    <%@ include file="dashboards/student_dashboard.jsp" %>
                <% } else if ("Teacher".equals((String) request.getAttribute("userRole"))) { %>
                    <%@ include file="dashboards/teacher_dashboard.jsp" %>
                <% } else if ("Admin".equals((String) request.getAttribute("userRole"))) { %>
                    <%@ include file="dashboards/admin_dashboard.jsp" %>
                <% } else { %>
                    <p>Welcome to your dashboard! Your role is not recognized or assigned.</p>
                <% } %>

            </div>
        </main>
    </div>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>