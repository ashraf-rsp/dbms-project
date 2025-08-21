<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for Dashboard
    

    // Recent Attendance Mock Data
    String[][] recentAttendance = {
        {"Math 101", "2025-08-15", "Absent"},
        {"Math 101", "2025-08-14", "Present"},
        {"Math 101", "2025-08-13", "Present"},
        {"Math 101", "2025-08-12", "Absent"},
        {"Math 101", "2025-08-11", "Present"},
        {"Math 101", "2025-08-10", "Present"}
    };

    // Upcoming Events Mock Data
    String[][] upcomingEvents = {
        {"Summer Break", "Holiday", "2025-08-20"},
        {"Midterm Exam", "Test", "2025-09-01"},
        {"Project Deadline", "Deadline", "2025-09-15"}
    };

    // Fee Status Mock Data
    double totalFee = 500.0;
    double totalPaid = 350.0;
    double outstandingBalance = totalFee - totalPaid;
%>
<%@ include file="includes/auth_check.jspf" %>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Dashboard - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>
        
        <main class="content-area">
            <div class="container"> <%-- Add this container --%>
                <div class="page-header">
                    <h2><i class="fas fa-tachometer-alt"></i> Parent Dashboard</h2>
                </div>
                
                <div class="summary-cards-grid">
                    <div class="summary-card">
                        <h3>Welcome, <%= parentName %>!</h3>
                        <p>Here's a quick overview of your student's academic status.</p>
                    </div>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <h3>Recent Attendance</h3>
                    </div>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Course</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < recentAttendance.length; i++) { %>
                                    <tr>
                                        <td><%= recentAttendance[i][0] %></td>
                                        <td><%= recentAttendance[i][1] %></td>
                                        <td><span class="status-badge status-<%= recentAttendance[i][2].toLowerCase() %>"><%= recentAttendance[i][2] %></span></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <div class="mobile-cards">
                        <% for (int i = 0; i < recentAttendance.length; i++) { %>
                            <div class="attendance-card">
                                <div class="card-header">
                                    <h4><%= recentAttendance[i][0] %></h4>
                                    <span class="status-badge status-<%= recentAttendance[i][2].toLowerCase() %>"><%= recentAttendance[i][2] %></span>
                                </div>
                                <div class="card-body">
                                    <p><strong>Date:</strong> <%= recentAttendance[i][1] %></p>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <h3>Upcoming Events</h3>
                    </div>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Event</th>
                                    <th>Type</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < upcomingEvents.length; i++) { %>
                                    <tr>
                                        <td><%= upcomingEvents[i][0] %></td>
                                        <td><%= upcomingEvents[i][1] %></td>
                                        <td><%= upcomingEvents[i][2] %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <div class="mobile-cards">
                        <% for (int i = 0; i < upcomingEvents.length; i++) { %>
                            <div class="event-card">
                                <div class="card-header">
                                    <h4><%= upcomingEvents[i][0] %></h4>
                                    <span class="event-type"><%= upcomingEvents[i][1] %></span>
                                </div>
                                <div class="card-body">
                                    <p><strong>Date:</strong> <%= upcomingEvents[i][2] %></p>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="summary-card">
                    <h3>Fee Status</h3>
                    <p><strong>Total Fee:</strong> $<%= String.format("%.2f", totalFee) %></p>
                    <p><strong>Total Paid:</strong> $<%= String.format("%.2f", totalPaid) %></p>
                    <p><strong>Outstanding Balance:</strong> $<%= String.format("%.2f", outstandingBalance) %></p>
                </div>

            </div> <%-- Close container --%>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>