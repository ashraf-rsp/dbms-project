<%@ page import="java.sql.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    // Ensure only Admin can access this page
    if (!"Admin".equals((String) session.getAttribute("userRole"))) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        String studentId = request.getParameter("studentId");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        // Set a default enrollment date
        java.sql.Date enrollmentDate = new java.sql.Date(new java.util.Date().getTime());

        String sql = "INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES (?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        pstmt.setInt(2, courseId);
        pstmt.setDate(3, enrollmentDate);
        pstmt.executeUpdate();

        session.setAttribute("message", "Student enrolled successfully.");
        session.setAttribute("status", "success");

    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
    }

    response.sendRedirect("enroll_student.jsp");
%>
