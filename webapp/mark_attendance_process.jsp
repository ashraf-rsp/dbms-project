<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    Connection conn = null;
    PreparedStatement pstmt = null;

    // Ensure only Admin or Teacher can access this page
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    if (!"Admin".equals(userRole) && !"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String action = request.getParameter("action");
    String studentId = request.getParameter("studentId"); // To redirect back to the correct student's attendance
    String status = "error";
    String message = "An unknown error occurred.";

    try {
        conn = getConnection();

        if ("add".equals(action)) {
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            String sessionDate = request.getParameter("sessionDate");
            String attendanceStatus = request.getParameter("status");
            String notes = request.getParameter("notes");

            String sql = "INSERT INTO Attendance (EnrollmentID, SessionDate, Status, Notes) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, enrollmentId);
            pstmt.setString(2, sessionDate);
            pstmt.setString(3, attendanceStatus);
            pstmt.setString(4, notes);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Attendance marked successfully!";
                logger.log(Level.INFO, "Attendance marked for EnrollmentID: {0} on {1} with status {2} by UserID: {3}", new Object[]{enrollmentId, sessionDate, attendanceStatus, userId});
            } else {
                message = "Failed to mark attendance.";
                logger.log(Level.WARNING, "Failed to mark attendance for EnrollmentID: {0} on {1} with status {2} by UserID: {3}", new Object[]{enrollmentId, sessionDate, attendanceStatus, userId});
            }

        } else if ("edit".equals(action)) {
            int attendanceId = Integer.parseInt(request.getParameter("attendanceId"));
            String sessionDate = request.getParameter("sessionDate");
            String attendanceStatus = request.getParameter("status");
            String notes = request.getParameter("notes");

            String sql = "UPDATE Attendance SET SessionDate = ?, Status = ?, Notes = ? WHERE AttendanceID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionDate);
            pstmt.setString(2, attendanceStatus);
            pstmt.setString(3, notes);
            pstmt.setInt(4, attendanceId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Attendance updated successfully!";
                logger.log(Level.INFO, "Attendance updated for AttendanceID: {0} by UserID: {1}", new Object[]{attendanceId, userId});
            } else {
                message = "No changes made or attendance record not found.";
                logger.log(Level.WARNING, "Attendance update failed or no changes for AttendanceID: {0}", attendanceId);
            }

        } else {
            message = "Invalid action.";
            logger.log(Level.WARNING, "Invalid action received: {0}", action);
        }

    } catch (NumberFormatException e) {
        message = "Invalid numeric input.";
        logger.log(Level.SEVERE, "NumberFormatException in mark_attendance_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in mark_attendance_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in mark_attendance_process.jsp: " + e.getMessage(), e);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Redirect back to view_attendance.jsp with status and message
    response.sendRedirect("view_attendance.jsp?studentId=" + studentId + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
