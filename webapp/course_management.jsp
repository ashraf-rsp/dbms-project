<%@ page import="java.sql.*" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>

<% 
    // Check if the logged-in user is an Admin
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    // Fetch all courses grouped by semester
    LinkedHashMap<String, List<String[]>> coursesBySemester = new LinkedHashMap<>();
    PreparedStatement pstmtCourses = null;
    ResultSet rsCourses = null;

    try {
        String sqlCourses = "SELECT CourseID, CourseCode, CourseName, CreditHours, Semester, CourseFee FROM Courses ORDER BY Semester, CourseCode";
        pstmtCourses = conn.prepareStatement(sqlCourses);
        rsCourses = pstmtCourses.executeQuery();

        while (rsCourses.next()) {
            String courseId = rsCourses.getString("CourseID");
            String courseCode = rsCourses.getString("CourseCode");
            String courseName = rsCourses.getString("CourseName");
            String creditHours = rsCourses.getString("CreditHours");
            String semester = rsCourses.getString("Semester");
            String courseFee = rsCourses.getString("CourseFee");

            if (!coursesBySemester.containsKey(semester)) {
                coursesBySemester.put(semester, new ArrayList<>());
            }
            coursesBySemester.get(semester).add(new String[]{courseId, courseCode, courseName, creditHours, courseFee});
        }

    } catch (SQLException e) {
        System.err.println("Error fetching courses for management: " + e.getMessage());
    } finally {
        if (rsCourses != null) try { rsCourses.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmtCourses != null) try { pstmtCourses.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Fetch all students
    List<String[]> students = new ArrayList<>();
    PreparedStatement pstmtStudents = null;
    ResultSet rsStudents = null;

    try {
        String sqlStudents = "SELECT StudentID, FirstName, LastName FROM Students ORDER BY FirstName, LastName";
        pstmtStudents = conn.prepareStatement(sqlStudents);
        rsStudents = pstmtStudents.executeQuery();

        while (rsStudents.next()) {
            String studentId = rsStudents.getString("StudentID");
            String firstName = rsStudents.getString("FirstName");
            String lastName = rsStudents.getString("LastName");
            students.add(new String[]{studentId, firstName + " " + lastName});
        }
    } catch (SQLException e) {
        System.err.println("Error fetching students for assignment: " + e.getMessage());
    } finally {
        if (rsStudents != null) try { rsStudents.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmtStudents != null) try { pstmtStudents.close(); } catch (SQLException e) { /* ignore */ }
        if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
    }
%>

<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= (String) session.getAttribute("theme") == null ? "ocean" : (String) session.getAttribute("theme") %>">
<head>
    <title>Course Management - Academic Center</title>
    <link rel="stylesheet" href="css/responsive-table.css">
</head>
<body>
    <% request.setAttribute("title", "Course Management"); %>
    <%@ include file="includes/header.jsp" %>

    <div class="main-container">
        <% request.setAttribute("activePage", "course_management"); %>
        <jsp:include page="includes/sidebar.jsp" />

        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-book-open"></i> Course Management</h2>
                </div>

                <div class="summary-card">
                    <h3>Assign Course to Student</h3>
                    <form action="assign_course_process.jsp" method="post">
                        <div class="form-group">
                            <label for="studentId">Select Student:</label>
                            <select id="studentId" name="studentId" class="form-control" required>
                                <option value="">-- Select Student --</option>
                                <% for (String[] student : students) { %>
                                    <option value="<%= student[0] %>"><%= student[1] %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="courseId">Select Course:</label>
                            <select id="courseId" name="courseId" class="form-control" required>
                                <option value="">-- Select Course --</option>
                                <% for (String semester : coursesBySemester.keySet()) { %>
                                    <optgroup label="<%= semester %>">
                                        <% for (String[] course : coursesBySemester.get(semester)) { %>
                                            <option value="<%= course[0] %>" data-credits="<%= course[3] %>" data-fee-per-credit="<%= course[4] %>"><%= course[1] %> (<%= course[3] %> Credits)</option>
                                        <% } %>
                                    </optgroup>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">Assignment Status:</label>
                            <select id="status" name="status" class="form-control" required>
                                <option value="Fresh Registration">Fresh Registration</option>
                                <option value="Enrolled">Enrolled</option>
                                <option value="Completed">Completed</option>
                                <option value="Dropped">Dropped</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="calculatedFee">Calculated Fee:</label>
                            <input type="text" id="calculatedFee" name="calculatedFee" class="form-control" readonly>
                        </div>
                        <button type="submit" class="btn btn-primary">Assign Course</button>
                    </form>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <h3>All Available Courses</h3>
                    </div>
                    <% if (coursesBySemester.isEmpty()) { %>
                        <p>No course information available.</p>
                    <% } else { %>
                        <% for (String semester : coursesBySemester.keySet()) { %>
                            <h4><%= semester %></h4>
                            <div class="responsive-table">
                                <table class="dashboard-table">
                                    <thead>
                                        <tr>
                                            <th>Course Code</th>
                                            <th>Course Name</th>
                                            <th>Credit Hours</th>
                                            <th>Fee per Credit</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (String[] course : coursesBySemester.get(semester)) { %>
                                            <tr>
                                                <td><%= course[1] %></td>
                                                <td><%= course[2] %></td>
                                                <td><%= course[3] %></td>
                                                <td><%= course[4] %></td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="includes/footer.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const courseSelect = document.getElementById('courseId');
            const calculatedFeeInput = document.getElementById('calculatedFee');

            courseSelect.addEventListener('change', function() {
                const selectedOption = courseSelect.options[courseSelect.selectedIndex];
                const credits = parseFloat(selectedOption.dataset.credits);
                const feePerCredit = parseFloat(selectedOption.dataset.feePerCredit);

                if (!isNaN(credits) && !isNaN(feePerCredit)) {
                    calculatedFeeInput.value = (credits * feePerCredit).toFixed(2);
                } else {
                    calculatedFeeInput.value = '';
                }
            });
        });
    </script>
</body>
</html>