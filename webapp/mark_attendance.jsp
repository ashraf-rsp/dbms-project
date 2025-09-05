<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || !"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Integer teacherId = userId; // Use userId from AuthFilter

%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
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
                                    session.setAttribute("message", "Error loading courses: " + e.getMessage());
                                    session.setAttribute("status", "error");
                                } finally {
                                    if (rsCourses != null) try { rsCourses.close(); } catch (SQLException e) { /* ignore */ } 
                                    if (pstmtCourses != null) try { pstmtCourses.close(); } catch (SQLException e) { /* ignore */ } 
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="sessionDate">Date:</label>
                        <input type="date" id="sessionDate" name="sessionDate" value="<%= request.getParameter("sessionDate") != null ? request.getParameter("sessionDate") : new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
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
                                            String sessionDate = request.getParameter("sessionDate");

                                            // Check if attendance has already been marked for this session
                                            boolean attendanceMarked = false;
                                            String sqlCheckAttendance = "SELECT COUNT(*) FROM Attendance WHERE CourseID = ? AND AttendanceDate = ?";
                                            PreparedStatement pstmtCheckAttendance = conn.prepareStatement(sqlCheckAttendance);
                                            pstmtCheckAttendance.setInt(1, courseId);
                                            pstmtCheckAttendance.setString(2, sessionDate);
                                            ResultSet rsCheckAttendance = pstmtCheckAttendance.executeQuery();
                                            if (rsCheckAttendance.next() && rsCheckAttendance.getInt(1) > 0) {
                                                attendanceMarked = true;
                                            }
                                            rsCheckAttendance.close();
                                            pstmtCheckAttendance.close();

                                            if (attendanceMarked) {
                                                out.println("<tr><td colspan=\"2\"><div class=\"alert alert-info\">Attendance for this session has already been marked.</div></td></tr>");
                                            }

                                            String sqlStudents = "SELECT s.StudentID, s.StudentName, a.Status FROM Students s JOIN Enrollments e ON s.StudentID = e.StudentID LEFT JOIN Attendance a ON s.StudentID = a.StudentID AND a.CourseID = ? AND a.AttendanceDate = ? WHERE e.CourseID = ? ORDER BY s.StudentName";
                                            pstmtStudents = conn.prepareStatement(sqlStudents);
                                            pstmtStudents.setInt(1, courseId);
                                            pstmtStudents.setString(2, sessionDate);
                                            pstmtStudents.setInt(3, courseId);
                                            rsStudents = pstmtStudents.executeQuery();
                                            while (rsStudents.next()) {
                                                String studentId = rsStudents.getString("StudentID");
                                                String studentName = rsStudents.getString("StudentName");
                                                String status = rsStudents.getString("Status");

                                                String presentChecked = "Present".equals(status) ? "checked" : "";
                                                String absentChecked = "Absent".equals(status) ? "checked" : "";
                                                String lateChecked = "Late".equals(status) ? "checked" : "";
                                    %>
                                    <tr>
                                        <td><%= studentName %></td>
                                        <td>
                                            <input type="radio" name="attendance_<%= studentId %>" value="Present" <%= presentChecked %>> Present
                                            <input type="radio" name="attendance_<%= studentId %>" value="Absent" <%= absentChecked %>> Absent
                                            <input type="radio" name="attendance_<%= studentId %>" value="Late" <%= lateChecked %>> Late
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } catch (Exception e) {
                                            session.setAttribute("message", "Error loading students: " + e.getMessage());
                                            session.setAttribute("status", "error");
                                        } finally {
                                            if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) { /* ignore */ } 
                                            if (pstmtStudents != null) try { pstmtStudents.close(); } catch (SQLException e) { /* ignore */ } 
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
