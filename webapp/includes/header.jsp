<%
    String parentName = (String) session.getAttribute("parentName");
    String studentName = (String) session.getAttribute("studentName");
    boolean hasNotifications = true; // Dynamic logic here
%>

<header class="main-header">
    <div class="header-content">
        <div class="logo-section">
            <h1><i class="fas fa-graduation-cap"></i> Academic Center</h1>
        </div>
        
        <div class="header-actions">
                        <div class="theme-selector">
                <select id="themeSelect" class="theme-dropdown">
                    <option value="ocean" <%= theme.equals("ocean") ? "selected" : "" %>>Ocean Academic</option>
                    <option value="dark" <%= theme.equals("dark") ? "selected" : "" %>>Modern Dark</option>
                </select>
            </div>
            <% if (hasNotifications) { %>
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
            <% } %>
            
            <div class="user-menu">
                <span class="welcome-text">Welcome, <%= parentName != null ? parentName : "Parent" %></span>
                <img src="assets/images/parent-avatar.png" alt="Parent Avatar" class="user-avatar">
            </div>
        </div>
        
        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</header>