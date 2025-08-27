<%@ page import="java.sql.*" %>

<div class="summary-cards-grid">
    <div class="summary-card">
        <h3>Teacher Quick Stats</h3>
        <p><strong>Total Courses:</strong> 4</p>
        <p><strong>Total Students:</strong> 65</p>
    </div>
</div>

<div class="data-table-container">
    <div class="table-header">
        <h3>My Courses</h3>
    </div>
    <div class="responsive-table">
        <table class="dashboard-table">
            <thead>
                <tr>
                    <th>Course Name</th>
                    <th>Enrolled Students</th>
                    <th>Schedule</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Advanced Mathematics</td>
                    <td>15</td>
                    <td>Mon, Wed, Fri @ 10:00 AM</td>
                </tr>
                <tr>
                    <td>History of Science</td>
                    <td>20</td>
                    <td>Tue, Thu @ 1:00 PM</td>
                </tr>
                <tr>
                    <td>English Literature</td>
                    <td>18</td>
                    <td>Mon, Wed @ 2:00 PM</td>
                </tr>
                 <tr>
                    <td>Physics 101</td>
                    <td>12</td>
                    <td>Tue, Thu @ 9:00 AM</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
