<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Teacher can access this page
    
    

    if (userRole == null || !userRole.equals("Teacher") || teacherUserId == null) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String message = "";
    

    try {
        
        conn.setAutoCommit(false); // Start transaction

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String sessionDateStr = request.getParameter("sessionDate");
        Date sessionDate = Date.valueOf(sessionDateStr);

        // Get all enrollment IDs for the given course
        String sqlEnrollments = "SELECT EnrollmentID FROM Enrollments WHERE CourseID = ?";
        pstmt = conn.prepareStatement(sqlEnrollments);
        pstmt.setInt(1, courseId);
        ResultSet rsEnrollments = pstmt.executeQuery();

        // Prepare for batch insert/update
        String sqlInsertAttendance = "INSERT INTO Attendance (EnrollmentID, SessionDate, Status) VALUES (?, ?, ?)";
        String sqlUpdateAttendance = "UPDATE Attendance SET Status = ? WHERE EnrollmentID = ? AND SessionDate = ?";

        PreparedStatement pstmtInsert = conn.prepareStatement(sqlInsertAttendance);
        PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdateAttendance);

        boolean allSuccessful = true;

        while (rsEnrollments.next()) {
            int enrollmentId = rsEnrollments.getInt("EnrollmentID");
            String status = request.getParameter("status_" + enrollmentId);

            if (status != null) {
                // Check if attendance record already exists for this enrollment and date
                String sqlCheck = "SELECT COUNT(*) FROM Attendance WHERE EnrollmentID = ? AND SessionDate = ?";
                PreparedStatement pstmtCheck = conn.prepareStatement(sqlCheck);
                pstmtCheck.setInt(1, enrollmentId);
                pstmtCheck.setDate(2, sessionDate);
                ResultSet rsCheck = pstmtCheck.executeQuery();
                rsCheck.next();
                int count = rsCheck.getInt(1);
                rsCheck.close();
                pstmtCheck.close();

                if (count > 0) {
                    // Update existing record
                    pstmtUpdate.setString(1, status);
                    pstmtUpdate.setInt(2, enrollmentId);
                    pstmtUpdate.setDate(3, sessionDate);
                    pstmtUpdate.addBatch();
                } else {
                    // Insert new record
                    pstmtInsert.setInt(1, enrollmentId);
                    pstmtInsert.setDate(2, sessionDate);
                    pstmtInsert.setString(3, status);
                    pstmtInsert.addBatch();
                }
            }
        }
        rsEnrollments.close();
        pstmt.close();

        int[] insertResults = pstmtInsert.executeBatch();
        int[] updateResults = pstmtUpdate.executeBatch();

        for (int result : insertResults) {
            if (result == PreparedStatement.EXECUTE_FAILED) allSuccessful = false;
        }
        for (int result : updateResults) {
            if (result == PreparedStatement.EXECUTE_FAILED) allSuccessful = false;
        }

        if (allSuccessful) {
            conn.commit(); // Commit transaction
            message = "Attendance marked successfully for Course ID: " + courseId;
        } else {
            conn.rollback(); // Rollback transaction
            message = "Failed to mark attendance for some students. Please check logs.";
        }

    } catch (SQLException e) {
        try { if (conn != null) conn.rollback(); } catch (SQLException rbex) { /* ignore */ }
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    } catch (NumberFormatException e) {
        message = "Invalid Course ID.";
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        message = "Server configuration error: JDBC Driver not found.";
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }

    session.setAttribute("message", message);
    response.sendRedirect("teacher_dashboard.jsp");
%>