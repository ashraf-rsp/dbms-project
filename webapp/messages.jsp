<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for messages
    String[][] messages = {
        {"John Doe", "Meeting Reminder", "Don't forget our meeting tomorrow at 10 AM.", "2025-08-14"},
        {"Admin", "System Update", "The system will be updated tonight.", "2025-08-13"},
        {"Jane Smith", "Question about homework", "Can you clarify question 3 on the math homework?", "2025-08-12"}
    };
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
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Inbox</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="messages-table">
                        <thead>
                            <tr>
                                <th>From</th>
                                <th>Subject</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < messages.length; i++) { %>
                                <tr class="message-row">
                                    <td><%= messages[i][0] %></td>
                                    <td><%= messages[i][1] %></td>
                                    <td><%= messages[i][3] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < messages.length; i++) { %>
                        <div class="message-card">
                            <div class="card-header">
                                <h4><%= messages[i][1] %></h4>
                                <span class="message-from">From: <%= messages[i][0] %></span>
                            </div>
                            <div class="card-body">
                                <p><%= messages[i][2] %></p>
                                <span class="message-date"><%= messages[i][3] %></span>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>