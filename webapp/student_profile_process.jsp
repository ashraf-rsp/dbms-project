<%@ page import="java.sql.*" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    

    // Ensure only Student or Parent can access this page
    
    

    if (!"Student".equals(userRole) && !"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String status = "error";
    String message = "An unknown error occurred.";

    try {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String dateOfBirth = request.getParameter("dateOfBirth"); // Format: YYYY-MM-DD

        // Basic validation (more robust validation should be added)
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            message = "First Name and Last Name cannot be empty.";
            response.sendRedirect("student_profile.jsp?studentId=" + studentId + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        }

        

        // Update Students table
        String sql = "UPDATE Students SET FirstName = ?, LastName = ?, DateOfBirth = ? WHERE StudentID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, dateOfBirth); // Assuming dateOfBirth is in YYYY-MM-DD format
        pstmt.setInt(4, studentId);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            status = "success";
            message = "Profile updated successfully!";
            logger.log(Level.INFO, "Student profile updated for StudentID: {0} by UserID: {1}", new Object[]{studentId, userId});
        } else {
            message = "No changes made or student not found.";
            logger.log(Level.WARNING, "Student profile update failed or no changes for StudentID: {0} by UserID: {1}", new Object[]{studentId, userId});
        }

    } catch (NumberFormatException e) {
        message = "Invalid Student ID.";
        logger.log(Level.SEVERE, "NumberFormatException in student_profile_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in student_profile_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in student_profile_process.jsp: " + e.getMessage(), e);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing PreparedStatement", e); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { logger.log(Level.WARNING, "Error closing Connection", e); }
    }

    // Redirect back to student_profile.jsp with status and message
    response.sendRedirect("student_profile.jsp?studentId=" + request.getParameter("studentId") + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
