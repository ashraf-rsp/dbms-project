<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter handles access control. This page is for Admins.
    String status = request.getParameter("status");
    String message = request.getParameter("message");
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Assign Teacher to Course - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="assign_teacher" />
        </jsp:include>
        <main class="container">
            <h1>Assign Teacher to Course</h1>
            <section class="assign-teacher-section">
                <h2>Select Teacher and Course</h2>
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
                <form action="assign_teacher_process.jsp" method="post">
                    <div class="form-group">
                        <label for="teacherId">Teacher:</label>
                        <select id="teacherId" name="teacherId" required>
                            <option value="">-- Select Teacher --</option>
                            <%
                                PreparedStatement pstmtTeachers = null;
                                ResultSet rsTeachers = null;
                                try {
                                    String sqlTeachers = "SELECT UserID, Username FROM Users WHERE UserType = 'Teacher' ORDER BY Username";
                                    pstmtTeachers = conn.prepareStatement(sqlTeachers);
                                    rsTeachers = pstmtTeachers.executeQuery();
                                    while (rsTeachers.next()) {
                            %>
                            <option value="<%= rsTeachers.getInt("UserID") %>"><%= rsTeachers.getString("Username") %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error loading teachers: " + e.getMessage());
                                } finally {
                                    if (rsTeachers != null) try { rsTeachers.close(); } catch (SQLException e) { /* ignore */ }
                                    if (pstmtTeachers != null) try { pstmtTeachers.close(); } catch (SQLException e) { /* ignore */ }
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
                    <button type="submit" class="button primary-button"><i class="fas fa-check-circle"></i> Assign Teacher</button>
                </form>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
