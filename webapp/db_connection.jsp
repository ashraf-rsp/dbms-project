<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%
    // Database credentials
    String dbUrl = "jdbc:mysql://localhost:3306/dbms_project";
    String dbUser = "dbms_user";
    String dbPassword = "ashraf";

    Connection conn = null;
    System.err.println("--- db_connection.jsp: Attempting to connect to the database ---");
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    } catch (SQLException e) {
        // Log the exception or handle it as needed
        System.err.println("Database connection error: " + e.getMessage());
        // Optionally, redirect to an error page or display a message
        // response.sendRedirect("error.jsp?message=Database connection failed");
    } catch (ClassNotFoundException e) {
        System.err.println("JDBC Driver not found: " + e.getMessage());
    }
%>