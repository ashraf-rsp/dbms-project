<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>View Attendance - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="attendance" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-calendar-check"></i> View Attendance</h2>
                <div class="term-selector">
                    <label for="month-filter">Filter by Month:</label>
                    <select id="month-filter">
                        <option value="all">All Months</option>
                        <option value="jan">January</option>
                        <option value="feb">February</option>
                        <option value="mar">March</option>
                        <option value="apr">April</option>
                        <option value="may">May</option>
                        <option value="jun">June</option>
                        <option value="jul">July</option>
                        <option value="aug">August</option>
                        <option value="sep">September</option>
                        <option value="oct">October</option>
                        <option value="nov">November</option>
                        <option value="dec">December</option>
                    </select>
                    <label for="year-filter">Filter by Year:</label>
                    <select id="year-filter">
                        <option value="all">All Years</option>
                        <option value="2025">2025</option>
                        <option value="2024">2024</option>
                        <option value="2023">2023</option>
                    </select>
                </div>
            </div>

            <div class="data-table-container">
                <div class="table-header">
                    <h3>Attendance Records for [Student Name]</h3>
                </div>
                <div class="responsive-table">
                    <table class="grades-table"> <%-- Reusing grades-table for now, will need specific attendance-table styles --%>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Reason/Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td data-label="Date">2025-03-06</td>
                                <td data-label="Status">Absent</td>
                                <td data-label="Reason/Notes">Sick leave (fever)</td>
                            </tr>
                            <tr>
                                <td data-label="Date">2025-02-14</td>
                                <td data-label="Status">Tardy</td>
                                <td data-label="Reason/Notes">Traffic delay</td>
                            </tr>
                            <tr>
                                <td data-label="Date">2025-01-20</td>
                                <td data-label="Status">Absent</td>
                                <td data-label="Reason/Notes">Family vacation</td>
                            </tr>
                            <tr>
                                <td data-label="Date">2024-12-01</td>
                                <td data-label="Status">Present</td>
                                <td data-label="Reason/Notes"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Mobile Card View (Hidden on Desktop) -->
                <div class="mobile-cards">
                    <div class="attendance-card">
                        <div class="card-header">
                            <h4>2025-03-06</h4>
                            <span class="status-badge status-absent">Absent</span>
                        </div>
                        <div class="card-body">
                            <p><strong>Reason:</strong> Sick leave (fever)</p>
                        </div>
                    </div>
                    <div class="attendance-card">
                        <div class="card-header">
                            <h4>2025-02-14</h4>
                            <span class="status-badge status-tardy">Tardy</span>
                        </div>
                        <div class="card-body">
                            <p><strong>Reason:</strong> Traffic delay</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>