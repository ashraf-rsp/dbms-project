<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Teacher List</h1>
    <section class="teacher-list-section">
        <h2>Our Faculty</h2>
        <div class="teacher-grid">
            <div class="teacher-card">
                <img src="assets/images/placeholder-teacher.png" alt="Teacher Photo" class="teacher-photo">
                <h3>John Doe</h3>
                <p><strong>Subject:</strong> Mathematics</p>
                <p><strong>Email:</strong> john.doe@example.com</p>
                <p><strong>Phone:</strong> (123) 456-7890</p>
                <a href="messages.jsp?composeTo=john.doe@example.com" class="button primary-button"><i class="fas fa-envelope"></i> Contact</a>
            </div>
            <div class="teacher-card">
                <img src="assets/images/placeholder-teacher.png" alt="Teacher Photo" class="teacher-photo">
                <h3>Jane Smith</h3>
                <p><strong>Subject:</strong> Science</p>
                <p><strong>Email:</strong> jane.smith@example.com</p>
                <p><strong>Phone:</strong> (123) 987-6543</p>
                <a href="messages.jsp?composeTo=jane.smith@example.com" class="button primary-button"><i class="fas fa-envelope"></i> Contact</a>
            </div>
            <div class="teacher-card">
                <img src="assets/images/placeholder-teacher.png" alt="Teacher Photo" class="teacher-photo">
                <h3>Robert Johnson</h3>
                <p><strong>Subject:</strong> History</p>
                <p><strong>Email:</strong> robert.j@example.com</p>
                <p><strong>Phone:</strong> (123) 111-2222</p>
                <a href="messages.jsp?composeTo=robert.j@example.com" class="button primary-button"><i class="fas fa-envelope"></i> Contact</a>
            </div>
            <div class="teacher-card">
                <img src="assets/images/placeholder-teacher.png" alt="Teacher Photo" class="teacher-photo">
                <h3>Emily White</h3>
                <p><strong>Subject:</strong> English</p>
                <p><strong>Email:</strong> emily.w@example.com</p>
                <p><strong>Phone:</strong> (123) 333-4444</p>
                <a href="messages.jsp?composeTo=emily.w@example.com" class="button primary-button"><i class="fas fa-envelope"></i> Contact</a>
            </div>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>