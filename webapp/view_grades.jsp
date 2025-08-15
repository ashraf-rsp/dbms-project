<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
                <h2><i class="fas fa-chart-line"></i> View Grades</h2>
            </div>
            
            <section class="grades-section">
                <h2>Grades for [Student Name]</h2>
                <div class="gpa-summary">
                    <h3>Overall GPA: <strong>[3.85]</strong></h3>
                    <p>Total Credits: [60]</p>
                </div>
                <div class="filter-controls">
                    <label for="term-filter">Filter by Term:</label>
                    <select id="term-filter">
                        <option value="all">All Terms</option>
                        <option value="fall2024">Fall 2024</option>
                        <option value="spring2024">Spring 2024</option>
                        <option value="fall2023">Fall 2023</option>
                    </select>
                    <label for="subject-filter">Filter by Subject:</label>
                    <select id="subject-filter">
                        <option value="all">All Subjects</option>
                        <option value="math">Mathematics</option>
                        <option value="science">Science</option>
                        <option value="history">History</option>
                    </select>
                </div>
                <div class="responsive-table-container">
                    <table class="grades-table">
                        <thead>
                            <tr>
                                <th>Course</th>
                                <th>Term</th>
                                <th>Teacher</th>
                                <th>Grade (%)</th>
                                <th>Grade (Letter)</th>
                                <th>Credits</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td data-label="Course">Advanced Algebra</td>
                                <td data-label="Term">Fall 2024</td>
                                <td data-label="Teacher">Mr. Smith</td>
                                <td data-label="Grade (%)">92</td>
                                <td data-label="Grade (Letter)">A-</td>
                                <td data-label="Credits">3</td>
                            </tr>
                            <tr>
                                <td data-label="Course">Biology I</td>
                                <td data-label="Term">Fall 2024</td>
                                <td data-label="Teacher">Ms. Johnson</td>
                                <td data-label="Grade (%)">88</td>
                                <td data-label="Grade (Letter)">B+</td>
                                <td data-label="Credits">4</td>
                            </tr>
                            <tr>
                                <td data-label="Course">World History II</td>
                                <td data-label="Term">Fall 2024</td>
                                <td data-label="Teacher">Mr. Davis</td>
                                <td data-label="Grade (%)">95</td>
                                <td data-label="Grade (Letter)">A</td>
                                <td data-label="Credits">3</td>
                            </tr>
                            <tr>
                                <td data-label="Course">Introduction to Programming</td>
                                <td data-label="Term">Spring 2024</td>
                                <td data-label="Teacher">Ms. Lee</td>
                                <td data-label="Grade (%)">80</td>
                                <td data-label="Grade (Letter)">B-</td>
                                <td data-label="Credits">3</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>