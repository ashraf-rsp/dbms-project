<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Check if the logged-in user is an Admin
    
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String action = request.getParameter("action");
    String message = "";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        

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
                message = "Course '" + courseName + "' added successfully.";
            } else {
                message = "Failed to add course.";
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
                message = "Course '" + courseName + "' updated successfully.";
            } else {
                message = "Failed to update course.";
            }
        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String sql = "DELETE FROM Courses WHERE CourseID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                message = "Course deleted successfully.";
            } else {
                message = "Failed to delete course.";
            }
        }
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    } catch (NumberFormatException e) {
        message = "Invalid input for Course Fee or Course ID.";
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        message = "Server configuration error: JDBC Driver not found.";
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    session.setAttribute("message", message);
    response.sendRedirect("course_management.jsp");
%>