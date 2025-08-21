<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    String loggedInUser = (String) session.getAttribute("loggedInUser");
%>

<% request.setAttribute("title", "Dashboard"); %>
<%@ include file="includes/header.jsp" %>

<div class="main-container">
    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>

    <main class="content-area">
        <div class="container">
            <div class="page-header">
                <h2><i class="fas fa-tachometer-alt"></i> <%= userRole %> Dashboard</h2>
            </div>

            <div class="summary-cards-grid">
                <div class="summary-card">
                    <h3>Welcome, <%= loggedInUser %>!</h3>
                    <p>Here's a quick overview of your academic status.</p>
                </div>
            </div>

            <%-- Role-based Dashboard Content --%>
            <% if ("Parent".equals(userRole)) { %>
                <%@ include file="dashboards/parent_dashboard.jsp" %>
            <% } else if ("Student".equals(userRole)) { %>
                <%@ include file="dashboards/student_dashboard.jsp" %>
            <% } else if ("Teacher".equals(userRole)) { %>
                <%@ include file="dashboards/teacher_dashboard.jsp" %>
            <% } else if ("Admin".equals(userRole)) { %>
                <%@ include file="dashboards/admin_dashboard.jsp" %>
            <% } else { %>
                <p>Welcome to your dashboard! Your role is not recognized or assigned.</p>
            <% } %>

        </div>
    </main>
</div>

<%@ include file="includes/footer.jsp" %>
