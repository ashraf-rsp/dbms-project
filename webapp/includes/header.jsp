<header class="main-header">
    <div class="header-content">
        <div class="logo-section">
            <h1><i class="fas fa-graduation-cap"></i> ThinkSpire Academy</h1>
        </div>

        <div class="header-actions desktop-header-actions">
            <% if (session.getAttribute("loggedInUser") != null) { %>
                

                <div class="notification-icon" id="notification-bell">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count hidden" id="notification-count">0</span>
                    <div class="notifications-dropdown" id="notifications-dropdown">
                        
                        <div class="notifications-list" id="notifications-list">
                            <!-- Notifications will be loaded here by JavaScript -->
                            <p class="no-notifications">No new notifications.</p>
                        </div>
                    </div>
                </div>

                <div class="message-icon">
                    <a href="messages.jsp"><i class="fas fa-comment-dots"></i></a>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const notificationBell = document.getElementById('notification-bell');
        const notificationsDropdown = document.getElementById('notifications-dropdown');
        const notificationCount = document.getElementById('notification-count');
        const notificationsList = document.getElementById('notifications-list');

        let loggedInUserId = <%= request.getAttribute("userId") %>;

        // Function to fetch notifications
        function fetchNotifications() {
            // Ensure loggedInUserId is a valid number before fetching
            if (typeof loggedInUserId === 'number' && loggedInUserId > 0) {
                fetch(`notifications_api.jsp?action=fetch&userId=${loggedInUserId}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            const notifications = data.notifications;
                            notificationCount.textContent = notifications.length;

                            // Hide count if zero
                            if (notifications.length === 0) {
                                notificationCount.classList.add('hidden');
                                notificationsList.innerHTML = '<p class="no-notifications">No new notifications.</p>';
                            } else {
                                notificationCount.classList.remove('hidden');
                                notificationsList.innerHTML = ''; // Clear existing notifications
                                notifications.forEach(notification => {
                                    const notificationLink = document.createElement('a');
                                    notificationLink.href = `notification_details.jsp?id=${notification.notificationId}`;
                                    notificationLink.classList.add('notification-item');
                                    notificationLink.dataset.notificationId = notification.notificationId;
                                    notificationLink.innerHTML = '<p>' + notification.message + '</p><span>' + new Date(notification.timestamp).toLocaleString() + '</span>';
                                    notificationsList.appendChild(notificationLink);
                                });
                            }
                        } else {
                            // If the API returns an error (e.g. invalid userId), log it but don't crash
                            console.error('Error fetching notifications:', data.message);
                            notificationCount.classList.add('hidden');
                            notificationsList.innerHTML = '<p class="no-notifications">Could not load notifications.</p>';
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching notifications:', error);
                        notificationCount.classList.add('hidden');
                        notificationsList.innerHTML = '<p class="no-notifications">Could not load notifications.</p>';
                    });
            } else {
                // Don't even try to fetch if the user ID isn't a valid number
                notificationCount.classList.add('hidden');
            }
        }

        // Mark notification as read
        notificationsList.addEventListener('click', function(event) {
            const target = event.target.closest('.notification-item');
            if (target) {
                const notificationId = target.dataset.notificationId;
                // Ensure notificationId is valid before sending
                if (notificationId && !isNaN(notificationId)) {
                    fetch(`notifications_api.jsp?action=mark_read&id=${notificationId}`)
                        .then(response => response.json())
                        .then(data => {
                            if (data.status !== 'success') {
                                console.error('Failed to mark notification as read.');
                            }
                        })
                        .catch(error => {
                            console.error('Error marking notification as read:', error);
                        });
                }
            }
        });

        // Toggle dropdown visibility
        notificationBell.addEventListener('click', function() {
            notificationsDropdown.classList.toggle('show');
            if (notificationsDropdown.classList.contains('show')) {
                fetchNotifications(); // Fetch notifications when dropdown is opened
            }
        });

        // Close dropdown when clicking outside
        window.addEventListener('click', function(event) {
            if (notificationBell && !notificationBell.contains(event.target) && !notificationsDropdown.contains(event.target)) {
                notificationsDropdown.classList.remove('show');
            }
        });

        // Initial fetch on page load
        fetchNotifications();
        // Periodically fetch every 60 seconds
        setInterval(fetchNotifications, 60000);

    });
</script>