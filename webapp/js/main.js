document.addEventListener('DOMContentLoaded', function() {
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
            if (!userMenuToggle.contains(event.target) && !userDropdownMenu.contains(event.target)) {
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
});