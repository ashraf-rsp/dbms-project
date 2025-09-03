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
    <title>Mark Attendance - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="mark_attendance" />
        </jsp:include>
        <main class="container">
            <h1>Mark Attendance</h1>
            <section class="mark-attendance-section">
                <form action="mark_attendance.jsp" method="get">
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
                    <div class="form-group">
                        <label for="sessionDate">Date:</label>
                        <input type="date" id="sessionDate" name="sessionDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                    </div>
                </form>

                <% if (request.getParameter("courseId") != null) { %>
                <form action="mark_attendance_process.jsp" method="post">
                    <input type="hidden" name="courseId" value="<%= request.getParameter("courseId") %>">
                    <input type="hidden" name="sessionDate" value="<%= request.getParameter("sessionDate") %>">
                    <div class="data-table-container">
                        <div class="responsive-table">
                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Attendance Status</th>
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
                                            <input type="radio" name="attendance_<%= rsStudents.getString("StudentID") %>" value="Present" checked> Present
                                            <input type="radio" name="attendance_<%= rsStudents.getString("StudentID") %>" value="Absent"> Absent
                                            <input type="radio" name="attendance_<%= rsStudents.getString("StudentID") %>" value="Late"> Late
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
                    <button type="submit" class="button primary-button">Submit Attendance</button>
                </form>
                <% } %>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
