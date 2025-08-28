<%
    String currentPage = (String) request.getAttribute("activePage");
    if (currentPage == null) currentPage = "";
    String userRole = (String) request.getAttribute("userRole"); // Retrieve userRole from request attribute
%>

<nav class="sidebar" id="sidebar">
    <ul class="nav-menu">
        <li><a href="index.jsp" class="<%= currentPage.equals("dashboard") ? "active" : "" %>">
            <i class="fas fa-home"></i> Dashboard</a></li>
        <% if ("Student".equals(userRole) || "Parent".equals(userRole) || "Teacher".equals(userRole)) { %>
        <li><a href="profile_redirect.jsp" class="<%= currentPage.equals("profile") ? "active" : "" %>">
            <i class="fas fa-user"></i> Profile</a></li>
        <% } %>
        <li><a href="view_grades.jsp" class="<%= currentPage.equals("grades") ? "active" : "" %>">
            <i class="fas fa-chart-line"></i> View Grades</a></li>
        <% if ("Teacher".equals(userRole)) { %>
        <li><a href="teacher_profile.jsp" class="<%= currentPage.equals("profile") ? "active" : "" %>">
            <i class="fas fa-user"></i> Teacher Profile</a></li>
        <% } %>
        <li><a href="view_attendance.jsp" class="<%= currentPage.equals("attendance") ? "active" : "" %>">
            <i class="fas fa-calendar-check"></i> Attendance</a></li>
        <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
            <i class="fas fa-envelope"></i> Messages</a></li>
        <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
            <i class="fas fa-bullhorn"></i> Announcements</a></li>
        <li><a href="class_schedule.jsp" class="<%= currentPage.equals("schedule") ? "active" : "" %>">
            <i class="fas fa-clock"></i> Schedule</a></li>
        <li><a href="teacher_list.jsp" class="<%= currentPage.equals("teachers") ? "active" : "" %>">
            <i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
        <li><a href="course_management.jsp" class="<%= currentPage.equals("courses") ? "active" : "" %>">
            <i class="fas fa-book"></i> Courses</a></li>
<%
    // Check if the logged-in user is an Admin
    if ("Admin".equals(userRole)) {
%>
        <li><a href="user_management.jsp" class="<%= currentPage.equals("user_management") ? "active" : "" %>">
            <i class="fas fa-users-cog"></i> User Management</a></li>
<%
    } else if ("Teacher".equals(userRole)) {
%>
        <li><a href="teacher_dashboard.jsp" class="<%= currentPage.equals("teacher_dashboard") ? "active" : "" %>">
            <i class="fas fa-chalkboard-teacher"></i> Teacher Dashboard</a></li>
<%
    } else if ("Parent".equals(userRole)) {
%>
        <li><a href="view_payments.jsp" class="<%= currentPage.equals("payments") ? "active" : "" %>">
            <i class="fas fa-dollar-sign"></i> Payments</a></li>
<%
    }
%>
    </ul>
</nav>