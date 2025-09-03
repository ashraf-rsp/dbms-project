<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");
    String loggedInUser = (String) request.getAttribute("loggedInUser");

    if (userId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    String studentIdString = null;
    String studentName = "";
    String studentDOB = "";
    String enrollmentDate = "N/A";
    String currentClass = "N/A";

    String parentFirstName = "";
    String parentLastName = "";
    String parentEmail = "";
    String parentPhone = "";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Determine which student profile to display
    // If logged in as Student, display their own profile
    // If logged in as Parent, display the profile of a child passed as a parameter
    String requestedStudentId = request.getParameter("studentId");

    // Role-based access check
    if ("Student".equals(userRole)) {
        // For student's own profile, assume StudentID is same as UserID (temporary workaround)
        studentIdString = String.valueOf(userId); // Use userId from AuthFilter
    } else if ("Parent".equals(userRole)) {
        if (requestedStudentId != null && !requestedStudentId.isEmpty()) {
            studentIdString = requestedStudentId;
            // Verify this student is linked to the parent
            Integer parentId = null;
            try {
                String sqlParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
                pstmt = conn.prepareStatement(sqlParentId);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    parentId = rs.getInt("ParentID");
                }
                rs.close();
                pstmt.close();

                if (parentId == null) {
                    out.println("<p>Parent ID not found for your user account.</p>");
                    return;
                }

                String checkLinkSql = "SELECT COUNT(*) FROM Student_Parent_Link WHERE StudentID = ? AND ParentID = ?";
                pstmt = conn.prepareStatement(checkLinkSql);
                pstmt.setString(1, studentIdString);
                pstmt.setInt(2, parentId);
                rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    out.println("<p>You are not authorized to view this student's profile.</p>");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error verifying student link.</p>");
                return;
            }
        } else {
            // If parent accesses profile page without studentId parameter, list their children
            response.sendRedirect("parent_profile.jsp"); // Redirect to parent_profile which lists children
            return;
        }
    } else { // Admin or Teacher trying to access student profile directly
        if (requestedStudentId != null && !requestedStudentId.isEmpty()) {
            studentIdString = requestedStudentId;
        } else {
            // Admin/Teacher needs to specify studentId
            out.println("<p>Please specify a student ID to view their profile.</p>");
            return;
        }
    }

    try {
        if (studentIdString != null) {
            // Get student details
            String sqlStudent = "SELECT StudentName, DOB FROM Students WHERE StudentID = ?";
            pstmt = conn.prepareStatement(sqlStudent);
            pstmt.setString(1, studentIdString);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                studentName = rs.getString("StudentName");
                studentDOB = rs.getDate("DOB") != null ? rs.getDate("DOB").toString() : "N/A";
            }
            rs.close();
            pstmt.close();

            // Get parent details linked to this student
            String sqlParentDetails = "SELECT p.FirstName, p.LastName, p.Email, p.Phone FROM Parents p " +
                                    "JOIN Student_Parent_Link spl ON p.ParentID = spl.ParentID " +
                                    "WHERE spl.StudentID = ? LIMIT 1";
            pstmt = conn.prepareStatement(sqlParentDetails);
            pstmt.setString(1, studentIdString);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                parentFirstName = rs.getString("FirstName");
                parentLastName = rs.getString("LastName");
                parentEmail = rs.getString("Email");
                parentPhone = rs.getString("Phone");
            }
            rs.close();
            pstmt.close();

            // Get current class/enrollment details
            String sqlEnrollment = "SELECT e.EnrollmentDate, c.CourseName FROM Enrollments e " +
                                 "JOIN Courses c ON e.CourseID = c.CourseID " +
                                 "WHERE e.StudentID = ? ORDER BY e.EnrollmentDate DESC LIMIT 1";
            pstmt = conn.prepareStatement(sqlEnrollment);
            pstmt.setString(1, studentIdString);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                enrollmentDate = rs.getDate("EnrollmentDate") != null ? rs.getDate("EnrollmentDate").toString() : "N/A";
                currentClass = rs.getString("CourseName");
            }
            rs.close();
            pstmt.close();

        } else {
            out.println("<p>Student profile not found or not linked.</p>");
            return;
        }

    } catch (Exception e) {
        System.err.println("Error loading student profile: " + e.getMessage());
        out.println("<p>Error loading student profile. Please try again.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Student Profile - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        <main class="container">
            <h1>Student Profile</h1>
            <section class="profile-card">
                <div class="profile-header">
                    <img src="assets/images/placeholder-student.png" alt="Student Photo" class="student-photo">
                    <h2><%= studentName %></h2>
                    <p class="student-id">Student ID: <strong><%= studentIdString %></strong></p>
                </div>
                <div class="profile-details">
                    <%
                        String status = request.getParameter("status");
                        String message = request.getParameter("message");
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
                    <h3>Personal Information</h3>
                    <p><strong>Date of Birth:</strong> <%= studentDOB %></p>
                    <p><strong>Enrollment Date:</strong> <%= enrollmentDate %></p>
                    <p><strong>Current Class:</strong> <%= currentClass %></p>

                    <h3>Parent/Guardian Information</h3>
                    <p><strong>Name:</strong> <%= parentFirstName %> <%= parentLastName %></p>
                    <p><strong>Email:</strong> <%= parentEmail %></p>
                    <p><strong>Phone:</strong> <%= parentPhone %></p>
                </div>
                <div class="profile-actions">
                    <a href="view_grades.jsp?studentId=<%= studentIdString %>" class="button"><i class="fas fa-chart-line"></i> View Grades</a>
                    <a href="view_attendance.jsp?studentId=<%= studentIdString %>" class="button"><i class="fas fa-calendar-check"></i> View Attendance</a>
                    <a href="messages.jsp?composeTo=<%= parentEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
                </div>
            </section>

            <section id="editProfileForm" class="profile-card" style="display:none;">
                <h2>Edit Student Profile</h2>
                <form action="profile_process.jsp" method="post">
                    <input type="hidden" name="studentId" value="<%= studentIdString %>">
                    <input type="hidden" name="userRole" value="Student">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" value="<%= loggedInUser %>" required>
                    <label for="studentName">Student Name:</label>
                    <input type="text" id="studentName" name="studentName" value="<%= studentName %>" required>
                    <label for="dateOfBirth">Date of Birth:</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" value="<%= studentDOB %>">
                    
                    <button type="submit" class="button">Save Changes</button>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'none'; document.querySelector('.profile-actions button').style.display = 'inline-block';">Cancel</button>
                </form>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
