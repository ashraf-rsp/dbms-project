<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.time.LocalTime, java.util.stream.Collectors" %>
<%@ include file="db_connection.jsp" %>
<%!
    // Simple Java Bean (POJO) to hold schedule item data
    public static class ScheduleEntry {
        private String timeSlot;
        private String courseName;
        private String teacherName;
        private String room;
        private LocalTime startTime;

        public ScheduleEntry(String startTime, String endTime, String courseName, String teacherName, String room) {
            this.timeSlot = startTime + " - " + endTime;
            this.courseName = courseName;
            this.teacherName = teacherName;
            this.room = room;
            this.startTime = LocalTime.parse(startTime);
        }

        public String getTimeSlot() { return timeSlot; }
        public String getCourseName() { return courseName; }
        public String getTeacherName() { return teacherName; }
        public String getRoom() { return room; }
        public LocalTime getStartTime() { return startTime; }
    }
%>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean";

    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }

    String displayName = "";
    String studentIdForQuery = null;
    Integer parentIdForQuery = null;

    // --- Get Display Name and User-Specific IDs ---
    // (This logic remains largely the same as before)
    PreparedStatement psName = null;
    ResultSet rsName = null;
    try {
        if ("Admin".equals(userRole)) {
            displayName = "All Users";
        } else if ("Teacher".equals(userRole)) {
            psName = conn.prepareStatement("SELECT TeacherName FROM Teachers WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) displayName = rsName.getString("TeacherName");
        } else if ("Student".equals(userRole)) {
            psName = conn.prepareStatement("SELECT StudentID, StudentName FROM Students WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) {
                studentIdForQuery = rsName.getString("StudentID");
                displayName = rsName.getString("StudentName");
            }
        } else if ("Parent".equals(userRole)) {
            psName = conn.prepareStatement("SELECT ParentID, FirstName, LastName FROM Parents WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) {
                parentIdForQuery = rsName.getInt("ParentID");
                displayName = rsName.getString("FirstName") + " " + rsName.getString("LastName");
            }
        }
        if (displayName == null || displayName.isEmpty()) {
            displayName = (String) request.getAttribute("loggedInUser"); // Fallback
        }
    } catch (SQLException e) {
        System.err.println("Error fetching display name: " + e.getMessage());
        displayName = (String) request.getAttribute("loggedInUser"); // Fallback
    } finally {
        if (rsName != null) try { rsName.close(); } catch (SQLException e) { /* ignore */ }
        if (psName != null) try { psName.close(); } catch (SQLException e) { /* ignore */ }
    }

    // --- Fetch Schedule Data into the new structure ---
    Map<String, List<ScheduleEntry>> scheduleByDay = new LinkedHashMap<>();
    String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
    for(String day : days) {
        scheduleByDay.put(day, new ArrayList<>());
    }

    PreparedStatement psSchedule = null;
    ResultSet rsSchedule = null;
    try {
        StringBuilder sqlSchedule = new StringBuilder("SELECT s.DayOfWeek, s.StartTime, s.EndTime, c.CourseName, u.Username AS TeacherUsername, s.Room FROM Schedules s JOIN Courses c ON s.CourseID = c.CourseID JOIN Users u ON s.TeacherUserID = u.UserID ");

        if ("Teacher".equals(userRole)) {
            sqlSchedule.append("WHERE s.TeacherUserID = ?");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setInt(1, userId);
        } else if ("Student".equals(userRole)) {
            sqlSchedule.append("JOIN Enrollments e ON s.CourseID = e.CourseID WHERE e.StudentID = ?");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setString(1, studentIdForQuery);
        } else if ("Parent".equals(userRole)) {
            sqlSchedule.append("JOIN Enrollments e ON s.CourseID = e.CourseID JOIN Student_Parent_Link spl ON e.StudentID = spl.StudentID WHERE spl.ParentID = ?");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setInt(1, parentIdForQuery);
        } else { // Admin
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
        }
        
        rsSchedule = psSchedule.executeQuery();
        while (rsSchedule.next()) {
            String day = rsSchedule.getString("DayOfWeek");
            ScheduleEntry entry = new ScheduleEntry(
                rsSchedule.getTime("StartTime").toString().substring(0, 5),
                rsSchedule.getTime("EndTime").toString().substring(0, 5),
                rsSchedule.getString("CourseName"),
                rsSchedule.getString("TeacherUsername"),
                rsSchedule.getString("Room")
            );
            if (scheduleByDay.containsKey(day)) {
                scheduleByDay.get(day).add(entry);
            }
        }

        // Sort entries within each day by start time
        for (List<ScheduleEntry> entries : scheduleByDay.values()) {
            entries.sort(Comparator.comparing(ScheduleEntry::getStartTime));
        }

    } catch (Exception e) {
        System.err.println("Error fetching schedule: " + e.getMessage());
    } finally {
        if (rsSchedule != null) try { rsSchedule.close(); } catch (SQLException e) { /* ignore */ }
        if (psSchedule != null) try { psSchedule.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Class Schedule - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="class_schedule" />
        </jsp:include>
        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-calendar-alt"></i> Class Schedule</h2>
                </div>
                <section class="schedule-section">
                    <h2>Schedule for <%= displayName %></h2>
                    
                    <div class="agenda-view">
                        <% for (String day : days) { 
                            List<ScheduleEntry> entries = scheduleByDay.get(day);
                        %>
                            <div class="day-section">
                                <h3 class="day-header"><%= day %></h3>
                                <div class="day-schedule-items">
                                    <% if (entries != null && !entries.isEmpty()) { %>
                                        <% for (ScheduleEntry entry : entries) { %>
                                            <div class="agenda-item">
                                                <div class="agenda-time">
                                                    <i class="far fa-clock"></i> <%= entry.getTimeSlot() %>
                                                </div>
                                                <div class="agenda-details">
                                                    <div class="agenda-course-name"><%= entry.getCourseName() %></div>
                                                    <div class="agenda-meta">
                                                        <span><i class="fas fa-chalkboard-teacher"></i> <%= entry.getTeacherName() %></span>
                                                        <span><i class="fas fa-map-marker-alt"></i> <%= entry.getRoom() %></span>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>
                                    <% } else { %>
                                        <div class="agenda-item empty">
                                            <p>No classes scheduled for this day.</p>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>

                </section>
            </div>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>