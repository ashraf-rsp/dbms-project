<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<% 
    // Ensure appropriate roles can access this page
    String userRole = (String) session.getAttribute("userRole");
    Integer userId = (Integer) session.getAttribute("userId");

    if (!"Student".equals(userRole) && !"Parent".equals(userRole) && !"Teacher".equals(userRole) && !"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int studentId = -1;
    String studentName = "";
    String status = request.getParameter("status");
    String message = request.getParameter("message");

    try {
        conn = getConnection();

        // Determine studentId based on userRole or request parameter
        if ("Student".equals(userRole)) {
            studentId = userId; // Assumption: UserID is StudentID for Student users
        } else if ("Parent".equals(userRole)) {
            String paramStudentId = request.getParameter("studentId");
            if (paramStudentId != null && !paramStudentId.isEmpty()) {
                studentId = Integer.parseInt(paramStudentId);
                // IMPORTANT: Add logic here to verify this studentId is linked to the logged-in parent
            } else {
                // If no studentId param, try to get the first linked student for this parent
                String sqlParentLinkedStudent = "SELECT spl.StudentID FROM Users u JOIN Student_Parent_Link spl ON u.ParentID = spl.ParentID WHERE u.UserID = ? LIMIT 1";
                pstmt = conn.prepareStatement(sqlParentLinkedStudent);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    studentId = rs.getInt("StudentID");
                }
                rs.close();
                pstmt.close();
            }
        } else if ("Teacher".equals(userRole) || "Admin".equals(userRole)) {
            String paramStudentId = request.getParameter("studentId");
            if (paramStudentId != null && !paramStudentId.isEmpty()) {
                studentId = Integer.parseInt(paramStudentId);
            } else {
                out.println("<p>Please select a student to view attendance.</p>");
                return;
            }
        }

        if (studentId == -1) {
            out.println("<p>Student not found or not selected.</p>");
            return;
        }

        // Fetch Student Name
        String sqlStudentName = "SELECT FirstName, LastName FROM Students WHERE StudentID = ?";
        pstmt = conn.prepareStatement(sqlStudentName);
        pstmt.setInt(1, studentId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            studentName = rs.getString("FirstName") + " " + rs.getString("LastName");
        }
        rs.close();
        pstmt.close();

    } catch (SQLException e) {
        // Log the exception or show a user-friendly error message
        e.printStackTrace(); // For debugging
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        return;
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid student ID format.");
        return;
    } finally {
        // Close resources in finally block
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            // Note: Connection closing depends on the getConnection() implementation. 
            // If it's a pooled connection, don't close it here. If it's a new connection each time, close it.
            // For this example, assuming getConnection() provides a managed connection that shouldn't be closed here.
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= (String) session.getAttribute("theme") %>">
<head>
    <title>View Attendance - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="attendance" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-calendar-check"></i> View Attendance</h2>
                <div class="term-selector">
                    <label for="month-filter">Filter by Month:</label>
                    <select id="month-filter">
                        <option value="all">All Months</option>
                        <option value="jan">January</option>
                        <option value="feb">February</option>
                        <option value="mar">March</option>
                        <option value="apr">April</option>
                        <option value="may">May</option>
                        <option value="jun">June</option>
                        <option value="jul">July</option>
                        <option value="aug">August</option>
                        <option value="sep">September</option>
                        <option value="oct">October</option>
                        <option value="nov">November</option>
                        <option value="dec">December</option>
                    </select>
                    <label for="year-filter">Filter by Year:</label>
                    <select id="year-filter">
                        <option value="all">All Years</option>
                        <option value="2025">2025</option>
                        <option value="2024">2024</option>
                        <option value="2023">2023</option>
                    </select>
                </div>
            </div>

            <div class="data-table-container">
                <div class="table-header">
                    <h3>Attendance Records for <%= studentName %></h3>
                </div>
                <% 
                    if (status != null && message != null) {
                        String alertClass = "";
                        if (status.equals("success")) {
                            alertClass = "alert-success";
                        } else if (status.equals("error")) {
                            alertClass = "alert-danger";
                        }
                %>
                <div class="alert <%= alertClass %>">
                    <%= message %>
                </div>
                <% 
                    }
                %>
                <div class="responsive-table">
                    <table class="grades-table"> <%-- Reusing grades-table for now, will need specific attendance-table styles --%> 
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Course</th>
                                <th>Status</th>
                                <th>Notes</th>
                                <% if ("Teacher".equals(userRole) || "Admin".equals(userRole)) { %>
                                <th>Actions</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                String sqlAttendance = "SELECT a.AttendanceID, a.SessionDate, a.Status, a.Notes, c.CourseName, e.EnrollmentID " +
                                                     "FROM Attendance a " +
                                                     "JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID " +
                                                     "JOIN Courses c ON e.CourseID = c.CourseID " +
                                                     "WHERE e.StudentID = ? ORDER BY a.SessionDate DESC";
                                pstmt = conn.prepareStatement(sqlAttendance);
                                pstmt.setInt(1, studentId);
                                rs = pstmt.executeQuery();
                                if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                                    out.println("<tr><td colspan=""" + ("Teacher".equals(userRole) || "Admin".equals(userRole) ? "5" : "4") + """>No attendance records found for this student.</td></tr>");
                                } else {
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td data-label="Date"><%= rs.getDate("SessionDate") %></td>
                                <td data-label="Course"><%= rs.getString("CourseName") %></td>
                                <td data-label="Status"><%= rs.getString("Status") %></td>
                                <td data-label="Notes"><%= rs.getString("Notes") != null ? rs.getString("Notes") : "" %></td>
                                <% if ("Teacher".equals(userRole) || "Admin".equals(userRole)) { %>
                                <td data-label="Actions">
                                    <button class="button edit-attendance-button" 
                                            data-attendance-id="<%= rs.getInt("AttendanceID") %>" 
                                            data-enrollment-id="<%= rs.getInt("EnrollmentID") %>" 
                                            data-session-date="<%= rs.getDate("SessionDate") %>" 
                                            data-status="<%= rs.getString("Status") %>" 
                                            data-notes="<%= rs.getString("Notes") != null ? rs.getString("Notes") : "" %>">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                </td>
                                <% } %>
                            </tr>
                            <% 
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View (Hidden on Desktop) -->
                <div class="mobile-cards">
                    <% 
                        // Re-execute query for mobile cards
                        // Ensure rs is reset if it was already iterated. If not, this is fine.
                        if (rs != null && !rs.isClosed()) {
                            try { rs.beforeFirst(); } catch (SQLException e) { /* Handle case where rs might be null or already closed */ }
                        }
                        
                        // Re-fetch data if rs is null or closed, or if we need to ensure it's fresh
                        // For simplicity here, assuming rs is still valid and can be reset. 
                        // In a real scenario, you might re-run the query or ensure rs is properly managed.
                        if (rs != null && !rs.isClosed()) {
                            if (rs.next()) { // Check if there's data
                                rs.beforeFirst(); // Reset again for the loop
                                while (rs.next()) {
                    %>
                    <div class="attendance-card">
                        <div class="card-header">
                            <h4><%= rs.getDate("SessionDate") %></h4>
                            <span class="status-badge status-<%= rs.getString("Status").toLowerCase() %>"><%= rs.getString("Status") %></span>
                        </div>
                        <div class="card-body">
                            <p><strong>Course:</strong> <%= rs.getString("CourseName") %></p>
                            <p><strong>Reason:</strong> <%= rs.getString("Notes") != null ? rs.getString("Notes") : "" %></p>
                        </div>
                    </div>
                    <% 
                            }
                        } else {
                            out.println("<p>No attendance records found for this student.</p>");
                        }
                    } else {
                         out.println("<p>No attendance records found for this student.</p>");
                    }
                    %>
                </div>

                <% if ("Teacher".equals(userRole) || "Admin".equals(userRole)) { %>
                <div class="mark-attendance-form">
                    <h2>Mark Attendance</h2>
                    <form action="mark_attendance_process.jsp" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="studentId" value="<%= studentId %>">
                        <div class="form-group">
                            <label for="enrollmentId">Enrollment:</label>
                            <select id="enrollmentId" name="enrollmentId" required>
                                <option value="">-- Select Enrollment --</option>
                                <% 
                                    // Fetch enrollments for this student
                                    String sqlEnrollments = "SELECT e.EnrollmentID, c.CourseName FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID WHERE e.StudentID = ?";
                                    pstmt = conn.prepareStatement(sqlEnrollments);
                                    pstmt.setInt(1, studentId);
                                    ResultSet rsEnrollments = pstmt.executeQuery();
                                    while (rsEnrollments.next()) {
                                %>
                                <option value="<%= rsEnrollments.getInt("EnrollmentID") %>"><%= rsEnrollments.getString("CourseName") %></option>
                                <% 
                                    }
                                    rsEnrollments.close();
                                    // Close pstmt for enrollments query
                                    if (pstmt != null) pstmt.close();
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sessionDate">Date:</label>
                            <input type="date" id="sessionDate" name="sessionDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                        </div>
                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select id="status" name="status" required>
                                <option value="Present">Present</option>
                                <option value="Absent">Absent</option>
                                <option value="Tardy">Tardy</option>
                                <option value="Excused">Excused</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="notes">Notes:</label>
                            <textarea id="notes" name="notes" rows="2"></textarea>
                        </div>
                        <button type="submit" class="button primary-button"><i class="fas fa-plus-circle"></i> Mark Attendance</button>
                    </form>
                </div>

                <div class="edit-attendance-form" style="display:none;">
                    <h2>Edit Attendance</h2>
                    <form action="mark_attendance_process.jsp" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="studentId" value="<%= studentId %>">
                        <input type="hidden" name="attendanceId" id="edit-attendance-id">
                        <div class="form-group">
                            <label for="edit-enrollment-id">Enrollment ID:</label>
                            <input type="text" id="edit-enrollment-id" readonly>
                        </div>
                        <div class="form-group">
                            <label for="edit-session-date">Date:</label>
                            <input type="date" id="edit-session-date" name="sessionDate" required>
                        </div>
                        <div class="form-group">
                            <label for="edit-status">Status:</label>
                            <select id="edit-status" name="status" required>
                                <option value="Present">Present</option>
                                <option value="Absent">Absent</option>
                                <option value="Tardy">Tardy</option>
                                <option value="Excused">Excused</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="edit-notes">Notes:</label>
                            <textarea id="edit-notes" name="notes" rows="2"></textarea>
                        </div>
                        <button type="submit" class="button primary-button">Save Changes</button>
                        <button type="button" class="button cancel-edit-attendance">Cancel</button>
                    </form>
                </div>
                <% } %> <%-- End Teacher/Admin specific section --%>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const markAttendanceForm = document.querySelector('.mark-attendance-form');
        const editAttendanceForm = document.querySelector('.edit-attendance-form');

        // Show edit form
        document.querySelectorAll('.edit-attendance-button').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('edit-attendance-id').value = this.dataset.attendanceId;
                document.getElementById('edit-enrollment-id').value = this.dataset.enrollmentId;
                document.getElementById('edit-session-date').value = this.dataset.sessionDate;
                document.getElementById('edit-status').value = this.dataset.status;
                document.getElementById('edit-notes').value = this.dataset.notes;

                markAttendanceForm.style.display = 'none';
                editAttendanceForm.style.display = 'block';
            });
        });

        // Cancel edit
        document.querySelector('.cancel-edit-attendance').addEventListener('click', function() {
            editAttendanceForm.style.display = 'none';
            markAttendanceForm.style.display = 'block';
        });
    });
</script>