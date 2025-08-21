<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%
    // Database credentials
    String dbUrl = "jdbc:mariadb://localhost:3306/academic_center_db";
    String dbUser = "academic_user";
    String dbPassword = "ashraf";

    Connection conn = null;
    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    } catch (SQLException e) {
        // Log the exception or handle it as needed
        System.err.println("Database connection error: " + e.getMessage());
        // Optionally, redirect to an error page or display a message
        // response.sendRedirect("error.jsp?message=Database connection failed");
    } catch (ClassNotFoundException e) {
        System.err.println("JDBC Driver not found: " + e.getMessage());
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
%>