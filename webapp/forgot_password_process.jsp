<%@ page import="java.sql.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="at.favre.lib.crypto.bcrypt.BCrypt" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>

<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    String username = request.getParameter("username");
    String redirectPage = "forgot_password.jsp";
    String status = "error";
    String message = "";

    if (username == null || username.trim().isEmpty()) {
        message = "Username cannot be empty.";
    } else {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT UserID FROM Users WHERE Username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("UserID");
                
                // Generate a temporary password (e.g., a UUID substring)
                String tempPassword = UUID.randomUUID().toString().substring(0, 8); // 8 characters
                String hashedTempPassword = BCrypt.withDefaults().hashToString(12, tempPassword.toCharArray());

                // Update user's password in the database
                String updateSql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
                PreparedStatement updatePstmt = conn.prepareStatement(updateSql);
                updatePstmt.setString(1, hashedTempPassword);
                updatePstmt.setInt(2, userId);
                int rowsAffected = updatePstmt.executeUpdate();
                updatePstmt.close();

                if (rowsAffected > 0) {
                    status = "success";
                    message = "Your temporary password is: <strong>" + tempPassword + "</strong>. Please use this to log in and change your password immediately.";
                    session.setAttribute("isTempPassword", "true"); // Flag for forced password change
                    session.setAttribute("tempUsername", username); // Store username to pre-fill login
                } else {
                    message = "Failed to update password. Please try again.";
                }
            } else {
                message = "Username not found.";
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error during password reset: " + e.getMessage(), e);
            message = "A database error occurred. Please try again later.";
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing ResultSet", e); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
        }
    }

    session.setAttribute("status", status);
    session.setAttribute("message", message);
    response.sendRedirect(redirectPage);
%>