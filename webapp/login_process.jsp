<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ include file="db_connection.jsp" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection();
        String sql = "SELECT * FROM Users WHERE Username = ? AND PasswordHash = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password); // Plain text password for now
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // User authenticated successfully
            session.setAttribute("username", username);
            response.sendRedirect("dashboard.jsp");
        } else {
            // Authentication failed
            response.sendRedirect("index.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp?error=2");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>