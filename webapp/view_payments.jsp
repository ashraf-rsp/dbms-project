<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Ensure only Parent can access this page
    String userRole = (String) session.getAttribute("userRole");
    Integer parentUserId = (Integer) session.getAttribute("userId");

    if (userRole == null || !userRole.equals("Parent") || parentUserId == null) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }

    List<Integer> linkedStudentIds = new ArrayList<>();
    try {
        

        // Get all students linked to this parent
        String sqlAllLinkedStudents = "SELECT spl.StudentID FROM Users u JOIN Student_Parent_Link spl ON u.ParentID = spl.ParentID WHERE u.UserID = ?";
        pstmt = conn.prepareStatement(sqlAllLinkedStudents);
        pstmt.setInt(1, parentUserId);
        rs = pstmt.executeQuery();
        while (rs.next()) {
            linkedStudentIds.add(rs.getInt("StudentID"));
        }
        rs.close();
        pstmt.close();

        if (linkedStudentIds.isEmpty()) {
            out.println("<p>No students linked to your account to display payment information.</p>");
            return;
        }

    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        message = "Server configuration error: JDBC Driver not found.";
        e.printStackTrace();
    } finally {
        // Resources will be closed after the main loop
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>View Payments - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="payments" />
        </jsp:include>
        
        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-dollar-sign"></i> My Payments</h2>
                </div>

                <% if (message != null) { %>
                    <p style="color:green;"><%= message %></p>
                <% } %>

                <% 
                    if (linkedStudentIds.isEmpty()) {
                        out.println("<p>No students linked to your account to display payment information.</p>");
                    } else {
                        for (Integer studentId : linkedStudentIds) {
                            String studentName = "";
                            double totalFee = 0.0;
                            double totalPaid = 0.0;
                            double outstandingBalance = 0.0;

                            try {
                                 // Get a new connection for each student loop

                                // Get student name
                                String sqlStudentName = "SELECT FirstName, LastName FROM Students WHERE StudentID = ?";
                                pstmt = conn.prepareStatement(sqlStudentName);
                                pstmt.setInt(1, studentId);
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    studentName = rs.getString("FirstName") + " " + rs.getString("LastName");
                                }
                                rs.close();
                                pstmt.close();

                                // Get total fee for courses enrolled by this student
                                String sqlTotalFee = "SELECT SUM(c.CourseFee) FROM Courses c JOIN Enrollments e ON c.CourseID = e.CourseID WHERE e.StudentID = ?";
                                pstmt = conn.prepareStatement(sqlTotalFee);
                                pstmt.setInt(1, studentId);
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    totalFee = rs.getDouble(1);
                                }
                                rs.close();
                                pstmt.close();

                                // Get total paid for this student's enrollments
                                String sqlTotalPaid = "SELECT SUM(p.Amount) FROM Payments p JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID WHERE e.StudentID = ?";
                                pstmt = conn.prepareStatement(sqlTotalPaid);
                                pstmt.setInt(1, studentId);
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    totalPaid = rs.getDouble(1);
                                }
                                rs.close();
                                pstmt.close();

                                outstandingBalance = totalFee - totalPaid;

                %>
                <div class="summary-card">
                    <h3>Payment Status for <%= studentName %> (ID: <%= studentId %>)</h3>
                    <p><strong>Total Course Fees:</strong> $<%= String.format("%.2f", totalFee) %></p>
                    <p><strong>Total Paid:</strong> $<%= String.format("%.2f", totalPaid) %></p>
                    <p><strong>Outstanding Balance:</strong> $<%= String.format("%.2f", outstandingBalance) %></p>
                </div>
                <div class="data-table-container">
                    <div class="table-header">
                        <h3>Payment History for <%= studentName %></h3>
                    </div>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Enrollment ID</th>
                                    <th>Course</th>
                                    <th>Amount Paid</th>
                                    <th>Payment Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    String sqlPaymentHistory = "SELECT p.PaymentID, e.EnrollmentID, c.CourseName, p.Amount, p.PaymentDate " +
                                                               "FROM Payments p " +
                                                               "JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID " +
                                                               "JOIN Courses c ON e.CourseID = c.CourseID " +
                                                               "WHERE e.StudentID = ? ORDER BY p.PaymentDate DESC";
                                    pstmt = conn.prepareStatement(sqlPaymentHistory);
                                    pstmt.setInt(1, studentId);
                                    rs = pstmt.executeQuery();
                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan=\"4\">No payment history found for this student.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("EnrollmentID") %></td>
                                    <td><%= rs.getString("CourseName") %></td>
                                    <td>$<%= String.format("%.2f", rs.getDouble("Amount")) %></td>
                                    <td><%= rs.getDate("PaymentDate") %></td>
                                </tr>
                                <% 
                                        }
                                    }
                                    rs.close();
                                    pstmt.close();
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <br/>
                <% 
                            } catch (SQLException e) {
                                message = "Database error loading payments for " + studentName + ": " + e.getMessage();
                                e.printStackTrace();
                                out.println("<p style=\"color:red;\">" + message + "</p>");
                            } catch (ClassNotFoundException e) {
                                message = "Server configuration error loading payments for " + studentName + ": JDBC Driver not found.";
                                e.printStackTrace();
                                out.println("<p style=\"color:red;\">" + message + "</p>");
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                                if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
                            }
                        }
                    }
                %>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
