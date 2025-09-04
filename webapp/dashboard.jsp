<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");
    String profileName = (String) request.getAttribute("loggedInUser"); // Default to username

    if (userId != null && userRole != null) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "";
            if ("Admin".equals(userRole)) {
                sql = "SELECT AdminName FROM Users WHERE UserID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String name = rs.getString("AdminName");
                    if (name != null && !name.isEmpty()) {
                        profileName = name;
                    }
                }
            } else if ("Teacher".equals(userRole)) {
                sql = "SELECT TeacherName FROM Teachers WHERE UserID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String name = rs.getString("TeacherName");
                    if (name != null && !name.isEmpty()) {
                        profileName = name;
                    }
                }
            } else if ("Parent".equals(userRole)) {
                sql = "SELECT FirstName, LastName FROM Parents WHERE ParentID = (SELECT ParentID FROM Users WHERE UserID = ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String firstName = rs.getString("FirstName");
                    String lastName = rs.getString("LastName");
                    if (firstName != null && !firstName.isEmpty()) {
                        profileName = firstName + (lastName != null && !lastName.isEmpty() ? " " + lastName : "");
                    }
                }
            } else if ("Student".equals(userRole)) {
                sql = "SELECT StudentName FROM Students WHERE StudentID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    String name = rs.getString("StudentName");
                    if (name != null && !name.isEmpty()) {
                        profileName = name;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching profile name in dashboard.jsp: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        }
    }
    request.setAttribute("profileName", profileName);
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
                        <h3>Welcome, <%= profileName %>!</h3>
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