<%@ page import="java.sql.*, jakarta.servlet.http.HttpServletResponse" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("application/json");
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
        response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in.\"}");
        return;
    }

    try {
        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserID = ? AND IsRead = 0";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.getWriter().write("{\"status\": \"success\", \"message\": \"All notifications marked as read.\"}");
        } else {
            response.getWriter().write("{\"status\": \"success\", \"message\": \"No unread notifications found.\"}");
        }

    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        response.getWriter().write("{\"status\": \"error\", \"message\": \"An internal error occurred: " + e.getMessage() + "}");
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>