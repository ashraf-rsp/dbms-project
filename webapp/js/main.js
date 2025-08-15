document.addEventListener('DOMContentLoaded', function() {
    const themeSelect = document.getElementById('themeSelect');
    const htmlElement = document.documentElement;

    // Function to apply theme
    function applyTheme(theme) {
        htmlElement.setAttribute('data-theme', theme);
        // Send theme preference to server to persist in session
        fetch('setTheme.jsp?theme=' + theme)
            .then(response => {
                if (!response.ok) {
                    console.error('Failed to set theme on server.');
                }
            })
            .catch(error => console.error('Error setting theme:', error));
    }

    // Set initial theme based on select value (which is set by JSP from session)
    if (themeSelect) {
        applyTheme(themeSelect.value);
        themeSelect.addEventListener('change', function() {
            applyTheme(this.value);
        });
    }

    // Mobile menu toggle
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const sidebar = document.getElementById('sidebar');
    const mainContainer = document.querySelector('.main-container'); // Get main container

    if (mobileMenuToggle && sidebar && mainContainer) {
        mobileMenuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            mainContainer.classList.toggle('sidebar-open'); // Toggle class on main container
        });
    }
});