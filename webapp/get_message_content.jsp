<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    String messageIdStr = request.getParameter("messageId");
    int messageId = -1;
    if (messageIdStr != null && !messageIdStr.isEmpty()) {
        messageId = Integer.parseInt(messageIdStr);
    }

    String messageContent = "";

    if (messageId != -1) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // Get message content
            String sqlContent = "SELECT Content FROM Messages WHERE MessageID = ?";
            pstmt = conn.prepareStatement(sqlContent);
            pstmt.setInt(1, messageId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                messageContent = rs.getString("Content");
            }
            rs.close();
            pstmt.close();

            // Mark message as read
            String sqlMarkRead = "UPDATE Messages SET IsRead = TRUE WHERE MessageID = ?";
            pstmt = conn.prepareStatement(sqlMarkRead);
            pstmt.setInt(1, messageId);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            messageContent = "Error fetching message content.";
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    out.print(messageContent);
%>