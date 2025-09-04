<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="at.favre.lib.PasswordUtil" %>

<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // TODO: Implement password hashing and comparison using a secure hashing algorithm (e.g., BCrypt).

        // Use PreparedStatement to prevent SQL injection
        String sql = "SELECT UserID, Username, UserType, PasswordHash FROM Users WHERE Username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String storedHashedPassword = rs.getString("PasswordHash");
            // Verify the password
            if (PasswordUtil.verifyPassword(password, storedHashedPassword)) {
                // Login successful
                session.setAttribute("loggedInUser", rs.getString("Username"));
                session.setAttribute("userId", rs.getInt("UserID"));
                session.setAttribute("userRole", rs.getString("UserType"));

                logger.log(Level.INFO, "User {0} logged in successfully with role {1}", new Object[]{username, rs.getString("UserType")});
                
                // Check if this is a temporary password login
                if ("true".equals(session.getAttribute("isTempPassword"))) {
                    session.removeAttribute("isTempPassword"); // Clear the flag
                    response.sendRedirect("change_password.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Password does not match
                session.setAttribute("loginError", "Invalid username or password.");
                logger.log(Level.WARNING, "Failed login attempt for username: {0} - Incorrect password", username);
                response.sendRedirect("login.jsp");
            }
        } else {
            // Username not found
            session.setAttribute("loginError", "Invalid username or password.");
            logger.log(Level.WARNING, "Failed login attempt for username: {0} - User not found", username);
            response.sendRedirect("login.jsp");
        }
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Database error during login process: " + e.getMessage(), e);
        session.setAttribute("loginError", "A database error occurred. Please try again later.");
        response.sendRedirect("login.jsp");
     } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing ResultSet", e); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
    }
%>