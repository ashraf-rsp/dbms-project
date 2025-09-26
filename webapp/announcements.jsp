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
                                <tr class="announcement-item" data-title="<%= announcement.get("Title") %>" data-content="<%= announcement.get("Content") %>" data-alert-id="<%= String.valueOf(announcement.get("AlertID")) %>">
                                    <% System.err.println("--- ANNOUNCEMENTS JSP (Desktop): Rendering AlertID=" + announcement.get("AlertID") + " ---"); %>
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
                                        <div class="announcement-card announcement-item" data-title="<%= announcement.get("Title") %>" data-content="<%= announcement.get("Content") %>" data-alert-id="<%= String.valueOf(announcement.get("AlertID")) %>">
                            <% System.err.println("--- ANNOUNCEMENTS JSP (Mobile): Rendering AlertID=" + announcement.get("AlertID") + " ---"); %>
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
    
    <!-- Announcement View Modal -->
    <div id="announcement-modal" class="modal-container" style="display:none;">
        <div class="modal-backdrop"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modal-title"></h3>
                <button id="modal-close-button" class="modal-close-button">&times;</button>
            </div>
            <div class="modal-body" id="modal-body">
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Modal elements
    const modal = document.getElementById('announcement-modal');
    const modalTitle = document.getElementById('modal-title');
    const modalBody = document.getElementById('modal-body');
    const closeModalButton = document.getElementById('modal-close-button');
    const modalBackdrop = document.querySelector('.modal-backdrop');

    // Function to open the modal
    function openModal(title, content, alertId) {
        modalTitle.textContent = title;
        modalBody.innerHTML = content; // Use innerHTML to render potential HTML content
        modal.style.display = 'flex';

        // Mark notification as read
        if (alertId) {
            fetch('mark_notification_read.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({ alertId: alertId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    console.log('Notification marked as read:', data.message);
                    // Trigger a refresh of the notification count
                    // Assuming fetchCounts() is available globally or can be called
                    if (typeof fetchCounts === 'function') {
                        fetchCounts();
                    } else {
                        // Fallback if fetchCounts is not directly accessible (e.g., defined in main.js)
                        // A simple way to trigger update is to dispatch a custom event
                        document.dispatchEvent(new CustomEvent('notificationRead'));
                    }
                } else {
                    console.error('Failed to mark notification as read:', data.message);
                }
            })
            .catch(error => console.error('Error marking notification as read:', error));
        }
    }

    // Function to close the modal
    function closeModal() {
        modal.style.display = 'none';
    }

    // Event listeners for closing the modal
    closeModalButton.addEventListener('click', closeModal);
    modalBackdrop.addEventListener('click', closeModal);

    // Event listener for opening the modal
    document.querySelectorAll('.announcement-item').forEach(item => {
        item.addEventListener('click', function(event) {
            // Don't open modal if the delete button was clicked
            if (event.target.closest('.delete-announcement-button')) {
                return;
            }
            const title = this.dataset.title;
            const content = this.dataset.content;
            const alertId = this.dataset.alertId; // Get the AlertID
            console.log("--- ANNOUNCEMENTS JS: Clicked AlertID from dataset:", alertId, "---"); // DEBUG
            openModal(title, content, alertId);
        });
    });

    // Enhanced delete functionality
    document.querySelectorAll('.delete-announcement-button').forEach(button => {
        button.addEventListener('click', function() {
            if (confirm('Are you sure you want to delete this announcement?')) {
                const alertId = this.dataset.alertId;
                const announcementItem = this.closest('.announcement-item');
                
                const bodyParams = new URLSearchParams();
                bodyParams.append('action', 'delete');
                bodyParams.append('alertId', alertId);

                fetch('announcements_process.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: bodyParams
                })
                .then(response => response.json()) // Expect a JSON response
                .then(data => {
                    if (data.status === 'success') {
                        // Smoothly remove the element from the DOM
                        announcementItem.style.transition = 'opacity 0.5s ease';
                        announcementItem.style.opacity = '0';
                        setTimeout(() => {
                            announcementItem.remove();
                        }, 500);
                    } else {
                        alert('Error deleting announcement: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred while deleting the announcement.');
                });
            }
        });
    });
});
</script>