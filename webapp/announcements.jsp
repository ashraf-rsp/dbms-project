<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter handles access control and sets userRole.
    String userRole = (String) request.getAttribute("userRole");

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

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
                                <% if ("Admin".equals(userRole)) { %>
                                <th>Actions</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                try {
                                    String sql = "SELECT AlertID, Message, Timestamp FROM Alert_Log ORDER BY Timestamp DESC";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();
                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan=\"" + ("Admin".equals(userRole) ? "3" : "2") + "\">No announcements found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String fullMessage = rs.getString("Message");
                                            String title = fullMessage;
                                            int newlinePos = -1;
                                            if (fullMessage != null) {
                                               newlinePos = fullMessage.indexOf('\n');
                                               if (newlinePos != -1) {
                                                   title = fullMessage.substring(0, newlinePos);
                                               }
                                            }
                                            String date = rs.getTimestamp("Timestamp").toString().substring(0, 10);
                            %>
                                <tr class="announcement-row">
                                    <td><%= title %></td>
                                    <td><%= date %></td>
                                    <% if ("Admin".equals(userRole)) { %>
                                    <td>
                                        <button class="button delete-announcement-button" data-alert-id="<%= rs.getInt("AlertID") %>"><i class="fas fa-trash-alt"></i> Delete</button>
                                    </td>
                                    <% } %>
                                </tr>
                            <% 
                                        }
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading announcements: " + e.getMessage());
                                    out.println("<tr><td colspan=\"" + ("Admin".equals(userRole) ? "3" : "2") + "\">Error loading announcements.</td></tr>");
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% 
                        try {
                            String sql = "SELECT AlertID, Message, Timestamp FROM Alert_Log ORDER BY Timestamp DESC";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            if (!rs.isBeforeFirst()) {
                                out.println("<p>No announcements found.</p>");
                            } else {
                                while (rs.next()) {
                                    String fullMessage = rs.getString("Message");
                                    String title = fullMessage;
                                    String content = "";
                                    int newlinePos = -1;
                                    if (fullMessage != null) {
                                        newlinePos = fullMessage.indexOf('\n');
                                        if (newlinePos != -1) {
                                            title = fullMessage.substring(0, newlinePos);
                                            content = fullMessage.substring(newlinePos + 1);
                                        }
                                    }
                                    String date = rs.getTimestamp("Timestamp").toString().substring(0, 10);
                    %>
                        <div class="announcement-card">
                            <div class="card-header">
                                <h4><%= title %></h4>
                                <span class="announcement-date"><%= date %></span>
                            </div>
                            <div class="card-body">
                                <p><%= content %></p>
                            </div>
                            <% if ("Admin".equals(userRole)) { %>
                            <div class="card-actions">
                                <button class="button delete-announcement-button" data-alert-id="<%= rs.getInt("AlertID") %>"><i class="fas fa-trash-alt"></i> Delete</button>
                            </div>
                            <% } %>
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
                        }
                    %>
                </div>
            </div>

            <% if ("Admin".equals(userRole)) { %>
            <div class="compose-announcement-section">
                <h2>Compose New Announcement</h2>
                <form action="announcements_process.jsp" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label for="announcementTitle">Title:</label>
                        <input type="text" id="announcementTitle" name="announcementTitle" required>
                    </div>
                    <div class="form-group">
                        <label for="announcementContent">Content:</label>
                        <textarea id="announcementContent" name="announcementContent" rows="5" required></textarea>
                    </div>
                    <button type="submit" class="button primary-button"><i class="fas fa-plus-circle"></i> Publish Announcement</button>
                </form>
            </div>
            <% } %>

            <form id="delete-announcement-form" action="announcements_process.jsp" method="post" style="display:none;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="alertId" id="delete-alert-id">
            </form>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const deleteAnnouncementForm = document.getElementById('delete-announcement-form');

        document.querySelectorAll('.delete-announcement-button').forEach(button => {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this announcement?')) {
                    const alertId = this.dataset.alertId;
                    document.getElementById('delete-alert-id').value = alertId;
                    deleteAnnouncementForm.submit();
                }
            });
        });
    });
</script>