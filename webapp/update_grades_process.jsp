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
        int gradedByUserId = Integer.parseInt(request.getParameter("gradedByUserId"));
        Date gradeDate = Date.valueOf(LocalDate.now());

        // Get all enrollment IDs for the given course
        String sqlEnrollments = "SELECT EnrollmentID FROM Enrollments WHERE CourseID = ?";
        pstmt = conn.prepareStatement(sqlEnrollments);
        pstmt.setInt(1, courseId);
        ResultSet rsEnrollments = pstmt.executeQuery();

        // Prepare for batch insert/update
        String sqlInsertGrade = "INSERT INTO Grades (EnrollmentID, GradePercentage, GradeLetter, GradedByUserID, GradeDate) VALUES (?, ?, ?, ?, ?)";
        String sqlUpdateGrade = "UPDATE Grades SET GradePercentage = ?, GradeLetter = ?, GradedByUserID = ?, GradeDate = ? WHERE EnrollmentID = ?";

        PreparedStatement pstmtInsert = conn.prepareStatement(sqlInsertGrade);
        PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdateGrade);

        boolean allSuccessful = true;

        while (rsEnrollments.next()) {
            int enrollmentId = rsEnrollments.getInt("EnrollmentID");
            String gradePercentageStr = request.getParameter("grade_" + enrollmentId);
            String gradeLetter = request.getParameter("gradeLetter_" + enrollmentId);

            Double gradePercentage = null;
            if (gradePercentageStr != null && !gradePercentageStr.isEmpty()) {
                try {
                    gradePercentage = Double.parseDouble(gradePercentageStr);
                } catch (NumberFormatException e) {
                    // Handle invalid number format, perhaps set to null or skip
                    gradePercentage = null;
                }
            }

            // Check if grade record already exists for this enrollment
            String sqlCheck = "SELECT COUNT(*) FROM Grades WHERE EnrollmentID = ?";
            PreparedStatement pstmtCheck = conn.prepareStatement(sqlCheck);
            pstmtCheck.setInt(1, enrollmentId);
            ResultSet rsCheck = pstmtCheck.executeQuery();
            rsCheck.next();
            int count = rsCheck.getInt(1);
            rsCheck.close();
            pstmtCheck.close();

            if (count > 0) {
                // Update existing record
                if (gradePercentage != null) {
                    pstmtUpdate.setDouble(1, gradePercentage);
                } else {
                    pstmtUpdate.setNull(1, java.sql.Types.DECIMAL);
                }
                pstmtUpdate.setString(2, gradeLetter);
                pstmtUpdate.setInt(3, gradedByUserId);
                pstmtUpdate.setDate(4, gradeDate);
                pstmtUpdate.setInt(5, enrollmentId);
                pstmtUpdate.addBatch();
            } else if (gradePercentage != null || (gradeLetter != null && !gradeLetter.isEmpty())) {
                // Insert new record only if there's actual grade data
                if (gradePercentage != null) {
                    pstmtInsert.setDouble(1, gradePercentage);
                } else {
                    pstmtInsert.setNull(1, java.sql.Types.DECIMAL);
                }
                pstmtInsert.setString(2, gradeLetter);
                pstmtInsert.setInt(3, enrollmentId);
                pstmtInsert.setInt(4, gradedByUserId);
                pstmtInsert.setDate(5, gradeDate);
                pstmtInsert.addBatch();
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
            message = "Grades updated successfully for Course ID: " + courseId;
        } else {
            conn.rollback(); // Rollback transaction
            message = "Failed to update grades for some students. Please check logs.";
        }

    } catch (SQLException e) {
        try { if (conn != null) conn.rollback(); } catch (SQLException rbex) { /* ignore */ }
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    } catch (NumberFormatException e) {
        message = "Invalid input for Course ID.";
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