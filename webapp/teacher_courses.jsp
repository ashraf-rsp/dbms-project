<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter handles access control. This page is for Teachers.
    String userRole = (String) session.getAttribute("userRole");
    if (!"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Integer teacherUserId = (Integer) session.getAttribute("userId");
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>My Courses - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="my_courses" />
        </jsp:include>
        <main class="container">
            <h1>My Courses</h1>
            <div class="course-list">
                <%
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        String sql = "SELECT c.CourseID, c.CourseName, c.CourseDescription FROM Courses c JOIN Schedules s ON c.CourseID = s.CourseID WHERE s.TeacherUserID = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, teacherUserId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                %>
                <div class="course-item">
                    <h3><%= rs.getString("CourseName") %></h3>
                    <p><strong>Course ID:</strong> <%= rs.getString("CourseID") %></p>
                    <p><strong>Description:</strong> <%= rs.getString("CourseDescription") %></p>
                    <div class="course-actions">
                        <a href="course_details.jsp?courseId=<%= rs.getString("CourseID") %>" class="button">View Details</a>
                    </div>
                </div>
                <%
                        }
                    } catch (Exception e) {
                        System.err.println("Error loading courses: " + e.getMessage());
                        out.println("<p>Error loading courses. Please try again.</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </div>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
