<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    int userId = (Integer) session.getAttribute("userId");

    if (!"Student".equals(userRole) && !"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    int studentId = -1;
    String studentFirstName = "";
    String studentLastName = "";
    String studentDOB = "";
    String enrollmentDate = "N/A";
    String currentClass = "N/A";

    String parentFirstName = "";
    String parentLastName = "";
    String parentEmail = "";
    String parentPhone = "";

    List<Integer> linkedStudentIds = new ArrayList<>();
    List<String> linkedStudentNames = new ArrayList<>();

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if ("Student".equals(userRole)) {
            studentId = userId;
        } else if ("Parent".equals(userRole)) {
            String sqlAllLinkedStudents = "SELECT s.StudentID, s.FirstName, s.LastName FROM Students s JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID JOIN Users u ON spl.ParentID = u.ParentID WHERE u.UserID = ?";
            pstmt = conn.prepareStatement(sqlAllLinkedStudents);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                linkedStudentIds.add(rs.getInt("StudentID"));
                linkedStudentNames.add(rs.getString("FirstName") + " " + rs.getString("LastName"));
            }
            rs.close();
            pstmt.close();

            if (linkedStudentIds.isEmpty()) {
                out.println("<p>No students linked to your account.</p>");
                return;
            }

            String paramStudentId = request.getParameter("studentId");
            if (paramStudentId != null && !paramStudentId.isEmpty()) {
                int requestedStudentId = Integer.parseInt(paramStudentId);
                if (linkedStudentIds.contains(requestedStudentId)) {
                    studentId = requestedStudentId;
                } else {
                    session.setAttribute("message", "You do not have access to this student's profile.");
                    response.sendRedirect("student_profile.jsp");
                    return;
                }
            } else {
                studentId = linkedStudentIds.get(0);
            }
        }

        if (studentId != -1) {
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

            String sqlEnrollment = "SELECT e.EnrollmentDate, c.CourseName FROM Enrollments e " +
                                 "JOIN Courses c ON e.CourseID = c.CourseID " +
                                 "WHERE e.StudentID = ? ORDER BY e.EnrollmentDate DESC LIMIT 1";
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
<%@ include file="includes/header.jsp" %>
<main class="container">
    <h1>Student Profile</h1>
    <% if ("Parent".equals(userRole) && linkedStudentIds.size() > 1) { %>
    <div class="student-selection-dropdown">
        <label for="selectStudent">Select Child:</label>
        <select id="selectStudent" onchange="window.location.href='student_profile.jsp?studentId=' + this.value;">
            <%
                for (int i = 0; i < linkedStudentIds.size(); i++) {
                    int sId = linkedStudentIds.get(i);
                    String sName = linkedStudentNames.get(i);
            %>
            <option value="<%= sId %>" <%= (sId == studentId) ? "selected" : "" %>><%= sName %></option>
            <%
                }
            %>
        </select>
    </div>
    <% } %>
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
<%@ include file="includes/footer.jsp" %>