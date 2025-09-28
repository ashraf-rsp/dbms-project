<%@ page import="java.sql.*, java.io.StringWriter, java.io.PrintWriter, java.util.logging.Logger, java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
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

            System.out.println("send_message_process.jsp: ReceiverUserID: " + receiverUserId);

            if (receiverUserId != -1) {
                System.out.println("send_message_process.jsp: Inserting message into database.");
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
            String messageIdParam = request.getParameter("messageId");
            int messageId = Integer.parseInt(messageIdParam);

            // Get sender and receiver of the message
            String sqlGetMessage = "SELECT SenderUserID, ReceiverUserID FROM Messages WHERE MessageID = ?";
            PreparedStatement pstmtGetMessage = conn.prepareStatement(sqlGetMessage);
            pstmtGetMessage.setInt(1, messageId);
            ResultSet rsMessage = pstmtGetMessage.executeQuery();

            if (rsMessage.next()) {
                int senderId = rsMessage.getInt("SenderUserID");
                int receiverId = rsMessage.getInt("ReceiverUserID");

                if (senderUserId.equals(senderId)) {
                    // User is the sender
                    String sqlUpdateSender = "UPDATE Messages SET DeletedBySender = TRUE WHERE MessageID = ?";
                    PreparedStatement pstmtUpdateSender = conn.prepareStatement(sqlUpdateSender);
                    pstmtUpdateSender.setInt(1, messageId);
                    pstmtUpdateSender.executeUpdate();
                    pstmtUpdateSender.close();
                } else if (senderUserId.equals(receiverId)) {
                    // User is the receiver
                    String sqlUpdateReceiver = "UPDATE Messages SET DeletedByReceiver = TRUE WHERE MessageID = ?";
                    PreparedStatement pstmtUpdateReceiver = conn.prepareStatement(sqlUpdateReceiver);
                    pstmtUpdateReceiver.setInt(1, messageId);
                    pstmtUpdateReceiver.executeUpdate();
                    pstmtUpdateReceiver.close();
                }

                // Check if both flags are set
                String sqlCheckFlags = "SELECT DeletedBySender, DeletedByReceiver FROM Messages WHERE MessageID = ?";
                PreparedStatement pstmtCheckFlags = conn.prepareStatement(sqlCheckFlags);
                pstmtCheckFlags.setInt(1, messageId);
                ResultSet rsFlags = pstmtCheckFlags.executeQuery();
                if (rsFlags.next()) {
                    boolean deletedBySender = rsFlags.getBoolean("DeletedBySender");
                    boolean deletedByReceiver = rsFlags.getBoolean("DeletedByReceiver");
                    if (deletedBySender && deletedByReceiver) {
                        String sqlDeleteMessage = "DELETE FROM Messages WHERE MessageID = ?";
                        PreparedStatement pstmtDeleteMessage = conn.prepareStatement(sqlDeleteMessage);
                        pstmtDeleteMessage.setInt(1, messageId);
                        pstmtDeleteMessage.executeUpdate();
                        pstmtDeleteMessage.close();
                    }
                }
                rsFlags.close();
                pstmtCheckFlags.close();
            }
            rsMessage.close();
            pstmtGetMessage.close();

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
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        String stackTrace = sw.toString();
        session.setAttribute("message", "An error occurred: " + e.getMessage() + "<br><pre>" + stackTrace + "</pre>");
        session.setAttribute("status", "error");
    }

    response.sendRedirect("messages.jsp");
%>