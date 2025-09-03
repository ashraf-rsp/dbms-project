<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="includes/auth_check.jspf" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Admin can access this page
    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String status = request.getParameter("status");
    String message = request.getParameter("message");

%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Enroll Student in Course - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="enroll_student" />
        </jsp:include>
        <main class="container">
            <h1>Enroll Student in Course</h1>
            <section class="enroll-student-section">
                <h2>Select Student and Course</h2>
                <%
                    if (status != null && message != null) {
                        String alertClass = "";
                        if (status.equals("success")) {
                            alertClass = "alert-success";
                        } else if (status.equals("error")) {
                            alertClass = "alert-danger";
                        }
                %>
                <div class="alert <%= alertClass %>">
                    <%= message %>
                </div>
                <%
                    }
                %>
                <form action="enroll_student_process.jsp" method="post">
                    <div class="form-group">
                        <label for="studentId">Student:</label>
                        <select id="studentId" name="studentId" required>
                            <option value="">-- Select Student --</option>
                            <%
                                PreparedStatement pstmtStudents = null;
                                ResultSet rsStudents = null;
                                try {
                                    String sqlStudents = "SELECT StudentID, StudentName FROM Students ORDER BY StudentName";
                                    pstmtStudents = conn.prepareStatement(sqlStudents);
                                    rsStudents = pstmtStudents.executeQuery();
                                    if (!rsStudents.isBeforeFirst() ) {    
                                        out.println("<option value='' disabled>No students found</option>");
                                    } else {
                                        while (rsStudents.next()) {
                            %>
                            <option value="<%= rsStudents.getString("StudentID") %>"><%= rsStudents.getString("StudentName") %></option>
                            <%
                                        }
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading students: " + e.getMessage());
                                } finally {
                                    if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmtStudents != null) try { pstmtStudents.close(); } catch (SQLException e) { /* ignore */ }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="courseId">Course:</label>
                        <select id="courseId" name="courseId" required>
                            <option value="">-- Select Course --</option>
                            <%
                                PreparedStatement pstmtCourses = null;
                                ResultSet rsCourses = null;
                                try {
                                    String sqlCourses = "SELECT CourseID, CourseName FROM Courses ORDER BY CourseName";
                                    pstmtCourses = conn.prepareStatement(sqlCourses);
                                    rsCourses = pstmtCourses.executeQuery();
                                    while (rsCourses.next()) {
                            %>
                            <option value="<%= rsCourses.getInt("CourseID") %>"><%= rsCourses.getString("CourseName") %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading courses: " + e.getMessage());
                                } finally {
                                    if (rsCourses != null) try { rsCourses.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmtCourses != null) try { pstmtCourses.close(); } catch (SQLException e) { /* ignore */ }
                                }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="button primary-button"><i class="fas fa-user-plus"></i> Enroll Student</button>
                </form>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
