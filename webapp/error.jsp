<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/components.css">
</head>
<body>
    <div class="container">
        <h1>Oops! Something went wrong.</h1>
        <p>We apologize for the inconvenience. An unexpected error has occurred.</p>
        <p>Please try again later or contact support if the problem persists.</p>
        <a href="index.jsp" class="button">Go to Home</a>
        <% if (exception != null) { %>
            <!-- For debugging: display exception details. Remove in production. -->
            <p><strong>Error Details:</strong></p>
            <pre><%= exception.getMessage() %></pre>
        <% } %>
    </div>
</body>
</html>