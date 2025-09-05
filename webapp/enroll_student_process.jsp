<%@ page import="java.sql.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    String userRole = (String) request.getAttribute("userRole");

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        String studentId = request.getParameter("studentId");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        // Check for duplicate enrollment
        String sqlCheckDuplicate = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = ? AND CourseID = ?";
        PreparedStatement pstmtCheck = conn.prepareStatement(sqlCheckDuplicate);
        pstmtCheck.setString(1, studentId);
        pstmtCheck.setInt(2, courseId);
        ResultSet rsCheck = pstmtCheck.executeQuery();
        if (rsCheck.next() && rsCheck.getInt(1) > 0) {
            session.setAttribute("message", "Student is already enrolled in this course.");
            session.setAttribute("status", "error");
            response.sendRedirect("enroll_student.jsp");
            return;
        }
        rsCheck.close();
        pstmtCheck.close();

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

    } catch (NumberFormatException e) {
        session.setAttribute("message", "Invalid student ID or course ID.");
        session.setAttribute("status", "error");
    } catch (SQLException e) {
        session.setAttribute("message", "Database error: " + e.getMessage());
        session.setAttribute("status", "error");
    } catch (Exception e) {
        session.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
    }

    response.sendRedirect("enroll_student.jsp");
%>
