<header class="main-header">
    <div class="header-content">
        <div class="logo-section">
            <h1><i class="fas fa-graduation-cap"></i> ThinkSpire Academy</h1>
        </div>
        
        <div class="header-actions">
                        <a href="#" id="theme-toggle-button" class="theme-toggle-button">
                <i class="fas fa-moon"></i>
            </a>
            
                <div class="notification-icon">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                </div>
            
            
            
            <div class="user-menu dropdown-toggle" id="user-menu-toggle">
                <% if (session.getAttribute("loggedInUser") != null) { %>
                <span class="welcome-text">Welcome, <%= session.getAttribute("loggedInUser") %></span>
                <% } %>
                <img src="assets/images/placeholder-student.png" alt="User Avatar" class="user-avatar">
                <div class="dropdown-menu" id="user-dropdown-menu">
                    <a href="student_profile.jsp" class="dropdown-item"><i class="fas fa-user"></i> Profile</a>
                    <a href="settings.jsp" class="dropdown-item"><i class="fas fa-cog"></i> Settings</a>
                    <a href="logout.jsp" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>
            
        </div>
        
        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</header>