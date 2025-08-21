<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    

    // This page is accessible by all logged-in users.
    

    String action = request.getParameter("action");
    String status = "error";
    String message = "An unknown error occurred.";

    try {
        

        if ("send".equals(action)) {
            String receiverUsername = request.getParameter("receiverUsername");
            String subject = request.getParameter("subject");
            String content = request.getParameter("content");

            // Get ReceiverUserID
            String sqlGetReceiverId = "SELECT UserID FROM Users WHERE Username = ?";
            pstmt = conn.prepareStatement(sqlGetReceiverId);
            pstmt.setString(1, receiverUsername);
            rs = pstmt.executeQuery();

            int receiverUserId = -1;
            if (rs.next()) {
                receiverUserId = rs.getInt("UserID");
            }
            rs.close();
            pstmt.close();

            if (receiverUserId != -1) {
                String sql = "INSERT INTO Messages (SenderUserID, ReceiverUserID, Subject, Content) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, receiverUserId);
                pstmt.setString(3, subject);
                pstmt.setString(4, content);

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Message sent successfully!";
                    logger.log(Level.INFO, "Message sent from {0} to {1}", new Object[]{userId, receiverUserId});
                } else {
                    message = "Failed to send message.";
                    logger.log(Level.WARNING, "Failed to send message from {0} to {1}", new Object[]{userId, receiverUserId});
                }
            } else {
                message = "Recipient username not found.";
                logger.log(Level.WARNING, "Message send failed: Recipient {0} not found.", receiverUsername);
            }

        } else if ("delete".equals(action)) {
            int messageId = Integer.parseInt(request.getParameter("messageId"));

            // Ensure user can only delete their own received messages
            String sql = "DELETE FROM Messages WHERE MessageID = ? AND ReceiverUserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, messageId);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Message deleted successfully!";
                logger.log(Level.INFO, "Message deleted: {0} by UserID: {1}", new Object[]{messageId, userId});
            } else {
                message = "Message not found or failed to delete.";
                logger.log(Level.WARNING, "Message deletion failed for MessageID: {0} by UserID: {1}", new Object[]{messageId, userId});
            }

        } else if ("mark_read".equals(action)) {
            int messageId = Integer.parseInt(request.getParameter("messageId"));

            // Ensure user can only mark their own received messages as read
            String sql = "UPDATE Messages SET IsRead = TRUE WHERE MessageID = ? AND ReceiverUserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, messageId);
            pstmt.setInt(2, userId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Message marked as read.";
                logger.log(Level.INFO, "Message marked as read: {0} by UserID: {1}", new Object[]{messageId, userId});
            } else {
                message = "Message not found or already marked as read.";
                logger.log(Level.WARNING, "Message mark read failed for MessageID: {0} by UserID: {1}", new Object[]{messageId, userId});
            }

        } else {
            message = "Invalid action.";
            logger.log(Level.WARNING, "Invalid action received: {0}", action);
        }

    } catch (NumberFormatException e) {
        message = "Invalid numeric input.";
        logger.log(Level.SEVERE, "NumberFormatException in send_message_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in send_message_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in send_message_process.jsp: " + e.getMessage(), e);
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Redirect back to messages.jsp with status and message
    response.sendRedirect("messages.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
