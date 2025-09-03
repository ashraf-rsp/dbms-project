package com.academic.filters;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AuthFilter implements Filter {

    private Map<String, List<String>> pageRoles;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        pageRoles = new HashMap<>();
        // Admin pages
        pageRoles.put("/user_management.jsp", Arrays.asList("Admin"));
        pageRoles.put("/course_management.jsp", Arrays.asList("Admin"));
        pageRoles.put("/assign_teacher.jsp", Arrays.asList("Admin"));
        pageRoles.put("/enroll_student.jsp", Arrays.asList("Admin"));

        // Teacher pages
        pageRoles.put("/mark_attendance.jsp", Arrays.asList("Teacher"));
        pageRoles.put("/update_grades.jsp", Arrays.asList("Teacher"));

        // Parent pages
        pageRoles.put("/view_payments.jsp", Arrays.asList("Parent"));

        // Shared pages
        pageRoles.put("/dashboard.jsp", Arrays.asList("Admin", "Teacher", "Parent", "Student"));
        pageRoles.put("/profile_redirect.jsp", Arrays.asList("Admin", "Teacher", "Parent", "Student"));
        pageRoles.put("/announcements.jsp", Arrays.asList("Admin", "Teacher", "Parent", "Student"));
        pageRoles.put("/messages.jsp", Arrays.asList("Admin", "Teacher", "Parent", "Student"));
        pageRoles.put("/class_schedule.jsp", Arrays.asList("Admin", "Teacher", "Parent", "Student"));
        pageRoles.put("/view_grades.jsp", Arrays.asList("Parent", "Student"));
        pageRoles.put("/view_attendance.jsp", Arrays.asList("Parent", "Student"));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String requestedPage = requestURI.substring(contextPath.length());

        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);

        if (!isLoggedIn && !requestedPage.equals("/login.jsp") && !requestedPage.equals("/login_process.jsp") && !requestedPage.equals("/register.jsp") && !requestedPage.equals("/register_process.jsp")) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        if (isLoggedIn) {
            String userRole = (String) session.getAttribute("userRole");
            request.setAttribute("loggedInUser", session.getAttribute("loggedInUser"));
            request.setAttribute("userRole", userRole);

            if (pageRoles.containsKey(requestedPage)) {
                List<String> allowedRoles = pageRoles.get(requestedPage);
                if (userRole == null || !allowedRoles.contains(userRole)) {
                    httpResponse.sendRedirect(contextPath + "/access_denied.jsp");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}
