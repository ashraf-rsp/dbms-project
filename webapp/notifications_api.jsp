<%@ page import="java.sql.*, org.json.*" %>
<jsp:include page="includes/DBConnectionProvider.jspf" />
<%!
    private JSONObject getErrorResponse(String message) {
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("status", "error");
        errorResponse.put("message", message);
        return errorResponse;
    }
%>
<%
    response.setContentType("application/json");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject jsonResponse = new JSONObject();

    String action = request.getParameter("action");
    if (action == null) {
        out.print(getErrorResponse("No action specified.").toString());
        return;
    }

    try {
        conn = getConnection();
        switch (action) {
            case "fetch":
                String userIdStr = request.getParameter("userId");
                if (userIdStr == null || userIdStr.trim().isEmpty()) {
                    out.print(getErrorResponse("User ID is required and cannot be empty.").toString());
                    return;
                }
                int userId = Integer.parseInt(userIdStr);

                String sqlFetch = "SELECT NotificationID, Message, Timestamp FROM Notifications WHERE UserID = ? AND IsRead = 0 ORDER BY Timestamp DESC";
                pstmt = conn.prepareStatement(sqlFetch);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();

                JSONArray notificationsArray = new JSONArray();
                while (rs.next()) {
                    JSONObject notification = new JSONObject();
                    notification.put("notificationId", rs.getInt("NotificationID"));
                    notification.put("message", rs.getString("Message"));
                    notification.put("timestamp", rs.getTimestamp("Timestamp"));
                    notificationsArray.put(notification);
                }
                jsonResponse.put("status", "success");
                jsonResponse.put("notifications", notificationsArray);
                break;

            case "get":
                String notificationIdStr = request.getParameter("id");
                if (notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
                    out.print(getErrorResponse("Notification ID is required and cannot be empty.").toString());
                    return;
                }
                int notificationId = Integer.parseInt(notificationIdStr);

                String sqlGet = "SELECT Message, Timestamp FROM Notifications WHERE NotificationID = ?";
                pstmt = conn.prepareStatement(sqlGet);
                pstmt.setInt(1, notificationId);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    JSONObject notification = new JSONObject();
                    notification.put("subject", "Notification"); // No subject in table, using generic
                    notification.put("message", rs.getString("Message"));
                    notification.put("timestamp", rs.getTimestamp("Timestamp"));
                    jsonResponse.put("status", "success");
                    jsonResponse.put("notification", notification);
                } else {
                    jsonResponse = getErrorResponse("Notification not found.");
                }
                break;

            case "mark_read":
                String notificationIdMarkStr = request.getParameter("id");
                 if (notificationIdMarkStr == null || notificationIdMarkStr.trim().isEmpty()) {
                    out.print(getErrorResponse("Notification ID is required and cannot be empty.").toString());
                    return;
                }
                int notificationIdMark = Integer.parseInt(notificationIdMarkStr);

                String sqlMarkRead = "UPDATE Notifications SET IsRead = 1 WHERE NotificationID = ?";
                pstmt = conn.prepareStatement(sqlMarkRead);
                pstmt.setInt(1, notificationIdMark);
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    jsonResponse.put("status", "success");
                } else {
                    jsonResponse = getErrorResponse("Could not mark notification as read.");
                }
                break;

            default:
                jsonResponse = getErrorResponse("Invalid action specified.");
                break;
        }
    } catch (Exception e) {
        jsonResponse = getErrorResponse("An error occurred: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) { /* ignored */ }
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) { /* ignored */ }
        try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
    }

    out.print(jsonResponse.toString());
%>