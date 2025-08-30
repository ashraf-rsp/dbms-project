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
                                    if (parentId != null) {
                                        PreparedStatement pstmt_grades = null;
                                        ResultSet rs_grades = null;
                                        try {
                                            String sqlGrades = "SELECT s.StudentName, c.CourseName, g.GradePercentage, g.GradeLetter, u.Username AS GradedBy, g.GradeDate FROM Grades g JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Users u ON g.GradedByUserID = u.UserID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID WHERE spl.ParentID = ? ORDER BY g.GradeDate DESC";
                                            pstmt_grades = conn.prepareStatement(sqlGrades);
                                            pstmt_grades.setInt(1, parentId);
                                            rs_grades = pstmt_grades.executeQuery();
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