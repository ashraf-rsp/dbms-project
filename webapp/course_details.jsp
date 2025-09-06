<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="db_connection.jsp" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    String courseIdParam = request.getParameter("courseId");
    int courseId = -1;
    if (courseIdParam != null && !courseIdParam.isEmpty()) {
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            // Handle error: invalid courseId
            response.sendRedirect("error.jsp?message=Invalid Course ID.");
            return;
        }
    }

    String courseName = "";
    String courseDescription = "";
    double courseFee = 0.0;

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String sql = "SELECT CourseName, CourseDescription, CourseFee FROM Courses WHERE CourseID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, courseId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            courseName = rs.getString("CourseName");
            courseDescription = rs.getString("CourseDescription");
            courseFee = rs.getDouble("CourseFee");
        } else {
            response.sendRedirect("error.jsp?message=Course not found.");
            return;
        }
    } catch (Exception e) {
        System.err.println("Error loading course details: " + e.getMessage());
        response.sendRedirect("error.jsp?message=Error loading course details.");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title><%= courseName %> Details - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="my_courses" />
        </jsp:include>
        <main class="container">
            <h1><%= courseName %></h1>
            <p><strong>Course ID:</strong> <%= courseId %></p>
            <p><strong>Description:</strong> <%= courseDescription %></p>
            <p><strong>Fee:</strong> $<%= String.format("%.2f", courseFee) %></p>

            <%
                // Display content based on user role
                if ("Teacher".equals(userRole)) {
            %>
                <h2>Enrolled Students</h2>
                <div class="student-list">
                    <%
                        PreparedStatement pstmtStudents = null;
                        ResultSet rsStudents = null;
                        try {
                            String sqlStudents = "SELECT s.StudentID, s.StudentName, e.EnrollmentID FROM Students s JOIN Enrollments e ON s.StudentID = e.StudentID WHERE e.CourseID = ?";
                            pstmtStudents = conn.prepareStatement(sqlStudents);
                            pstmtStudents.setInt(1, courseId);
                            rsStudents = pstmtStudents.executeQuery();
                            if (!rsStudents.isBeforeFirst()) { // Check if ResultSet is empty
                                out.println("<p>No students enrolled in this course yet.</p>");
                            } else {
                                while (rsStudents.next()) {
                    %>
                                <div class="student-item">
                                    <h3><%= rsStudents.getString("StudentName") %></h3>
                                    <p>Student ID: <%= rsStudents.getString("StudentID") %></p>
                                    <a href="mark_attendance.jsp?enrollmentId=<%= rsStudents.getInt("EnrollmentID") %>" class="button">Mark Attendance</a>
                                    <a href="update_grades.jsp?enrollmentId=<%= rsStudents.getInt("EnrollmentID") %>" class="button">Update Grades</a>
                                </div>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading students for teacher: " + e.getMessage());
                            out.println("<p>Error loading students. Please try again.</p>");
                        } finally {
                            if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmtStudents != null) try { pstmtStudents.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
            <%
                } else if ("Parent".equals(userRole)) {
            %>
                <h2>My Children in this Course</h2>
                <div class="student-list">
                    <%
                        PreparedStatement pstmtParentStudents = null;
                        ResultSet rsParentStudents = null;
                        try {
                            // Get ParentID from Users table
                            String sqlGetParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
                            PreparedStatement pstmtGetParentId = conn.prepareStatement(sqlGetParentId);
                            pstmtGetParentId.setInt(1, userId);
                            ResultSet rsParentId = pstmtGetParentId.executeQuery();
                            Integer parentId = null;
                            if (rsParentId.next()) {
                                parentId = rsParentId.getInt("ParentID");
                            }
                            rsParentId.close();
                            pstmtGetParentId.close();

                            if (parentId != null) {
                                String sqlParentStudents = "SELECT s.StudentID, s.StudentName, e.EnrollmentID FROM Students s JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID JOIN Enrollments e ON s.StudentID = e.StudentID WHERE spl.ParentID = ? AND e.CourseID = ?";
                                pstmtParentStudents = conn.prepareStatement(sqlParentStudents);
                                pstmtParentStudents.setInt(1, parentId);
                                pstmtParentStudents.setInt(2, courseId);
                                rsParentStudents = pstmtParentStudents.executeQuery();
                                if (!rsParentStudents.isBeforeFirst()) {
                                    out.println("<p>None of your children are enrolled in this course.</p>");
                                } else {
                                    while (rsParentStudents.next()) {
                    %>
                                    <div class="student-item">
                                        <h3><%= rsParentStudents.getString("StudentName") %></h3>
                                        <p>Student ID: <%= rsParentStudents.getString("StudentID") %></p>
                                        <a href="view_attendance.jsp?enrollmentId=<%= rsParentStudents.getInt("EnrollmentID") %>" class="button">View Attendance</a>
                                        <a href="view_grades.jsp?enrollmentId=<%= rsParentStudents.getInt("EnrollmentID") %>" class="button">View Grades</a>
                                    </div>
                    <%
                                    }
                                }
                            } else {
                                out.println("<p>No children associated with your account.</p>");
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading parent's students for course: " + e.getMessage());
                            out.println("<p>Error loading student information. Please try again.</p>");
                        } finally {
                            if (rsParentStudents != null) try { rsParentStudents.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmtParentStudents != null) try { pstmtParentStudents.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
            <%
                } else if ("Student".equals(userRole)) {
            %>
                <h2>My Performance in this Course</h2>
                <div class="performance-details">
                    <%
                        PreparedStatement pstmtStudentPerformance = null;
                        ResultSet rsStudentPerformance = null;
                        try {
                            // Get StudentID from Users table
                            String sqlGetStudentId = "SELECT StudentID FROM Students WHERE UserID = ?";
                            PreparedStatement pstmtGetStudentId = conn.prepareStatement(sqlGetStudentId);
                            pstmtGetStudentId.setInt(1, userId);
                            ResultSet rsStudentId = pstmtGetStudentId.executeQuery();
                            String studentId = null;
                            if (rsStudentId.next()) {
                                studentId = rsStudentId.getString("StudentID");
                            }
                            rsStudentId.close();
                            pstmtGetStudentId.close();

                            if (studentId != null) {
                                String sqlEnrollment = "SELECT EnrollmentID FROM Enrollments WHERE StudentID = ? AND CourseID = ?";
                                PreparedStatement pstmtEnrollment = conn.prepareStatement(sqlEnrollment);
                                pstmtEnrollment.setString(1, studentId);
                                pstmtEnrollment.setInt(2, courseId);
                                ResultSet rsEnrollment = pstmtEnrollment.executeQuery();
                                Integer enrollmentId = null;
                                if (rsEnrollment.next()) {
                                    enrollmentId = rsEnrollment.getInt("EnrollmentID");
                                }
                                rsEnrollment.close();
                                pstmtEnrollment.close();

                                if (enrollmentId != null) {
                    %>
                                    <p><a href="view_attendance.jsp?enrollmentId=<%= enrollmentId %>" class="button">View My Attendance</a></p>
                                    <p><a href="view_grades.jsp?enrollmentId=<%= enrollmentId %>" class="button">View My Grades</a></p>
                    <%
                                } else {
                                    out.println("<p>You are not enrolled in this course.</p>");
                                }
                            } else {
                                out.println("<p>Student information not found.</p>");
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading student performance: " + e.getMessage());
                            out.println("<p>Error loading performance details. Please try again.</p>");
                        } finally {
                            if (rsStudentPerformance != null) try { rsStudentPerformance.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmtStudentPerformance != null) try { pstmtStudentPerformance.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
            <%
                } else { // Admin or other roles
            %>
                <p>Additional details for this course are available based on your role.</p>
            <%
                }
            %>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
