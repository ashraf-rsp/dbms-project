<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("title", "Mark Absent"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="page-section">
    <h2>Mark Student Absent</h2>
    <form action="#" method="post">
        <div class="form-group">
            <label for="studentName">Student Name:</label>
            <input type="text" id="studentName" name="studentName" required>
        </div>
        <div class="form-group">
            <label for="absentDate">Date of Absence:</label>
            <input type="date" id="absentDate" name="absentDate" required>
        </div>
        <div class="form-group">
            <label for="reason">Reason for Absence (Optional):</label>
            <textarea id="reason" name="reason" rows="4"></textarea>
        </div>
        <button type="submit">Mark Absent</button>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
