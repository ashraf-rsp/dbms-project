<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || !"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    String adminUsername = "";
    String adminEmail = ""; // Assuming email might be added to Users table or a linked table later

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Retrieve admin details from the Users table
        String sqlAdmin = "SELECT Username FROM Users WHERE UserID = ? AND UserType = 'Admin'";
        pstmt = conn.prepareStatement(sqlAdmin);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            adminUsername = rs.getString("Username");
            // If an email column is added to Users, retrieve it here
            // adminEmail = rs.getString("Email");
        } else {
            out.println("<p>Admin user not found or role mismatch.</p>");
            return;
        }

    } catch (Exception e) {
        System.err.println("Error loading admin profile: " + e.getMessage());
        out.println("<p>Error loading admin profile. Please try again.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Admin Profile - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        <main class="container">
            <h1>Admin Profile</h1>
            <section class="profile-card">
                <div class="profile-header">
                    <div class="admin-photo-fallback student-photo"><%= adminUsername.isEmpty() ? "?" : adminUsername.substring(0, 1).toUpperCase() %></div>
                    <h2><%= adminUsername %></h2>
                    <p class="admin-id">User ID: <strong><%= userId %></strong></p>
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
                    <p><strong>Username:</strong> <%= adminUsername %></p>
                    <%-- <p><strong>Email:</strong> <%= adminEmail %></p> --%>
                </div>
                <div class="profile-actions">
                    <%-- <a href="messages.jsp?composeTo=<%= adminEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a> --%>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
                </div>
            </section>

            <section id="editProfileForm" class="profile-card" style="display:none;">
                <h2>Edit Admin Profile</h2>
                <form action="profile_process.jsp" method="post">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <input type="hidden" name="userRole" value="Admin">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" value="<%= adminUsername %>" required>
                    <%-- If email is added to Users table, uncomment below --%>
                    <%-- <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= adminEmail %>" required> --%>
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
