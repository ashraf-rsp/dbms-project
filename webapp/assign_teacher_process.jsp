<%@ page import="java.sql.*" %>

<%@ include file="../db_connection.jsp" %>

<%
    // Ensure only Admin can access this page
    if (!"Admin".equals((String) session.getAttribute("userRole"))) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    try {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));

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

    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
        session.setAttribute("status", "error");
    }

    response.sendRedirect("assign_teacher.jsp");
%>