<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    String action = request.getParameter("action");
    String userRole = (String) request.getAttribute("userRole");

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        if ("add".equals(action)) {
            String announcementTitle = request.getParameter("announcementTitle");
            String announcementContent = request.getParameter("announcementContent");

            String sql = "INSERT INTO Alert_Log (Title, Content, Timestamp) VALUES (?, ?, NOW())";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, announcementTitle);
            pstmt.setString(2, announcementContent);
            pstmt.executeUpdate();

            // After creating the announcement, create a notification for all users
            try {
                // Get all user IDs
                Statement userStmt = conn.createStatement();
                ResultSet userRs = userStmt.executeQuery("SELECT UserID FROM Users");

                String notificationSql = "INSERT INTO Notifications (UserID, Message, IsRead) VALUES (?, ?, 0)";
                PreparedStatement notificationPstmt = conn.prepareStatement(notificationSql);

                while (userRs.next()) {
                    int userId = userRs.getInt("UserID");
                    notificationPstmt.setInt(1, userId);
                    notificationPstmt.setString(2, "New announcement posted: " + announcementTitle);
                    notificationPstmt.addBatch();
                }
                notificationPstmt.executeBatch(); // Execute batch insert

            } catch (SQLException e) {
                // Log this error but don't stop the process if notifications fail
                System.err.println("Error creating notifications for announcement: " + e.getMessage());
            }

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