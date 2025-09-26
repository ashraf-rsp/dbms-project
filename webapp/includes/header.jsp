<header class="main-header">
    <div class="header-content">
        <a href="dashboard.jsp" style="text-decoration: none; color: inherit;">
            <div class="logo-section">
                <h1><i class="fas fa-graduation-cap"></i> ThinkSpire Academy</h1>
            </div>
        </a>

        <div class="header-actions desktop-header-actions">
            <% if (session.getAttribute("loggedInUser") != null) { %>
                

                <div class="notification-icon" id="notification-bell">
                    <i class="fas fa-bell"></i>
                </div>

                <div class="message-icon">
                    <a href="messages.jsp"><i class="fas fa-comment-dots"></i></a>
                    <span class="message-count" id="message-count">0</span>
                </div>

                <div class="user-menu dropdown-toggle" id="user-menu-toggle">
                    <span class="welcome-text">Welcome, <%= (String) request.getAttribute("loggedInUser") %></span>
                    <img src="assets/images/placeholder-student.png" alt="User Avatar" class="user-avatar">
                    <div class="dropdown-menu" id="user-dropdown-menu">
                        <a href="profile.jsp" class="dropdown-item"><i class="fas fa-user"></i> Profile</a>
                        <a href="settings.jsp" class="dropdown-item"><i class="fas fa-cog"></i> Settings</a>
                        <a href="logout.jsp" class="dropdown-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            <% } %>
            <a href="#" id="theme-toggle-button" class="theme-toggle-button">
                <i class="fas fa-moon"></i>
            </a>

        </div>

        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</header>

<% if (session.getAttribute("loggedInUser") != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const messageCountSpan = document.getElementById('message-count');
        const loggedInUserId = "<%= request.getAttribute("userId") %>"; // Assuming userId is available in request scope

        if (loggedInUserId && loggedInUserId !== "null") { // Check if user is logged in
            const websocketUrl = "ws://" + window.location.host + "<%= request.getContextPath() %>/message-updates/" + loggedInUserId;
            const websocket = new WebSocket(websocketUrl);

            websocket.onopen = function(event) {
                console.log("WebSocket connected:", event);
            };

            websocket.onmessage = function(event) {
                const message = JSON.parse(event.data);
                if (message.type === "new_message_count") {
                    messageCountSpan.textContent = message.count;
                    if (message.count > 0) {
                        messageCountSpan.classList.add('has-messages'); // Add a class for styling
                    } else {
                        messageCountSpan.classList.remove('has-messages');
                    }
                }
            };

            websocket.onclose = function(event) {
                console.log("WebSocket disconnected:", event);
                // Optionally, try to reconnect after a delay
            };

            websocket.onerror = function(error) {
                console.error("WebSocket error:", error);
            };
        }
    });
</script>
<% } %>