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
    if (!"Admin".equals(userRole) && !"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String action = request.getParameter("action");
    String status = "error";
    String message = "An unknown error occurred.";

    try {
        conn = getConnection();

        if ("add".equals(action)) {
            String courseName = request.getParameter("courseName");
            String courseDescription = request.getParameter("courseDescription");
            double courseFee = Double.parseDouble(request.getParameter("courseFee"));

            String sql = "INSERT INTO Courses (CourseName, CourseDescription, CourseFee) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, courseName);
            pstmt.setString(2, courseDescription);
            pstmt.setDouble(3, courseFee);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Course added successfully!";
                logger.log(Level.INFO, "Course added: {0}", courseName);
            } else {
                message = "Failed to add course.";
                logger.log(Level.WARNING, "Failed to add course: {0}", courseName);
            }

        } else if ("edit".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String courseName = request.getParameter("courseName");
            String courseDescription = request.getParameter("courseDescription");
            double courseFee = Double.parseDouble(request.getParameter("courseFee"));

            String sql = "UPDATE Courses SET CourseName = ?, CourseDescription = ?, CourseFee = ? WHERE CourseID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, courseName);
            pstmt.setString(2, courseDescription);
            pstmt.setDouble(3, courseFee);
            pstmt.setInt(4, courseId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Course updated successfully!";
                logger.log(Level.INFO, "Course updated: {0}", courseId);
            } else {
                message = "No changes made or course not found.";
                logger.log(Level.WARNING, "Course update failed or no changes for CourseID: {0}", courseId);
            }

        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String sql = "DELETE FROM Courses WHERE CourseID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                status = "success";
                message = "Course deleted successfully!";
                logger.log(Level.INFO, "Course deleted: {0}", courseId);
            } else {
                message = "Course not found or failed to delete.";
                logger.log(Level.WARNING, "Course deletion failed for CourseID: {0}", courseId);
            }

        } else {
            message = "Invalid action.";
            logger.log(Level.WARNING, "Invalid action received: {0}", action);
        }

    } catch (NumberFormatException e) {
        message = "Invalid numeric input.";
        logger.log(Level.SEVERE, "NumberFormatException in course_management_process.jsp: " + e.getMessage(), e);
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        logger.log(Level.SEVERE, "SQLException in course_management_process.jsp: " + e.getMessage(), e);
    } catch (Exception e) {
        message = "An unexpected error occurred: " + e.getMessage();
        logger.log(Level.SEVERE, "Exception in course_management_process.jsp: " + e.getMessage(), e);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Redirect back to course_management.jsp with status and message
    response.sendRedirect("course_management.jsp?status=" + status + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
