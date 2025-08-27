<%
    // Get theme from session or set a default
    // We will directly use session.getAttribute("theme") in the HTML below
    // and handle the default value there.

    String parentName = (String) session.getAttribute("parentName");
    
    boolean hasNotifications = true; // Dynamic logic here
%>

<header class="main-header">
    <div class="header-content">
        <div class="logo-section">
            <h1><i class="fas fa-graduation-cap"></i> ThinkSpire Academy</h1>
        </div>
        
        <div class="header-actions">
                        <a href="#" id="theme-toggle-button" class="theme-toggle-button">
                <i class="fas fa-moon"></i>
            </a>
            <% if (hasNotifications) { %>
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
            <% } %>
            
            <% if (session.getAttribute("loggedInUser") != null) { %>
            <div class="user-menu dropdown-toggle" id="user-menu-toggle">
                <span class="welcome-text">Welcome, <%= session.getAttribute("loggedInUser") != null ? session.getAttribute("loggedInUser") : "User" %></span>
                <img src="assets/images/placeholder-<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole").toString().toLowerCase() : "student" %>.png" alt="User Avatar" class="user-avatar">
                <div class="dropdown-menu" id="user-dropdown-menu">
                    <a href="student_profile.jsp" class="dropdown-item"><i class="fas fa-user"></i> Profile</a>
                    <a href="settings.jsp" class="dropdown-item"><i class="fas fa-cog"></i> Settings</a>
                    <a href="logout.jsp" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>
            <% } %>
        </div>
        
        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</header>