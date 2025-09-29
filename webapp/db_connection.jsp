<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%
    Connection conn = null;
    try {
        /*
        // OLD MySQL Credentials
        String dbUrl_mysql = "jdbc:mysql://localhost:3306/dbms_project";
        String dbUser_mysql = "dbms_user";
        String dbPassword_mysql = "ashraf";
        Class.forName("com.mysql.jdbc.Driver");
        */

        // NEW Oracle Credentials
        String dbUrl = "jdbc:oracle:thin:@//localhost:1521/XE";
        String dbUser = "c##dbms";
        String dbPassword = "ashraf";
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    } catch (SQLException e) {
        System.err.println("Database connection error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        System.err.println("JDBC Driver not found: " + e.getMessage());
    }
%>