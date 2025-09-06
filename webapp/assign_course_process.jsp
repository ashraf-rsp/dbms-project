<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>

<% 
    // Check if the logged-in user is an Admin
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String studentId = request.getParameter("studentId");
    String courseId = request.getParameter("courseId");
    String sessionId = request.getParameter("sessionId"); // New parameter
    String status = request.getParameter("status");

    if (studentId == null || studentId.isEmpty() || 
        courseId == null || courseId.isEmpty() || 
        sessionId == null || sessionId.isEmpty() || // Check for sessionId
        status == null || status.isEmpty()) {
        // Handle missing parameters, redirect to an error page or back to form with message
        response.sendRedirect("course_management.jsp?error=missing_parameters");
        return;
    }

    PreparedStatement pstmt = null;
    try {
        // Check if enrollment already exists to avoid duplicates (now also by SessionID)
        String checkSql = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = ? AND CourseID = ? AND SessionID = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, Integer.parseInt(studentId));
        pstmt.setInt(2, Integer.parseInt(courseId));
        pstmt.setInt(3, Integer.parseInt(sessionId)); // Use sessionId
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        int existingEnrollments = rs.getInt(1);
        rs.close();
        pstmt.close();

        if (existingEnrollments > 0) {
            // Update existing enrollment
            String updateSql = "UPDATE Enrollments SET Status = ?, EnrollmentDate = CURDATE() WHERE StudentID = ? AND CourseID = ? AND SessionID = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, status);
            pstmt.setInt(2, Integer.parseInt(studentId));
            pstmt.setInt(3, Integer.parseInt(courseId));
            pstmt.setInt(4, Integer.parseInt(sessionId)); // Use sessionId
            pstmt.executeUpdate();
            session.setAttribute("message", "Enrollment updated successfully!");
        } else {
            // Insert new enrollment
            String insertSql = "INSERT INTO Enrollments (StudentID, CourseID, SessionID, EnrollmentDate, Status) VALUES (?, ?, ?, CURDATE(), ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, Integer.parseInt(studentId));
            pstmt.setInt(2, Integer.parseInt(courseId));
            pstmt.setInt(3, Integer.parseInt(sessionId)); // Use sessionId
            pstmt.setString(4, status);
            pstmt.executeUpdate();
            session.setAttribute("message", "Course assigned successfully!");
        }

    } catch (SQLException e) {
        session.setAttribute("error", "Database error: " + e.getMessage());
        System.err.println("Error assigning course: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    response.sendRedirect("course_management.jsp");
%>