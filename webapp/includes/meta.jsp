<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Parent-First Academic Center Management">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/themes.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/components.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
<%
    String additionalCss = (String) request.getAttribute("additionalCss");
    if (additionalCss != null && !additionalCss.isEmpty()) {
%>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/<%= additionalCss %>.css">
<%
    }
%>