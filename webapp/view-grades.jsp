<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Mock data (in real app, this would come from database/session)
    String[][] grades = {
        {"Mathematics", "A", "92%", "Fall 2024", "Mrs. Johnson"},
        {"Science", "B+", "87%", "Fall 2024", "Mr. Smith"},
        {"English", "A-", "90%", "Fall 2024", "Ms. Davis"},
        {"History", "B", "85%", "Fall 2024", "Mr. Brown"}
    };
    
    String currentTerm = "Fall 2024";
    double gpa = 3.65;

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>

<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>View Grades - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="grades" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-chart-line"></i> Academic Grades</h2>
                <div class="term-selector">
                    <label for="termSelect">Term:</label>
                    <select id="termSelect" class="form-control">
                        <option value="fall2024" selected>Fall 2024</option>
                        <option value="spring2024">Spring 2024</option>
                        <option value="fall2023">Fall 2023</option>
                    </select>
                </div>
            </div>
            
            <!-- GPA Summary Card -->
            <div class="summary-card">
                <div class="gpa-display">
                    <span class="gpa-label">Current GPA</span>
                    <span class="gpa-value"><%= String.format("%.2f", gpa) %></span>
                </div>
                <div class="term-info">
                    <span class="term-label">Term: <%= currentTerm %></span>
                </div>
            </div>
            
            <!-- Grades Table -->
            <div class="data-table-container">
                <div class="table-header">
                    <h3>Course Grades</h3>
                </div>
                
                <div class="responsive-table">
                    <table class="grades-table">
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th>Letter Grade</th>
                                <th>Percentage</th>
                                <th>Term</th>
                                <th>Teacher</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < grades.length; i++) { %>
                                <tr class="grade-row">
                                    <td class="subject-cell">
                                        <i class="fas fa-book-open"></i>
                                        <%= grades[i][0] %>
                                    </td>
                                    <td class="grade-cell">
                                        <span class="grade-badge grade-<%= grades[i][1].toLowerCase().replaceAll("[^a-z]", "") %>">
                                            <%= grades[i][1] %>
                                        </span>
                                    </td>
                                    <td class="percentage-cell"><%= grades[i][2] %></td>
                                    <td class="term-cell"><%= grades[i][3] %></td>
                                    <td class="teacher-cell"><%= grades[i][4] %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View (Hidden on Desktop) -->
                <div class="mobile-cards">
                    <% for (int i = 0; i < grades.length; i++) { %>
                        <div class="grade-card">
                            <div class="card-header">
                                <h4><%= grades[i][0] %></h4>
                                <span class="grade-badge grade-<%= grades[i][1].toLowerCase().replaceAll("[^a-z]", "") %>">
                                    <%= grades[i][1] %>
                                </span>
                            </div>
                            <div class="card-body">
                                <p><strong>Percentage:</strong> <%= grades[i][2] %></p>
                                <p><strong>Teacher:</strong> <%= grades[i][4] %></p>
                                <p><strong>Term:</strong> <%= grades[i][3] %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
    
    <script src="js/main.js"></script>
    <script>
        // Page-specific JavaScript
        document.getElementById('termSelect').addEventListener('change', function() {
            // Simulate filtering grades by term
            console.log('Term changed to:', this.value);
        });
    </script>
</body>
</html>