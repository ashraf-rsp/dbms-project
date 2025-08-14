<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int parentId = -1;
    int studentId = -1;
    List<Integer> courseIds = new ArrayList<>();
    double totalFee = 0;
    double totalPaid = 0;
%>
<% request.setAttribute("title", "Dashboard"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

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