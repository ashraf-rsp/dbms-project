<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || !"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    String teacherUsername = "";
    String teacherName = "";
    String teacherEmail = ""; // Assuming email might be added to Users table or a linked table later
    List<String> assignedCourses = new ArrayList<>();

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Retrieve teacher details from the Users table
        String sqlTeacher = "SELECT u.Username, t.TeacherName FROM Users u JOIN Teachers t ON u.UserID = t.UserID WHERE u.UserID = ? AND u.UserType = 'Teacher'";
        pstmt = conn.prepareStatement(sqlTeacher);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            teacherUsername = rs.getString("Username");
            teacherName = rs.getString("TeacherName");
            // If an email column is added to Users, retrieve it here
            // teacherEmail = rs.getString("Email");
        } else {
            out.println("<p>Teacher user not found or role mismatch.</p>");
            return;
        }
        rs.close();
        pstmt.close();

        // Retrieve assigned courses
        String sqlCourses = "SELECT c.CourseName FROM Courses c JOIN Schedules s ON c.CourseID = s.CourseID WHERE s.TeacherUserID = ? ORDER BY c.CourseName";
        pstmt = conn.prepareStatement(sqlCourses);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            assignedCourses.add(rs.getString("CourseName"));
        }

    } catch (Exception e) {
        System.err.println("Error loading teacher profile: " + e.getMessage());
        out.println("<p>Error loading teacher profile. Please try again.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Teacher Profile - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        <main class="container">
            <h1>Teacher Profile</h1>
            <section class="profile-card">
                <div class="profile-header">
                    <div class="teacher-photo-fallback student-photo"><%= teacherUsername.isEmpty() ? "?" : teacherUsername.substring(0, 1).toUpperCase() %></div>
                    <h2><%= (teacherName != null && !teacherName.isEmpty()) ? teacherName : teacherUsername %></h2>
                    <p class="teacher-id">User ID: <strong><%= userId %></strong></p>
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
                    <h3>Contact Information</h3>
                    <p><strong>Username:</strong> <%= teacherUsername %></p>
                    <%-- <p><strong>Email:</strong> <%= teacherEmail %></p> --%>

                    <h3>Assigned Courses</h3>
                    <ul>
                        <%
                            if (assignedCourses.isEmpty()) {
                        %>
                                <li>No courses assigned.</li>
                        <%
                            } else {
                                for (String course : assignedCourses) {
                        %>
                                <li><%= course %></li>
                        <%
                                }
                            }
                        %>
                    </ul>
                </div>
                <div class="profile-actions">
                    <%-- <a href="messages.jsp?composeTo=<%= teacherEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a> --%>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
                </div>
            </section>

            <section id="editProfileForm" class="profile-card" style="display:none;">
                <h2>Edit Teacher Profile</h2>
                <form action="profile_process.jsp" method="post">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <input type="hidden" name="userRole" value="Teacher">
                    <label for="teacherName">Teacher Name:</label>
                    <input type="text" id="teacherName" name="teacherName" value="<%= (teacherName != null) ? teacherName : "" %>" required>
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" value="<%= teacherUsername %>" required>
                    <%-- If email is added to Users table, uncomment below --%>
                    <%-- <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= teacherEmail %>" required> --%>
                    <label for="password">New Password (leave blank to keep current):</label>
                    <input type="password" id="password" name="password">
                    
                    <button type="submit" class="button">Save Changes</button>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'none'; document.querySelector('.profile-actions button').style.display = 'inline-block';">Cancel</button>
                </form>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
