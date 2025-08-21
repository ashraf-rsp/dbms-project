<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    

    // This page is accessible by all logged-in users.
    

    String messageContent = "Error: Message not found or unauthorized access.";

    try {
        int messageId = Integer.parseInt(request.getParameter("messageId"));

        

        // Fetch message content, ensuring it belongs to the logged-in user
        String sql = "SELECT Content FROM Messages WHERE MessageID = ? AND ReceiverUserID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, messageId);
        pstmt.setInt(2, userId);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            messageContent = rs.getString("Content");
        } else {
            logger.log(Level.WARNING, "Attempt to access unauthorized message or message not found. MessageID: {0}, UserID: {1}", new Object[]{messageId, userId});
        }

    } catch (NumberFormatException e) {
        logger.log(Level.SEVERE, "NumberFormatException in get_message_content.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "SQLException in get_message_content.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        logger.log(Level.SEVERE, "Exception in get_message_content.jsp: " + e.getMessage(), e);
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Output the message content directly
    out.print(messageContent);
%>
