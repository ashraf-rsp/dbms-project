<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    String status = request.getParameter("status");
    String message = request.getParameter("message");

%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= (String) session.getAttribute("theme") %>">
<head>
    <title>Messages - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="messages" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-envelope"></i> Messages</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Inbox</h3>
                </div>
                <% 
                    if (status != null && message != null) {
                        String alertClass = "";
                        if (status.equals("success")) {
                            alertClass = "alert-success";
                        } else if (status.equals("error")) {
                            alertClass = "alert-danger";
                        }
                %>
                <div class="alert <%= alertClass %>">
                    <%= message %>
                </div>
                <% 
                    }
                %>
                
                <div class="responsive-table">
                    <table class="messages-table">
                        <thead>
                            <tr>
                                <th>From</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                try {
                                    conn = getConnection();
                                    String sql = "SELECT m.MessageID, u.Username AS SenderUsername, m.Subject, m.Timestamp, m.IsRead " +
                                                 "FROM Messages m JOIN Users u ON m.SenderUserID = u.UserID " +
                                                 "WHERE m.ReceiverUserID = ? ORDER BY m.Timestamp DESC";
                                    pstmt = conn.prepareStatement(sql);
                                    pstmt.setInt(1, userId);
                                    rs = pstmt.executeQuery();
                                    if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                        out.println("<tr><td colspan=\"5\">No messages found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                            %>
                            <tr class="message-row <%= rs.getBoolean("IsRead") ? "read" : "unread" %>">
                                <td data-label="From"><%= rs.getString("SenderUsername") %></td>
                                <td data-label="Subject"><%= rs.getString("Subject") %></td>
                                <td data-label="Date"><%= rs.getTimestamp("Timestamp") %></td>
                                <td data-label="Status"><%= rs.getBoolean("IsRead") ? "Read" : "Unread" %></td>
                                <td data-label="Actions">
                                    <button class="button view-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>" 
                                            data-sender="<%= rs.getString("SenderUsername") %>" 
                                            data-subject="<%= rs.getString("Subject") %>" 
                                            data-timestamp="<%= rs.getTimestamp("Timestamp") %>" 
                                            data-is-read="<%= rs.getBoolean("IsRead") %>">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="button delete-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </td>
                            </tr>
                            <% 
                                        }
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading messages: " + e.getMessage());
                                    out.println("<tr><td colspan=\"5\">Error loading messages.</td></tr>");
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
                        // Re-execute query for mobile cards
                        try {
                            conn = getConnection(); // Re-establish connection for this block
                            String sql = "SELECT m.MessageID, u.Username AS SenderUsername, m.Subject, m.Timestamp, m.IsRead " +
                                         "FROM Messages m JOIN Users u ON m.SenderUserID = u.UserID " +
                                         "WHERE m.ReceiverUserID = ? ORDER BY m.Timestamp DESC";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setInt(1, userId);
                            rs = pstmt.executeQuery();
                            if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                out.println("<p>No messages found.</p>");
                            } else {
                                while (rs.next()) {
                    %>
                        <div class="message-card <%= rs.getBoolean("IsRead") ? "read" : "unread" %>">
                            <div class="card-header">
                                <h4><%= rs.getString("Subject") %></h4>
                                <span class="message-from">From: <%= rs.getString("SenderUsername") %></span>
                            </div>
                            <div class="card-body">
                                <p>Date: <%= rs.getTimestamp("Timestamp") %></p>
                                <p>Status: <%= rs.getBoolean("IsRead") ? "Read" : "Unread" %></p>
                                <div class="card-actions">
                                    <button class="button view-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>" 
                                            data-sender="<%= rs.getString("SenderUsername") %>" 
                                            data-subject="<%= rs.getString("Subject") %>" 
                                            data-timestamp="<%= rs.getTimestamp("Timestamp") %>" 
                                            data-is-read="<%= rs.getBoolean("IsRead") %>">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="button delete-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% 
                                }
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading messages for mobile view: " + e.getMessage());
                            out.println("<p>Error loading messages.</p>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
            </div>

            <div class="compose-message-section">
                <h2>Compose New Message</h2>
                <form action="send_message_process.jsp" method="post">
                    <div class="form-group">
                        <label for="receiverUsername">To (Username):</label>
                        <input type="text" id="receiverUsername" name="receiverUsername" required>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject:</label>
                        <input type="text" id="subject" name="subject" required>
                    </div>
                    <div class="form-group">
                        <label for="content">Message:</label>
                        <textarea id="content" name="content" rows="5" required></textarea>
                    </div>
                    <button type="submit" class="button primary-button"><i class="fas fa-paper-plane"></i> Send Message</button>
                </form>
            </div>

            <div class="view-message-modal" style="display:none;">
                <div class="modal-content">
                    <span class="close-button">&times;</span>
                    <h2>Message Details</h2>
                    <p><strong>From:</strong> <span id="modal-sender"></span></p>
                    <p><strong>Subject:</strong> <span id="modal-subject"></span></p>
                    <p><strong>Date:</strong> <span id="modal-timestamp"></span></p>
                    <hr>
                    <p id="modal-content"></p>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const viewMessageModal = document.querySelector('.view-message-modal');
        const closeButton = document.querySelector('.view-message-modal .close-button');
        const deleteMessageForm = document.createElement('form'); // Create a form dynamically for delete
        deleteMessageForm.action = 'send_message_process.jsp';
        deleteMessageForm.method = 'post';
        deleteMessageForm.style.display = 'none';
        deleteMessageForm.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="messageId" id="delete-message-id">';
        document.body.appendChild(deleteMessageForm);

        // View message button click
        document.querySelectorAll('.view-message-button').forEach(button => {
            button.addEventListener('click', function() {
                const messageId = this.dataset.messageId;
                const sender = this.dataset.sender;
                const subject = this.dataset.subject;
                const timestamp = this.dataset.timestamp;
                const isRead = this.dataset.isRead === 'true';

                // Fetch full message content via AJAX or redirect to a view_message.jsp
                // For simplicity, let's assume content is not passed via data-attribute for now
                // and will be fetched from the server when modal is opened, or we can pass it.
                // For now, I'll just display the subject and sender.

                // To fetch full content, we'd need another AJAX call or a hidden field with content.
                // For this implementation, I'll make a simple AJAX call to get content.
                fetch('get_message_content.jsp?messageId=' + messageId)
                    .then(response => response.text())
                    .then(content => {
                        document.getElementById('modal-sender').textContent = sender;
                        document.getElementById('modal-subject').textContent = subject;
                        document.getElementById('modal-timestamp').textContent = timestamp;
                        document.getElementById('modal-content').textContent = content;
                        viewMessageModal.style.display = 'block';

                        // Mark as read if not already read
                        if (!isRead) {
                            fetch('send_message_process.jsp?action=mark_read&messageId=' + messageId, { method: 'POST' })
                                .then(response => {
                                    if (response.ok) {
                                        // Update UI to show as read
                                        this.closest('tr').classList.remove('unread');
                                        this.closest('tr').classList.add('read');
                                        // Update status text if visible
                                        const statusCell = this.closest('tr').querySelector('td[data-label="Status"]');
                                        if (statusCell) statusCell.textContent = 'Read';
                                    }
                                });
                        }
                    })
                    .catch(error => console.error('Error fetching message content:', error));
            });
        });

        // Close modal
        closeButton.addEventListener('click', function() {
            viewMessageModal.style.display = 'none';
        });

        window.addEventListener('click', function(event) {
            if (event.target == viewMessageModal) {
                viewMessageModal.style.display = 'none';
            }
        });

        // Delete message button click
        document.querySelectorAll('.delete-message-button').forEach(button => {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this message?')) {
                    const messageId = this.dataset.messageId;
                    document.getElementById('delete-message-id').value = messageId;
                    deleteMessageForm.submit();
                }
            });
        });
    });
</script>