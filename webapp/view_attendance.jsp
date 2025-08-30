<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Parent can access this page
    if (!"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    Integer parentId = null;

    if (userId != null) {
        try {
            String sqlParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
            PreparedStatement pstmt_parent = conn.prepareStatement(sqlParentId);
            pstmt_parent.setInt(1, userId);
            ResultSet rs_parent = pstmt_parent.executeQuery();
            if (rs_parent.next()) {
                parentId = rs_parent.getInt("ParentID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>View Attendance - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="view_attendance" />
        </jsp:include>
        <main class="container">
            <h1>View Attendance</h1>
            <section class="view-attendance-section">
                <div class="data-table-container">
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Course</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (parentId != null) {
                                        PreparedStatement pstmt_attendance = null;
                                        ResultSet rs_attendance = null;
                                        try {
                                            String sqlAttendance = "SELECT s.StudentName, c.CourseName, a.SessionDate, a.Status FROM Attendance a JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID WHERE spl.ParentID = ? ORDER BY a.SessionDate DESC";
                                            pstmt_attendance = conn.prepareStatement(sqlAttendance);
                                            pstmt_attendance.setInt(1, parentId);
                                            rs_attendance = pstmt_attendance.executeQuery();
                                            while (rs_attendance.next()) {
                                %>
                                <tr>
                                    <td><%= rs_attendance.getString("StudentName") %></td>
                                    <td><%= rs_attendance.getString("CourseName") %></td>
                                    <td><%= rs_attendance.getDate("SessionDate") %></td>
                                    <td><span class="status-badge status-<%= rs_attendance.getString("Status").toLowerCase() %>"><%= rs_attendance.getString("Status") %></span></td>
                                </tr>
                                <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
