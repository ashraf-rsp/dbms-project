<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // userRole and loggedInUser are already available from auth_check.jspf
    int userId = (Integer) session.getAttribute("userId"); // userId is needed
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String adminIdString = null;
    String adminName = "";
    String adminEmail = "";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String sqlGetAdminID = "SELECT AdminID FROM Admins WHERE UserID = ?";
        pstmt = conn.prepareStatement(sqlGetAdminID);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            adminIdString = rs.getString("AdminID");
        }
        rs.close();
        pstmt.close();

        if (adminIdString != null) {
            String sqlAdmin = "SELECT AdminName, Email FROM Admins WHERE AdminID = ?";
            pstmt = conn.prepareStatement(sqlAdmin);
            pstmt.setString(1, adminIdString);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                adminName = rs.getString("AdminName");
                adminEmail = rs.getString("Email");
            }
            rs.close();
            pstmt.close();

        } else {
            out.println("<p>Admin profile not found or not linked to your user ID. Please ensure your user account is correctly configured as an Admin.</p>");
            return;
        }

    } catch (Exception e) {
        System.err.println("Error loading admin profile: " + e.getMessage());
        out.println("<p>Error loading admin profile. Please try again.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="<%= theme %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Parent-First Academic Center Management">
    <title>Admin Profile - Academic Center</title>
    <link rel="stylesheet" href="/academic-center/css/themes.css">
    <link rel="stylesheet" href="/academic-center/css/components.css">
    <link rel="stylesheet" href="/academic-center/css/style.css">
    <link rel="stylesheet" href="/academic-center/css/responsive.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("title", "Admin Profile"); %>
    <%@ include file="includes/header.jsp" %>
    <main class="container">
    <h1>Admin Profile</h1>
    
    <section class="profile-card">
        <div class="profile-header">
            <% 
                // Assuming adminPhotoUrl is not directly available from the Admins table
                // If it were, you'd fetch it here, e.g., String adminPhotoUrl = rs.getString("PhotoURL");
                String adminPhotoUrl = null; // Set to null for now as it's not in the Admins table
                
                if (adminPhotoUrl != null && !adminPhotoUrl.isEmpty()) {
            %>
                <img src="<%= adminPhotoUrl %>" alt="Admin Photo" class="student-photo">
            <% 
                } else if (adminName != null && !adminName.trim().isEmpty()) {
                    String firstLetter = adminName.trim().substring(0, 1).toUpperCase();
            %>
                <div class="admin-photo-fallback student-photo"><%= firstLetter %></div>
            <% 
                } else {
            %>
                <div class="admin-photo-fallback student-photo">?</div> <%-- Fallback for no admin name --%>
            <% } %>
            <h2><%= adminName %></h2>
            <p class="admin-id">Admin ID: <strong><%= adminIdString %></strong></p>
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
            <p><strong>Email:</strong> <%= adminEmail %></p>
        </div>
        <div class="profile-actions">
            <a href="messages.jsp?composeTo=<%= adminEmail %>" class="button"><i class="fas fa-envelope"></i> Send Message</a>
            <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'block'; this.style.display = 'none';"><i class="fas fa-edit"></i> Edit Profile</button>
        </div>
    </section>

    <section id="editProfileForm" class="profile-card" style="display:none;">
        <h2>Edit Admin Profile</h2>
        <form action="profile_process.jsp" method="post">
            <input type="hidden" name="userId" value="<%= userId %>"> <%-- Use userId from session --%>
            <input type="hidden" name="userRole" value="Admin"> <%-- Explicitly set role --%>
            <label for="adminName">Admin Name:</label>
            <input type="text" id="adminName" name="adminName" value="<%= adminName %>" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= adminEmail %>" required>
            
            <button type="submit" class="button">Save Changes</button>
            <button type="button" class="button" onclick="document.getElementById('editProfileForm').style.display = 'none'; document.querySelector('.profile-actions button').style.display = 'inline-block';">Cancel</button>
        </form>
    </section>
</main>
<%@ include file="includes/footer.jsp" %>