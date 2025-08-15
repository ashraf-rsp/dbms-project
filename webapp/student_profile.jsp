<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Student Profile</h1>
    <section class="profile-card">
        <div class="profile-header">
            <img src="assets/images/placeholder-student.png" alt="Student Photo" class="student-photo">
            <h2>[Student Name]</h2>
            <p class="student-id">Student ID: <strong>[Student ID]</strong></p>
        </div>
        <div class="profile-details">
            <h3>Personal Information</h3>
            <p><strong>Date of Birth:</strong> [DOB]</p>
            <p><strong>Enrollment Date:</strong> [Enrollment Date]</p>
            <p><strong>Current Class:</strong> [Class Name]</p>

            <h3>Parent/Guardian Information</h3>
            <p><strong>Name:</strong> [Parent Name]</p>
            <p><strong>Email:</strong> [Parent Email]</p>
            <p><strong>Phone:</strong> [Parent Phone]</p>
        </div>
        <div class="profile-actions">
            <a href="view_grades.jsp?studentId=[Student ID]" class="button"><i class="fas fa-chart-line"></i> View Grades</a>
            <a href="view_attendance.jsp?studentId=[Student ID]" class="button"><i class="fas fa-calendar-check"></i> View Attendance</a>
            <a href="messages.jsp?composeTo=[Parent Email]" class="button"><i class="fas fa-envelope"></i> Send Message</a>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>