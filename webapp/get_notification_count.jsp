<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    response.setContentType("text/plain");
    int count = 0;
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null && conn != null) {
        try {
            String sql = "SELECT COALESCE(unread_count, 0) FROM user_notification_counts WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    out.print(count);
%>