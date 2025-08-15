<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title>Student Profile - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="profile" />
        </jsp:include>
        
        <main class="content-area">
            <div class="page-header">
                <h2><i class="fas fa-user"></i> Student Profile</h2>
            </div>
            
            <div class="profile-card">
                <div class="profile-avatar">
                    <img src="assets/images/placeholder-student.png" alt="Student Avatar">
                </div>
                <div class="profile-details">
                    <h3>Jane Doe</h3> <%-- Replaced <%= studentName %> --%>
                    <p><strong>Student ID:</strong> STD12345</p> <%-- Replaced <%= studentId %> --%>
                    <p><strong>Grade Level:</strong> 10th Grade</p> <%-- Replaced <%= gradeLevel %> --%>
                    <p><strong>Date of Birth:</strong> 2008-05-15</p> <%-- Replaced <%= dateOfBirth %> --%>
                    <p><strong>Address:</strong> 123 Main St, Anytown, USA</p> <%-- Replaced <%= address %> --%>
                    <p><strong>Parent Contact:</strong> John Doe (john.doe@example.com)</p> <%-- Replaced <%= parentContact %> --%>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>