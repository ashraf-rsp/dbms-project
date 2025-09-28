<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, org.json.JSONArray, org.json.JSONObject, jakarta.servlet.http.HttpServletResponse" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    Integer currentUserId = (Integer) session.getAttribute("userId");
    String otherUserIdParam = request.getParameter("otherUserId");

    if (currentUserId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in.\"}");
        return;
    }

    if (otherUserIdParam == null || otherUserIdParam.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Missing otherUserId parameter.\"}");
        return;
    }

    JSONArray conversation = new JSONArray();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        int otherUserId = Integer.parseInt(otherUserIdParam);
        String sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, m.Subject, m.Content, m.Timestamp, m.IsRead, " +
                     "s.Username AS SenderUsername, r.Username AS ReceiverUsername " +
                     "FROM Messages m " +
                     "JOIN Users s ON m.SenderUserID = s.UserID " +
                     "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                     "WHERE (m.SenderUserID = ? AND m.ReceiverUserID = ?) " +
                     "OR (m.SenderUserID = ? AND m.ReceiverUserID = ?) " +
                     "ORDER BY m.Timestamp ASC";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, currentUserId);
        pstmt.setInt(2, otherUserId);
        pstmt.setInt(3, otherUserId);
        pstmt.setInt(4, currentUserId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("messageId", rs.getInt("MessageID"));
            message.put("senderId", rs.getInt("SenderUserID"));
            message.put("receiverId", rs.getInt("ReceiverUserID"));
            message.put("subject", rs.getString("Subject"));
            message.put("content", rs.getString("Content"));
            message.put("timestamp", rs.getTimestamp("Timestamp").toString());
            message.put("isRead", rs.getBoolean("IsRead"));
            message.put("senderUsername", rs.getString("SenderUsername"));
            message.put("receiverUsername", rs.getString("ReceiverUsername"));
            conversation.put(message);
        }

        response.getWriter().write(conversation.toString());

    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject error = new JSONObject();
        error.put("status", "error");
        error.put("message", "An internal error occurred: " + e.getMessage());
        response.getWriter().write(error.toString());
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>