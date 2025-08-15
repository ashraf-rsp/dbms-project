<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for announcements
    String[][] announcements = {
        {"School Closure Due to Weather", "The school will be closed on August 16th due to severe weather conditions. Please check the website for updates.", "2025-08-15"},
        {"Parent-Teacher Conference Schedule", "Parent-Teacher conferences will be held on September 1st and 2nd. Please sign up for a slot online.", "2025-08-10"},
        {"New After-School Programs", "Exciting new after-school programs are now available! Visit the student activities page for more details.", "2025-08-05"}
    };
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Announcements - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="announcements" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-bullhorn"></i> Announcements</h2>
            </div>
            
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Latest Announcements</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="announcements-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < announcements.length; i++) { %>
                                <tr class="announcement-row">
                                    <td><%= announcements[i][0] %></td>
                                    <td><%= announcements[i][2] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < announcements.length; i++) { %>
                        <div class="announcement-card">
                            <div class="card-header">
                                <h4><%= announcements[i][0] %></h4>
                                <span class="announcement-date"><%= announcements[i][2] %></span>
                            </div>
                            <div class="card-body">
                                <p><%= announcements[i][1] %></p>
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