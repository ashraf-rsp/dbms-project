<%@ page import="java.sql.*, java.util.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    Integer parentId = null;

    PreparedStatement pstmt_parent = null;
    ResultSet rs_parent = null;

    if (userId != null) {
        try {
            // Get parentId from Users table
            String sqlParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
            pstmt_parent = conn.prepareStatement(sqlParentId);
            pstmt_parent.setInt(1, userId);
            rs_parent = pstmt_parent.executeQuery();
            if (rs_parent.next()) {
                parentId = rs_parent.getInt("ParentID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs_parent != null) try { rs_parent.close(); } catch (SQLException e) { /* ignore */ }
            if (pstmt_parent != null) try { pstmt_parent.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    if (parentId != null) {
%>
<div class="summary-cards-grid">
    <div class="summary-card">
        <h3>Fee Status</h3>
        <%
            PreparedStatement pstmt_fees = null;
            ResultSet rs_fees = null;
            try {
                String sqlFees = "SELECT SUM(c.CourseFee) AS TotalFee, SUM(p.Amount) AS TotalPaid FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID LEFT JOIN Payments p ON e.EnrollmentID = p.EnrollmentID JOIN Student_Parent_Link spl ON e.StudentID = spl.StudentID WHERE spl.ParentID = ?";
                pstmt_fees = conn.prepareStatement(sqlFees);
                pstmt_fees.setInt(1, parentId);
                rs_fees = pstmt_fees.executeQuery();
                if (rs_fees.next()) {
                    double totalFee = rs_fees.getDouble("TotalFee");
                    double totalPaid = rs_fees.getDouble("TotalPaid");
        %>
        <p><strong>Total Fee:</strong> $<%= String.format("%.2f", totalFee) %></p>
        <p><strong>Total Paid:</strong> $<%= String.format("%.2f", totalPaid) %></p>
        <p><strong>Outstanding Balance:</strong> $<%= String.format("%.2f", totalFee - totalPaid) %></p>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs_fees != null) try { rs_fees.close(); } catch (SQLException e) { /* ignore */ }
                if (pstmt_fees != null) try { pstmt_fees.close(); } catch (SQLException e) { /* ignore */ }
            }
        %>
    </div>
</div>

<div class="data-table-container">
    <div class="table-header">
        <h3>Recent Attendance</h3>
    </div>
    <div class="responsive-table">
        <table class="dashboard-table">
            <thead>
                <tr>
                    <th>Course</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    PreparedStatement pstmt_attendance = null;
                    ResultSet rs_attendance = null;
                    try {
                        String sqlAttendance = "SELECT c.CourseName, a.SessionDate, a.Status FROM Attendance a JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID JOIN Courses c ON e.CourseID = c.CourseID WHERE spl.ParentID = ? ORDER BY a.SessionDate DESC LIMIT 5";
                        pstmt_attendance = conn.prepareStatement(sqlAttendance);
                        pstmt_attendance.setInt(1, parentId);
                        rs_attendance = pstmt_attendance.executeQuery();
                        while (rs_attendance.next()) {
                %>
                <tr>
                    <td><%= rs_attendance.getString("CourseName") %></td>
                    <td><%= rs_attendance.getDate("SessionDate") %></td>
                    <td><span class="status-badge status-<%= rs_attendance.getString("Status").toLowerCase() %>"><%= rs_attendance.getString("Status") %></span></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs_attendance != null) try { rs_attendance.close(); } catch (SQLException e) { /* ignore */ }
                        if (pstmt_attendance != null) try { pstmt_attendance.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<div class="data-table-container">
    <div class="table-header">
        <h3>Upcoming Events</h3>
    </div>
    <div class="responsive-table">
        <table class="dashboard-table">
            <thead>
                <tr>
                    <th>Event</th>
                    <th>Type</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    PreparedStatement pstmt_events = null;
                    ResultSet rs_events = null;
                    try {
                        String sqlEvents = "SELECT EventName, EventType, EventDate FROM Events WHERE EventDate >= CURDATE() ORDER BY EventDate ASC LIMIT 3";
                        pstmt_events = conn.prepareStatement(sqlEvents);
                        rs_events = pstmt_events.executeQuery();
                        while (rs_events.next()) {
                %>
                <tr>
                    <td><%= rs_events.getString("EventName") %></td>
                    <td><%= rs_events.getString("EventType") %></td>
                    <td><%= rs_events.getDate("EventDate") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs_events != null) try { rs_events.close(); } catch (SQLException e) { /* ignore */ }
                        if (pstmt_events != null) try { pstmt_events.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
<%
    } else {
%>
<p>No parent ID found for your user account.</p>
<%
    }
%>