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

    String status = (String) session.getAttribute("status");
    String message = (String) session.getAttribute("message");

    // DEBUG: Print session attributes to see if they are set
    out.println("<!-- DEBUG: Status from session: " + status + " -->");
    out.println("<!-- DEBUG: Message from session: " + message + " -->");

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
                <button id="mark-all-messages-read-button" class="button secondary-button"><i class="fas fa-check-double"></i> Mark All As Read</button>
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
                        // Temporarily commented out for debugging
                        // session.removeAttribute("status");
                        // session.removeAttribute("message");
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
                                    sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, s.Username AS SenderUsername, r.Username AS ReceiverUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                          "FROM Messages m " +
                                          "JOIN Users s ON m.SenderUserID = s.UserID " +
                                          "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                                          "WHERE m.ReceiverUserID = ? AND m.DeletedByReceiver = FALSE ORDER BY m.Timestamp DESC";
                                } else { // sent view
                                    sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, s.Username AS SenderUsername, r.Username AS ReceiverUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                          "FROM Messages m " +
                                          "JOIN Users s ON m.SenderUserID = s.UserID " +
                                          "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                                          "WHERE m.SenderUserID = ? AND m.DeletedBySender = FALSE ORDER BY m.Timestamp DESC";
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
                                            data-sender-id="<%= rs.getInt("SenderUserID") %>"
                                            data-receiver-id="<%= rs.getInt("ReceiverUserID") %>"
                                            data-sender="<%= "inbox".equals(currentView) ? rs.getString("SenderUsername") : rs.getString("ReceiverUsername") %>"
                                            data-receiver="<%= "inbox".equals(currentView) ? rs.getString("ReceiverUsername") : rs.getString("SenderUsername") %>"
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
                            sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, s.Username AS SenderUsername, r.Username AS ReceiverUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                  "FROM Messages m " +
                                  "JOIN Users s ON m.SenderUserID = s.UserID " +
                                  "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                                  "WHERE m.ReceiverUserID = ? AND m.DeletedByReceiver = FALSE ORDER BY m.Timestamp DESC";
                        } else { // sent view
                            sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, s.Username AS SenderUsername, r.Username AS ReceiverUsername, m.Subject, m.Content, m.Timestamp, m.IsRead " +
                                  "FROM Messages m " +
                                  "JOIN Users s ON m.SenderUserID = s.UserID " +
                                  "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                                  "WHERE m.SenderUserID = ? AND m.DeletedBySender = FALSE ORDER BY m.Timestamp DESC";
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
                                            data-sender-id="<%= rs.getInt("SenderUserID") %>"
                                            data-receiver-id="<%= rs.getInt("ReceiverUserID") %>"
                                            data-sender="<%= "inbox".equals(currentView) ? rs.getString("SenderUsername") : rs.getString("ReceiverUsername") %>"
                                            data-receiver="<%= "inbox".equals(currentView) ? rs.getString("ReceiverUsername") : rs.getString("SenderUsername") %>"
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
                    <input type="hidden" name="action" value="send">
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

            <div class="view-message-modal modal-container" style="display:none;">
                <div class="modal-backdrop"></div>
                <div class="modal-content chat-modal-content">
                    <div class="modal-header">
                        <h3 id="chat-modal-subject"></h3>
                        <span class="close-button">&times;</span>
                    </div>
                    <div class="chat-history" id="chat-history">
                        <!-- Chat messages will be loaded here -->
                    </div>
                    <div class="chat-input-area">
                        <input type="text" id="chat-reply-input" placeholder="Type your message...">
                        <button id="chat-send-button" class="button primary-button"><i class="fas fa-paper-plane"></i> Send</button>
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
        const composeForm = document.querySelector('.compose-message-section form');
        if (composeForm) {
            composeForm.addEventListener('submit', function(event) {
                event.preventDefault();

                try {
                    const formData = new URLSearchParams(new FormData(composeForm)).toString();

                    fetch('send_message_process.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            window.location.reload();
                        } else {
                            response.text().then(text => {
                                alert('ERROR: Server returned an error.\n' + text);
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Fetch Error:', error);
                        alert('FATAL: A network error occurred. Check console for details.\n' + error);
                    });

                } catch (e) {
                    console.error('Error in form submission handler:', e);
                    alert('FATAL: A JavaScript error occurred. Check console for details.\n' + e);
                }
            });
        }

        const viewMessageModal = document.querySelector('.view-message-modal');
        const closeButton = viewMessageModal.querySelector('.close-button');
        const chatModalSubject = document.getElementById('chat-modal-subject');
        const chatHistory = document.getElementById('chat-history');
        const chatReplyInput = document.getElementById('chat-reply-input');
        const chatSendButton = document.getElementById('chat-send-button');

        let currentOtherUserId = null; // To store the ID of the user in the current chat

        // Function to open the chat modal
        function openChatModal(otherUserId, otherUsername, subject) {
            currentOtherUserId = otherUserId;
            chatModalSubject.textContent = `Chat with ${otherUsername} - ${subject}`;
            chatHistory.innerHTML = ''; // Clear previous messages
            viewMessageModal.style.display = 'flex';

            // Fetch conversation history
            const conversationHistoryUrl = "get_conversation_history.jsp?otherUserId=" + otherUserId;
            console.log("--- MESSAGES JS DEBUG: Fetching conversation history from (concatenated):", conversationHistoryUrl, "---"); // DEBUG
            fetch(conversationHistoryUrl)
                .then(response => response.json())
                .then(conversation => {
                    conversation.forEach(msg => {
                        const messageElement = document.createElement('div');
                        messageElement.classList.add('chat-message');
                        messageElement.classList.add(msg.senderId === userIdFromSession ? 'sent' : 'received');
                        messageElement.innerHTML = `\r\n                            <div class="chat-bubble">\r\n                                ${msg.content}\r\n                                <div class="chat-message-info">${msg.senderUsername} - ${msg.timestamp}</div>\r\n                            </div>\r\n                        `;
                        chatHistory.appendChild(messageElement);

                        // Mark message as read if it's an unread message received by current user
                        if (msg.receiverId === userIdFromSession && !msg.isRead) {
                            fetch('send_message_process.jsp', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: new URLSearchParams({ action: 'mark_read', messageId: msg.messageId })
                            })
                            .then(response => response.json())
                            .then(data => {
                                if (data.status === 'success') {
                                    console.log('Message marked as read:', msg.messageId);
                                    document.dispatchEvent(new CustomEvent('messageRead')); // Refresh count
                                } else {
                                    console.error('Failed to mark message as read:', data.message);
                                }
                            })
                            .catch(error => console.error('Error marking message as read:', error));
                        }
                    });
                    chatHistory.scrollTop = chatHistory.scrollHeight; // Scroll to bottom
                })
                .catch(error => console.error('Error fetching conversation history:', error));
        }

        // Function to close the chat modal
        function closeChatModal() {
            viewMessageModal.style.display = 'none';
            window.location.reload(); // Reload page to update message list status
        }

        // Event listeners for closing the modal
        closeButton.addEventListener('click', closeChatModal);
        window.addEventListener('click', function(event) {
            if (event.target === viewMessageModal) {
                closeChatModal();
            }
        });

        // View message button click
        document.querySelectorAll('.view-message-button').forEach(button => {
            button.addEventListener('click', function() {
                const messageId = this.dataset.messageId;
                const senderId = parseInt(this.dataset.senderId, 10); // Parse as integer
                const receiverId = parseInt(this.dataset.receiverId, 10); // Parse as integer
                const senderUsername = this.dataset.sender; // Assuming sender username is available
                const receiverUsername = this.dataset.receiver; // Assuming receiver username is available
                const subject = this.dataset.subject;

                // Determine the other user's ID and username for the chat
                const userIdFromSession = parseInt("<%= userId %>", 10); // Get current user ID from session
                let otherUserId = null;
                let otherUsername = '';

                console.log("--- MESSAGES JS DEBUG: senderId=", senderId, ", receiverId=", receiverId, ", userIdFromSession=", userIdFromSession, "---"); // DEBUG

                if (senderId === userIdFromSession) {
                    otherUserId = receiverId;
                    otherUsername = receiverUsername;
                } else {
                    otherUserId = senderId;
                    otherUsername = senderUsername;
                }

                console.log("--- MESSAGES JS DEBUG: Determined otherUserId=", otherUserId, ", otherUsername=", otherUsername, "---"); // DEBUG

                if (otherUserId) {
                    openChatModal(otherUserId, otherUsername, subject);
                } else {
                    console.error('Could not determine other user for chat.'); // <--- This is the error message
                }
            });
        });

        // Send reply functionality
        chatSendButton.addEventListener('click', sendMessage);
        chatReplyInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        function sendMessage() {
            const replyContent = chatReplyInput.value.trim();
            if (replyContent === '' || currentOtherUserId === null) {
                return;
            }

            const bodyParams = new URLSearchParams();
            bodyParams.append('action', 'send');
            bodyParams.append('receiverUserId', currentOtherUserId);
            bodyParams.append('subject', chatModalSubject.textContent.split(' - ')[1]); // Extract subject from modal title
            bodyParams.append('content', replyContent);

            fetch('send_message_process.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: bodyParams
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    chatReplyInput.value = '';
                    // Reload conversation to show new message
                    openChatModal(currentOtherUserId, chatModalSubject.textContent.split(' - ')[0].replace('Chat with ', ''), chatModalSubject.textContent.split(' - ')[1]);
                } else {
                    alert('Error sending message: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error sending message:', error);
                alert('An error occurred while sending the message.');
            });
        }

        // Delete message button click
        document.querySelectorAll('.delete-message-button').forEach(button => {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this message?')) {
                    const messageId = this.dataset.messageId;
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'send_message_process.jsp';
                    document.body.appendChild(form); // Append form first

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete';
                    form.appendChild(actionInput);

                    const messageIdInput = document.createElement('input');
                    messageIdInput.type = 'hidden';
                    messageIdInput.name = 'messageId';
                    messageIdInput.value = messageId; // Use the messageId from the dataset
                    form.appendChild(messageIdInput);

                    form.submit();
                }
            });
        });

        // Mark All As Read functionality
        const markAllMessagesReadButton = document.getElementById('mark-all-messages-read-button');
        if (markAllMessagesReadButton) {
            markAllMessagesReadButton.addEventListener('click', function() {
                if (confirm('Are you sure you want to mark all messages as read?')) {
                    fetch('mark_all_messages_read.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            alert(data.message);
                            document.dispatchEvent(new CustomEvent('messageRead')); // Refresh count
                            window.location.reload(); // Reload page to update message list
                        } else {
                            alert('Error marking all messages as read: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('An error occurred while marking all messages as read.');
                    });
                }
            });
        }
    });
</script>