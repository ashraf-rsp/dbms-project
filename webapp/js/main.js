document.addEventListener('DOMContentLoaded', function() {
    try {
        const themeToggleButton = document.getElementById('theme-toggle-button');
        const htmlElement = document.documentElement;

        // Function to apply theme and update icon
        function applyTheme(theme) {
            htmlElement.setAttribute('data-theme', theme);
            updateThemeIcon(theme);
            // Send theme preference to server to persist in session
            fetch('setTheme.jsp?theme=' + theme)
                .then(response => {
                    if (!response.ok) {
                        console.error('Failed to set theme on server.');
                    }
                })
                .catch(error => console.error('Error setting theme:', error));
        }

        // Function to update the theme icon
        function updateThemeIcon(theme) {
            const icon = themeToggleButton.querySelector('i');
            if (theme === 'dark') {
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
            } else {
                icon.classList.remove('fa-sun');
                icon.classList.add('fa-moon');
            }
        }

        // Event listener for the theme toggle button
        if (themeToggleButton) {
            themeToggleButton.addEventListener('click', function(event) {
                event.preventDefault();
                const currentTheme = htmlElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'ocean' : 'dark';
                applyTheme(newTheme);
            });
        }

        // Set initial icon based on the theme from the session (set on the html tag by JSP)
        const initialTheme = htmlElement.getAttribute('data-theme');
        if (initialTheme) {
            updateThemeIcon(initialTheme);
        }

        // User menu dropdown toggle
        const userMenuToggle = document.getElementById('user-menu-toggle');
        const userDropdownMenu = document.getElementById('user-dropdown-menu');

        if (userMenuToggle && userDropdownMenu) {
            userMenuToggle.addEventListener('click', function(event) {
                event.stopPropagation(); // Prevent document click from immediately closing
                userDropdownMenu.classList.toggle('active');
            });

            // Close dropdown if clicked outside
            document.addEventListener('click', function(event) {
                if (userDropdownMenu.classList.contains('active') && !userMenuToggle.contains(event.target) && !userDropdownMenu.contains(event.target)) {
                    userDropdownMenu.classList.remove('active');
                }
            });
        }

        // Mobile menu toggle
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const sidebar = document.getElementById('sidebar');
        const mainContainer = document.querySelector('.main-container'); // Get main container

        if (mobileMenuToggle && sidebar && mainContainer && !mobileMenuToggle.dataset.listenerAttached) {
            mobileMenuToggle.addEventListener('click', function() {
                console.log('Hamburger menu clicked!');
                sidebar.classList.toggle('active');
                mainContainer.classList.toggle('sidebar-open'); // Toggle class on main container
            });
            mobileMenuToggle.dataset.listenerAttached = 'true'; // Set a flag
        }
    } catch (e) {
        console.error('Error in DOMContentLoaded event listener:', e);
    }
});

// --- Real-Time Count Polling ---
document.addEventListener('DOMContentLoaded', function() {
    const notificationCountElement = document.getElementById('notification-count');
    const messageCountElement = document.getElementById('message-count');

    function fetchCounts() {
        // Fetch Notification Count
        fetch('get_notification_count.jsp')
            .then(response => response.text())
            .then(count => {
                updateCount(notificationCountElement, count);
            })
            .catch(error => console.error('Error fetching notification count:', error));

        // Fetch Message Count
        fetch('get_message_count.jsp')
            .then(response => response.text())
            .then(count => {
                updateCount(messageCountElement, count);
            })
            .catch(error => console.error('Error fetching message count:', error));
    }

    function updateCount(element, count) {
        if (!element) return;
        const currentCount = parseInt(element.textContent, 10);
        const newCount = parseInt(count, 10);

        if (newCount > 0) {
            element.textContent = newCount;
            element.classList.remove('hidden');
        } else {
            element.classList.add('hidden');
        }

        // Optional: Add a small animation if the count changes
        if (newCount !== currentCount) {
            element.classList.add('updated');
            setTimeout(() => {
                element.classList.remove('updated');
            }, 500);
        }
    }

    // Check if the count elements exist before starting polling
    if (notificationCountElement && messageCountElement) {
        // Fetch counts immediately on page load
        fetchCounts();

        // Poll for new counts every 10 seconds
        setInterval(fetchCounts, 10000);
    }
});