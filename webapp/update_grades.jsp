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
                                    session.setAttribute("message", "Error loading courses: " + e.getMessage());
                                    session.setAttribute("status", "error");
                                } finally {
                                    if (rsCourses != null) try { rsCourses.close(); } catch (SQLException e) { /* ignore */ } 
                                    if (pstmtCourses != null) try { pstmtCourses.close(); } catch (SQLException e) { /* ignore */ } 
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

                                            // Check if grades have already been entered for this course
                                            boolean gradesEntered = false;
                                            String sqlCheckGrades = "SELECT COUNT(*) FROM Grades WHERE CourseID = ?";
                                            PreparedStatement pstmtCheckGrades = conn.prepareStatement(sqlCheckGrades);
                                            pstmtCheckGrades.setInt(1, courseId);
                                            ResultSet rsCheckGrades = pstmtCheckGrades.executeQuery();
                                            if (rsCheckGrades.next() && rsCheckGrades.getInt(1) > 0) {
                                                gradesEntered = true;
                                            }
                                            rsCheckGrades.close();
                                            pstmtCheckGrades.close();

                                            if (gradesEntered) {
                                                out.println("<tr><td colspan=\"2\"><div class=\"alert alert-info\">Grades for this course have already been entered.</div></td></tr>");
                                            }

                                            String sqlStudents = "SELECT s.StudentID, s.StudentName, g.GradeValue FROM Students s JOIN Enrollments e ON s.StudentID = e.StudentID LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID WHERE e.CourseID = ? ORDER BY s.StudentName";
                                            pstmtStudents = conn.prepareStatement(sqlStudents);
                                            pstmtStudents.setInt(1, courseId);
                                            rsStudents = pstmtStudents.executeQuery();
                                            while (rsStudents.next()) {
                                                String studentId = rsStudents.getString("StudentID");
                                                String studentName = rsStudents.getString("StudentName");
                                                int gradeValue = rsStudents.getInt("GradeValue");
                                                String grade = (gradeValue == 0) ? "" : String.valueOf(gradeValue);
                                    %>
                                    <tr>
                                        <td><%= studentName %></td>
                                        <td>
                                            <input type="number" min="0" max="100" name="grade_<%= studentId %>" value="<%= grade %>" placeholder="Enter grade">
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
                    <button type="submit" class="button primary-button">Submit Grades</button>
                </form>
                <% } %>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>