<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for class schedule
    String[][] schedule = {
        {"Monday", "8:00 AM - 9:00 AM", "Mathematics", "Room 101", "Mrs. Johnson"},
        {"Monday", "9:15 AM - 10:15 AM", "Science", "Lab 203", "Mr. Smith"},
        {"Tuesday", "10:30 AM - 11:30 AM", "English", "Room 105", "Ms. Davis"},
        {"Wednesday", "1:00 PM - 2:00 PM", "History", "Room 201", "Mr. Brown"}
    };
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Class Schedule - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="schedule" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-clock"></i> Class Schedule</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Your Weekly Schedule</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="schedule-table">
                        <thead>
                            <tr>
                                <th>Day</th>
                                <th>Time</th>
                                <th>Subject</th>
                                <th>Room</th>
                                <th>Teacher</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < schedule.length; i++) { %>
                                <tr class="schedule-row">
                                    <td><%= schedule[i][0] %></td>
                                    <td><%= schedule[i][1] %></td>
                                    <td><%= schedule[i][2] %></td>
                                    <td><%= schedule[i][3] %></td>
                                    <td><%= schedule[i][4] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < schedule.length; i++) { %>
                        <div class="schedule-card">
                            <div class="card-header">
                                <h4><%= schedule[i][2] %></h4>
                                <span class="schedule-time"><%= schedule[i][1] %></span>
                            </div>
                            <div class="card-body">
                                <p><strong>Day:</strong> <%= schedule[i][0] %></p>
                                <p><strong>Room:</strong> <%= schedule[i][3] %></p>
                                <p><strong>Teacher:</strong> <%= schedule[i][4] %></p>
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