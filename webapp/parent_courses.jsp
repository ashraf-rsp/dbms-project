<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter handles access control. This page is for Parents.
    String userRole = (String) session.getAttribute("userRole");
    if (!"Parent".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    Integer parentUserId = (Integer) session.getAttribute("userId");
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>My Children's Courses - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="my_children_courses" />
        </jsp:include>
        <main class="container">
            <h1>My Children's Courses</h1>
            <div class="course-list">
                <%
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        // Get ParentID from Users table
                        String sqlGetParentId = "SELECT ParentID FROM Users WHERE UserID = ?";
                        PreparedStatement pstmtGetParentId = conn.prepareStatement(sqlGetParentId);
                        pstmtGetParentId.setInt(1, parentUserId);
                        ResultSet rsParentId = pstmtGetParentId.executeQuery();
                        Integer parentId = null;
                        if (rsParentId.next()) {
                            parentId = rsParentId.getInt("ParentID");
                        }
                        rsParentId.close();
                        pstmtGetParentId.close();

                        if (parentId != null) {
                            String sql = "SELECT DISTINCT c.CourseID, c.CourseName, c.CourseDescription FROM Courses c JOIN Enrollments e ON c.CourseID = e.CourseID JOIN Students s ON e.StudentID = s.StudentID JOIN Student_Parent_Link spl ON s.StudentID = spl.StudentID WHERE spl.ParentID = ?";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setInt(1, parentId);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                %>
                <div class="course-item">
                    <h3><%= rs.getString("CourseName") %></h3>
                    <p><strong>Course ID:</strong> <%= rs.getString("CourseID") %></p>
                    <p><strong>Description:</strong> <%= rs.getString("CourseDescription") %></p>
                    <div class="course-actions">
                        <a href="course_details.jsp?courseId=<%= rs.getString("CourseID") %>" class="button">View Details</a>
                    </div>
                </div>
                <%
                            }
                        } else {
                            out.println("<p>No children associated with this parent account.</p>");
                        }
                    } catch (Exception e) {
                        System.err.println("Error loading courses for parent: " + e.getMessage());
                        out.println("<p>Error loading courses. Please try again.</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                    }
                %>
            </div>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
