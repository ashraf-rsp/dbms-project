<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>

<% 
    String year = request.getParameter("year");
    String term = request.getParameter("term");

    if (year != null && !year.isEmpty() && term != null && !term.isEmpty()) {
        String sessionName = term + " " + year;
        PreparedStatement pstmt = null;
        try {
            String sql = "INSERT INTO Sessions (SessionName, Year, Term) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sessionName);
            pstmt.setInt(2, Integer.parseInt(year));
            pstmt.setString(3, term);
            pstmt.executeUpdate();
            response.sendRedirect("course_management.jsp");
        } catch (SQLException e) {
            // Handle error
            e.printStackTrace();
            response.sendRedirect("course_management.jsp?error=true");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
            if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignore */ }
        }
    } else {
        response.sendRedirect("course_management.jsp?error=true");
    }
%>