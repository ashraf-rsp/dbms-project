<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%-- This file assumes that db_connection.jsp and auth_check.jspf have been included in the parent file --%>

<%
    PreparedStatement pstmt_parent = null;
    ResultSet rs_parent = null;

    try {
        // Get parentId from Parents table linked by UserID
        String sqlParentId = "SELECT ParentID FROM Parents WHERE UserID = ?";
        pstmt_parent = conn.prepareStatement(sqlParentId);
        pstmt_parent.setInt(1, (Integer) session.getAttribute("userId"));
        rs_parent = pstmt_parent.executeQuery();
        int parentId = -1;
        if (rs_parent.next()) {
            parentId = rs_parent.getInt("ParentID");
        }

        if (parentId != -1) {
%>
            <div class="summary-cards-grid">
                <div class="summary-card">
                    <h3>Fee Status</h3>
<%
                String sqlFees = "SELECT SUM(c.CourseFee) AS TotalFee, SUM(p.Amount) AS TotalPaid FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID LEFT JOIN Payments p ON e.EnrollmentID = p.EnrollmentID JOIN Student_Parent_Link spl ON e.StudentID = spl.StudentID WHERE spl.ParentID = ?";
                PreparedStatement pstmt_fees = conn.prepareStatement(sqlFees);
                pstmt_fees.setInt(1, parentId);
                ResultSet rs_fees = pstmt_fees.executeQuery();
                if (rs_fees.next()) {
                    double totalFee = rs_fees.getDouble("TotalFee");
                    double totalPaid = rs_fees.getDouble("TotalPaid");
%>
                    <p><strong>Total Fee:</strong> $<%= String.format("%.2f", totalFee) %></p>
                    <p><strong>Total Paid:</strong> $<%= String.format("%.2f", totalPaid) %></p>
                    <p><strong>Outstanding Balance:</strong> $<%= String.format("%.2f", totalFee - totalPaid) %></p>
<%
                }
                rs_fees.close();
                pstmt_fees.close();
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
                            String sqlAttendance = "SELECT c.CourseName, a.SessionDate, a.Status FROM Attendance a JOIN Enrollments e ON a.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID JOIN Courses c ON e.CourseID = c.CourseID WHERE spl.ParentID = ? ORDER BY a.SessionDate DESC LIMIT 5";
                            PreparedStatement pstmt_attendance = conn.prepareStatement(sqlAttendance);
                            pstmt_attendance.setInt(1, parentId);
                            ResultSet rs_attendance = pstmt_attendance.executeQuery();
                            while (rs_attendance.next()) {
%>
                                <tr>
                                    <td><%= rs_attendance.getString("CourseName") %></td>
                                    <td><%= rs_attendance.getDate("SessionDate") %></td>
                                    <td><span class="status-badge status-<%= rs_attendance.getString("Status").toLowerCase() %>"><%= rs_attendance.getString("Status") %></span></td>
                                </tr>
<%
                            }
                            rs_attendance.close();
                            pstmt_attendance.close();
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
                            String sqlEvents = "SELECT EventName, EventType, EventDate FROM Events WHERE EventDate >= CURDATE() ORDER BY EventDate ASC LIMIT 3";
                            PreparedStatement pstmt_events = conn.prepareStatement(sqlEvents);
                            ResultSet rs_events = pstmt_events.executeQuery();
                            while (rs_events.next()) {
%>
                                <tr>
                                    <td><%= rs_events.getString("EventName") %></td>
                                    <td><%= rs_events.getString("EventType") %></td>
                                    <td><%= rs_events.getDate("EventDate") %></td>
                                </tr>
<%
                            }
                            rs_events.close();
                            pstmt_events.close();
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
    } catch (SQLException e) {
%>
        <p>Database error: <%= e.getMessage() %></p>
<%
        e.printStackTrace();
    } finally {
        if (rs_parent != null) try { rs_parent.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt_parent != null) try { pstmt_parent.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
