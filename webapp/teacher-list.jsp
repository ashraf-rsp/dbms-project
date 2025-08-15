<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for teacher list
    String[][] teachers = {
        {"Mrs. Johnson", "Mathematics", "johnson@example.com"},
        {"Mr. Smith", "Science", "smith@example.com"},
        {"Ms. Davis", "English", "davis@example.com"},
        {"Mr. Brown", "History", "brown@example.com"}
    };
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Teacher List - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="teachers" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-chalkboard-teacher"></i> Teacher List</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Our Faculty</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="teacher-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Subject</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < teachers.length; i++) { %>
                                <tr class="teacher-row">
                                    <td><%= teachers[i][0] %></td>
                                    <td><%= teachers[i][1] %></td>
                                    <td><a href="mailto:<%= teachers[i][2] %>"><%= teachers[i][2] %></a></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < teachers.length; i++) { %>
                        <div class="teacher-card">
                            <div class="card-header">
                                <h4><%= teachers[i][0] %></h4>
                                <span class="teacher-subject"><%= teachers[i][1] %></span>
                            </div>
                            <div class="card-body">
                                <p><strong>Email:</strong> <a href="mailto:<%= teachers[i][2] %>"><%= teachers[i][2] %></a></p>
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