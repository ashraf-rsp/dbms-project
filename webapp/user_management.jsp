<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ include file="includes/auth_check.jspf" %>
<%@ page import="java.sql.*" %>

<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    // Check if the logged-in user is an Admin
    
    if (userRole == null || !userRole.equals("Admin")) {
        response.sendRedirect("access_denied.jsp");
        return;
    }

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
    String userType = "";
    String parentId = "";
    String formTitle = "Add New User";
    String submitButtonText = "Add User";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if ("edit".equals(action) && userId != -1) {
        formTitle = "Edit User";
        submitButtonText = "Update User";

        

        try {
            
            String sql = "SELECT Username, UserType, ParentID FROM Users WHERE UserID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                username = rs.getString("Username");
                userType = rs.getString("UserType");
                parentId = rs.getString("ParentID");
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
<html lang="en">
<head>
    <title><%= formTitle %> - Academic Center</title>
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
                    <form action="user_management_process.jsp" method="post">
                        <input type="hidden" name="action" value="<%= action != null ? action : "add" %>">
                        <input type="hidden" name="userId" value="<%= userId != -1 ? userId : "" %>">

                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" value="<%= username %>" required>

                        <label for="password">Password: <% if ("edit".equals(action)) { %>(Leave blank to keep current password)<% } %></label>
                        <input type="password" id="password" name="password" <% if ("add".equals(action) || action == null) { %>required<% } %>>

                        <label for="userType">User Type:</label>
                        <select id="userType" name="userType" required>
                            <option value="">-- Select --</option>
                            <option value="Admin" <%= "Admin".equals(userType) ? "selected" : "" %>>Admin</option>
                            <option value="Teacher" <%= "Teacher".equals(userType) ? "selected" : "" %>>Teacher</option>
                            <option value="Parent" <%= "Parent".equals(userType) ? "selected" : "" %>>Parent</option>
                        </select>

                        <label for="parentId">Parent ID (if User Type is Parent):</label>
                        <input type="text" id="parentId" name="parentId" value="<%= parentId %>">

                        <button type="submit" class="button"><%= submitButtonText %></button>
                    </form>
                </div>

                <h3>Existing Users</h3>
                <div class="data-table-container">
                    <div class="responsive-table">
                        <table class="dashboard-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>User Type</th>
                                    <th>Parent ID</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    PreparedStatement pstmtList = null;
                                    ResultSet rsList = null;
                                    try {
                                        String sqlList = "SELECT UserID, Username, UserType, ParentID FROM Users ORDER BY UserID";
                                        pstmtList = conn.prepareStatement(sqlList);
                                        rsList = pstmtList.executeQuery();
                                        while (rsList.next()) {
                                %>
                                <tr>
                                    <td><%= rsList.getInt("UserID") %></td>
                                    <td><%= rsList.getString("Username") %></td>
                                    <td><%= rsList.getString("UserType") %></td>
                                    <td><%= rsList.getString("ParentID") != null ? rsList.getString("ParentID") : "N/A" %></td>
                                    <td>
                                        <a href="user_management.jsp?action=edit&userId=<%= rsList.getInt("UserID") %>" class="button small">Edit</a>
                                        <a href="user_management_process.jsp?action=delete&userId=<%= rsList.getInt("UserID") %>" class="button small danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                                <% 
                                        }
                                    } catch (SQLException e) {
                                        // Log error
                                    } finally {
                                        if (rsList != null) try { rsList.close(); } catch (SQLException e) { /* ignore */ }
                                        if (pstmtList != null) try { pstmtList.close(); } catch (SQLException e) { /* ignore */ }
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
