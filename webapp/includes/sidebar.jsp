<%
    String currentPage = (String) request.getAttribute("activePage");
    if (currentPage == null) currentPage = "";
    String userRole = (String) session.getAttribute("userRole");
%>

<nav class="sidebar" id="sidebar">
    <ul class="nav-menu">
        <li><a href="dashboard.jsp" class="<%= currentPage.equals("dashboard") ? "active" : "" %>">
            <i class="fas fa-home"></i> Dashboard</a></li>

        <% if ("Admin".equals(userRole)) { %>
            
            <li><a href="user_management.jsp" class="<%= currentPage.equals("user_management") ? "active" : "" %>">
                <i class="fas fa-users-cog"></i> User Management</a></li>
            <li><a href="course_management.jsp" class="<%= currentPage.equals("course_management") ? "active" : "" %>">
                <i class="fas fa-book"></i> Course Management</a></li>
            <li><a href="assign_teacher.jsp" class="<%= currentPage.equals("assign_teacher") ? "active" : "" %>">
                <i class="fas fa-chalkboard-teacher"></i> Assign Teacher</a></li>
            <li><a href="enroll_student.jsp" class="<%= currentPage.equals("enroll_student") ? "active" : "" %>">
                <i class="fas fa-user-plus"></i> Enroll Student</a></li>
            <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
                <i class="fas fa-bullhorn"></i> Announcements</a></li>
            <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
                <i class="fas fa-envelope"></i> Messages</a></li>
            <li><a href="teacher_list.jsp" class="<%= currentPage.equals("teacher_list") ? "active" : "" %>">
                <i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
            <li><a href="class_schedule.jsp" class="<%= currentPage.equals("class_schedule") ? "active" : "" %>">
                <i class="fas fa-clock"></i> Class Schedule</a></li>

        <% } else if ("Teacher".equals(userRole)) { %>
            
            <li><a href="teacher_courses.jsp" class="<%= currentPage.equals("my_courses") ? "active" : "" %>">
                <i class="fas fa-book"></i> My Courses</a></li>
            <li><a href="mark_attendance.jsp" class="<%= currentPage.equals("mark_attendance") ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> Mark Attendance</a></li>
            <li><a href="update_grades.jsp" class="<%= currentPage.equals("update_grades") ? "active" : "" %>">
                <i class="fas fa-chart-line"></i> Update Grades</a></li>
            <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
                <i class="fas fa-bullhorn"></i> Announcements</a></li>
            <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
                <i class="fas fa-envelope"></i> Messages</a></li>
            <li><a href="class_schedule.jsp" class="<%= currentPage.equals("class_schedule") ? "active" : "" %>">
                <i class="fas fa-clock"></i> Class Schedule</a></li>

        <% } else if ("Parent".equals(userRole)) { %>
            
            <li><a href="parent_courses.jsp" class="<%= currentPage.equals("my_children_courses") ? "active" : "" %>">
                <i class="fas fa-book"></i> My Children's Courses</a></li>
            <li><a href="view_grades.jsp" class="<%= currentPage.equals("view_grades") ? "active" : "" %>">
                <i class="fas fa-chart-line"></i> View Grades</a></li>
            <li><a href="view_attendance.jsp" class="<%= currentPage.equals("view_attendance") ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> View Attendance</a></li>
            <li><a href="view_payments.jsp" class="<%= currentPage.equals("view_payments") ? "active" : "" %>">
                <i class="fas fa-dollar-sign"></i> View Payments</a></li>
            <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
                <i class="fas fa-bullhorn"></i> Announcements</a></li>
            <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
                <i class="fas fa-envelope"></i> Messages</a></li>
            <li><a href="class_schedule.jsp" class="<%= currentPage.equals("class_schedule") ? "active" : "" %>">
                <i class="fas fa-clock"></i> Class Schedule</a></li>

        <% } else if ("Student".equals(userRole)) { %>
            
            <li><a href="student_courses.jsp" class="<%= currentPage.equals("my_courses") ? "active" : "" %>">
                <i class="fas fa-book"></i> My Courses</a></li>
            <li><a href="view_grades.jsp" class="<%= currentPage.equals("view_grades") ? "active" : "" %>">
                <i class="fas fa-chart-line"></i> View Grades</a></li>
            <li><a href="view_attendance.jsp" class="<%= currentPage.equals("view_attendance") ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> View Attendance</a></li>
            <li><a href="class_schedule.jsp" class="<%= currentPage.equals("class_schedule") ? "active" : "" %>">
                <i class="fas fa-clock"></i> Class Schedule</a></li>
            <li><a href="announcements.jsp" class="<%= currentPage.equals("announcements") ? "active" : "" %>">
                <i class="fas fa-bullhorn"></i> Announcements</a></li>
            <li><a href="messages.jsp" class="<%= currentPage.equals("messages") ? "active" : "" %>">
                <i class="fas fa-envelope"></i> Messages</a></li>
        <% } %>
    </ul>
    <div class="sidebar-bottom-actions">
        <a href="profile_redirect.jsp" class="<%= currentPage.equals("profile") ? "active" : "" %>">
            <i class="fas fa-user"></i>
            <span>Profile</span>
        </a>
        <a href="logout.jsp">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</nav>