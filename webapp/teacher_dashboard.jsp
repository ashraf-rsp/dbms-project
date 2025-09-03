<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Teacher can access this page
    
    

    if (userRole == null || !userRole.equals("Teacher") || teacherUserId == null) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Teacher Dashboard - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="teacher_dashboard" />
        </jsp:include>
        
        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-chalkboard-teacher"></i> Teacher Dashboard</h2>
                </div>

                <% if (message != null) { %>
                    <p style="color: green;"><%= message %></p>
                <% } %>

                <h3>My Assigned Courses</h3>
                <div class="data-table-container">
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Course ID</th>
                                    <th>Course Name</th>
                                    <th>Description</th>
                                    <th>Fee</th>
                                    <th>Schedule</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        
                                        String sql = "SELECT c.CourseID, c.CourseName, c.CourseDescription, c.CourseFee, s.DayOfWeek, s.StartTime, s.EndTime, s.Room " +
                                                     "FROM Courses c " +
                                                     "JOIN Schedules s ON c.CourseID = s.CourseID " +
                                                     "WHERE s.TeacherUserID = ? ORDER BY c.CourseName";
                                        pstmt = conn.prepareStatement(sql);
                                        pstmt.setInt(1, teacherUserId);
                                        rs = pstmt.executeQuery();
                                        if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                            out.println("<tr><td colspan=\"6\">No courses assigned to you yet.</td></tr>");
                                        } else {
                                            while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("CourseID") %></td>
                                    <td><%= rs.getString("CourseName") %></td>
                                    <td><%= rs.getString("CourseDescription") %></td>
                                    <td>$<%= String.format("%.2f", rs.getDouble("CourseFee")) %></td>
                                    <td><%= rs.getString("DayOfWeek") %> <%= rs.getString("StartTime") %> - <%= rs.getString("EndTime") %> (<%= rs.getString("Room") %>)</td>
                                    <td>
                                        <a href="mark_attendance.jsp?courseId=<%= rs.getInt("CourseID") %>" class="button small">Mark Attendance</a>
                                        <a href="update_grades.jsp?courseId=<%= rs.getInt("CourseID") %>" class="button small">Update Grades</a>
                                    </td>
                                </tr>
                                <% 
                                            }
                                        }
                                    } catch (SQLException e) {
                                        // Log error
                                        e.printStackTrace();
                                        out.println("<tr><td colspan=\"6\">Error loading courses: " + e.getMessage() + "</td></tr>");
                                    } finally {
                                        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                                        
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
