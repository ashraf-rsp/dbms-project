<%@ page import="java.sql.*" %>
<%@ page import="at.favre.lib.crypto.bcrypt.BCrypt" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>

<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    Integer userId = (Integer) session.getAttribute("userId");
    String redirectPage = "change_password.jsp";
    String status = "error";
    String message = "";

    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
        message = "New password and confirmation cannot be empty.";
    } else if (!newPassword.equals(confirmPassword)) {
        message = "New password and confirmation do not match.";
    } else {
        PreparedStatement pstmt = null;
        try {
            String hashedNewPassword = BCrypt.withDefaults().hashToString(12, newPassword.toCharArray());

            String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, hashedNewPassword);
            pstmt.setInt(2, userId);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                status = "success";
                message = "Password changed successfully. You can now proceed to your dashboard.";
                session.removeAttribute("isTempPassword"); // Clear the temporary password flag
                session.removeAttribute("tempUsername"); // Clear temp username if set
                redirectPage = "dashboard.jsp";
            } else {
                message = "Failed to change password. Please try again.";
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error during password change: " + e.getMessage(), e);
            message = "A database error occurred. Please try again later.";
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
        }
    }

    session.setAttribute("status", status);
    session.setAttribute("message", message);
    response.sendRedirect(redirectPage);
%>