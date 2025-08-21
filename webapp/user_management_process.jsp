<%@ page import="java.sql.*" %>

<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Check if the logged-in user is an Admin
    
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String action = request.getParameter("action");
    String message = "";

    

    try {
        

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String parentIdStr = request.getParameter("parentId");
            Integer parentId = null;
            if (parentIdStr != null && !parentIdStr.isEmpty()) {
                parentId = Integer.parseInt(parentIdStr);
            }

            // Hash the password
            String hashedPassword = password;

            String sql = "INSERT INTO Users (Username, PasswordHash, UserType, ParentID) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, hashedPassword);
            pstmt.setString(3, userType);
            if (parentId != null) {
                pstmt.setInt(4, parentId);
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                message = "User '" + username + "' added successfully.";
            } else {
                message = "Failed to add user.";
            }
        } else if ("edit".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String password = request.getParameter("password"); // New password, if provided
            String userType = request.getParameter("userType");
            String parentIdStr = request.getParameter("parentId");
            Integer parentId = null;
            if (parentIdStr != null && !parentIdStr.isEmpty()) {
                parentId = Integer.parseInt(parentIdStr);
            }

            String sql;
            if (password != null && !password.isEmpty()) {
                // Hash the new password
                String hashedPassword = password;
                sql = "UPDATE Users SET Username = ?, PasswordHash = ?, UserType = ?, ParentID = ? WHERE UserID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, hashedPassword);
                pstmt.setString(3, userType);
                if (parentId != null) {
                    pstmt.setInt(4, parentId);
                } else {
                    pstmt.setNull(4, java.sql.Types.INTEGER);
                }
                pstmt.setInt(5, userId);
            } else {
                // Keep existing password
                sql = "UPDATE Users SET Username = ?, UserType = ?, ParentID = ? WHERE UserID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, userType);
                if (parentId != null) {
                    pstmt.setInt(3, parentId);
                } else {
                    pstmt.setNull(3, java.sql.Types.INTEGER);
                }
                pstmt.setInt(4, userId);
            }

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                message = "User '" + username + "' updated successfully.";
            } else {
                message = "Failed to update user.";
            }
        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));

            String sql = "DELETE FROM Users WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                message = "User deleted successfully.";
            } else {
                message = "Failed to delete user.";
            }
        }
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        // Log the exception for debugging
        e.printStackTrace();
    } catch (NumberFormatException e) {
        message = "Invalid input for Parent ID or User ID.";
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        message = "Server configuration error: JDBC Driver not found.";
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    session.setAttribute("message", message);
    response.sendRedirect("user_management.jsp");
%>