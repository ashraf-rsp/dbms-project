<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // In a real application, hash passwords!

        conn = getConnection(); // Get connection from db_connection.jsp

        // Use PreparedStatement to prevent SQL injection
        String sql = "SELECT UserID, Username, UserType FROM Users WHERE Username = ? AND PasswordHash = ?"; // Assuming PasswordHash stores plain text for now, but should be hashed
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password); // IMPORTANT: In a real application, 'password' should be hashed and compared with 'PasswordHash'

        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Login successful
            session.setAttribute("loggedInUser", rs.getString("Username"));
            session.setAttribute("userId", rs.getInt("UserID"));
            session.setAttribute("userRole", rs.getString("UserType"));

            logger.log(Level.INFO, "User {0} logged in successfully with role {1}", new Object[]{username, rs.getString("UserType")});
            response.sendRedirect("dashboard.jsp");
        } else {
            // Login failed
            session.setAttribute("loginError", "Invalid username or password.");
            logger.log(Level.WARNING, "Failed login attempt for username: {0}", username);
            response.sendRedirect("login.jsp");
        }
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Database error during login process: " + e.getMessage(), e);
        session.setAttribute("loginError", "A database error occurred. Please try again later.");
        response.sendRedirect("login.jsp");
    } catch (ClassNotFoundException e) {
        logger.log(Level.SEVERE, "JDBC Driver not found: " + e.getMessage(), e);
        session.setAttribute("loginError", "Server configuration error. Please contact support.");
        response.sendRedirect("login.jsp");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing ResultSet", e); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing Connection", e); }
    }
%>
