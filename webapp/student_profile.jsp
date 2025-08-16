<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Student or Parent can access this page
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    if (!"Student".equals(userRole) && !"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int studentId = -1;
    String studentFirstName = "";
    String studentLastName = "";
    String studentDOB = "";
    String enrollmentDate = "N/A"; // Assuming EnrollmentDate is in Enrollments table
    String currentClass = "N/A"; // Assuming CurrentClass is in Courses table via Enrollments

    String parentFirstName = "";
    String parentLastName = "";
    String parentEmail = "";
    String parentPhone = "";

    try {
        conn = getConnection();

        // Determine studentId based on userRole
        if ("Student".equals(userRole)) {
            studentId = userId; // Assumption: UserID is StudentID for Student users
        } else if ("Parent".equals(userRole)) {
            // If parent, get studentId from request parameter or linked student
            String paramStudentId = request.getParameter("studentId");
            if (paramStudentId != null && !paramStudentId.isEmpty()) {
                studentId = Integer.parseInt(paramStudentId);
                // IMPORTANT: Add logic here to verify this studentId is linked to the logged-in parent
                // For now, assuming valid studentId is passed by parent.
            } else {
                // If no studentId param, try to get the first linked student for this parent
                String sqlParentLinkedStudent = "SELECT spl.StudentID FROM Users u JOIN Student_Parent_Link spl ON u.ParentID = spl.ParentID WHERE u.UserID = ? LIMIT 1";
                pstmt = conn.prepareStatement(sqlParentLinkedStudent);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    studentId = rs.getInt("StudentID");
                }
                rs.close();
                pstmt.close();
            }
        }

        if (studentId != -1) {
            // Fetch Student Details
            String sqlStudent = "SELECT FirstName, LastName, DateOfBirth FROM Students WHERE StudentID = ?";
            pstmt = conn.prepareStatement(sqlStudent);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                studentFirstName = rs.getString("FirstName");
                studentLastName = rs.getString("LastName");
                studentDOB = rs.getDate("DateOfBirth") != null ? rs.getDate("DateOfBirth").toString() : "N/A";
            }
            rs.close();
            pstmt.close();

            // Fetch Parent Details (via Student_Parent_Link)
            String sqlParentDetails = "SELECT p.FirstName, p.LastName, p.Email, p.Phone FROM Parents p " +
                                    "JOIN Student_Parent_Link spl ON p.ParentID = spl.ParentID " +
                                    "WHERE spl.StudentID = ? LIMIT 1";
            pstmt = conn.prepareStatement(sqlParentDetails);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                parentFirstName = rs.getString("FirstName");
                parentLastName = rs.getString("LastName");
                parentEmail = rs.getString("Email");
                parentPhone = rs.getString("Phone");
            }
            rs.close();
            pstmt.close();

            // Fetch Enrollment Date and Current Class (from Enrollments and Courses)
            String sqlEnrollment = "SELECT e.EnrollmentDate, c.CourseName FROM Enrollments e " +
                                 "JOIN Courses c ON e.CourseID = c.CourseID " +
                                 "WHERE e.StudentID = ? ORDER BY e.EnrollmentDate DESC LIMIT 1"; // Get most recent enrollment
            pstmt = conn.prepareStatement(sqlEnrollment);
            pstmt.setInt(1, studentId);
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
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Student Profile</h1>
    <section class="profile-card">
        <div class="profile-header">
            <img src="assets/images/placeholder-student.png" alt="Student Photo" class="student-photo">
            <h2><%= studentFirstName %> <%= studentLastName %></h2>
            <p class="student-id">Student ID: <strong><%= studentId %></strong></p>
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
            <a href="view_grades.jsp?studentId=<%= studentId %>" class="button"><i class="fas fa-chart-line"></i> View Grades</a>
            <a href="view_attendance.jsp?studentId=<%= studentId %>" class="button"><i class="fas fa-calendar-check"></i> View Attendance</a>
            <a href="messages.jsp?composeTo=<%= parentEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a>
            <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
        </div>
    </section>

    <section id="editProfileForm" class="profile-card" style="display:none;">
        <h2>Edit Student Profile</h2>
        <form action="student_profile_process.jsp" method="post">
            <input type="hidden" name="studentId" value="<%= studentId %>">
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" value="<%= studentFirstName %>" required>
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" value="<%= studentLastName %>" required>
            <label for="dateOfBirth">Date of Birth:</label>
            <input type="date" id="dateOfBirth" name="dateOfBirth" value="<%= studentDOB %>">
            
            <button type="submit" class="button">Save Changes</button>
            <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'none'; document.querySelector('.profile-actions button').style.display = 'inline-block';">Cancel</button>
        </form>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>