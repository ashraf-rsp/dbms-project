<%@ page import="java.sql.*, java.util.*" %>

<%
    int studentCount = 0;
    int teacherCount = 0;
    int courseCount = 0;
    int pendingUsersCount = 0;

    try {
        // Get Student Count
        PreparedStatement psStudent = conn.prepareStatement("SELECT COUNT(*) FROM Students");
        ResultSet rsStudent = psStudent.executeQuery();
        if (rsStudent.next()) {
            studentCount = rsStudent.getInt(1);
        }

        // Get Teacher Count
        PreparedStatement psTeacher = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE UserType = 'Teacher'");
        ResultSet rsTeacher = psTeacher.executeQuery();
        if (rsTeacher.next()) {
            teacherCount = rsTeacher.getInt(1);
        }

        // Get Course Count
        PreparedStatement psCourse = conn.prepareStatement("SELECT COUNT(*) FROM Courses");
        ResultSet rsCourse = psCourse.executeQuery();
        if (rsCourse.next()) {
            courseCount = rsCourse.getInt(1);
        }

        // Get Pending Users Count
        PreparedStatement psPending = conn.prepareStatement("SELECT COUNT(*) FROM Users WHERE RegistrationCode IS NOT NULL");
        ResultSet rsPending = psPending.executeQuery();
        if (rsPending.next()) {
            pendingUsersCount = rsPending.getInt(1);
        }

    } catch (Exception e) {
        // Basic error handling
        e.printStackTrace();
    }
%>

<div class="summary-cards-grid">
    <div class="summary-card">
        <div class="card-icon"><i class="fas fa-user-graduate"></i></div>
        <div class="card-info">
            <h3>Total Students</h3>
            <p><%= studentCount %></p>
        </div>
    </div>
    <div class="summary-card">
        <div class="card-icon"><i class="fas fa-chalkboard-teacher"></i></div>
        <div class="card-info">
            <h3>Total Teachers</h3>
            <p><%= teacherCount %></p>
        </div>
    </div>
    <div class="summary-card">
        <div class="card-icon"><i class="fas fa-book"></i></div>
        <div class="card-info">
            <h3>Total Courses</h3>
            <p><%= courseCount %></p>
        </div>
    </div>
    <div class_="summary-card">
        <div class="card-icon"><i class="fas fa-user-plus"></i></div>
        <div class="card-info">
            <h3>Pending Registrations</h3>
            <p><%= pendingUsersCount %></p>
        </div>
    </div>
</div>

<div class="data-table-container">
    <div class="table-header">
        <h3>Recent Activities</h3>
    </div>
    <div class="responsive-table">
        <table class="dashboard-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Action</th>
                    <th>Timestamp</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Admin</td>
                    <td>Updated system settings</td>
                    <td>2025-08-30 10:00 AM</td>
                </tr>
                <!-- Add more dynamic rows here -->
            </tbody>
        </table>
    </div>
</div>