<%@ page import="at.favre.lib.PasswordUtil" %>
<%@ page import="java.io.PrintWriter" %>
<%
    String plainPassword = request.getParameter("password");
    if (plainPassword != null && !plainPassword.isEmpty()) {
        String hashedPassword = PasswordUtil.hash(plainPassword);
        out.print(hashedPassword);
    } else {
        out.print("Error: No password provided.");
    }
%>