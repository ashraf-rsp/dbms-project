<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // auth_check.jspf ensures user is logged in and sets session attributes: loggedInUser, userId, userRole
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    Integer userId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // Initialize variables based on role
    int parentId = -1;
    int studentId = -1;
    int teacherId = -1;
    List<Integer> courseIds = new ArrayList<>();
    double totalFee = 0;
    double totalPaid = 0;
%>
<% request.setAttribute("title", "Dashboard"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-section">
    <h2><%= userRole %> Dashboard</h2>
    <p>Welcome, <%= loggedInUser %>!</p>
    
    <div class="dashboard-grid">
        <%
            // --- Role-based Dashboard Content ---
            if ("Parent".equals(userRole)) {
                // Existing Parent Dashboard Logic
                // Need to fetch parentId and studentId based on userId from Users table
                try {
                    conn = getConnection();
                    // 1. Get ParentID from Users table (assuming ParentID in Users links to Parents table)
                    String sqlParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
                    pstmt = conn.prepareStatement(sqlParentId);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        parentId = rs.getInt("ParentID");
                    }
                    rs.close();
                    pstmt.close();

                    // 2. Get StudentID linked to this Parent
                    if (parentId != -1) {
                        String sqlStudentId = "SELECT StudentID FROM Student_Parent_Link WHERE ParentID = ?";
                        pstmt = conn.prepareStatement(sqlStudentId);
                        pstmt.setInt(1, parentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            studentId = rs.getInt("StudentID");
                        }
                        rs.close();
                        pstmt.close();
                    }

                    // --- Recent Attendance (Parent/Student) ---
                    if (studentId != -1) {
        %>
        <div class="dashboard-card">
            <h3>Recent Attendance</h3>
            <%
                        String sqlAttendance = "SELECT a.SessionDate, a.Status, c.CourseName FROM Attendance a " +
                                             "JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID " +
                                             "JOIN Courses c ON e.CourseID = c.CourseID " +
                                             "WHERE e.StudentID = ? ORDER BY a.SessionDate DESC LIMIT 5"; // Limit to 5 recent
                        pstmt = conn.prepareStatement(sqlAttendance);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
            %>
            <table>
                <thead>
                    <tr>
                        <th>Course</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td data-label="Course"><%= rs.getString("CourseName") %></td>
                    <td data-label="Date"><%= rs.getDate("SessionDate") %></td>
                    <td data-label="Status"><%= rs.getString("Status") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <%
                        rs.close();
                        pstmt.close();
                    } else {
                        out.println("<p>No student linked or no attendance data.</p>");
                    }
            %>
        </div>

        <%
                    // --- Upcoming Events (Parent/Student) ---
                    if (studentId != -1) {
                        // 1. Get Course IDs for the student
                        String sqlCourses = "SELECT CourseID FROM Enrollments WHERE StudentID = ?";
                        pstmt = conn.prepareStatement(sqlCourses);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            courseIds.add(rs.getInt("CourseID"));
                        }
                        rs.close();
                        pstmt.close();

                        // 2. Get Events
                        StringBuilder sqlEventsBuilder = new StringBuilder("SELECT EventName, EventType, EventDate FROM Events WHERE EventDate >= CURDATE() ");
                        if (!courseIds.isEmpty()) {
                            sqlEventsBuilder.append("AND (CourseID IS NULL");
                            for (int i = 0; i < courseIds.size(); i++) {
                                sqlEventsBuilder.append(" OR CourseID = ?");
                            }
                            sqlEventsBuilder.append(") ");
                        }
                        sqlEventsBuilder.append("ORDER BY EventDate ASC LIMIT 5"); // Limit to 5 upcoming

                        pstmt = conn.prepareStatement(sqlEventsBuilder.toString());
                        int paramIndex = 1;
                        if (!courseIds.isEmpty()) {
                            for (Integer courseId : courseIds) {
                                pstmt.setInt(paramIndex++, courseId);
                            }
                        }
                        rs = pstmt.executeQuery();
            %>
        <div class="dashboard-card">
            <h3>Upcoming Events</h3>
            <table>
                <thead>
                    <tr>
                        <th>Event</th>
                        <th>Type</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td data-label="Event"><%= rs.getString("EventName") %></td>
                    <td data-label="Type"><%= rs.getString("EventType") %></td>
                    <td data-label="Date"><%= rs.getDate("EventDate") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <%
                        rs.close();
                        pstmt.close();
                    } else {
                        out.println("<p>No upcoming events.</p>");
                    }
            %>
        </div>

        <%
                    // --- Fee Status (Parent/Student) ---
                    if (studentId != -1) {
                        // 1. Get total fee
                        String sqlFee = "SELECT SUM(c.CourseFee) AS TotalFee FROM Courses c " +
                                      "JOIN Enrollments e ON c.CourseID = e.CourseID " +
                                      "WHERE e.StudentID = ?";
                        pstmt = conn.prepareStatement(sqlFee);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            totalFee = rs.getDouble("TotalFee");
                        }
                        rs.close();
                        pstmt.close();

                        // 2. Get total paid
                        String sqlPaid = "SELECT SUM(p.Amount) AS TotalPaid FROM Payments p " +
                                       "JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID " +
                                       "WHERE e.StudentID = ?";
                        pstmt = conn.prepareStatement(sqlPaid);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            totalPaid = rs.getDouble("TotalPaid");
                        }
                        rs.close();
                        pstmt.close();
            %>
        <div class="dashboard-card">
            <h3>Fee Status</h3>
            <p>Total Fee: <%= String.format("%.2f", totalFee) %></p>
            <p>Total Paid: <%= String.format("%.2f", totalPaid) %></p>
            <p><strong>Outstanding Balance: <%= String.format("%.2f", totalFee - totalPaid) %></strong></p>
            <%
                    } else {
                        out.println("<p>No fee information available.</p>");
                    }
            %>
        </div>
        <%
                } catch (Exception e) {
                    // Log the exception for debugging, but don't expose details to user
                    System.err.println("Dashboard Parent Error: " + e.getMessage());
                    out.println("<p>Error loading dashboard data. Please try again.</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                }
            } else if ("Student".equals(userRole)) {
                // --- Student Dashboard Logic ---
                // Assuming UserID is directly the StudentID for Student users
                studentId = userId;

                try {
                    conn = getConnection();
                    if (studentId != -1) {
                        // Reuse Parent's attendance, events, fee status logic for student
                        // (Code for attendance, events, fee status will be similar to Parent's, just using studentId directly)
                        // For brevity, I'll just put placeholders here, but the actual implementation would copy/adapt the above blocks.
            %>
            <div class="dashboard-card">
                <h3>My Recent Attendance</h3>
                <%
                            String sqlAttendance = "SELECT a.SessionDate, a.Status, c.CourseName FROM Attendance a " +
                                                 "JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID " +
                                                 "JOIN Courses c ON e.CourseID = c.CourseID " +
                                                 "WHERE e.StudentID = ? ORDER BY a.SessionDate DESC LIMIT 5"; // Limit to 5 recent
                            pstmt = conn.prepareStatement(sqlAttendance);
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                %>
                <table>
                    <thead>
                        <tr>
                            <th>Course</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% while (rs.next()) { %>
                    <tr>
                        <td data-label="Course"><%= rs.getString("CourseName") %></td>
                        <td data-label="Date"><%= rs.getDate("SessionDate") %></td>
                        <td data-label="Status"><%= rs.getString("Status") %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <%
                            rs.close();
                            pstmt.close();
                %>
            </div>

            <div class="dashboard-card">
                <h3>My Upcoming Events</h3>
                <%
                            // 1. Get Course IDs for the student
                            String sqlCourses = "SELECT CourseID FROM Enrollments WHERE StudentID = ?";
                            pstmt = conn.prepareStatement(sqlCourses);
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                                courseIds.add(rs.getInt("CourseID"));
                            }
                            rs.close();
                            pstmt.close();

                            // 2. Get Events
                            StringBuilder sqlEventsBuilder = new StringBuilder("SELECT EventName, EventType, EventDate FROM Events WHERE EventDate >= CURDATE() ");
                            if (!courseIds.isEmpty()) {
                                sqlEventsBuilder.append("AND (CourseID IS NULL");
                                for (int i = 0; i < courseIds.size(); i++) {
                                    sqlEventsBuilder.append(" OR CourseID = ?");
                                }
                                sqlEventsBuilder.append(") ");
                            }
                            sqlEventsBuilder.append("ORDER BY EventDate ASC LIMIT 5"); // Limit to 5 upcoming

                            pstmt = conn.prepareStatement(sqlEventsBuilder.toString());
                            int paramIndex = 1;
                            if (!courseIds.isEmpty()) {
                                for (Integer courseId : courseIds) {
                                    pstmt.setInt(paramIndex++, courseId);
                                }
                            }
                            rs = pstmt.executeQuery();
                %>
                <table>
                    <thead>
                        <tr>
                            <th>Event</th>
                            <th>Type</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% while (rs.next()) { %>
                    <tr>
                        <td data-label="Event"><%= rs.getString("EventName") %></td>
                        <td data-label="Type"><%= rs.getString("EventType") %></td>
                        <td data-label="Date"><%= rs.getDate("EventDate") %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <%
                            rs.close();
                            pstmt.close();
                %>
            </div>

            <div class="dashboard-card">
                <h3>My Fee Status</h3>
                <%
                            // 1. Get total fee
                            String sqlFee = "SELECT SUM(c.CourseFee) AS TotalFee FROM Courses c " +
                                          "JOIN Enrollments e ON c.CourseID = e.CourseID " +
                                          "WHERE e.StudentID = ?";
                            pstmt = conn.prepareStatement(sqlFee);
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                                totalFee = rs.getDouble("TotalFee");
                            }
                            rs.close();
                            pstmt.close();

                            // 2. Get total paid
                            String sqlPaid = "SELECT SUM(p.Amount) AS TotalPaid FROM Payments p " +
                                           "JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID " +
                                           "WHERE e.StudentID = ?";
                            pstmt = conn.prepareStatement(sqlPaid);
                            pstmt.setInt(1, studentId);
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                                totalPaid = rs.getDouble("TotalPaid");
                            }
                            rs.close();
                            pstmt.close();
                %>
                <p>Total Fee: <%= String.format("%.2f", totalFee) %></p>
                <p>Total Paid: <%= String.format("%.2f", totalPaid) %></p>
                <p><strong>Outstanding Balance: <%= String.format("%.2f", totalFee - totalPaid) %></strong></p>
                <%
                    } else {
                        out.println("<p>No student profile linked.</p>");
                    }
                } catch (Exception e) {
                    System.err.println("Dashboard Student Error: " + e.getMessage());
                    out.println("<p>Error loading dashboard data. Please try again.</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                }
            } else if ("Teacher".equals(userRole)) {
                // --- Teacher Dashboard Logic ---
                // Since there is no Teachers table, we'll display generic info or info linked via UserID if applicable.
                // For now, just a placeholder.
            %>
            <div class="dashboard-card">
                <h3>Teacher Dashboard</h3>
                <p>Welcome, Teacher! Specific content for teachers will go here.</p>
                <p>Possible content: List of assigned courses, recent student activities, quick links to grade entry.</p>
            </div>
            <%
            } else if ("Admin".equals(userRole)) {
                // --- Admin Dashboard Logic ---
        %>
        <div class="dashboard-card">
            <h3>System Overview</h3>
            <p>Display system statistics, quick links to user management, course management, etc.</p>
        </div>
        <div class="dashboard-card">
            <h3>Recent System Alerts</h3>
            <p>Display recent alerts from Alert_Log table.</p>
        </div>
        <%
            } else {
                // Unknown Role or No Role
                out.println("<p>Welcome to your dashboard! Your role is not recognized or assigned.</p>");
            }
        %>
    </div>
</div>

<div class="page-section">
    <h2>Parent Dashboard</h2>
    <p>Welcome, <%= username %>!</p>
    
    <div class="dashboard-grid">
        <div class="dashboard-card">
            <h3>Recent Attendance</h3>
            <%
                try {
                    conn = getConnection();
                    // 1. Get ParentID
                    String sqlParent = "SELECT ParentID FROM Users WHERE Username = ?";
                    pstmt = conn.prepareStatement(sqlParent);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        parentId = rs.getInt("ParentID");
                    }
                    rs.close();
                    pstmt.close();

                    // 2. Get StudentID
                    if (parentId != -1) {
                        String sqlStudent = "SELECT StudentID FROM Student_Parent_Link WHERE ParentID = ?";
                        pstmt = conn.prepareStatement(sqlStudent);
                        pstmt.setInt(1, parentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            studentId = rs.getInt("StudentID");
                        }
                        rs.close();
                        pstmt.close();
                    }

                    // 3. Get Attendance
                    if (studentId != -1) {
                        String sqlAttendance = "SELECT a.SessionDate, a.Status, c.CourseName FROM Attendance a " +
                                             "JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID " +
                                             "JOIN Courses c ON e.CourseID = c.CourseID " +
                                             "WHERE e.StudentID = ? ORDER BY a.SessionDate DESC";
                        pstmt = conn.prepareStatement(sqlAttendance);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
            %>
            <table>
                <thead>
                    <tr>
                        <th>Course</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td data-label="Course"><%= rs.getString("CourseName") %></td>
                    <td data-label="Date"><%= rs.getDate("SessionDate") %></td>
                    <td data-label="Status"><%= rs.getString("Status") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <%
                        rs.close();
                        pstmt.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
        
        <div class="dashboard-card">
            <h3>Upcoming Events</h3>
            <%
                try {
                    conn = getConnection();
                    // 1. Get Course IDs for the student
                    if (studentId != -1) {
                        String sqlCourses = "SELECT CourseID FROM Enrollments WHERE StudentID = ?";
                        pstmt = conn.prepareStatement(sqlCourses);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            courseIds.add(rs.getInt("CourseID"));
                        }
                        rs.close();
                        pstmt.close();
                    }

                    // 2. Get Events
                    if (!courseIds.isEmpty()) {
                        StringBuilder sqlEventsBuilder = new StringBuilder("SELECT * FROM Events WHERE EventDate >= CURDATE() AND (CourseID IS NULL");
                        for (int i = 0; i < courseIds.size(); i++) {
                            sqlEventsBuilder.append(" OR CourseID = ?");
                        }
                        sqlEventsBuilder.append(") ORDER BY EventDate ASC");

                        pstmt = conn.prepareStatement(sqlEventsBuilder.toString());
                        int paramIndex = 1;
                        for (Integer courseId : courseIds) {
                            pstmt.setInt(paramIndex++, courseId);
                        }
                        rs = pstmt.executeQuery();
            %>
            <table>
                <thead>
                    <tr>
                        <th>Event</th>
                        <th>Type</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <% while (rs.next()) { %>
                <tr>
                    <td data-label="Event"><%= rs.getString("EventName") %></td>
                    <td data-label="Type"><%= rs.getString("EventType") %></td>
                    <td data-label="Date"><%= rs.getDate("EventDate") %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
        
        <div class="dashboard-card">
            <h3>Fee Status</h3>
            <%
                try {
                    conn = getConnection();
                    // 1. Get total fee
                    if (studentId != -1) {
                        String sqlFee = "SELECT SUM(c.CourseFee) AS TotalFee FROM Courses c " +
                                      "JOIN Enrollments e ON c.CourseID = e.CourseID " +
                                      "WHERE e.StudentID = ?";
                        pstmt = conn.prepareStatement(sqlFee);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            totalFee = rs.getDouble("TotalFee");
                        }
                        rs.close();
                        pstmt.close();
                    }

                    // 2. Get total paid
                    if (studentId != -1) {
                        String sqlPaid = "SELECT SUM(p.Amount) AS TotalPaid FROM Payments p " +
                                       "JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID " +
                                       "WHERE e.StudentID = ?";
                        pstmt = conn.prepareStatement(sqlPaid);
                        pstmt.setInt(1, studentId);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            totalPaid = rs.getDouble("TotalPaid");
                        }
                        rs.close();
                        pstmt.close();
                    }
            %>
            <p>Total Fee: <%= totalFee %></p>
            <p>Total Paid: <%= totalPaid %></p>
            <p><strong>Outstanding Balance: <%= totalFee - totalPaid %></strong></p>
            <%
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>