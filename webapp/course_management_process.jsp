<%@ page import="java.sql.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    String action = request.getParameter("action");
    String userRole = (String) request.getAttribute("userRole");

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        if ("add".equals(action)) {
            String courseName = request.getParameter("courseName");
            String courseDescription = request.getParameter("courseDescription");
            double courseFee = Double.parseDouble(request.getParameter("courseFee"));

            String sql = "INSERT INTO Courses (CourseName, CourseDescription, CourseFee) VALUES (?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, courseName);
            pstmt.setString(2, courseDescription);
            pstmt.setDouble(3, courseFee);
            pstmt.executeUpdate();

            session.setAttribute("message", "Course added successfully.");

        } else if ("edit".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String courseName = request.getParameter("courseName");
            String courseDescription = request.getParameter("courseDescription");
            double courseFee = Double.parseDouble(request.getParameter("courseFee"));

            String sql = "UPDATE Courses SET CourseName = ?, CourseDescription = ?, CourseFee = ? WHERE CourseID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, courseName);
            pstmt.setString(2, courseDescription);
            pstmt.setDouble(3, courseFee);
            pstmt.setInt(4, courseId);
            pstmt.executeUpdate();

            session.setAttribute("message", "Course updated successfully.");

        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            String sql = "DELETE FROM Courses WHERE CourseID = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.executeUpdate();

            session.setAttribute("message", "Course deleted successfully.");
        }
    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
    }

    response.sendRedirect("course_management.jsp");
%>
