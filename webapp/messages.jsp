<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<% 
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    String currentView = request.getParameter("view");
    if (currentView == null || currentView.trim().isEmpty()) {
        currentView = "inbox"; // Default view
    }

    if (userId == null) {
        // Should not happen if filter is working, but as a safeguard
        response.sendRedirect("login.jsp?error=session");
        return;
    }

    String status = request.getParameter("status");
    String message = request.getParameter("message");

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
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
            
            <div class="message-tabs">
                <button class="tab-button <%= "inbox".equals(currentView) ? "active" : "" %>" onclick="window.location.href='messages.jsp?view=inbox'">Inbox</button>
                <button class="tab-button <%= "sent".equals(currentView) ? "active" : "" %>" onclick="window.location.href='messages.jsp?view=sent'">Sent</button>
            </div>

            <div class="data-table-container">
                <div class="table-header">
                    <h3><%= "inbox".equals(currentView) ? "Inbox" : "Sent Messages" %></h3>
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
                        session.removeAttribute("status");
                        session.removeAttribute("message");
                    }
                %>
                
                <div class="responsive-table">
                    <table class="messages-table">
                        <thead>
                            <tr>
                                <th><%= "inbox".equals(currentView) ? "From" : "To" %></th>
                                <th>Subject</th>
                                <th>Content Preview</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                String sql = "";

                                if ("inbox".equals(currentView)) {
                                    sql = "SELECT m.MessageID, u.Username AS SenderUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                          "FROM Messages m JOIN Users u ON m.SenderUserID = u.UserID " +
                                          "WHERE m.ReceiverUserID = ? ORDER BY m.Timestamp DESC";
                                } else { // sent view
                                    sql = "SELECT m.MessageID, u.Username AS ReceiverUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                          "FROM Messages m JOIN Users u ON m.ReceiverUserID = u.UserID " +
                                          "WHERE m.SenderUserID = ? ORDER BY m.Timestamp DESC";
                                }

                                try {
                                    
                                    pstmt = conn.prepareStatement(sql);
                                    pstmt.setInt(1, userId);
                                    rs = pstmt.executeQuery();
                                    if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                        out.println("<tr><td colspan=\"5\">No messages found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                            %>
                            <tr class="message-row <%= rs.getBoolean("IsRead") ? "read" : "unread" %>">
                                <td data-label="<%= "inbox".equals(currentView) ? "SenderUsername" : "ReceiverUsername" %>"><%= rs.getString("inbox".equals(currentView) ? "SenderUsername" : "ReceiverUsername") %></td>
                                <td data-label="Subject"><%= rs.getString("Subject") %></td>
                                <td data-label="Content Preview"><%= rs.getString("Content").length() > 50 ? rs.getString("Content").substring(0, 50) + "..." : rs.getString("Content") %></td>
                                <td data-label="Date"><%= rs.getTimestamp("Timestamp") %></td>
                                <td data-label="Status"><%= rs.getBoolean("IsRead") ? "Read" : "Unread" %></td>
                                <td data-label="Actions">
                                    <button class="button view-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>" 
                                            data-sender="<%= "inbox".equals(currentView) ? "SenderUsername" : "ReceiverUsername" %>"
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
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% 
                        // Re-execute query for mobile cards
                        // Need to re-prepare statement as it might have been closed in finally block
                        if ("inbox".equals(currentView)) {
                            sql = "SELECT m.MessageID, u.Username AS SenderUsername, m.Subject, m.Timestamp, m.IsRead " +
                                  "FROM Messages m JOIN Users u ON m.SenderUserID = u.UserID " +
                                  "WHERE m.ReceiverUserID = ? ORDER BY m.Timestamp DESC";
                        } else { // sent view
                            sql = "SELECT m.MessageID, u.Username AS ReceiverUsername, m.Subject, m.Timestamp, m.IsRead " +
                                  "FROM Messages m JOIN Users u ON m.ReceiverUserID = u.UserID " +
                                  "WHERE m.SenderUserID = ? ORDER BY m.Timestamp DESC";
                        }

                        try {
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
                                <span class="message-from"><%= "inbox".equals(currentView) ? "From" : "To" %>: <%= rs.getString("inbox".equals(currentView) ? "SenderUsername" : "ReceiverUsername") %></span>
                            </div>
                            <div class="card-body">
                                <p>Content: <%= rs.getString("Content").length() > 100 ? rs.getString("Content").substring(0, 100) + "..." : rs.getString("Content") %></p>
                                <p>Date: <%= rs.getTimestamp("Timestamp") %></p>
                                <p>Status: <%= rs.getBoolean("IsRead") ? "Read" : "Unread" %></p>
                                <div class="card-actions">
                                    <button class="button view-message-button" 
                                            data-message-id="<%= rs.getInt("MessageID") %>" 
                                            data-sender="<%= "inbox".equals(currentView) ? "SenderUsername" : "ReceiverUsername" %>"
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
                        }
                    %>
                </div>
            </div>


            <div class="compose-message-section">
                <h2>Compose New Message</h2>
                <form action="send_message_process.jsp" method="post">
                    <div class="form-group">
                        <label for="receiverUsername">To (Username):</label>
                        <select id="receiverUsername" name="receiverUsername" required>
                            <option value="">-- Select User --</option>
                            <% 
                                PreparedStatement pstmtUsers = null;
                                ResultSet rsUsers = null;
                                try {
                                    String sqlUsers = "SELECT UserID, Username FROM Users WHERE UserID != ? ORDER BY Username";
                                    pstmtUsers = conn.prepareStatement(sqlUsers);
                                    pstmtUsers.setInt(1, userId);
                                    rsUsers = pstmtUsers.executeQuery();
                                    while (rsUsers.next()) {
                            %>
                                <option value="<%= rsUsers.getString("Username") %>"><%= rsUsers.getString("Username") %></option>
                            <% 
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading users for message composition: " + e.getMessage());
                                } finally {
                                    if (rsUsers != null) try { rsUsers.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmtUsers != null) try { pstmtUsers.close(); } catch (SQLException e) { /* ignore */ }
                                }
                            %>
                        </select>
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
                    <div class="modal-actions">
                        <button class="button primary-button reply-message-button"><i class="fas fa-reply"></i> Reply</button>
                    </div>
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

                fetch('get_message_content.jsp?messageId=' + messageId)
                    .then(response => response.text())
                    .then(content => {
                        document.getElementById('modal-sender').textContent = sender;
                        document.getElementById('modal-subject').textContent = subject;
                        document.getElementById('modal-timestamp').textContent = timestamp;
                        document.getElementById('modal-content').textContent = content;
                        viewMessageModal.style.display = 'block';

                        // Store sender and subject for reply functionality
                        viewMessageModal.dataset.currentSender = sender;
                        viewMessageModal.dataset.currentSubject = subject;

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

        // Reply message button click
        document.querySelector('.reply-message-button').addEventListener('click', function() {
            const sender = viewMessageModal.dataset.currentSender;
            const subject = viewMessageModal.dataset.currentSubject;

            document.getElementById('receiverUsername').value = sender;
            document.getElementById('subject').value = 'Re: ' + subject;
            document.getElementById('content').value = ''; // Clear content for new reply

            viewMessageModal.style.display = 'none'; // Close modal

            // Scroll to compose section
            document.querySelector('.compose-message-section').scrollIntoView({ behavior: 'smooth' });
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