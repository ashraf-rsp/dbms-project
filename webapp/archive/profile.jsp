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
    String parentFirstName = "";
    String parentLastName = "";
    String teacherPhotoURL = "";
    String adminName = "";
    String parentPhotoURL = "";

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // If a userId parameter is provided, and the current user is an Admin or Teacher,
        // allow viewing of other profiles.
        if (paramUserId != null && !paramUserId.isEmpty()) {
            int requestedUserId = Integer.parseInt(paramUserId);
            String requestedUserRole = null;

            // Get the role of the requested user
            String sqlRequestedRole = "SELECT UserType FROM Users WHERE UserID = ?";
            pstmt = conn.prepareStatement(sqlRequestedRole);
            pstmt.setInt(1, requestedUserId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                requestedUserRole = rs.getString("UserType");
            }
            rs.close();
            pstmt.close();

            boolean authorized = false;

            // Permission checks
            if ("Admin".equals(sessionUserRole)) {
                authorized = true;
            } else if ("Teacher".equals(sessionUserRole) && "Student".equals(requestedUserRole)) {
                // Teachers can view student profiles
                authorized = true;
            } else if ("Parent".equals(sessionUserRole)) {
                // Parents can view their linked children's profiles
                String sqlCheckLink = "SELECT 1 FROM Student_Parent_Link WHERE StudentID = (SELECT StudentID FROM Students WHERE UserID = ?) AND ParentID = (SELECT ParentID FROM Users WHERE UserID = ?)";
                pstmt = conn.prepareStatement(sqlCheckLink);
                pstmt.setInt(1, requestedUserId);
                pstmt.setInt(2, sessionUserId);
                rs = pstmt.executeQuery();
                if(rs.next()){
                    authorized = true;
                }
                rs.close();
                pstmt.close();
            }

            if (authorized) {
                profileUserId = requestedUserId;
                profileRole = requestedUserRole;
            } else {
                response.sendRedirect("access_denied.jsp");
                return;
            }
        }

        // Conditional data retrieval based on user role
        switch (profileRole) {
            case "Student":
                String sqlStudent = "SELECT s.StudentName, u.Email, s.DOB, s.PhotoURL FROM Students s JOIN Users u ON s.UserID = u.UserID WHERE s.UserID = ?";
                pstmt = conn.prepareStatement(sqlStudent);
                pstmt.setInt(1, profileUserId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    profileName = rs.getString("StudentName");
                    profileEmail = rs.getString("Email");
                    studentDOB = rs.getString("DOB");
                    studentPhotoURL = rs.getString("PhotoURL");

                }
                break;
            case "Parent":
                String sqlParent = "SELECT p.FirstName, p.LastName, u.Email, p.PhotoURL FROM Parents p JOIN Users u ON p.UserID = u.UserID WHERE p.UserID = ?";
                pstmt = conn.prepareStatement(sqlParent);
                pstmt.setInt(1, profileUserId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    profileName = rs.getString("FirstName") + " " + rs.getString("LastName");
                    profileEmail = rs.getString("Email");
                    parentFirstName = rs.getString("FirstName");
                    parentLastName = rs.getString("LastName");
                }
                break;
            case "Teacher":
                String sqlTeacher = "SELECT t.TeacherName, u.Email, t.PhotoURL FROM Teachers t JOIN Users u ON t.UserID = u.UserID WHERE t.UserID = ?";
                pstmt = conn.prepareStatement(sqlTeacher);
                pstmt.setInt(1, profileUserId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    profileEmail = rs.getString("Email");
                    teacherPhotoURL = rs.getString("PhotoURL");

                }
                break;
            case "Admin":
                String sqlAdmin = "SELECT Username, Email FROM Users WHERE UserID = ?";
                pstmt = conn.prepareStatement(sqlAdmin);
                pstmt.setInt(1, profileUserId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    profileName = rs.getString("Username");
                    profileEmail = rs.getString("Email");
                    adminName = rs.getString("Username"); // Assuming admin name is username
                }
                break;
        }
        request.setAttribute("loggedInUser", profileName);
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>My Profile</title>
    <%@ include file="includes/meta.jsp" %>
    <script>
        console.log("Context Path: <%= request.getContextPath() %>");
    </script>

</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        
        <main class="content-area">
            <h1><%= profileName %>'s Profile</h1>
            <section class="profile-card">
                <div class="profile-header">
                    <h2><%= profileName %></h2>
                    <p>Role: <%= profileRole %></p>
                </div>
                <div class="profile-details">
                    <p><strong>Email:</strong> <%= profileEmail %></p>
                    <% if ("Student".equals(profileRole)) { %>
                        <%@ include file="includes/student_profile_details.jspf" %>
                    <% } else if ("Parent".equals(profileRole)) { %>
                        <%@ include file="includes/parent_profile_details.jspf" %>
                    <% } else if ("Teacher".equals(profileRole)) { %>
                        <%@ include file="includes/teacher_profile_details.jspf" %>
                    <% } else if ("Admin".equals(profileRole)) { %>
                        <%@ include file="includes/admin_profile_details.jspf" %>
                    <% } %>
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

                    <% if ("Student".equals(profileRole)) { %>
                        <%@ include file="includes/student_profile_edit_fields.jspf" %>
                    <% } else if ("Parent".equals(profileRole)) { %>
                        <%@ include file="includes/parent_profile_edit_fields.jspf" %>
                    <% } else if ("Teacher".equals(profileRole)) { %>
                        <%@ include file="includes/teacher_profile_edit_fields.jspf" %>
                    <% } else if ("Admin".equals(profileRole)) { %>
                        <%@ include file="includes/admin_profile_edit_fields.jspf" %>
                    <% } %>

                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </form>
            </section>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>