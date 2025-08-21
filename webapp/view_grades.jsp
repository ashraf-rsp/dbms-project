<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    int userId = (Integer) session.getAttribute("userId");

    if (!"Student".equals(userRole) && !"Parent".equals(userRole) && !"Teacher".equals(userRole) && !"Admin".equals(userRole)) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

    int studentId = -1;
    String studentName = "";
    String status = request.getParameter("status");
    String message = request.getParameter("message");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if ("Student".equals(userRole)) {
            studentId = userId;
        } else if ("Parent".equals(userRole)) {
            String paramStudentId = request.getParameter("studentId");
            if (paramStudentId != null && !paramStudentId.isEmpty()) {
                studentId = Integer.parseInt(paramStudentId);
            } else {
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
                session.setAttribute("message", "Please select a student to view grades.");
                response.sendRedirect("teacher_dashboard.jsp"); // Or a student selection page
                return;
            }
        }

        if (studentId != -1) {
            String sqlStudentName = "SELECT FirstName, LastName FROM Students WHERE StudentID = ?";
            pstmt = conn.prepareStatement(sqlStudentName);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                studentName = rs.getString("FirstName") + " " + rs.getString("LastName");
            }
            rs.close();
            pstmt.close();
        } else {
            out.println("<p>No student selected or found.</p>");
            return;
        }

    } catch (Exception e) {
        System.err.println("Error in view_grades.jsp: " + e.getMessage());
        out.println("<p>Error loading grades. Please try again.</p>");
        return;
    
%>

<p>Student ID: <%= studentId %></p>
<p>Student Name: <%= studentName %></p>

<% 
    try {
        String sqlGrades = "SELECT c.CourseName, g.GradePercentage, g.GradeLetter, u.Username AS GradedBy, g.GradeDate FROM Grades g JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID JOIN Courses c ON e.CourseID = c.CourseID JOIN Users u ON g.GradedByUserID = u.UserID WHERE e.StudentID = ? ORDER BY g.GradeDate DESC";
        out.println("SQL Query: " + sqlGrades + "<br>");
        out.println("studentId for query: " + studentId + "<br>");
        pstmt = conn.prepareStatement(sqlGrades);
        pstmt.setInt(1, studentId);
        rs = pstmt.executeQuery();
        if (!rs.isBeforeFirst()) {
            out.println("No grades found for this student.<br>");
        } else {
            while (rs.next()) {
                out.println("Course: " + rs.getString("CourseName") + ", Grade: " + rs.getString("GradePercentage") + ", Letter: " + rs.getString("GradeLetter") + ", GradedBy: " + rs.getString("GradedBy") + ", Date: " + rs.getDate("GradeDate") + "<br>");
            }
        }
    } catch (SQLException e) {
        System.err.println("Error loading grades: " + e.getMessage());
        out.println("Error loading grades: " + e.getMessage() + "<br>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
    }
%>
