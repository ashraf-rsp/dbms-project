<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    String action = request.getParameter("action");
    Integer senderUserId = (Integer) session.getAttribute("userId");

    if (senderUserId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    try {
        if ("send".equals(action)) {
            String receiverUsername = request.getParameter("receiverUsername");
            String subject = request.getParameter("subject");
            String content = request.getParameter("content");

            // Get receiverUserID
            String sqlGetReceiverId = "SELECT UserID FROM Users WHERE Username = ?";
            PreparedStatement pstmtReceiver = conn.prepareStatement(sqlGetReceiverId);
            pstmtReceiver.setString(1, receiverUsername);
            ResultSet rsReceiver = pstmtReceiver.executeQuery();
            int receiverUserId = -1;
            if (rsReceiver.next()) {
                receiverUserId = rsReceiver.getInt("UserID");
            }
            rsReceiver.close();
            pstmtReceiver.close();

            if (receiverUserId != -1) {
                String sqlInsertMessage = "INSERT INTO Messages (SenderUserID, ReceiverUserID, Subject, Content) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmtInsert = conn.prepareStatement(sqlInsertMessage);
                pstmtInsert.setInt(1, senderUserId);
                pstmtInsert.setInt(2, receiverUserId);
                pstmtInsert.setString(3, subject);
                pstmtInsert.setString(4, content);
                pstmtInsert.executeUpdate();
                session.setAttribute("message", "Message sent successfully.");
                session.setAttribute("status", "success");
            } else {
                session.setAttribute("message", "Recipient username not found.");
                session.setAttribute("status", "error");
            }

        } else if ("delete".equals(action)) {
            int messageId = Integer.parseInt(request.getParameter("messageId"));

            String sqlDeleteMessage = "DELETE FROM Messages WHERE MessageID = ? AND (SenderUserID = ? OR ReceiverUserID = ?)"; // Allow sender or receiver to delete
            PreparedStatement pstmtDelete = conn.prepareStatement(sqlDeleteMessage);
            pstmtDelete.setInt(1, messageId);
            pstmtDelete.setInt(2, senderUserId);
            pstmtDelete.setInt(3, senderUserId);
            pstmtDelete.executeUpdate();
            session.setAttribute("message", "Message deleted successfully.");
            session.setAttribute("status", "success");

        } else if ("mark_read".equals(action)) {
            int messageId = Integer.parseInt(request.getParameter("messageId"));

            String sqlMarkRead = "UPDATE Messages SET IsRead = TRUE WHERE MessageID = ? AND ReceiverUserID = ?";
            PreparedStatement pstmtMarkRead = conn.prepareStatement(sqlMarkRead);
            pstmtMarkRead.setInt(1, messageId);
            pstmtMarkRead.setInt(2, senderUserId);
            pstmtMarkRead.executeUpdate();
            // No redirect needed for AJAX call
            return;
        }

    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
        e.printStackTrace();
    }

    response.sendRedirect("messages.jsp");
%>