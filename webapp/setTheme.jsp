<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String theme = request.getParameter("theme");
    if (theme != null && !theme.isEmpty()) {
        session.setAttribute("theme", theme);
        response.setStatus(HttpServletResponse.SC_OK);
    } else {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    }
%>