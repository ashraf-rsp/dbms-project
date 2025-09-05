<%@ page import="java.sql.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    String userRole = (String) request.getAttribute("userRole");

    if (!"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        // Check for duplicate assignment
        String sqlCheckDuplicate = "SELECT COUNT(*) FROM Schedules WHERE TeacherUserID = ? AND CourseID = ?";
        PreparedStatement pstmtCheck = conn.prepareStatement(sqlCheckDuplicate);
        pstmtCheck.setInt(1, teacherId);
        pstmtCheck.setInt(2, courseId);
        ResultSet rsCheck = pstmtCheck.executeQuery();
        if (rsCheck.next() && rsCheck.getInt(1) > 0) {
            session.setAttribute("message", "Teacher is already assigned to this course.");
            session.setAttribute("status", "error");
            response.sendRedirect("assign_teacher.jsp");
            return;
        }
        rsCheck.close();
        pstmtCheck.close();

        // For now, we'll set a default schedule time. This can be expanded later.
        String dayOfWeek = "TBD";
        String startTime = "00:00:00";
        String endTime = "00:00:00";
        String room = "TBD";

        String sql = "INSERT INTO Schedules (CourseID, TeacherUserID, DayOfWeek, StartTime, EndTime, Room) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, courseId);
        pstmt.setInt(2, teacherId);
        pstmt.setString(3, dayOfWeek);
        pstmt.setString(4, startTime);
        pstmt.setString(5, endTime);
        pstmt.setString(6, room);
        pstmt.executeUpdate();

        session.setAttribute("message", "Teacher assigned successfully.");
        session.setAttribute("status", "success");

    } catch (NumberFormatException e) {
        session.setAttribute("message", "Invalid teacher ID or course ID.");
        session.setAttribute("status", "error");
    } catch (SQLException e) {
        session.setAttribute("message", "Database error: " + e.getMessage());
        session.setAttribute("status", "error");
    } catch (Exception e) {
        session.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
    }

    response.sendRedirect("assign_teacher.jsp");
%>