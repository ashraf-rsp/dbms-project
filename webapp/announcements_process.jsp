<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<% logger = Logger.getLogger(this.getClass().getName());
    Connection conn = null;
    PreparedStatement pstmt = null;

    // Ensure only Admin or Teacher can access this page
    
    if (!"Admin".equals(userRole) && !"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String action = request.getParameter("action");
    String status = "error";
    String message = "An unknown error occurred.";

    try {
        

        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String fullMessage = title + "\n" + content; // Combine title and content

            String sql = "INSERT INTO Alert_Log (Message, Timestamp) VALUES (?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullMessage);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Announcement added successfully!";
                logger.log(Level.INFO, "Announcement added: {0}", title);
            } else {
                message = "Failed to add announcement.";
                logger.log(Level.WARNING, "Failed to add announcement: {0}", title);
            }

        } else if ("edit".equals(action)) {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String fullMessage = title + "\n" + content; // Combine title and content

            String sql = "UPDATE Alert_Log SET Message = ?, Timestamp = NOW() WHERE AlertID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullMessage);
            pstmt.setInt(2, alertId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Announcement updated successfully!";
                logger.log(Level.INFO, "Announcement updated: {0}", alertId);
            } else {
                message = "No changes made or announcement not found.";
                logger.log(Level.WARNING, "Announcement update failed or no changes for AlertID: {0}", alertId);
            }

        } else if ("delete".equals(action)) {
            int alertId = Integer.parseInt(request.getParameter("alertId"));

            String sql = "DELETE FROM Alert_Log WHERE AlertID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alertId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Announcement deleted successfully!";
                logger.log(Level.INFO, "Announcement deleted: {0}", alertId);
            } else {
                message = "Announcement not found or failed to delete.";
                logger.log(Level.WARNING, "Announcement deletion failed for AlertID: {0}", alertId);
            }

        } else {
            message = "Invalid action.";
            logger.log(Level.WARNING, "Invalid action received: {0}", action);
        }

    } catch (NumberFormatException e) {
        message = "Invalid numeric input.";
        logger.log(Level.SEVERE, "NumberFormatException in announcements_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in announcements_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in announcements_process.jsp: " + e.getMessage(), e);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Redirect back to announcements.jsp with status and message
    response.sendRedirect("announcements.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>