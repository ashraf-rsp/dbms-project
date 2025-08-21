<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String status = request.getParameter("status");
    String message = request.getParameter("message");

%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Announcements - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="announcements" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-bullhorn"></i> Announcements</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Latest Announcements</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="announcements-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                try {
                                    conn = null; // Initialize conn to null
                                    conn = getConnection();
                                    String sql = "SELECT AlertID, Message, Timestamp FROM Alert_Log ORDER BY Timestamp DESC";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();
                                    if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                        out.println("<tr><td colspan=\"2\">No announcements found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String fullMessage = rs.getString("Message");
                                            String title = fullMessage.split("\\n")[0]; // Get first line as title
                                            String date = rs.getTimestamp("Timestamp").toString().substring(0, 10); // YYYY-MM-DD
                            %>
                                <tr class="announcement-row">
                                    <td><%= title %></td>
                                    <td><%= date %></td>
                                </tr>
                            <% 
                                        }
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading announcements: " + e.getMessage());
                                    out.println("<tr><td colspan=\"2\">Error loading announcements. Please try again.</td></tr>");
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% 
                        try {
                            // Re-fetch data for mobile cards if needed, or reset ResultSet
                            // For simplicity, re-executing query here. In a real app, manage ResultSet better.
                            conn = null; // Initialize conn to null
                            conn = getConnection(); // Re-establish connection for this block
                            String sql = "SELECT AlertID, Message, Timestamp FROM Alert_Log ORDER BY Timestamp DESC";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                out.println("<p>No announcements found.</p>");
                            } else {
                                while (rs.next()) {
                                    String fullMessage = rs.getString("Message");
                                    String title = fullMessage.split("\\n")[0]; // Get first line as title
                                    String content = fullMessage.substring(fullMessage.indexOf("\\n") + 1); // Get content after first line
                                    String date = rs.getTimestamp("Timestamp").toString().substring(0, 10); // YYYY-MM-DD
                    %>
                        <div class="announcement-card">
                            <div class="card-header">
                                <h4><%= title %></h4>
                                <span class="announcement-date"><%= date %></span>
                            </div>
                            <div class="card-body">
                                <p><%= content %></p>
                            </div>
                        </div>
                    <% 
                                }
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading announcements for mobile view: " + e.getMessage());
                            out.println("<p>Error loading announcements.</p>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>