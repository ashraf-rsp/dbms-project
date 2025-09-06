<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="java.sql.*, java.util.*" %><%@ include file="db_connection.jsp" %>
<% 
    // AuthFilter handles access control and sets userRole.
    String userRole = (String) request.getAttribute("userRole");

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    String status = request.getParameter("status");
    String message = request.getParameter("message");

    // Fetch announcements once
    List<Map<String, Object>> announcements = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        String sql = "SELECT AlertID, Title, Content, Timestamp FROM Alert_Log ORDER BY Timestamp DESC";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            Map<String, Object> announcement = new HashMap<>();
            announcement.put("AlertID", rs.getInt("AlertID"));
            announcement.put("Title", rs.getString("Title"));
            announcement.put("Content", rs.getString("Content"));
            announcement.put("Timestamp", rs.getTimestamp("Timestamp"));
            announcements.add(announcement);
        }
    } catch (Exception e) {
        System.err.println("Error loading announcements: " + e.getMessage());
        // Set an error message to be displayed
        message = "Error loading announcements.";
        status = "error";
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
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
                                if (announcements.isEmpty()) {
                                    out.println("<tr><td colspan=\"" + ("Admin".equals(userRole) ? "3" : "2") + "\">No announcements found.</td></tr>");
                                } else {
                                    for (Map<String, Object> announcement : announcements) {
                                        String date = ((Timestamp) announcement.get("Timestamp")).toString().substring(0, 10);
                            %>
                                <tr class="announcement-row">
                                    <td><%= announcement.get("Title") %></td>
                                    <td><%= date %></td>
                                    <% if ("Admin".equals(userRole)) { %>
                                    <td>
                                        <button class="button delete-announcement-button" data-alert-id="<%= announcement.get("AlertID") %>"><i class="fas fa-trash-alt"></i> Delete</button>
                                    </td>
                                    <% } %>
                                </tr>
                            <% 
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% 
                        if (announcements.isEmpty()) {
                            out.println("<p>No announcements found.</p>");
                        } else {
                            for (Map<String, Object> announcement : announcements) {
                                String date = ((Timestamp) announcement.get("Timestamp")).toString().substring(0, 10);
                    %>
                        <div class="announcement-card">
                            <div class="card-header">
                                <h4><%= announcement.get("Title") %></h4>
                                <span class="announcement-date"><%= date %></span>
                            </div>
                            <div class="card-body">
                                <p><%= announcement.get("Content") %></p>
                            </div>
                            <% if ("Admin".equals(userRole)) { %>
                            <div class="card-actions">
                                <button class="button delete-announcement-button" data-alert-id="<%= announcement.get("AlertID") %>"><i class="fas fa-trash-alt"></i> Delete</button>
                            </div>
                            <% } %>
                        </div>
                    <% 
                            }
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
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.delete-announcement-button').forEach(button => {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this announcement?')) {
                    const alertId = this.dataset.alertId;
                    const formData = new FormData();
                    formData.append('action', 'delete');
                    formData.append('alertId', alertId);

                    fetch('announcements_process.jsp', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            window.location.reload();
                        } else {
                            alert('Error deleting announcement.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error deleting announcement.');
                    });
                }
            });
        });
    });
</script>