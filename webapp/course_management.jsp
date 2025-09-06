<%@ page import="java.sql.*" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>

<% 
    // Check if the logged-in user is an Admin
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    // Fetch all semesters
    Map<Integer, String> semesters = new LinkedHashMap<>();
    PreparedStatement pstmtSemesters = null;
    ResultSet rsSemesters = null;
    try {
        String sqlSemesters = "SELECT SemesterID, SemesterName FROM Semesters ORDER BY SemesterLevel";
        pstmtSemesters = conn.prepareStatement(sqlSemesters);
        rsSemesters = pstmtSemesters.executeQuery();
        while (rsSemesters.next()) {
            semesters.put(rsSemesters.getInt("SemesterID"), rsSemesters.getString("SemesterName"));
        }
    } catch (SQLException e) {
        System.err.println("Error fetching semesters: " + e.getMessage());
    } finally {
        if (rsSemesters != null) try { rsSemesters.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmtSemesters != null) try { pstmtSemesters.close(); } catch (SQLException e) { /* ignore */ }
    }

    // Fetch all sessions
    List<String[]> sessions = new ArrayList<>();
    PreparedStatement pstmtSessions = null;
    ResultSet rsSessions = null;
    try {
        String sqlSessions = "SELECT SessionID, SessionName FROM Sessions ORDER BY Year DESC, Term";
        pstmtSessions = conn.prepareStatement(sqlSessions);
        rsSessions = pstmtSessions.executeQuery();
        while (rsSessions.next()) {
            sessions.add(new String[]{rsSessions.getString("SessionID"), rsSessions.getString("SessionName")});
        }
    } catch (SQLException e) {
        System.err.println("Error fetching sessions: " + e.getMessage());
    } finally {
        if (rsSessions != null) try { rsSessions.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmtSessions != null) try { pstmtSessions.close(); } catch (SQLException e) { /* ignore */ }
    }


    // Fetch all courses grouped by semester
    Map<Integer, List<String[]>> coursesBySemester = new LinkedHashMap<>();
    PreparedStatement pstmtCourses = null;
    ResultSet rsCourses = null;

    try {
        String sqlCourses = "SELECT c.CourseID, c.CourseCode, c.CourseName, c.CreditHours, c.CourseFee, c.SemesterID " +
                            "FROM Courses c ORDER BY c.SemesterID, c.CourseCode";
        pstmtCourses = conn.prepareStatement(sqlCourses);
        rsCourses = pstmtCourses.executeQuery();

        while (rsCourses.next()) {
            int semesterID = rsCourses.getInt("SemesterID");
            if (!coursesBySemester.containsKey(semesterID)) {
                coursesBySemester.put(semesterID, new ArrayList<>());
            }
            coursesBySemester.get(semesterID).add(new String[]{
                rsCourses.getString("CourseID"),
                rsCourses.getString("CourseCode"),
                rsCourses.getString("CourseName"),
                rsCourses.getString("CreditHours"),
                rsCourses.getString("CourseFee")
            });
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
    <style>
        .tabs {
            display: flex;
            border-bottom: 1px solid #ccc;
            margin-bottom: 20px;
        }
        .tab-link {
            padding: 10px 20px;
            cursor: pointer;
            border: 1px solid transparent;
            border-bottom: none;
            margin-right: 5px;
        }
        .tab-link.active {
            border-color: #ccc;
            border-bottom: 1px solid white;
            background-color: white;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
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
                    <h3>Create New Session</h3>
                    <form action="create_session_process.jsp" method="post">
                        <div class="form-group">
                            <label for="year">Year:</label>
                            <input type="number" id="year" name="year" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="term">Term:</label>
                            <select id="term" name="term" class="form-control" required>
                                <option value="Fall">Fall</option>
                                <option value="Summer">Summer</option>
                                <option value="Spring">Spring</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Create Session</button>
                    </form>
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
                            <label for="sessionId">Select Session:</label>
                            <select id="sessionId" name="sessionId" class="form-control" required>
                                <option value="">-- Select Session --</option>
                                <% for (String[] sess : sessions) { %>
                                    <option value="<%= sess[0] %>"><%= sess[1] %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="courseId">Select Course:</label>
                            <select id="courseId" name="courseId" class="form-control" required>
                                <option value="">-- Select Course --</option>
                                <% for (Map.Entry<Integer, List<String[]>> entry : coursesBySemester.entrySet()) { %>
                                    <optgroup label="<%= semesters.get(entry.getKey()) %>">
                                        <% for (String[] course : entry.getValue()) { %>
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
                    <div class="tabs">
                        <% for (Map.Entry<Integer, String> entry : semesters.entrySet()) { %>
                            <div class="tab-link" onclick="openTab(event, 'semester-<%= entry.getKey() %>')"><%= entry.getValue() %></div>
                        <% } %>
                    </div>

                    <% for (Map.Entry<Integer, String> entry : semesters.entrySet()) { %>
                        <div id="semester-<%= entry.getKey() %>" class="tab-content">
                            <h3><%= entry.getValue() %></h3>
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
                                        <% if (coursesBySemester.containsKey(entry.getKey())) { %>
                                            <% for (String[] course : coursesBySemester.get(entry.getKey())) { %>
                                                <tr>
                                                    <td><%= course[1] %></td>
                                                    <td><%= course[2] %></td>
                                                    <td><%= course[3] %></td>
                                                    <td><%= course[4] %></td>
                                                </tr>
                                            <% } %>
                                        <% } else { %>
                                            <tr>
                                                <td colspan="4">No courses found for this semester.</td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="includes/footer.jsp" %>

    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tab-link");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Open the first tab by default
            document.querySelector('.tab-link').click();

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