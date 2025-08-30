<%@ page import="java.sql.*, java.util.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    // Ensure only Teacher can access this page
    if (!"Teacher".equals((String) session.getAttribute("userRole"))) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String sessionDateStr = request.getParameter("sessionDate");
        java.sql.Date sessionDate = java.sql.Date.valueOf(sessionDateStr);

        // Get all students enrolled in the course
        String studentsSql = "SELECT e.EnrollmentID, s.StudentID FROM Enrollments e JOIN Students s ON e.StudentID = s.StudentID WHERE e.CourseID = ?";
        PreparedStatement psStudents = conn.prepareStatement(studentsSql);
        psStudents.setInt(1, courseId);
        ResultSet rsStudents = psStudents.executeQuery();

        while (rsStudents.next()) {
            int enrollmentId = rsStudents.getInt("EnrollmentID");
            String studentId = rsStudents.getString("StudentID");
            String attendanceStatus = request.getParameter("attendance_" + studentId);

            // Check if attendance record already exists for this student and date
            String checkSql = "SELECT AttendanceID FROM Attendance WHERE EnrollmentID = ? AND SessionDate = ?";
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, enrollmentId);
            psCheck.setDate(2, sessionDate);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // Update existing record
                String updateSql = "UPDATE Attendance SET Status = ? WHERE AttendanceID = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                psUpdate.setString(1, attendanceStatus);
                psUpdate.setInt(2, rsCheck.getInt("AttendanceID"));
                psUpdate.executeUpdate();
            } else {
                // Insert new record
                String insertSql = "INSERT INTO Attendance (EnrollmentID, SessionDate, Status) VALUES (?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(insertSql);
                psInsert.setInt(1, enrollmentId);
                psInsert.setDate(2, sessionDate);
                psInsert.setString(3, attendanceStatus);
                psInsert.executeUpdate();
            }
        }

        session.setAttribute("message", "Attendance marked successfully.");
        session.setAttribute("status", "success");

    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
        e.printStackTrace();
    }

    response.sendRedirect("mark_attendance.jsp");
%>