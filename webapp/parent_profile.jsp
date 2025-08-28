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

    if (!"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String parentIdString = null;
    String parentFirstName = "";
    String parentLastName = "";
    String parentEmail = "";
    String parentPhone = "";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String sqlGetParentID = "SELECT ParentID FROM Parents WHERE UserID = ?";
        pstmt = conn.prepareStatement(sqlGetParentID);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            parentIdString = rs.getString("ParentID");
        }
        rs.close();
        pstmt.close();

        if (parentIdString != null) {
            String sqlParent = "SELECT FirstName, LastName, Email, Phone FROM Parents WHERE ParentID = ?";
            pstmt = conn.prepareStatement(sqlParent);
            pstmt.setString(1, parentIdString);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                parentFirstName = rs.getString("FirstName");
                parentLastName = rs.getString("LastName");
                parentEmail = rs.getString("Email");
                parentPhone = rs.getString("Phone");
            }
            rs.close();
            pstmt.close();

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
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="<%= theme %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Parent-First Academic Center Management">
    <title>Parent Profile - Academic Center</title>
    <link rel="stylesheet" href="/academic-center/css/themes.css">
    <link rel="stylesheet" href="/academic-center/css/components.css">
    <link rel="stylesheet" href="/academic-center/css/style.css">
    <link rel="stylesheet" href="/academic-center/css/responsive.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <% request.setAttribute("title", "Parent Profile"); %>
    <%@ include file="includes/header.jsp" %>
    <main class="container">
    <h1>Parent Profile</h1>
    
    <section class="profile-card">
        <div class="profile-header">
            <% 
                // Assuming parentPhotoUrl is not directly available from the Parents table
                // If it were, you'd fetch it here, e.g., String parentPhotoUrl = rs.getString("PhotoURL");
                String parentPhotoUrl = null; // Set to null for now as it's not in the Parents table
                String parentFullName = parentFirstName + " " + parentLastName;
                
                if (parentPhotoUrl != null && !parentPhotoUrl.isEmpty()) {
            %>
                <img src="<%= parentPhotoUrl %>" alt="Parent Photo" class="student-photo">
            <% 
                } else if (parentFullName != null && !parentFullName.trim().isEmpty()) {
                    String firstLetter = parentFullName.trim().substring(0, 1).toUpperCase();
            %>
                <div class="parent-photo-fallback student-photo"><%= firstLetter %></div>
            <% 
                } else {
            %>
                <div class="parent-photo-fallback student-photo">?</div> <%-- Fallback for no parent name --%>
            <% } %>
            <h2><%= parentFirstName %> <%= parentLastName %></h2>
            <p class="parent-id">Parent ID: <strong><%= parentIdString %></strong></p>
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
            <input type="hidden" name="userId" value="<%= userId %>"> <%-- Use userId from session --%>
            <input type="hidden" name="userRole" value="Parent"> <%-- Explicitly set role --%>
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
<%@ include file="includes/footer.jsp" %>