<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    // Mock data for student profile
    String studentName = "Jane Doe";
    String studentId = "STD12345";
    String gradeLevel = "10th Grade";
    String dateOfBirth = "2008-05-15";
    String address = "123 Main St, Anytown, USA";
    String parentContact = "John Doe (john.doe@example.com)";
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
                    <h3><%= studentName %></h3>
                    <p><strong>Student ID:</strong> <%= studentId %></p>
                    <p><strong>Grade Level:</strong> <%= gradeLevel %></p>
                    <p><strong>Date of Birth:</strong> <%= dateOfBirth %></p>
                    <p><strong>Address:</strong> <%= address %></p>
                    <p><strong>Parent Contact:</strong> <%= parentContact %></p>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>