<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Course Management</h1>
    <section class="course-management-section">
        <h2>Available Courses</h2>
        <div class="course-list">
            <div class="course-item" data-course-id="MATH101">
                <h3>Mathematics - Grade 5</h3>
                <p><strong>Course ID:</strong> MATH101</p>
                <p><strong>Teacher:</strong> Mr. Smith</p>
                <p><strong>Description:</strong> Covers basic algebra, geometry, and number theory.</p>
                <div class="course-actions">
                    <button class="button edit-button"><i class="fas fa-edit"></i> Edit</button>
                    <button class="button delete-button"><i class="fas fa-trash-alt"></i> Delete</button>
                </div>
            </div>
            <div class="course-item" data-course-id="SCI101">
                <h3>Science - Grade 5</h3>
                <p><strong>Course ID:</strong> SCI101</p>
                <p><strong>Teacher:</strong> Ms. Johnson</p>
                <p><strong>Description:</strong> Introduction to biology, chemistry, and physics concepts.</p>
                <div class="course-actions">
                    <button class="button edit-button"><i class="fas fa-edit"></i> Edit</button>
                    <button class="button delete-button"><i class="fas fa-trash-alt"></i> Delete</button>
                </div>
            </div>
            <div class="course-item" data-course-id="HIST101">
                <h3>History - Grade 5</h3>
                <p><strong>Course ID:</strong> HIST101</p>
                <p><strong>Teacher:</strong> Mr. Davis</p>
                <p><strong>Description:</strong> Explores ancient civilizations and world history events.</p>
                <div class="course-actions">
                    <button class="button edit-button"><i class="fas fa-edit"></i> Edit</button>
                    <button class="button delete-button"><i class="fas fa-trash-alt"></i> Delete</button>
                </div>
            </div>
            <div class="course-item" data-course-id="ENG101">
                <h3>English - Grade 5</h3>
                <p><strong>Course ID:</strong> ENG101</p>
                <p><strong>Teacher:</strong> Ms. Emily White</p>
                <p><strong>Description:</strong> Focuses on reading comprehension, writing skills, and grammar.</p>
                <div class="course-actions">
                    <button class="button edit-button"><i class="fas fa-edit"></i> Edit</button>
                    <button class="button delete-button"><i class="fas fa-trash-alt"></i> Delete</button>
                </div>
            </div>
        </div>
        <div class="add-course-form">
            <h2>Add New Course</h2>
            <form>
                <div class="form-group">
                    <label for="course-name">Course Name:</label>
                    <input type="text" id="course-name" name="course-name" required>
                </div>
                <div class="form-group">
                    <label for="course-id">Course ID:</label>
                    <input type="text" id="course-id" name="course-id" required>
                </div>
                <div class="form-group">
                    <label for="course-teacher">Teacher:</label>
                    <input type="text" id="course-teacher" name="course-teacher">
                </div>
                <div class="form-group">
                    <label for="course-description">Description:</label>
                    <textarea id="course-description" name="course-description" rows="3"></textarea>
                </div>
                <button type="submit" class="button primary-button"><i class="fas fa-plus-circle"></i> Add Course</button>
            </form>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>