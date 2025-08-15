<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="WEB-INF/jspf/header.jspf" %>
<main class="container">
    <h1>Class Schedule</h1>
    <section class="schedule-section">
        <h2>Schedule for [Student Name/Class Name]</h2>
        <div class="filter-controls">
            <label for="day-filter">Filter by Day:</label>
            <select id="day-filter">
                <option value="all">All Days</option>
                <option value="monday">Monday</option>
                <option value="tuesday">Tuesday</option>
                <option value="wednesday">Wednesday</option>
                <option value="thursday">Thursday</option>
                <option value="friday">Friday</option>
            </select>
        </div>

        <div class="schedule-grid-container">
            <div class="schedule-grid">
                <div class="grid-header time-col">Time</div>
                <div class="grid-header">Monday</div>
                <div class="grid-header">Tuesday</div>
                <div class="grid-header">Wednesday</div>
                <div class="grid-header">Thursday</div>
                <div class="grid-header">Friday</div>

                <div class="time-slot">09:00 - 10:00</div>
                <div class="schedule-item">Mathematics<br>Mr. Smith<br>Room 101</div>
                <div class="schedule-item">History<br>Mr. Davis<br>Room 102</div>
                <div class="schedule-item">Mathematics<br>Mr. Smith<br>Room 101</div>
                <div class="schedule-item">Science<br>Ms. Johnson<br>Lab 203</div>
                <div class="schedule-item">Mathematics<br>Mr. Smith<br>Room 101</div>

                <div class="time-slot">10:00 - 11:00</div>
                <div class="schedule-item">Science<br>Ms. Johnson<br>Lab 203</div>
                <div class="schedule-item">Mathematics<br>Mr. Smith<br>Room 101</div>
                <div class="schedule-item">Science<br>Ms. Johnson<br>Lab 203</div>
                <div class="schedule-item">History<br>Mr. Davis<br>Room 102</div>
                <div class="schedule-item">Science<br>Ms. Johnson<br>Lab 203</div>

                <div class="time-slot">11:00 - 12:00</div>
                <div class="schedule-item">History<br>Mr. Davis<br>Room 102</div>
                <div class="schedule-item">Science<br>Ms. Johnson<br>Lab 203</div>
                <div class="schedule-item">History<br>Mr. Davis<br>Room 102</div>
                <div class="schedule-item">Mathematics<br>Mr. Smith<br>Room 101</div>
                <div class="schedule-item">History<br>Mr. Davis<br>Room 102</div>
            </div>
        </div>

        <h3>Detailed Schedule List</h3>
        <div class="responsive-table-container">
            <table class="schedule-table">
                <thead>
                    <tr>
                        <th>Day</th>
                        <th>Time</th>
                        <th>Subject</th>
                        <th>Teacher</th>
                        <th>Room</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td data-label="Day">Monday</td>
                        <td data-label="Time">09:00 - 10:00</td>
                        <td data-label="Subject">Mathematics</td>
                        <td data-label="Teacher">Mr. Smith</td>
                        <td data-label="Room">Room 101</td>
                    </tr>
                    <tr>
                        <td data-label="Day">Monday</td>
                        <td data-label="Time">10:00 - 11:00</td>
                        <td data-label="Subject">Science</td>
                        <td data-label="Teacher">Ms. Johnson</td>
                        <td data-label="Room">Lab 203</td>
                    </tr>
                    <tr>
                        <td data-label="Day">Tuesday</td>
                        <td data-label="Time">09:00 - 10:00</td>
                        <td data-label="Subject">History</td>
                        <td data-label="Teacher">Mr. Davis</td>
                        <td data-label="Room">Room 102</td>
                    </tr>
                    <tr>
                        <td data-label="Day">Wednesday</td>
                        <td data-label="Time">09:00 - 10:00</td>
                        <td data-label="Subject">Mathematics</td>
                        <td data-label="Teacher">Mr. Smith</td>
                        <td data-label="Room">Room 101</td>
                    </tr>
                    <tr>
                        <td data-label="Day">Thursday</td>
                        <td data-label="Time">10:00 - 11:00</td>
                        <td data-label="Subject">Science</td>
                        <td data-label="Teacher">Ms. Johnson</td>
                        <td data-label="Room">Lab 203</td>
                    </tr>
                    <tr>
                        <td data-label="Day">Friday</td>
                        <td data-label="Time">09:00 - 10:00</td>
                        <td data-label="Subject">Mathematics</td>
                        <td data-label="Teacher">Mr. Smith</td>
                        <td data-label="Room">Room 101</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="WEB-INF/jspf/footer.jspf" %>