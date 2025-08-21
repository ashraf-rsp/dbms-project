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

    int courseId = -1;
    String courseIdParam = request.getParameter("courseId");
    if (courseIdParam != null && !courseIdParam.isEmpty()) {
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid Course ID.");
            response.sendRedirect("teacher_dashboard.jsp");
            return;
        }
    }

    if (courseId == -1) {
        session.setAttribute("message", "Course ID is missing.");
        response.sendRedirect("teacher_dashboard.jsp");
        return;
    }

    
    String courseName = "";

    try {
        

        // Get course name
        String sqlCourse = "SELECT CourseName FROM Courses WHERE CourseID = ?";
        pstmt = conn.prepareStatement(sqlCourse);
        pstmt.setInt(1, courseId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            courseName = rs.getString("CourseName");
        } else {
            session.setAttribute("message", "Course not found.");
            response.sendRedirect("teacher_dashboard.jsp");
            return;
        }
        rs.close();
        pstmt.close();

    } catch (SQLException e) {
        session.setAttribute("message", "Database error: " + e.getMessage());
        response.sendRedirect("teacher_dashboard.jsp");
        return;
    } catch (ClassNotFoundException e) {
        session.setAttribute("message", "Server configuration error: JDBC Driver not found.");
        response.sendRedirect("teacher_dashboard.jsp");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%> 
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Update Grades - <%= courseName %></title>
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
                    <h2><i class="fas fa-graduation-cap"></i> Update Grades for <%= courseName %></h2>
                </div>

                <% if (message != null) { %>
                    <p style="color: green;"><%= message %></p>
                <% } %>

                <form action="update_grades_process.jsp" method="post">
                    <input type="hidden" name="courseId" value="<%= courseId %>">
                    <input type="hidden" name="gradedByUserId" value="<%= teacherUserId %>">

                    <h3>Students in this Course</h3>
                    <div class="data-table-container">
                        <div class="responsive-table">
                            <table class="dashboard-table">
                                <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Student Name</th>
                                        <th>Current Grade (%)</th>
                                        <th>New Grade (%)</th>
                                        <th>Grade Letter</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        Connection connStudents = null;
                                        PreparedStatement pstmtStudents = null;
                                        ResultSet rsStudents = null;
                                        try {
                                            
                                            String sqlStudents = "SELECT s.StudentID, s.FirstName, s.LastName, e.EnrollmentID, g.GradePercentage, g.GradeLetter " +
                                                                 "FROM Students s " +
                                                                 "JOIN Enrollments e ON s.StudentID = e.StudentID " +
                                                                 "LEFT JOIN Grades g ON e.EnrollmentID = g.EnrollmentID " +
                                                                 "WHERE e.CourseID = ? ORDER BY s.LastName, s.FirstName";
                                            pstmtStudents = connStudents.prepareStatement(sqlStudents);
                                            pstmtStudents.setInt(1, courseId);
                                            rsStudents = pstmtStudents.executeQuery();
                                            if (!rsStudents.isBeforeFirst()) {
                                                out.println("<tr><td colspan=\"5\">No students enrolled in this course.</td></tr>");
                                            } else {
                                                while (rsStudents.next()) {
                                    %>
                                    <tr>
                                        <td><%= rsStudents.getInt("StudentID") %></td>
                                        <td><%= rsStudents.getString("FirstName") %> <%= rsStudents.getString("LastName") %></td>
                                        <td><%= rsStudents.getString("GradePercentage") != null ? rsStudents.getString("GradePercentage") + " (" + rsStudents.getString("GradeLetter") + ")" : "N/A" %></td>
                                        <td>
                                            <input type="number" step="0.01" min="0" max="100" name="grade_<%= rsStudents.getInt("EnrollmentID") %>" value="<%= rsStudents.getString("GradePercentage") != null ? rsStudents.getString("GradePercentage") : "" %>">
                                            <input type="hidden" name="enrollmentId" value="<%= rsStudents.getInt("EnrollmentID") %>">
                                        </td>
                                        <td>
                                            <input type="text" name="gradeLetter_<%= rsStudents.getInt("EnrollmentID") %>" value="<%= rsStudents.getString("GradeLetter") != null ? rsStudents.getString("GradeLetter") : "" %>" maxlength="5">
                                        </td>
                                    </tr>
                                    <% 
                                                }
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                            out.println("<tr><td colspan=\"5\">Error loading students: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) { /* ignore */ }
                                            if (pstmtStudents != null) try { pstmtStudents.close(); } catch (SQLException e) { /* ignore */ }
                                            if (connStudents != null) try { connStudents.close(); } catch (SQLException e) { /* ignore */ }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <button type="submit" class="button primary-button">Submit Grades</button>
                </form>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
