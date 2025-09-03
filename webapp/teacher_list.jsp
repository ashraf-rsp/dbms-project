<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    String userRole = (String) request.getAttribute("userRole");

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Teacher List - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="teacher_list" />
        </jsp:include>
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-chalkboard-teacher"></i> Teacher List</h2>
            </div>
            <section class="teacher-list-section">
                <h2>Our Faculty</h2>
                <div class="teacher-grid">
            <%
                try {
                    
                    String sql = "SELECT UserID, Username FROM Users WHERE UserType = 'Teacher' ORDER BY Username";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                        out.println("<p>No teachers found.</p>");
                    } else {
                        while (rs.next()) {
            %>
            <div class="teacher-card">
                <img src="assets/images/placeholder-teacher.png" alt="Teacher Photo" class="teacher-photo">
                <h3><%= rs.getString("Username") %></h3>
                <p><strong>Subject:</strong> N/A</p> <%-- Subject not available in Users table --%>
                <p><strong>Email:</strong> N/A</p> <%-- Email not available in Users table --%>
                <p><strong>Phone:</strong> N/A</p> <%-- Phone not available in Users table --%>
                <a href="messages.jsp?composeTo=<%= rs.getString("Username") %>" class="button primary-button"><i class="fas fa-envelope"></i> Contact</a>
            </div>
            <%
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error loading teacher list: " + e.getMessage());
                    out.println("<p>Error loading teacher list. Please try again.</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                    
                }
            %>
        </div>
    </section>
</main>
<%@ include file="includes/footer.jsp" %>