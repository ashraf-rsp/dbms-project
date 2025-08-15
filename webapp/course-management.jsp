<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for courses
    String[][] courses = {
        {"Mathematics I", "MATH101", "Mrs. Johnson", "Fall 2024"},
        {"Science Fundamentals", "SCI101", "Mr. Smith", "Fall 2024"},
        {"English Literature", "ENG201", "Ms. Davis", "Spring 2025"},
        {"World History", "HIST101", "Mr. Brown", "Fall 2024"}
    };
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Course Management - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="courses" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-book"></i> Course Management</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Available Courses</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="course-table">
                        <thead>
                            <tr>
                                <th>Course Name</th>
                                <th>Course ID</th>
                                <th>Instructor</th>
                                <th>Term</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < courses.length; i++) { %>
                                <tr class="course-row">
                                    <td><%= courses[i][0] %></td>
                                    <td><%= courses[i][1] %></td>
                                    <td><%= courses[i][2] %></td>
                                    <td><%= courses[i][3] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% for (int i = 0; i = courses.length; i++) { %>
                        <div class="course-card">
                            <div class="card-header">
                                <h4><%= courses[i][0] %></h4>
                                <span class="course-id"><%= courses[i][1] %></span>
                            </div>
                            <div class="card-body">
                                <p><strong>Instructor:</strong> <%= courses[i][2] %></p>
                                <p><strong>Term:</strong> <%= courses[i][3] %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>