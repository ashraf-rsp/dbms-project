<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter provides user attributes
    Integer userId = (Integer) request.getAttribute("userId");
    String userRole = (String) request.getAttribute("userRole");

    if (userId == null || !"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Integer parentId = null;

    if (userId != null) { // userId is guaranteed not null by the check above
        try {
            String sqlParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
            PreparedStatement pstmt_parent = conn.prepareStatement(sqlParentId);
            pstmt_parent.setInt(1, userId);
            ResultSet rs_parent = pstmt_parent.executeQuery();
            if (rs_parent.next()) {
                parentId = rs_parent.getInt("ParentID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>View Payments - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="view_payments" />
        </jsp:include>
        <main class="container">
            <h1>View Payments</h1>
            <section class="view-payments-section">
                <div class="summary-cards-grid">
                    <div class="summary-card">
                        <h3>Fee Status</h3>
                        <%
                            double totalFee = 0;
                            double totalPaid = 0;
                            if (parentId != null) {
                                PreparedStatement pstmt_fees = null;
                                ResultSet rs_fees = null;
                                try {
                                    String sqlFees = "SELECT SUM(c.CourseFee) AS TotalFee, SUM(p.Amount) AS TotalPaid FROM Enrollments e JOIN Courses c ON e.CourseID = c.CourseID LEFT JOIN Payments p ON e.EnrollmentID = p.EnrollmentID JOIN Student_Parent_Link spl ON e.StudentID = spl.StudentID WHERE spl.ParentID = ?";
                                    pstmt_fees = conn.prepareStatement(sqlFees);
                                    pstmt_fees.setInt(1, parentId);
                                    rs_fees = pstmt_fees.executeQuery();
                                    if (rs_fees.next()) {
                                        totalFee = rs_fees.getDouble("TotalFee");
                                        totalPaid = rs_fees.getDouble("TotalPaid");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                        <p><strong>Total Fee:</strong> $<%= String.format("%.2f", totalFee) %></p>
                        <p><strong>Total Paid:</strong> $<%= String.format("%.2f", totalPaid) %></p>
                        <p><strong>Outstanding Balance:</strong> $<%= String.format("%.2f", totalFee - totalPaid) %></p>
                    </div>
                </div>

                <div class="data-table-container">
                    <div class="table-header">
                        <h3>Payment History</h3>
                    </div>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Course</th>
                                    <th>Amount Paid</th>
                                    <th>Payment Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (parentId != null) {
                                        PreparedStatement pstmt_payments = null;
                                        ResultSet rs_payments = null;
                                        try {
                                            String sqlPayments = "SELECT s.StudentName, c.CourseName, p.Amount, p.PaymentDate FROM Payments p JOIN Enrollments e ON p.EnrollmentID = e.EnrollmentID JOIN Students s ON e.StudentID = s.StudentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID WHERE spl.ParentID = ? ORDER BY p.PaymentDate DESC";
                                            pstmt_payments = conn.prepareStatement(sqlPayments);
                                            pstmt_payments.setInt(1, parentId);
                                            rs_payments = pstmt_payments.executeQuery();
                                            while (rs_payments.next()) {
                                %>
                                <tr>
                                    <td><%= rs_payments.getString("StudentName") %></td>
                                    <td><%= rs_payments.getString("CourseName") %></td>
                                    <td>$<%= String.format("%.2f", rs_payments.getDouble("Amount")) %></td>
                                    <td><%= rs_payments.getDate("PaymentDate") %></td>
                                </tr>
                                <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>