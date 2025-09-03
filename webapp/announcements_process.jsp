<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    String action = request.getParameter("action");

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        if ("add".equals(action)) {
            String announcementTitle = request.getParameter("announcementTitle");
            String announcementContent = request.getParameter("announcementContent");
            String fullMessage = announcementTitle + "\n" + announcementContent;

            String sql = "INSERT INTO Alert_Log (Message, Timestamp) VALUES (?, NOW())";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullMessage);
            pstmt.executeUpdate();

            session.setAttribute("message", "Announcement published successfully.");
            session.setAttribute("status", "success");

        } else if ("delete".equals(action)) {
            int alertId = Integer.parseInt(request.getParameter("alertId"));

            String sql = "DELETE FROM Alert_Log WHERE AlertID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alertId);
            pstmt.executeUpdate();

            session.setAttribute("message", "Announcement deleted successfully.");
            session.setAttribute("status", "success");
        }
    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
        e.printStackTrace();
    }

    response.sendRedirect("announcements.jsp");
%>