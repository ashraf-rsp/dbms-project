<%@ page import="java.sql.*, java.util.*" %>

<%
    int totalCourses = 0;
    int totalStudents = 0;

    // Maps to hold course data
    Map<String, Integer> courseStudentCount = new LinkedHashMap<>();
    Map<String, String> courseSchedules = new LinkedHashMap<>();

    if (userId != null) {
        try {
            // Get courses taught by the teacher and their schedules
            String coursesSql = "SELECT c.CourseID, c.CourseName, s.DayOfWeek, s.StartTime, s.EndTime FROM Courses c JOIN Schedules s ON c.CourseID = s.CourseID WHERE s.TeacherUserID = ?";
            PreparedStatement psCourses = conn.prepareStatement(coursesSql);
            psCourses.setInt(1, userId);
            ResultSet rsCourses = psCourses.executeQuery();

            while (rsCourses.next()) {
                int courseId = rsCourses.getInt("CourseID");
                String courseName = rsCourses.getString("CourseName");
                String dayOfWeek = rsCourses.getString("DayOfWeek");
                String startTime = rsCourses.getString("StartTime");
                String endTime = rsCourses.getString("EndTime");
                String schedule = dayOfWeek + " @ " + startTime + " - " + endTime;

                // Get student count for each course
                String studentCountSql = "SELECT COUNT(*) FROM Enrollments WHERE CourseID = ?";
                PreparedStatement psStudentCount = conn.prepareStatement(studentCountSql);
                psStudentCount.setInt(1, courseId);
                ResultSet rsStudentCount = psStudentCount.executeQuery();
                int studentCount = 0;
                if (rsStudentCount.next()) {
                    studentCount = rsStudentCount.getInt(1);
                }

                courseStudentCount.put(courseName, studentCount);
                courseSchedules.put(courseName, schedule);
                totalStudents += studentCount;
            }
            totalCourses = courseStudentCount.size();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<div class="summary-cards-grid">
    <div class="summary-card">
        <h3>Teacher Quick Stats</h3>
        <p><strong>Total Courses:</strong> <%= totalCourses %></p>
        <p><strong>Total Students:</strong> <%= totalStudents %></p>
    </div>
</div>

<div class="data-table-container">
    <div class="table-header">
        <h3>My Courses</h3>
    </div>
    <div class="responsive-table">
        <table class="dashboard-table">
            <thead>
                <tr>
                    <th>Course Name</th>
                    <th>Enrolled Students</th>
                    <th>Schedule</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map.Entry<String, Integer> entry : courseStudentCount.entrySet()) { %>
                <tr>
                    <td><%= entry.getKey() %></td>
                    <td><%= entry.getValue() %></td>
                    <td><%= courseSchedules.get(entry.getKey()) %></td>
                </tr>
                <% } %>
                <% if (courseStudentCount.isEmpty()) { %>
                <tr>
                    <td colspan="3">You are not currently assigned to any courses.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
