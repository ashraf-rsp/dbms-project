<%@ page import="java.sql.*" %>
<%@ page import="at.favre.lib.PasswordUtil" %>

<%@ include file="../db_connection.jsp" %>

<%
    String action = request.getParameter("action");

    try {
        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String parentId = request.getParameter("parentId");

            String hashedPassword = PasswordUtil.hashPassword(password);

            String sql = "INSERT INTO Users (Username, PasswordHash, UserType, ParentID) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, hashedPassword);
            pstmt.setString(3, userType);
            if (parentId != null && !parentId.isEmpty()) {
                pstmt.setInt(4, Integer.parseInt(parentId));
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            pstmt.executeUpdate();

            session.setAttribute("message", "User added successfully.");

        } else if ("update".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String parentId = request.getParameter("parentId");

            if (password != null && !password.isEmpty()) {
                String hashedPassword = PasswordUtil.hashPassword(password);
                String sql = "UPDATE Users SET Username = ?, PasswordHash = ?, UserType = ?, ParentID = ? WHERE UserID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, hashedPassword);
                pstmt.setString(3, userType);
                if (parentId != null && !parentId.isEmpty()) {
                    pstmt.setInt(4, Integer.parseInt(parentId));
                } else {
                    pstmt.setNull(4, java.sql.Types.INTEGER);
                }
                pstmt.setInt(5, userId);
                pstmt.executeUpdate();
            } else {
                String sql = "UPDATE Users SET Username = ?, UserType = ?, ParentID = ? WHERE UserID = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, userType);
                if (parentId != null && !parentId.isEmpty()) {
                    pstmt.setInt(3, Integer.parseInt(parentId));
                } else {
                    pstmt.setNull(3, java.sql.Types.INTEGER);
                }
                pstmt.setInt(4, userId);
                pstmt.executeUpdate();
            }

            session.setAttribute("message", "User updated successfully.");

        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));

            String sql = "DELETE FROM Users WHERE UserID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();

            session.setAttribute("message", "User deleted successfully.");
        }
    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
    }

    response.sendRedirect("user_management.jsp");
%>
