<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null) {
        response.sendRedirect("login.jsp?error=session");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Prepare variables
    String displayName = "";
    String studentId = null;
    Integer parentId = null;

    // --- Get Display Name and User-Specific IDs ---
    PreparedStatement psName = null;
    ResultSet rsName = null;
    try {
        if ("Admin".equals(userRole)) {
            displayName = "Admin";
        } else if ("Teacher".equals(userRole)) {
            psName = conn.prepareStatement("SELECT TeacherName FROM Teachers WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) {
                displayName = rsName.getString("TeacherName");
            } else {
                displayName = (String) request.getAttribute("loggedInUser"); // Fallback to username
            }
        } else if ("Student".equals(userRole)) {
            psName = conn.prepareStatement("SELECT StudentName, StudentID FROM Students WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) {
                displayName = rsName.getString("StudentName");
                studentId = rsName.getString("StudentID");
            } else {
                displayName = (String) request.getAttribute("loggedInUser"); // Fallback to username
            }
        } else if ("Parent".equals(userRole)) {
            psName = conn.prepareStatement("SELECT ParentID, FirstName, LastName FROM Parents WHERE UserID = ?");
            psName.setInt(1, userId);
            rsName = psName.executeQuery();
            if (rsName.next()) {
                parentId = rsName.getInt("ParentID");
                displayName = rsName.getString("FirstName") + " " + rsName.getString("LastName");
            } else {
                displayName = (String) request.getAttribute("loggedInUser"); // Fallback to username
            }
        }
    } catch (SQLException e) {
        System.err.println("Error fetching display name: " + e.getMessage());
        displayName = (String) request.getAttribute("loggedInUser"); // Fallback to username
    } finally {
        if (rsName != null) try { rsName.close(); } catch (SQLException e) { /* ignore */ }
        if (psName != null) try { psName.close(); } catch (SQLException e) { /* ignore */ }
    }

    // --- Fetch Schedule Data ---
    Map<String, Map<String, String>> scheduleGrid = new HashMap<>();
    String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
    List<String> timeSlots = new ArrayList<>();

    PreparedStatement psSchedule = null;
    ResultSet rsSchedule = null;
    PreparedStatement psTimeSlots = null;
    ResultSet rsTimeSlots = null;

    try {
        // Dynamically get all unique time slots
        String sqlTimeSlots = "SELECT DISTINCT StartTime, EndTime FROM Schedules ORDER BY StartTime";
        psTimeSlots = conn.prepareStatement(sqlTimeSlots);
        rsTimeSlots = psTimeSlots.executeQuery();
        while (rsTimeSlots.next()) {
            timeSlots.add(rsTimeSlots.getTime("StartTime").toString().substring(0, 5) + " - " + rsTimeSlots.getTime("EndTime").toString().substring(0, 5));
        }
        rsTimeSlots.close();
        psTimeSlots.close();

        StringBuilder sqlSchedule = new StringBuilder("SELECT s.DayOfWeek, s.StartTime, s.EndTime, c.CourseName, u.Username AS TeacherUsername, s.Room FROM Schedules s JOIN Courses c ON s.CourseID = c.CourseID JOIN Users u ON s.TeacherUserID = u.UserID ");

        if ("Teacher".equals(userRole)) {
            sqlSchedule.append("WHERE s.TeacherUserID = ? ");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setInt(1, userId);
        } else if ("Student".equals(userRole)) {
            sqlSchedule.append("JOIN Enrollments e ON s.CourseID = e.CourseID WHERE e.StudentID = ? ");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setString(1, studentId);
        } else if ("Parent".equals(userRole)) {
            sqlSchedule.append("JOIN Enrollments e ON s.CourseID = e.CourseID JOIN Student_Parent_Link spl ON e.StudentID = spl.StudentID WHERE spl.ParentID = ? ");
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
            psSchedule.setInt(1, parentId);
        } else { // Admin sees all schedules
            psSchedule = conn.prepareStatement(sqlSchedule.toString());
        }
        
        rsSchedule = psSchedule.executeQuery();
        while (rsSchedule.next()) {
            String day = rsSchedule.getString("DayOfWeek");
            String startTime = rsSchedule.getTime("StartTime").toString().substring(0, 5);
            String endTime = rsSchedule.getTime("EndTime").toString().substring(0, 5);
            String courseName = rsSchedule.getString("CourseName");
            String teacherUsername = rsSchedule.getString("TeacherUsername");
            String room = rsSchedule.getString("Room");
            String timeSlot = startTime + " - " + endTime;
            String itemContent = courseName + "<br>" + teacherUsername + "<br>Room " + room;

            scheduleGrid.computeIfAbsent(timeSlot, k -> new HashMap<>()).put(day, itemContent);
        }
    } catch (Exception e) {
        System.err.println("Error fetching schedule: " + e.getMessage());
        // Optionally set an error message for the user
    } finally {
        if (rsSchedule != null) try { rsSchedule.close(); } catch (SQLException e) { /* ignore */ }
        if (psSchedule != null) try { psSchedule.close(); } catch (SQLException e) { /* ignore */ }
        if (rsTimeSlots != null) try { rsTimeSlots.close(); } catch (SQLException e) { /* ignore */ }
        if (psTimeSlots != null) try { psTimeSlots.close(); } catch (SQLException e) { /* ignore */ }
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
            <div class="page-header">
                <h2><i class="fas fa-calendar-alt"></i> Class Schedule</h2>
            </div>
            <section class="schedule-section">
                <h2>Schedule for 
                    <%= displayName %>
                </h2>
                
                <div class="schedule-grid-container">
                    <div class="schedule-grid">
                        <div class="grid-header time-col">Time</div>
                        <% for (String day : days) { %>
                            <div class="grid-header"><%= day %></div>
                        <% } %>

                        <% for (String timeSlot : timeSlots) { %>
                            <div class="time-slot"><%= timeSlot %></div>
                            <% for (String day : days) {
                                String content = scheduleGrid.getOrDefault(timeSlot, Collections.emptyMap()).getOrDefault(day, "");
                            %>
                                <div class="schedule-item"><%= content %></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
