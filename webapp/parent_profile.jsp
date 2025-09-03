<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || !"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    Integer parentId = null;
    String parentFirstName = "";
    String parentLastName = "";
    String parentEmail = "";
    String parentPhone = "";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Get ParentID from Users table
        String sqlGetParentID = "SELECT ParentID FROM Users WHERE UserID = ?";
        pstmt = conn.prepareStatement(sqlGetParentID);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            parentId = rs.getInt("ParentID");
        }
        rs.close();
        pstmt.close();

        if (parentId != null) {
            String sqlParent = "SELECT FirstName, LastName, Email, Phone FROM Parents WHERE ParentID = ?";
            pstmt = conn.prepareStatement(sqlParent);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                parentFirstName = rs.getString("FirstName");
                parentLastName = rs.getString("LastName");
                parentEmail = rs.getString("Email");
                parentPhone = rs.getString("Phone");
            }
        } else {
            out.println("<p>Parent profile not found or not linked.</p>");
            return;
        }

    } catch (Exception e) {
        System.err.println("Error loading parent profile: " + e.getMessage());
        out.println("<p>Error loading parent profile. Please try again.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Parent Profile - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        <main class="container">
            <h1>Parent Profile</h1>
            <section class="profile-card">
                <div class="profile-header">
                    <%
                        String parentFullName = parentFirstName + " " + parentLastName;
                        String firstLetter = parentFullName.trim().isEmpty() ? "?" : parentFullName.trim().substring(0, 1).toUpperCase();
                    %>
                    <div class="parent-photo-fallback student-photo"><%= firstLetter %></div>
                    <h2><%= parentFirstName %> <%= parentLastName %></h2>
                    <p class="parent-id">Parent ID: <strong><%= parentId %></strong></p>
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
                    <p><strong>Email:</strong> <%= parentEmail %></p>
                    <p><strong>Phone:</strong> <%= parentPhone %></p>
                </div>
                <div class="profile-actions">
                    <a href="messages.jsp?composeTo=<%= parentEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
                </div>
            </section>

            <section id="editProfileForm" class="profile-card" style="display:none;">
                <h2>Edit Parent Profile</h2>
                <form action="profile_process.jsp" method="post">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <input type="hidden" name="userRole" value="Parent">
                    <label for="firstName">First Name:</label>
                    <input type="text" id="firstName" name="firstName" value="<%= parentFirstName %>" required>
                    <label for="lastName">Last Name:</label>
                    <input type="text" id="lastName" name="lastName" value="<%= parentLastName %>" required>
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= parentEmail %>" required>
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" value="<%= parentPhone %>">
                    
                    <button type="submit" class="button">Save Changes</button>
                    <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'none'; document.querySelector('.profile-actions button').style.display = 'inline-block';">Cancel</button>
                </form>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
