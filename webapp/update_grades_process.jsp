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
    String studentId = request.getParameter("studentId"); // To redirect back to the correct student's grades
    String status = "error";
    String message = "An unknown error occurred.";

    try {
        conn = getConnection();

        if ("add".equals(action)) {
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            double gradePercentage = Double.parseDouble(request.getParameter("gradePercentage"));
            String gradeLetter = request.getParameter("gradeLetter");

            String sql = "INSERT INTO Grades (EnrollmentID, GradePercentage, GradeLetter, GradedByUserID, GradeDate) VALUES (?, ?, ?, ?, CURDATE())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, enrollmentId);
            pstmt.setDouble(2, gradePercentage);
            pstmt.setString(3, gradeLetter);
            pstmt.setInt(4, userId); // Graded by current user

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Grade added successfully!";
                logger.log(Level.INFO, "Grade added for EnrollmentID: {0} by UserID: {1}", new Object[]{enrollmentId, userId});
            } else {
                message = "Failed to add grade.";
                logger.log(Level.WARNING, "Failed to add grade for EnrollmentID: {0} by UserID: {1}", new Object[]{enrollmentId, userId});
            }

        } else if ("edit".equals(action)) {
            int gradeId = Integer.parseInt(request.getParameter("gradeId"));
            double gradePercentage = Double.parseDouble(request.getParameter("gradePercentage"));
            String gradeLetter = request.getParameter("gradeLetter");

            String sql = "UPDATE Grades SET GradePercentage = ?, GradeLetter = ?, GradedByUserID = ?, GradeDate = CURDATE() WHERE GradeID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setDouble(1, gradePercentage);
            pstmt.setString(2, gradeLetter);
            pstmt.setInt(3, userId); // Updated by current user
            pstmt.setInt(4, gradeId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Grade updated successfully!";
                logger.log(Level.INFO, "Grade updated for GradeID: {0} by UserID: {1}", new Object[]{gradeId, userId});
            } else {
                message = "No changes made or grade not found.";
                logger.log(Level.WARNING, "Grade update failed or no changes for GradeID: {0}", gradeId);
            }

        } else {
            message = "Invalid action.";
            logger.log(Level.WARNING, "Invalid action received: {0}", action);
        }

    } catch (NumberFormatException e) {
        message = "Invalid numeric input.";
        logger.log(Level.SEVERE, "NumberFormatException in update_grades_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in update_grades_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in update_grades_process.jsp: " + e.getMessage(), e);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Redirect back to view_grades.jsp with status and message
    response.sendRedirect("view_grades.jsp?studentId=" + studentId + "&status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
