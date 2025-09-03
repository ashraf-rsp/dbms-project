<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // This page is protected by AuthFilter, which sets userRole as a request attribute.
    String userRole = (String) request.getAttribute("userRole");
    
    if (userRole == null) {
        // If userRole is not set, something is wrong. Redirect to login.
        response.sendRedirect("login.jsp");
        return;
    }

    switch (userRole) {
        case "Student":
            response.sendRedirect("student_profile.jsp");
            break;
        case "Parent":
            response.sendRedirect("parent_profile.jsp");
            break;
        case "Teacher":
            response.sendRedirect("teacher_profile.jsp");
            break;
        case "Admin":
            response.sendRedirect("admin_profile.jsp");
            break;
        default:
            // Default or error page if role is not recognized
            response.sendRedirect("access_denied.jsp");
            break;
    }
%>