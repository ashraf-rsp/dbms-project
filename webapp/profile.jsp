<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Get logged-in user's info from session
    String sessionUserRole = (String) session.getAttribute("userRole");
    int sessionUserId = (Integer) session.getAttribute("userId");

    // Determine which user profile to display
    String paramUserId = request.getParameter("userId");
    int profileUserId = sessionUserId; // Default to own profile
    String profileRole = sessionUserRole; // Default to own role

    // Variables to hold profile data
    String profileName = "";
    String profileEmail = "";
    String studentDOB = "";
    String studentPhotoURL = "";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // For student profile, we only care about the student's own profile for now
        // No authorization checks for viewing other profiles in this phase
        // Conditional data retrieval based on user role
        if ("Student".equals(sessionUserRole)) {
            String sqlStudent = "SELECT s.StudentName, s.Email, s.DOB, s.PhotoURL FROM Students s WHERE s.UserID = ?";
            pstmt = conn.prepareStatement(sqlStudent);
            pstmt.setInt(1, profileUserId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                profileName = rs.getString("StudentName");
                profileEmail = rs.getString("Email");
                studentDOB = rs.getString("DOB");
                studentPhotoURL = rs.getString("PhotoURL");
            }
            request.setAttribute("studentDOB", studentDOB);
            request.setAttribute("studentPhotoURL", studentPhotoURL);
            request.setAttribute("profileName", profileName); // Pass profileName to fragment
        } else if ("Teacher".equals(sessionUserRole)) {
            String sqlTeacher = "SELECT t.TeacherName, t.Email, t.PhotoURL FROM Teachers t WHERE t.UserID = ?";
            pstmt = conn.prepareStatement(sqlTeacher);
            pstmt.setInt(1, profileUserId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                profileName = rs.getString("TeacherName");
                profileEmail = rs.getString("Email");
                // Assuming PhotoURL is available for teachers
                studentPhotoURL = rs.getString("PhotoURL"); // Reusing studentPhotoURL for generic photo
            }
            request.setAttribute("profileName", profileName); // Pass profileName to fragment
            request.setAttribute("teacherPhotoURL", studentPhotoURL); // Pass teacher photo URL
        }
        // Add more else if blocks for other roles (Admin, Parent) as needed

    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <%@ include file="includes/meta.jsp" %>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/components.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <main class="container">
        <h1><%= profileName %>'s Profile</h1>
        <section class="profile-card">
            <div class="profile-header">
                <h2><%= profileName %></h2>
                <p>Role: <%= profileRole %></p>
            </div>
            <div class="profile-details">
                <p><strong>Email:</strong> <%= profileEmail %></p>
                <%-- Include role-specific profile details --%>
                <% if ("Student".equals(sessionUserRole)) { %>
                    <%@ include file="includes/student_profile_details.jspf" %>
                <% } else if ("Teacher".equals(sessionUserRole)) { %>
                    <%@ include file="includes/teacher_profile_details.jspf" %>
                <% } %>
                <%-- Add more else if blocks for other roles (Admin, Parent) as needed --%>
            </div>
        </section>

        <section class="profile-edit-form">
            <h2>Edit Profile</h2>
            <form action="profile_process.jsp" method="post" enctype="multipart/form-data">
                <input type="hidden" name="userId" value="<%= profileUserId %>">
                <input type="hidden" name="userRole" value="<%= profileRole %>">

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= profileEmail %>" required>
                </div>

                <%-- Role-specific edit fields --%>
                <% if ("Student".equals(sessionUserRole)) { %>
                    <%@ include file="includes/student_profile_edit_fields.jspf" %>
                <% } else if ("Teacher".equals(sessionUserRole)) { %>
                    <%@ include file="includes/teacher_profile_edit_fields.jspf" %>
                <% } %>
                <%-- Add more else if blocks for other roles (Admin, Parent) as needed --%>

                <button type="submit" class="btn btn-primary">Update Profile</button>
            </form>
        </section>
    </main>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>