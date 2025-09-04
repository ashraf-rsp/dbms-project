<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer loggedInUserId = (Integer) request.getAttribute("userId");

    String messageIdStr = request.getParameter("messageId");
    int messageId = -1;
    if (messageIdStr != null && !messageIdStr.isEmpty()) {
        messageId = Integer.parseInt(messageIdStr);
    }

    String messageContent = "Error: You are not authorized to view this message."; // Default error

    if (loggedInUserId == null) {
        messageContent = "Error: Not logged in.";
    } else if (messageId != -1) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // Get message content, ensuring user is either the sender or receiver
            String sqlContent = "SELECT Content FROM Messages WHERE MessageID = ? AND (SenderUserID = ? OR ReceiverUserID = ?)";
            pstmt = conn.prepareStatement(sqlContent);
            pstmt.setInt(1, messageId);
            pstmt.setInt(2, loggedInUserId);
            pstmt.setInt(3, loggedInUserId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                messageContent = rs.getString("Content");

                // Mark message as read ONLY if the current user is the receiver
                String sqlMarkRead = "UPDATE Messages SET IsRead = TRUE WHERE MessageID = ? AND ReceiverUserID = ?";
                PreparedStatement markReadPstmt = conn.prepareStatement(sqlMarkRead);
                markReadPstmt.setInt(1, messageId);
                markReadPstmt.setInt(2, loggedInUserId);
                markReadPstmt.executeUpdate();
                markReadPstmt.close();
            }
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