<%@ page import="java.sql.*, java.util.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    String userRole = (String) request.getAttribute("userRole");

    if (!"Teacher".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    Integer teacherId = (Integer) request.getAttribute("userId");

    try {
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        // Get all students enrolled in the course
        String studentsSql = "SELECT e.EnrollmentID, s.StudentID FROM Enrollments e JOIN Students s ON e.StudentID = s.StudentID WHERE e.CourseID = ?";
        PreparedStatement psStudents = conn.prepareStatement(studentsSql);
        psStudents.setInt(1, courseId);
        ResultSet rsStudents = psStudents.executeQuery();

        while (rsStudents.next()) {
            int enrollmentId = rsStudents.getInt("EnrollmentID");
            String studentId = rsStudents.getString("StudentID");
            String gradeStr = request.getParameter("grade_" + studentId);

            if (gradeStr != null && !gradeStr.isEmpty()) {
                double gradePercentage = Double.parseDouble(gradeStr);
                String gradeLetter = "";

                if (gradePercentage >= 90) {
                    gradeLetter = "A";
                } else if (gradePercentage >= 80) {
                    gradeLetter = "B";
                } else if (gradePercentage >= 70) {
                    gradeLetter = "C";
                } else if (gradePercentage >= 60) {
                    gradeLetter = "D";
                } else {
                    gradeLetter = "F";
                }

                // Check if a grade record already exists
                String checkSql = "SELECT GradeID FROM Grades WHERE EnrollmentID = ?";
                PreparedStatement psCheck = conn.prepareStatement(checkSql);
                psCheck.setInt(1, enrollmentId);
                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next()) {
                    // Update existing record
                    String updateSql = "UPDATE Grades SET GradePercentage = ?, GradeLetter = ?, GradedByUserID = ?, GradeDate = CURDATE() WHERE GradeID = ?";
                    PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                    psUpdate.setDouble(1, gradePercentage);
                    psUpdate.setString(2, gradeLetter);
                    psUpdate.setInt(3, teacherId);
                    psUpdate.setInt(4, rsCheck.getInt("GradeID"));
                    psUpdate.executeUpdate();
                } else {
                    // Insert new record
                    String insertSql = "INSERT INTO Grades (EnrollmentID, GradePercentage, GradeLetter, GradedByUserID, GradeDate) VALUES (?, ?, ?, ?, CURDATE())";
                    PreparedStatement psInsert = conn.prepareStatement(insertSql);
                    psInsert.setInt(1, enrollmentId);
                    psInsert.setDouble(2, gradePercentage);
                    psInsert.setString(3, gradeLetter);
                    psInsert.setInt(4, teacherId);
                    psInsert.executeUpdate();
                }
            }
        }

        session.setAttribute("message", "Grades updated successfully.");
        session.setAttribute("status", "success");

    } catch (NumberFormatException e) {
        session.setAttribute("message", "Invalid grade format.");
        session.setAttribute("status", "error");
    } catch (SQLException e) {
        session.setAttribute("message", "Database error: " + e.getMessage());
        session.setAttribute("status", "error");
    } catch (Exception e) {
        session.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
    }

    response.sendRedirect("update_grades.jsp");
%>
