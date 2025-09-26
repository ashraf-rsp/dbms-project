<%@ page import="java.sql.*, jakarta.servlet.http.HttpServletResponse" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("application/json");
    Integer userId = (Integer) session.getAttribute("userId");
    String alertIdParam = request.getParameter("alertId");

    System.err.println("--- MARK NOTIFICATION READ: userId=" + userId + ", alertIdParam=" + alertIdParam + " ---"); // DEBUG

    if (userId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
        response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in.\"}");
        return;
    }

    if (alertIdParam == null || alertIdParam.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Missing AlertID parameter.\"}");
        return;
    }

    try {
        int alertId = Integer.parseInt(alertIdParam);

        String sql = "UPDATE Notifications SET IsRead = 1 WHERE UserID = ? AND AlertID = ? AND IsRead = 0";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, alertId);
        int rowsAffected = pstmt.executeUpdate();

        System.err.println("--- MARK NOTIFICATION READ: rowsAffected=" + rowsAffected + " for userId=" + userId + ", alertId=" + alertId + " ---"); // DEBUG

        if (rowsAffected > 0) {
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Notification marked as read.\"}");
        } else {
            response.getWriter().write("{\"status\": \"success\", \"message\": \"Notification already read or not found.\"}");
        }

    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid AlertID format.\"}");
        e.printStackTrace();
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        response.getWriter().write("{\"status\": \"error\", \"message\": \"An internal error occurred: " + e.getMessage() + "}");
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>