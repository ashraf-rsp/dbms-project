<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // This page is accessible by all logged-in users.
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Teacher List</h1>
    <section class="teacher-list-section">
        <h2>Our Faculty</h2>
        <div class="teacher-grid">
            <%
                try {
                    conn = getConnection();
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
                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                }
            %>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>