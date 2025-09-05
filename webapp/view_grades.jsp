<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || (!"Parent".equals(userRole) && !"Teacher".equals(userRole) && !"Student".equals(userRole))) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Integer parentId = null;
    Integer teacherId = null;

    if ("Parent".equals(userRole)) {
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
    } else if ("Teacher".equals(userRole)) {
        teacherId = userId;
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>View Grades - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="view_grades" />
        </jsp:include>
        <main class="container">
            <h1>View Grades</h1>
            <section class="view-grades-section">
                <div class="data-table-container">
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Course</th>
                                    <th>Grade (%)</th>
                                    <th>Grade (Letter)</th>
                                    <th>Graded By</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement pstmt_grades = null;
                                    ResultSet rs_grades = null;
                                    try {
                                        String sqlGrades = "";
                                        if ("Parent".equals(userRole) && parentId != null) {
                                            sqlGrades = "SELECT s.StudentName, c.CourseName, g.GradePercentage, g.GradeLetter, u.Username AS GradedBy, g.GradeDate FROM Grades g JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Users u ON g.GradedByUserID = u.UserID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID WHERE spl.ParentID = ? ORDER BY g.GradeDate DESC";
                                            pstmt_grades = conn.prepareStatement(sqlGrades);
                                            pstmt_grades.setInt(1, parentId);
                                        } else if ("Teacher".equals(userRole) && teacherId != null) {
                                            sqlGrades = "SELECT s.StudentName, c.CourseName, g.GradePercentage, g.GradeLetter, u.Username AS GradedBy, g.GradeDate FROM Grades g JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Users u ON g.GradedByUserID = u.UserID JOIN Schedules sch ON c.CourseID = sch.CourseID WHERE sch.TeacherUserID = ? ORDER BY g.GradeDate DESC";
                                            pstmt_grades = conn.prepareStatement(sqlGrades);
                                            pstmt_grades.setInt(1, teacherId);
                                        } else if ("Student".equals(userRole) && userId != null) {
                                            sqlGrades = "SELECT s.StudentName, c.CourseName, g.GradePercentage, g.GradeLetter, u.Username AS GradedBy, g.GradeDate FROM Grades g JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Users u ON g.GradedByUserID = u.UserID WHERE s.UserID = ? ORDER BY g.GradeDate DESC";
                                            pstmt_grades = conn.prepareStatement(sqlGrades);
                                            pstmt_grades.setInt(1, userId);
                                        }

                                        if (pstmt_grades != null) {
                                            rs_grades = pstmt_grades.executeQuery();
                                            if (!rs_grades.isBeforeFirst()) {
                                                out.println("<tr><td colspan=\"6\">No grade records found.</td></tr>");
                                            } else {
                                                while (rs_grades.next()) {
                                %>
                                <tr>
                                    <td><%= rs_grades.getString("StudentName") %></td>
                                    <td><%= rs_grades.getString("CourseName") %></td>
                                    <td><%= rs_grades.getDouble("GradePercentage") %></td>
                                    <td><%= rs_grades.getString("GradeLetter") %></td>
                                    <td><%= rs_grades.getString("GradedBy") %></td>
                                    <td><%= rs_grades.getDate("GradeDate") %></td>
                                </tr>
                                <%
                                                }
                                            }
                                        }
                                    } catch (Exception e) {
                                        session.setAttribute("message", "Error loading grade records: " + e.getMessage());
                                        session.setAttribute("status", "error");
                                    } finally {
                                        if (rs_grades != null) try { rs_grades.close(); } catch (SQLException e) { /* ignore */ }
                                        if (pstmt_grades != null) try { pstmt_grades.close(); } catch (SQLException e) { /* ignore */ }
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
