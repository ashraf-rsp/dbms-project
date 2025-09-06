<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ include file="db_connection.jsp" %>

<%
    String userRole = (String) request.getAttribute("userRole");
    // The AuthFilter should handle the redirection if userRole is not Admin.
    // This JSP assumes the AuthFilter has already verified the role.

    String theme = (String) session.getAttribute("theme");
    if (theme == null) theme = "ocean"; // Default theme

    String action = request.getParameter("action");
    String userIdParam = request.getParameter("userId");

    int userId = -1;
    if (userIdParam != null && !userIdParam.isEmpty()) {
        try {
            userId = Integer.parseInt(userIdParam);
        } catch (NumberFormatException e) {
            // Handle error: invalid userId
            session.setAttribute("message", "Invalid User ID.");
            response.sendRedirect("user_management.jsp");
            return;
        }
    }

    String username = "";
    String email = "";
    String userType = "";
    String parentId = "";
    String studentName = "";
    String formTitle = "Add New User";
    String submitButtonText = "Add User";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if ("edit".equals(action) && userId != -1) {
        formTitle = "Edit User";
        submitButtonText = "Update User";

        

        try {
            
            String sql = "SELECT Username, UserType, ParentID, Email FROM Users WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                username = rs.getString("Username");
                userType = rs.getString("UserType");
                parentId = rs.getString("ParentID");
                email = rs.getString("Email");

                if ("Student".equals(userType)) {
                    String sqlStudent = "SELECT StudentName FROM Students WHERE UserID = ?";
                    PreparedStatement pstmtStudent = conn.prepareStatement(sqlStudent);
                    pstmtStudent.setInt(1, userId);
                    ResultSet rsStudent = pstmtStudent.executeQuery();
                    if (rsStudent.next()) {
                        studentName = rsStudent.getString("StudentName");
                    }
                    rsStudent.close();
                    pstmtStudent.close();
                }
            } else {
                session.setAttribute("message", "User not found.");
                response.sendRedirect("user_management.jsp");
                return;
            }
        } catch (SQLException e) {
            session.setAttribute("message", "Database error: " + e.getMessage());
            response.sendRedirect("user_management.jsp");
            return;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignore */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignore */ }
        }
    }

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>
<%@ include file="includes/meta.jsp" %>
<html lang="en" data-theme="<%= theme %>">
<head>
    <title><%= formTitle %> - Academic Center</title>
    <link rel="stylesheet" href="css/responsive-table.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <div class="main-container">
        <jsp:include page="includes/sidebar.jsp">
            <jsp:param name="activePage" value="user_management" />
        </jsp:include>
        
        <main class="content-area">
            <div class="container">
                <div class="page-header">
                    <h2><i class="fas fa-users"></i> <%= formTitle %></h2>
                </div>

                <% if (message != null) { %>
                    <p style="color: green;"><%= message %></p>
                <% } %>

                <div class="form-container">
                    <form action="user_management_process.jsp" method="post" onsubmit="return debugUpdate(this)">
                        <input type="hidden" name="action" value="<%= action != null ? action : "add" %>">
                        <input type="hidden" name="userId" value="<%= userId != -1 ? userId : "" %>">

                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" value="<%= username %>" required>

                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="<%= email %>" required>

                        <label for="password">Password: <% if ("edit".equals(action)) { %>(Leave blank to keep current password)<% } %></label>
                        <input type="password" id="password" name="password" <% if ("add".equals(action) || action == null) { %>required<% } %>>

                        <label for="userType">User Type:</label>
                        <select id="userType" name="userType" required onchange="toggleParentIdField()">
                            <option value="">-- Select --</option>
                            <option value="Admin" <%= "Admin".equals(userType) ? "selected" : "" %>>Admin</option>
                            <option value="Teacher" <%= "Teacher".equals(userType) ? "selected" : "" %>>Teacher</option>
                            <option value="Parent" <%= "Parent".equals(userType) ? "selected" : "" %>>Parent</option>
                            <option value="Student" <%= "Student".equals(userType) ? "selected" : "" %>>Student</option>
                        </select>

                        <div id="studentNameField" style="display: <%= "Student".equals(userType) ? "block" : "none" %>;">
                            <label for="studentName">Student Name:</label>
                            <input type="text" id="studentName" name="studentName" value="<%= studentName %>">
                        </div>

                        <div id="parentIdField" style="display: <%= "Parent".equals(userType) || "Student".equals(userType) ? "block" : "none" %>;">
                            <label for="parentId">Parent:</label>
                            <select id="parentId" name="parentId">
                                <option value="">-- Select Parent --</option>
                                <%-- Populate with parents from the database --%>
                                <% 
                                    PreparedStatement pstmtParents = null;
                                    ResultSet rsParents = null;
                                    try {
                                        String sqlParents = "SELECT ParentID, CONCAT(FirstName, ' ', LastName) AS ParentName FROM Parents ORDER BY ParentName";
                                        pstmtParents = conn.prepareStatement(sqlParents);
                                        rsParents = pstmtParents.executeQuery();
                                        while (rsParents.next()) {
                                            String pId = rsParents.getString("ParentID");
                                            String selected = pId.equals(parentId) ? "selected" : "";
                                %>
                                <option value="<%= pId %>" <%= selected %>><%= rsParents.getString("ParentName") %></option>
                                <% 
                                        }
                                    } catch (SQLException e) {
                                        // log e
                                    } finally {
                                        if (rsParents != null) try { rsParents.close(); } catch (SQLException e) { /* ignore */ }
                                        if (pstmtParents != null) try { pstmtParents.close(); } catch (SQLException e) { /* ignore */ }
                                    }
                                %>
                            </select>
                        </div>

                        <button type="submit" class="button"><%= submitButtonText %></button>
                    </form>
                </div>

                <script>
                    function debugUpdate(form) {
                        var userId = form.userId.value;
                        var username = form.username.value;
                        var email = form.email.value;
                        var userType = form.userType.value;
                        var studentName = form.studentName.value;
                        var parentId = form.parentId.value;
                        alert("Submitting the following values:\n" +
                            "User ID: " + userId + "\n" +
                            "Username: " + username + "\n" +
                            "Email: " + email + "\n" +
                            "User Type: " + userType + "\n" +
                            "Student Name: " + studentName + "\n" +
                            "Parent ID: " + parentId);
                        return true;
                    }

                    function toggleParentIdField() {
                        var userType = document.getElementById('userType').value;
                        var parentIdField = document.getElementById('parentIdField');
                        var studentNameField = document.getElementById('studentNameField');
                        if (userType === 'Parent' || userType === 'Student') {
                            parentIdField.style.display = 'block';
                        } else {
                            parentIdField.style.display = 'none';
                        }
                        if (userType === 'Student') {
                            studentNameField.style.display = 'block';
                        } else {
                            studentNameField.style.display = 'none';
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function() {
                        toggleParentIdField(); // Call on page load to set initial state

                        // Tab switching logic
                        document.querySelectorAll('.user-type-tab').forEach(tab => {
                            tab.addEventListener('click', function() {
                                const userType = this.dataset.userType;
                                document.querySelectorAll('.user-type-tab').forEach(t => t.classList.remove('active'));
                                this.classList.add('active');
                                document.querySelectorAll('.user-list-section').forEach(s => s.style.display = 'none');
                                document.getElementById(userType + 'List').style.display = 'block';
                            });
                        });

                        // Set initial active tab
                        const initialTab = document.querySelector('.user-type-tab.active');
                        if (initialTab) {
                            const userType = initialTab.dataset.userType;
                            document.getElementById(userType + 'List').style.display = 'block';
                        } else { // Default to Admin tab if no active tab is set
                            document.querySelector('.user-type-tab[data-user-type="Admin"]').click();
                        }
                    });
                </script>

                <h3>Existing Users</h3>
                <div class="user-type-tabs">
                    <button class="user-type-tab active" data-user-type="Admin">Admins</button>
                    <button class="user-type-tab" data-user-type="Teacher">Teachers</button>
                    <button class="user-type-tab" data-user-type="Parent">Parents</button>
                    <button class="user-type-tab" data-user-type="Student">Students</button>
                </div>

                <%!
                    // Helper function to render user table
                    // This function will be called for each user type
                    // It takes the userType and a list of users as input
                    // and renders the table for that user type.
                    // This is a simplified example, actual implementation might involve more complex data fetching.
                    
                    // Function to fetch users by type
                                        List<Map<String, Object>> getUsersByType(Connection conn, String type) throws SQLException {
                        List<Map<String, Object>> users = new ArrayList<>();
                        StringBuilder sqlBuilder = new StringBuilder();
                        String joinClause = "";
                        String selectColumns = "u.UserID, u.Username, u.UserType, u.ParentID"; // Base columns from Users table

                        // Add Email column based on UserType and table structure
                        if ("Teacher".equals(type)) {
                            selectColumns += ", t.TeacherName, t.Email"; // Teacher has its own Email
                            joinClause = " JOIN Teachers t ON u.UserID = t.UserID";
                        } else if ("Parent".equals(type)) {
                            selectColumns += ", p.FirstName, p.LastName, p.Phone, u.Email"; // Parent uses Users.Email
                            joinClause = " JOIN Parents p ON u.ParentID = p.ParentID";
                        } else if ("Student".equals(type)) {
                            selectColumns += ", s.StudentID, s.StudentName, u.Email"; // Student uses Users.Email
                            joinClause = " JOIN Students s ON u.UserID = s.UserID";
                        } else { // Admin and other types
                            selectColumns += ", u.Email"; // Admin uses Users.Email
                        }

                        sqlBuilder.append("SELECT ").append(selectColumns).append(" FROM Users u").append(joinClause).append(" WHERE u.UserType = ? ORDER BY u.UserID");

                        // out.println("DEBUG SQL: " + sqlBuilder.toString()); // Removed debug print

                        PreparedStatement pstmtList = conn.prepareStatement(sqlBuilder.toString());
                        pstmtList.setString(1, type);
                        ResultSet rsList = pstmtList.executeQuery();
                        while (rsList.next()) {
                            Map<String, Object> user = new HashMap<>();
                            user.put("UserID", rsList.getInt("UserID"));
                            user.put("Username", rsList.getString("Username"));
                            user.put("UserType", rsList.getString("UserType"));
                            
                            // Populate Email based on UserType
                            if ("Teacher".equals(type)) {
                                user.put("Email", rsList.getString("Email")); // From Teachers table
                                user.put("TeacherName", rsList.getString("TeacherName"));
                            } else if ("Parent".equals(type)) {
                                user.put("Email", rsList.getString("Email")); // From Users table
                                user.put("ParentID", rsList.getString("ParentID"));
                                user.put("FirstName", rsList.getString("FirstName"));
                                user.put("LastName", rsList.getString("LastName"));
                                user.put("Phone", rsList.getString("Phone"));
                            } else if ("Student".equals(type)) {
                                user.put("Email", rsList.getString("Email")); // From Users table
                                user.put("StudentID", rsList.getString("StudentID"));
                                user.put("StudentName", rsList.getString("StudentName"));
                                // Fetch parent name for student
                                String studentParentSql = "SELECT CONCAT(p.FirstName, ' ', p.LastName) AS ParentName FROM Parents p JOIN Student_Parent_Link spl ON p.ParentID = spl.ParentID WHERE spl.StudentID = ?";
                                PreparedStatement pstmtStudentParent = conn.prepareStatement(studentParentSql);
                                pstmtStudentParent.setString(1, rsList.getString("StudentID"));
                                ResultSet rsStudentParent = pstmtStudentParent.executeQuery();
                                if (rsStudentParent.next()) {
                                    user.put("ParentName", rsStudentParent.getString("ParentName"));
                                } else {
                                    user.put("ParentName", "N/A");
                                }
                                rsStudentParent.close();
                                pstmtStudentParent.close();
                            } else { // Admin and other types
                                user.put("Email", rsList.getString("Email")); // From Users table
                            }
                            users.add(user);
                        }
                        rsList.close();
                        pstmtList.close();
                        return users;
                    }
                %>

                <div id="AdminList" class="user-list-section" style="display:none;">
                    <h4>Admin Users</h4>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        List<Map<String, Object>> adminUsers = getUsersByType(conn, "Admin");
                                        if (adminUsers.isEmpty()) {
                                            out.println("<tr><td colspan=\"4\">No Admin users found.</td></tr>");
                                        } else {
                                            for (Map<String, Object> user : adminUsers) {
                                %>
                                <tr>
                                    <td><%= user.get("UserID") %></td>
                                    <td><%= user.get("Username") %></td>
                                    <td><%= user.get("Email") %></td>
                                    <td>
                                        <a href="user_management.jsp?action=edit&userId=<%= user.get("UserID") %>" class="button small">Edit</a>
                                        <a href="user_management_process.jsp?action=delete&userId=<%= user.get("UserID") %>" class="button small danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                                <% 
                                            }
                                        }
                                    } catch (SQLException e) {
                                        out.println("<tr><td colspan=\"4\">Error loading Admin users.</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="TeacherList" class="user-list-section" style="display:none;">
                    <h4>Teacher Users</h4>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Teacher Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        List<Map<String, Object>> teacherUsers = getUsersByType(conn, "Teacher");
                                        if (teacherUsers.isEmpty()) {
                                            out.println("<tr><td colspan=\"5\">No Teacher users found.</td></tr>");
                                        } else {
                                            for (Map<String, Object> user : teacherUsers) {
                                %>
                                <tr>
                                    <td><%= user.get("UserID") %></td>
                                    <td><%= user.get("Username") %></td>
                                    <td><%= user.get("Email") %></td>
                                    <td><%= user.get("TeacherName") %></td>
                                    <td>
                                        <a href="user_management.jsp?action=edit&userId=<%= user.get("UserID") %>" class="button small">Edit</a>
                                        <a href="user_management_process.jsp?action=delete&userId=<%= user.get("UserID") %>" class="button small danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                                <% 
                                            }
                                        }
                                    } catch (SQLException e) {
                                        out.println("<tr><td colspan=\"5\">Error loading Teacher users: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="ParentList" class="user-list-section" style="display:none;">
                    <h4>Parent Users</h4>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Name</th>
                                    <th>Phone</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        List<Map<String, Object>> parentUsers = getUsersByType(conn, "Parent");
                                        if (parentUsers.isEmpty()) {
                                            out.println("<tr><td colspan=\"6\">No Parent users found.</td></tr>");
                                        } else {
                                            for (Map<String, Object> user : parentUsers) {
                                %>
                                <tr>
                                    <td><%= user.get("UserID") %></td>
                                    <td><%= user.get("Username") %></td>
                                    <td><%= user.get("Email") %></td>
                                    <td><%= user.get("FirstName") %> <%= user.get("LastName") %></td>
                                    <td><%= user.get("Phone") %></td>
                                    <td>
                                        <a href="user_management.jsp?action=edit&userId=<%= user.get("UserID") %>" class="button small">Edit</a>
                                        <a href="user_management_process.jsp?action=delete&userId=<%= user.get("UserID") %>" class="button small danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                                <% 
                                            }
                                        }
                                    } catch (SQLException e) {
                                        out.println("<tr><td colspan=\"6\">Error loading Parent users: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="StudentList" class="user-list-section" style="display:none;">
                    <h4>Student Users</h4>
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Student Name</th>
                                    <th>Parent Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    try {
                                        List<Map<String, Object>> studentUsers = getUsersByType(conn, "Student");
                                        if (studentUsers.isEmpty()) {
                                            out.println("<tr><td colspan=\"6\">No Student users found.</td></tr>");
                                        } else {
                                            for (Map<String, Object> user : studentUsers) {
                                %>
                                <tr>
                                    <td><%= user.get("UserID") %></td>
                                    <td><%= user.get("Username") %></td>
                                    <td><%= user.get("Email") %></td>
                                    <td><%= user.get("StudentName") %></td>
                                    <td><%= user.get("ParentName") %></td>
                                    <td>
                                        <a href="user_management.jsp?action=edit&userId=<%= user.get("UserID") %>" class="button small">Edit</a>
                                        <a href="user_management_process.jsp?action=delete&userId=<%= user.get("UserID") %>" class="button small danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                                <% 
                                            }
                                        }
                                    } catch (SQLException e) {
                                        out.println("<tr><td colspan=\"6\">Error loading Student users: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
