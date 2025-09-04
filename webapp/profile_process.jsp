<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.logging.*, java.util.ArrayList, java.util.List, java.util.Map, java.util.HashMap" %>
<%@ page import="at.favre.lib.crypto.bcrypt.BCrypt" %> <%-- Import BCrypt --%>
<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    Integer loggedInUserId = (Integer) request.getAttribute("userId"); // From AuthFilter
    String loggedInUserRole = (String) request.getAttribute("userRole"); // From AuthFilter

    int targetUserId = -1;

    String status = "error";
    String message = "An unknown error occurred.";

    // Retrieve form fields directly from request parameters
    String targetUserIdStr = request.getParameter("userId");
    if (targetUserIdStr == null || targetUserIdStr.isEmpty()) {
        if (loggedInUserId != null) {
            targetUserIdStr = loggedInUserId.toString();
        }
    }
    String userRole = request.getParameter("userRole"); // Role of the profile being edited
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email"); // Assuming email field is added to forms

    // --- Removed File Upload Logic ---
    // FileItem photoItem = null; // No longer used
    // String photoURL = null; // No longer used
    // --- End Removed File Upload Logic ---

    if (targetUserIdStr != null && !targetUserIdStr.isEmpty()) {
        targetUserId = Integer.parseInt(targetUserIdStr);

        // Authorization check: Admin can edit anyone, others can only edit themselves
        boolean canEdit = false;
        if ("Admin".equals(loggedInUserRole)) {
            canEdit = true;
        } else if (loggedInUserId != null && loggedInUserId == targetUserId) {
            canEdit = true;
        }

        if (canEdit) {
            List<String> setClauses = new ArrayList<>();
            List<Object> paramsUser = new ArrayList<>();

            if (username != null && !username.isEmpty()) {
                setClauses.add("Username = ?");
                paramsUser.add(username);
            }

            if (password != null && !password.isEmpty()) {
                setClauses.add("PasswordHash = ?");
                paramsUser.add(BCrypt.withDefaults().hashToString(12, password.toCharArray()));
            }
            // Add email update if email field is present in form
            if (email != null && !email.isEmpty()) {
                setClauses.add("Email = ?");
                paramsUser.add(email);
            }

            StringBuilder sqlUpdateUser = new StringBuilder();
            if (!setClauses.isEmpty()) {
                sqlUpdateUser.append("UPDATE Users SET ");
                sqlUpdateUser.append(String.join(", ", setClauses));
                sqlUpdateUser.append(" WHERE UserID = ?");
                paramsUser.add(targetUserId);
            }

            StringBuilder sqlUpdateProfile = new StringBuilder();
            List<Object> paramsProfile = new ArrayList<>();
            // photoURL is no longer handled here

            // Role-specific profile updates
            if ("Student".equals(userRole)) {
                String studentName = request.getParameter("studentName"); // Use request.getParameter
                String dateOfBirth = request.getParameter("dateOfBirth"); // Use request.getParameter

                sqlUpdateProfile.append("UPDATE Students SET StudentName = ?, DOB = ? ");
                paramsProfile.add(studentName);
                paramsProfile.add(dateOfBirth.isEmpty() ? null : dateOfBirth);
                // if (photoURL != null) { sqlUpdateProfile.append(", PhotoURL = ?"); paramsProfile.add(photoURL); }
                sqlUpdateProfile.append(" WHERE StudentID = ?"); // Use StudentID
                paramsProfile.add(request.getParameter("studentId")); // Add StudentID from form
            } else if ("Teacher".equals(userRole)) {
                String teacherName = request.getParameter("teacherName"); // Use request.getParameter
                
                sqlUpdateProfile.append("UPDATE Teachers SET TeacherName = ? ");
                paramsProfile.add(teacherName);
                // if (photoURL != null) { sqlUpdateProfile.append(", PhotoURL = ?"); paramsProfile.add(photoURL); }
                sqlUpdateProfile.append(" WHERE UserID = ?"); // Assuming UserID in Teachers table
                paramsProfile.add(targetUserId);
            } else if ("Parent".equals(userRole)) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String phone = request.getParameter("phone");

                sqlUpdateProfile.append("UPDATE Parents SET FirstName = ?, LastName = ?, Phone = ? ");
                paramsProfile.add(firstName);
                paramsProfile.add(lastName);
                paramsProfile.add(phone);
                // if (photoURL != null) { sqlUpdateProfile.append(", PhotoURL = ?"); paramsProfile.add(photoURL); }
                sqlUpdateProfile.append(" WHERE UserID = ?"); // Assuming UserID in Parents table
                paramsProfile.add(targetUserId);
            } else if ("Admin".equals(userRole)) {
                String adminName = request.getParameter("adminName");
                
                sqlUpdateProfile.append("UPDATE Users SET AdminName = ? ");
                paramsProfile.add(adminName);
                sqlUpdateProfile.append(" WHERE UserID = ?");
                paramsProfile.add(targetUserId);
            }

            boolean userUpdated = false;
            boolean profileUpdated = false;

            if (sqlUpdateUser.length() > 0) { // Only execute if there's a user update
                try (PreparedStatement psUser = conn.prepareStatement(sqlUpdateUser.toString())) {
                    logger.info("Executing SQL (User): " + sqlUpdateUser.toString());
                    logger.info("Params (User): " + paramsUser.toString());
                    for (int i = 0; i < paramsUser.size(); i++) {
                        psUser.setObject(i + 1, paramsUser.get(i));
                    }
                    int rowsAffected = psUser.executeUpdate();
                    userUpdated = rowsAffected > 0;
                    logger.info("User update rows affected: " + rowsAffected + ", userUpdated: " + userUpdated);
                } catch (SQLException e) {
                    message = "Database error updating user: " + e.getMessage();
                    logger.log(Level.SEVERE, "SQLException on user update", e);
                }
            }

            if (sqlUpdateProfile.length() > 0) { // Only execute if there's a profile-specific update
                try (PreparedStatement psProfile = conn.prepareStatement(sqlUpdateProfile.toString())) {
                    for (int i = 0; i < paramsProfile.size(); i++) {
                        psProfile.setObject(i + 1, paramsProfile.get(i));
                    }
                    profileUpdated = psProfile.executeUpdate() > 0;
                } catch (SQLException e) {
                    message = "Database error updating profile: " + e.getMessage();
                    logger.log(Level.SEVERE, "SQLException on profile update", e);
                }
            }

            if (userUpdated || profileUpdated) {
                status = "success";
                message = "Profile updated successfully!";
                // Update session username if it was changed
                if (loggedInUserId != null && loggedInUserId == targetUserId && username != null && !username.isEmpty()) {
                    session.setAttribute("loggedInUser", username);
                }
            } else {
                message = "No changes were made to the profile.";
            }
        } else {
            message = "You are not authorized to perform this action.";
        }
    } else {
        message = "Invalid request. User ID was not provided.";
    }

    session.setAttribute("message", message);
    // Redirect based on the role of the profile being edited
    String redirectPage = "dashboard.jsp"; // Default redirect
    if ("Student".equals(userRole)) {
        redirectPage = "student_profile.jsp";
    } else if ("Teacher".equals(userRole)) {
        redirectPage = "teacher_profile.jsp";
    } else if ("Parent".equals(userRole)) {
        redirectPage = "parent_profile.jsp";
    } else if ("Admin".equals(userRole)) {
        redirectPage = "admin_profile.jsp";
    }
    response.sendRedirect(redirectPage + "?userId=" + targetUserId + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>