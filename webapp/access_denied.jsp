<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Access Denied - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-ban"></i> Access Denied</h2>
                </div>
                <div class="error-message">
                    <p>You do not have permission to access this page.</p>
                    <p>Please <a href="login.jsp">log in</a> with appropriate credentials or contact your administrator.</p>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>