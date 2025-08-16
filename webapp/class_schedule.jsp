<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<% 
    // This page is accessible by all logged-in users.
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String studentName = "";
    String teacherName = "";
    int studentId = -1;
    int teacherId = -1; // Placeholder, as no Teachers table

    // Map to hold schedule data for grid view
    Map<String, Map<String, String>> scheduleGrid = new HashMap<>();
    String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
    String[] timeSlots = {"09:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00"}; // Example time slots

    try {
        conn = getConnection();

        // Determine studentId or teacherId based on userRole
        if ("Student".equals(userRole)) {
            studentId = userId; // Assumption: UserID is StudentID for Student users
            String sqlStudentName = "SELECT FirstName, LastName FROM Students WHERE StudentID = ?";
            pstmt = conn.prepareStatement(sqlStudentName);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                studentName = rs.getString("FirstName") + " " + rs.getString("LastName");
            }
            rs.close();
            pstmt.close();
        } else if ("Parent".equals(userRole)) {
            // Get the first linked student for this parent
            String sqlParentLinkedStudent = "SELECT spl.StudentID FROM Users u JOIN Student_Parent_Link spl ON u.ParentID = spl.ParentID WHERE u.UserID = ? LIMIT 1";
            pstmt = conn.prepareStatement(sqlParentLinkedStudent);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                studentId = rs.getInt("StudentID");
            }
            rs.close();
            pstmt.close();

            if (studentId != -1) {
                String sqlStudentName = "SELECT FirstName, LastName FROM Students WHERE StudentID = ?";
                pstmt = conn.prepareStatement(sqlStudentName);
                pstmt.setInt(1, studentId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    studentName = rs.getString("FirstName") + " " + rs.getString("LastName");
                }
                rs.close();
                pstmt.close();
            }
        } else if ("Teacher".equals(userRole)) {
            teacherId = userId; // Assumption: UserID is TeacherUserID for Teacher users
            String sqlTeacherName = "SELECT Username FROM Users WHERE UserID = ?";
            pstmt = conn.prepareStatement(sqlTeacherName);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                teacherName = rs.getString("Username");
            }
            rs.close();
            pstmt.close();
        }

        // Fetch Schedule Data
        StringBuilder sqlSchedule = new StringBuilder("SELECT s.DayOfWeek, s.StartTime, s.EndTime, c.CourseName, u.Username AS TeacherName, s.Room ");
        sqlSchedule.append("FROM Schedules s JOIN Courses c ON s.CourseID = c.CourseID JOIN Users u ON s.TeacherUserID = u.UserID ");

        if ("Student".equals(userRole) || "Parent".equals(userRole)) {
            if (studentId != -1) {
                sqlSchedule.append("JOIN Enrollments e ON s.CourseID = e.CourseID WHERE e.StudentID = ? ");
            } else {
                // No student linked, no schedule to show
                out.println("<p>No student linked to display schedule.</p>");
                return;
            }
        } else if ("Teacher".equals(userRole)) {
            if (teacherId != -1) {
                sqlSchedule.append("WHERE s.TeacherUserID = ? ");
            } else {
                // No teacher linked, no schedule to show
                out.println("<p>No teacher linked to display schedule.</p>");
                return;
            }
        }
        sqlSchedule.append("ORDER BY FIELD(s.DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), s.StartTime");

        pstmt = conn.prepareStatement(sqlSchedule.toString());
        if ("Student".equals(userRole) || "Parent".equals(userRole)) {
            if (studentId != -1) {
                pstmt.setInt(1, studentId);
            }
        } else if ("Teacher".equals(userRole)) {
            if (teacherId != -1) {
                pstmt.setInt(1, teacherId);
            }
        }
        rs = pstmt.executeQuery();

        // Populate scheduleGrid for grid view
        while (rs.next()) {
            String day = rs.getString("DayOfWeek");
            String startTime = rs.getTime("StartTime").toString().substring(0, 5); // Format HH:MM
            String endTime = rs.getTime("EndTime").toString().substring(0, 5); // Format HH:MM
            String courseName = rs.getString("CourseName");
            String teacher = rs.getString("TeacherName");
            String room = rs.getString("Room");

            String timeSlot = startTime + " - " + endTime;
            String itemContent = courseName + "<br>" + teacher + "<br>Room " + room;

            if (!scheduleGrid.containsKey(timeSlot)) {
                scheduleGrid.put(timeSlot, new HashMap<>());
            }
            scheduleGrid.get(timeSlot).put(day, itemContent);
        }

%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Class Schedule</h1>
    <section class="schedule-section">
        <h2>Schedule for 
            <% 
                if ("Student".equals(userRole) || "Parent".equals(userRole)) {
                    out.print(studentName);
                } else if ("Teacher".equals(userRole)) {
                    out.print(teacherName);
                } else {
                    out.print("All Classes");
                }
            %>
        </h2>
        <div class="filter-controls">
            <label for="day-filter">Filter by Day:</label>
            <select id="day-filter">
                <option value="all">All Days</option>
                <option value="monday">Monday</option>
                <option value="tuesday">Tuesday</option>
                <option value="wednesday">Wednesday</option>
                <option value="thursday">Thursday</option>
                <option value="friday">Friday</option>
            </select>
        </div>

        <div class="schedule-grid-container">
            <div class="schedule-grid">
                <div class="grid-header time-col">Time</div>
                <div class="grid-header">Monday</div>
                <div class="grid-header">Tuesday</div>
                <div class="grid-header">Wednesday</div>
                <div class="grid-header">Thursday</div>
                <div class="grid-header">Friday</div>

                <% 
                    for (String timeSlot : timeSlots) {
                %>
                <div class="time-slot"><%= timeSlot %></div>
                <% 
                        for (String day : days) {
                            String content = scheduleGrid.containsKey(timeSlot) ? scheduleGrid.get(timeSlot).getOrDefault(day, "") : "";
                %>
                <div class="schedule-item"><%= content %></div>
                <% 
                        }
                    }
                %>
            </div>
        </div>

        <h3>Detailed Schedule List</h3>
        <div class="responsive-table-container">
            <table class="schedule-table">
                <thead>
                    <tr>
                        <th>Day</th>
                        <th>Time</th>
                        <th>Subject</th>
                        <th>Teacher</th>
                        <th>Room</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Re-execute query for list view
                        rs.beforeFirst(); // Reset ResultSet cursor
                        if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                            out.println("<tr><td colspan=\"5\">No schedule found.</td></tr>");
                        } else {
                            while (rs.next()) {
                    %>
                    <tr>
                        <td data-label="Day"><%= rs.getString("DayOfWeek") %></td>
                        <td data-label="Time"><%= rs.getTime("StartTime").toString().substring(0, 5) %> - <%= rs.getTime("EndTime").toString().substring(0, 5) %></td>
                        <td data-label="Subject"><%= rs.getString("CourseName") %></td>
                        <td data-label="Teacher"><%= rs.getString("TeacherName") %></td>
                        <td data-label="Room"><%= rs.getString("Room") %></td>
                    </tr>
                    <% 
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>
<% 
    } catch (Exception e) {
        System.err.println("Error loading class schedule: " + e.getMessage());
        out.println("<p>Error loading class schedule. Please try again.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="WEB-INF/jspf/footer.jspf" %>