<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="includes/auth_check.jspf" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Teacher can access this page
    if (!"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    Integer teacherId = (Integer) session.getAttribute("userId");

%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Update Grades - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="update_grades" />
        </jsp:include>
        <main class="container">
            <h1>Update Grades</h1>
            <section class="update-grades-section">
                <form action="update_grades.jsp" method="get">
                    <div class="form-group">
                        <label for="courseId">Course:</label>
                        <select id="courseId" name="courseId" required onchange="this.form.submit()">
                            <option value="">-- Select Course --</option>
                            <%
                                PreparedStatement pstmtCourses = null;
                                ResultSet rsCourses = null;
                                try {
                                    String sqlCourses = "SELECT c.CourseID, c.CourseName FROM Courses c JOIN Schedules s ON c.CourseID = s.CourseID WHERE s.TeacherUserID = ? ORDER BY c.CourseName";
                                    pstmtCourses = conn.prepareStatement(sqlCourses);
                                    pstmtCourses.setInt(1, teacherId);
                                    rsCourses = pstmtCourses.executeQuery();
                                    while (rsCourses.next()) {
                                        String selected = "";
                                        if (request.getParameter("courseId") != null && Integer.parseInt(request.getParameter("courseId")) == rsCourses.getInt("CourseID")) {
                                            selected = "selected";
                                        }
                            %>
                            <option value="<%= rsCourses.getInt("CourseID") %>" <%= selected %>><%= rsCourses.getString("CourseName") %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading courses: " + e.getMessage());
                                }
                            %>
                        </select>
                    </div>
                </form>

                <% if (request.getParameter("courseId") != null) { %>
                <form action="update_grades_process.jsp" method="post">
                    <input type="hidden" name="courseId" value="<%= request.getParameter("courseId") %>">
                    <div class="data-table-container">
                        <div class="responsive-table">
                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Grade (%)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        PreparedStatement pstmtStudents = null;
                                        ResultSet rsStudents = null;
                                        try {
                                            int courseId = Integer.parseInt(request.getParameter("courseId"));
                                            String sqlStudents = "SELECT s.StudentID, s.StudentName FROM Students s JOIN Enrollments e ON s.StudentID = e.StudentID WHERE e.CourseID = ? ORDER BY s.StudentName";
                                            pstmtStudents = conn.prepareStatement(sqlStudents);
                                            pstmtStudents.setInt(1, courseId);
                                            rsStudents = pstmtStudents.executeQuery();
                                            while (rsStudents.next()) {
                                    %>
                                    <tr>
                                        <td><%= rsStudents.getString("StudentName") %></td>
                                        <td>
                                            <input type="number" min="0" max="100" name="grade_<%= rsStudents.getString("StudentID") %>" placeholder="Enter grade">
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            System.err.println("Error loading students: " + e.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <button type="submit" class="button primary-button">Submit Grades</button>
                </form>
                <% } %>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>