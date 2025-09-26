<%@ page import="java.sql.*, java.util.ArrayList, java.util.HashMap, java.util.List, java.util.Map, jakarta.servlet.http.HttpServletResponse" %>
<%@ include file="db_connection.jsp" %>
<%
    // Helper function to escape JSON strings
    String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            switch (ch) {
                case '\"':
                    sb.append("\\\"");
                    break;
                case '\\':
                    sb.append("\\\\");
                    break;
                case '\n':
                    sb.append("\\n");
                    break;
                case '\r':
                    sb.append("\\r");
                    break;
                case '\t':
                    sb.append("\\t");
                    break;
                default:
                    sb.append(ch);
            }
        }
        return sb.toString();
    }

    // Helper function to safely escape JSON strings
    String tryEscapeJson(String text) {
        try {
            return escapeJson(text);
        } catch (Exception e) {
            System.err.println("--- GET CONVERSATION HISTORY ERROR: Failed to escape JSON string: " + text + ", Error: " + e.getMessage() + " ---");
            return "[JSON_ESCAPE_ERROR]"; // Return a placeholder
        }
    }

    response.setContentType("application/json");
    Integer currentUserId = (Integer) session.getAttribute("userId");
    String otherUserIdParam = request.getParameter("otherUserId");

    System.err.println("--- GET CONVERSATION HISTORY: Received otherUserIdParam='" + otherUserIdParam + "' ---"); // DEBUG

    if (currentUserId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
        response.getWriter().write("{\"status\": \"error\", \"message\": \"User not logged in.\"}");
        return;
    }

    if (otherUserIdParam == null || otherUserIdParam.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Missing otherUserId parameter.\"}");
        return;
    }

    List<Map<String, Object>> conversation = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        int otherUserId = Integer.parseInt(otherUserIdParam);
        System.err.println("--- GET CONVERSATION HISTORY DEBUG: Parsed otherUserId=" + otherUserId + " ---");

        // SQL to fetch messages between currentUserId and otherUserId
        // Ordered by timestamp to show conversation flow
        String sql = "SELECT m.MessageID, m.SenderUserID, m.ReceiverUserID, m.Subject, m.Content, m.Timestamp, m.IsRead, " +
                     "s.Username AS SenderUsername, r.Username AS ReceiverUsername " +
                     "FROM Messages m " +
                     "JOIN Users s ON m.SenderUserID = s.UserID " +
                     "JOIN Users r ON m.ReceiverUserID = r.UserID " +
                     "WHERE (m.SenderUserID = ? AND m.ReceiverUserID = ?) " +
                     "OR (m.SenderUserID = ? AND m.ReceiverUserID = ?) " +
                     "ORDER BY m.Timestamp ASC";

        System.err.println("--- GET CONVERSATION HISTORY DEBUG: Preparing SQL: " + sql + " ---");
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, currentUserId);
        pstmt.setInt(2, otherUserId);
        pstmt.setInt(3, otherUserId);
        pstmt.setInt(4, currentUserId);
        System.err.println("--- GET CONVERSATION HISTORY DEBUG: Executing query with currentUserId=" + currentUserId + ", otherUserId=" + otherUserId + " ---");
        rs = pstmt.executeQuery();
        System.err.println("--- GET CONVERSATION HISTORY DEBUG: Query executed, processing results ---");

        while (rs.next()) {
            System.err.println("--- GET CONVERSATION HISTORY DEBUG: Processing row for MessageID=" + rs.getInt("MessageID") + " ---");
            Map<String, Object> message = new HashMap<>();
            message.put("messageId", rs.getInt("MessageID"));
            message.put("senderId", rs.getInt("SenderUserID"));
            message.put("receiverId", rs.getInt("ReceiverUserID"));
            message.put("subject", rs.getString("Subject"));
            message.put("content", rs.getString("Content"));
            message.put("timestamp", rs.getTimestamp("Timestamp").toString()); // Convert to string for JSON
            message.put("isRead", rs.getBoolean("IsRead"));
            message.put("senderUsername", rs.getString("SenderUsername"));
            message.put("receiverUsername", rs.getString("ReceiverUsername"));
            conversation.add(message);
        }
        System.err.println("--- GET CONVERSATION HISTORY DEBUG: Finished processing all rows. Conversation size: " + conversation.size() + " ---");

        // Convert List<Map> to JSON string
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < conversation.size(); i++) {
            Map<String, Object> msg = conversation.get(i);
            json.append("{");
            json.append("\"messageId\":").append(msg.get("messageId")).append(",");
            json.append("\"senderId\":").append(msg.get("senderId")).append(",");
            json.append("\"receiverId\":").append(msg.get("receiverId")).append(",");
            json.append("\"subject\":\"").append(tryEscapeJson((String)msg.get("subject"))).append("\",");
            json.append("\"content\":\"").append(tryEscapeJson((String)msg.get("content"))).append("\",");
            json.append("\"timestamp\":\"").append(tryEscapeJson((String)msg.get("timestamp"))).append("\",");
            json.append("\"isRead\":").append(msg.get("isRead")).append(",");
            json.append("\"senderUsername\":\"").append(tryEscapeJson((String)msg.get("senderUsername"))).append("\",");
            json.append("\"receiverUsername\":\"").append(tryEscapeJson((String)msg.get("receiverUsername"))).append("\"");
            json.append("}");
            if (i < conversation.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.getWriter().write(json.toString());
        System.err.println("--- GET CONVERSATION HISTORY DEBUG: JSON response sent ---");

    } catch (NumberFormatException e) {
        System.err.println("--- GET CONVERSATION HISTORY ERROR: NumberFormatException - " + e.getMessage() + " ---");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid otherUserId format.\"}");
        e.printStackTrace();
    } catch (Exception e) {
        System.err.println("--- GET CONVERSATION HISTORY ERROR: General Exception - " + e.getMessage() + " ---");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        response.getWriter().write("{\"status\": \"error\", \"message\": \"An internal error occurred: " + e.getMessage() + "\"}");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("--- GET CONVERSATION HISTORY ERROR: Error closing ResultSet - " + e.getMessage() + " ---"); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("--- GET CONVERSATION HISTORY ERROR: Error closing PreparedStatement - " + e.getMessage() + " ---"); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("--- GET CONVERSATION HISTORY ERROR: Error closing Connection - " + e.getMessage() + " ---"); }
    }
%>