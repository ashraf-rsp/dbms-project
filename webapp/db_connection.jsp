<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%!
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/academic_center_db";
    private static final String DB_USER = "academic_user";
    private static final String DB_PASSWORD = "ashraf";

    public Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.mariadb.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
%>
