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
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String userType = request.getParameter("user_type");

        // 1. Basic Validation
        if (username == null || username.isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty() ||
            userType == null || userType.isEmpty()) {
            session.setAttribute("regError", "All fields are required.");
            response.sendRedirect("register.jsp");
            return;
        }

        // 2. Password Match Validation
        if (!password.equals(confirmPassword)) {
            session.setAttribute("regError", "Passwords do not match.");
            response.sendRedirect("register.jsp");
            return;
        }

        // 3. Username Uniqueness Validation
        String checkUserSql = "SELECT COUNT(*) FROM Users WHERE Username = ?";
        pstmt = conn.prepareStatement(checkUserSql);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            session.setAttribute("regError", "Username already exists. Please choose a different one.");
            response.sendRedirect("register.jsp");
            return;
        }
        rs.close();
        pstmt.close(); // Close for reuse

        // 4. Hash Password
        String hashedPassword = PasswordUtil.hashPassword(password);

        // 5. Insert User into Database
        String insertUserSql = "INSERT INTO Users (Username, PasswordHash, UserType) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(insertUserSql);
        pstmt.setString(1, username);
        pstmt.setString(2, hashedPassword);
        pstmt.setString(3, userType);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            session.setAttribute("regMessage", "Registration successful! Please log in.");
            logger.log(Level.INFO, "New user registered: {0} ({1})", new Object[]{username, userType});
            response.sendRedirect("login.jsp");
        } else {
            session.setAttribute("regError", "Registration failed. Please try again.");
            logger.log(Level.WARNING, "Registration failed for user: {0}", username);
            response.sendRedirect("register.jsp");
        }

    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Database error during registration process: " + e.getMessage(), e);
        session.setAttribute("regError", "A database error occurred during registration. Please try again later.");
        response.sendRedirect("register.jsp");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing ResultSet", e); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
        // Do NOT close connection here, it's managed by db_connection.jsp's parent
    }
%>
