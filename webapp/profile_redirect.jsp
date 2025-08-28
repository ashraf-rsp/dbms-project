<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    
    if ("Student".equals(userRole)) {
        response.sendRedirect("student_profile.jsp");
    } else if ("Parent".equals(userRole)) {
        response.sendRedirect("parent_profile.jsp");
    } else if ("Teacher".equals(userRole)) {
        response.sendRedirect("teacher_profile.jsp");
    } else if ("Admin".equals(userRole)) {
        response.sendRedirect("admin_profile.jsp");
    } else {
        // Default or error page if role is not recognized or not logged in
        response.sendRedirect("access_denied.jsp");
    }
%>