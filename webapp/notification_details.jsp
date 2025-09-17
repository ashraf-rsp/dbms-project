<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/sidebar.jsp" />

<div class="content-area">
    <div class="page-header">
        <h2>Notification Details</h2>
    </div>

    <div class="container">
        <div id="notification-content">
            <!-- Notification details will be loaded here -->
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const notificationId = urlParams.get('id');
    const notificationContent = document.getElementById('notification-content');

    if (notificationId) {
        // Fetch notification details
        fetch(`notifications_api.jsp?action=get&id=${notificationId}`)
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    const notification = data.notification;
                    notificationContent.innerHTML = `
                        <h3>${notification.subject}</h3>
                        <p>${notification.message}</p>
                        <small>${new Date(notification.timestamp).toLocaleString()}</small>
                    `;
                } else {
                    notificationContent.innerHTML = '<p>Error loading notification.</p>';
                }
            })
            .catch(error => {
                console.error('Error fetching notification:', error);
                notificationContent.innerHTML = '<p>Error loading notification.</p>';
            });

        // Mark notification as read
        fetch(`notifications_api.jsp?action=mark_read&id=${notificationId}`)
            .then(response => response.json())
            .then(data => {
                if (data.status !== 'success') {
                    console.error('Error marking notification as read:', data.message);
                }
            });
    } else {
        notificationContent.innerHTML = '<p>No notification ID provided.</p>';
    }
});
</script>

<jsp:include page="includes/footer.jsp" />
