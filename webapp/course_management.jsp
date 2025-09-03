<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db_connection.jsp" %>
<%
    // AuthFilter handles access control. This page is for Admins.
    String status = request.getParameter("status");
    String message = request.getParameter("message");
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en">
<head>
    <title>Course Management - Academic Center</title>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="course_management" />
        </jsp:include>
        <main class="container">
            <h1>Course Management</h1>
            <section class="course-management-section">
                <h2>Available Courses</h2>
                <%
                    if (status != null && message != null) {
                        String alertClass = "";
                        if (status.equals("success")) {
                            alertClass = "alert-success";
                        } else if (status.equals("error")) {
                            alertClass = "alert-danger";
                        }
                %>
                <div class="alert <%= alertClass %>">
                    <%= message %>
                </div>
                <%
                    }
                %>
                <div class="course-list">
                    <%
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            String sql = "SELECT CourseID, CourseName, CourseDescription, CourseFee FROM Courses ORDER BY CourseName";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <div class="course-item" data-course-id="<%= rs.getString("CourseID") %>">
                        <h3><%= rs.getString("CourseName") %></h3>
                        <p><strong>Course ID:</strong> <%= rs.getString("CourseID") %></p>
                        <p><strong>Description:</strong> <%= rs.getString("CourseDescription") %></p>
                        <p><strong>Fee:</strong> $<%= String.format("%.2f", rs.getDouble("CourseFee")) %></p>
                        <div class="course-actions">
                            <button class="button edit-button" data-course-id="<%= rs.getString("CourseID") %>" data-course-name="<%= rs.getString("CourseName") %>" data-course-description="<%= rs.getString("CourseDescription") %>" data-course-fee="<%= rs.getDouble("CourseFee") %>"><i class="fas fa-edit"></i> Edit</button>
                            <button class="button delete-button" data-course-id="<%= rs.getString("CourseID") %>"><i class="fas fa-trash-alt"></i> Delete</button>
                        </div>
                    </div>
                    <%
                            }
                        } catch (Exception e) {
                            System.err.println("Error loading courses: " + e.getMessage());
                            out.println("<p>Error loading courses. Please try again.</p>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
                        }
                    %>
                </div>
                <div class="add-course-form">
                    <h2>Add New Course</h2>
                    <form action="course_management_process.jsp" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label for="course-name">Course Name:</label>
                            <input type="text" id="course-name" name="courseName" required>
                        </div>
                        <div class="form-group">
                            <label for="course-description">Description:</label>
                            <textarea id="course-description" name="courseDescription" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="course-fee">Course Fee:</label>
                            <input type="number" id="course-fee" name="courseFee" step="0.01" required>
                        </div>
                        <button type="submit" class="button primary-button"><i class="fas fa-plus-circle"></i> Add Course</button>
                    </form>
                </div>

                <div class="edit-course-form" style="display:none;">
                    <h2>Edit Course</h2>
                    <form action="course_management_process.jsp" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="courseId" id="edit-course-id">
                        <div class="form-group">
                            <label for="edit-course-name">Course Name:</label>
                            <input type="text" id="edit-course-name" name="courseName" required>
                        </div>
                        <div class="form-group">
                            <label for="edit-course-description">Description:</label>
                            <textarea id="edit-course-description" name="courseDescription" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="edit-course-fee">Course Fee:</label>
                            <input type="number" id="edit-course-fee" name="courseFee" step="0.01" required>
                        </div>
                        <button type="submit" class="button primary-button">Save Changes</button>
                        <button type="button" class="button cancel-edit">Cancel</button>
                    </form>
                </div>

                <form id="delete-course-form" action="course_management_process.jsp" method="post" style="display:none;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="courseId" id="delete-course-id">
                </form>

            </section>
        </main>
    </div>
    <%@ include file="includes/footer.jsp" %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const courseList = document.querySelector('.course-list');
            const addCourseForm = document.querySelector('.add-course-form');
            const editCourseForm = document.querySelector('.edit-course-form');
            const deleteCourseForm = document.getElementById('delete-course-form');

            // Show edit form
            courseList.addEventListener('click', function(event) {
                if (event.target.classList.contains('edit-button')) {
                    const button = event.target;
                    document.getElementById('edit-course-id').value = button.dataset.courseId;
                    document.getElementById('edit-course-name').value = button.dataset.courseName;
                    document.getElementById('edit-course-description').value = button.dataset.courseDescription;
                    document.getElementById('edit-course-fee').value = button.dataset.courseFee;

                    addCourseForm.style.display = 'none';
                    editCourseForm.style.display = 'block';
                }
            });

            // Cancel edit
            document.querySelector('.cancel-edit').addEventListener('click', function() {
                editCourseForm.style.display = 'none';
                addCourseForm.style.display = 'block';
            });

            // Delete course
            courseList.addEventListener('click', function(event) {
                if (event.target.classList.contains('delete-button')) {
                    if (confirm('Are you sure you want to delete this course?')) {
                        const courseId = event.target.dataset.courseId;
                        document.getElementById('delete-course-id').value = courseId;
                        deleteCourseForm.submit();
                    }
                }
            });
        });
    </script>
</body>
</html>
