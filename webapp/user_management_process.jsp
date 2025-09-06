<%@ page import="java.sql.*" %>
<%@ page import="at.favre.lib.PasswordUtil" %>

<%@ include file="../db_connection.jsp" %>

<%
    String action = request.getParameter("action");

    try {
        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String parentId = request.getParameter("parentId");
            String studentName = request.getParameter("studentName"); // For student type

            String hashedPassword = PasswordUtil.hashPassword(password);

            // Insert into Users table
            String sqlInsertUser = "INSERT INTO Users (Username, PasswordHash, UserType, ParentID, Email) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmtUser = conn.prepareStatement(sqlInsertUser, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, username);
            pstmtUser.setString(2, hashedPassword);
            pstmtUser.setString(3, userType);
            if (parentId != null && !parentId.isEmpty()) {
                pstmtUser.setInt(4, Integer.parseInt(parentId));
            } else {
                pstmtUser.setNull(4, java.sql.Types.INTEGER);
            }
            pstmtUser.setString(5, email);
            pstmtUser.executeUpdate();

            int newUserId = -1;
            ResultSet rs = pstmtUser.getGeneratedKeys();
            if (rs.next()) {
                newUserId = rs.getInt(1);
            }
            rs.close();
            pstmtUser.close();

            if ("Student".equals(userType) && newUserId != -1) {
                // Insert into Students table
                String sqlInsertStudent = "INSERT INTO Students (StudentID, UserID, StudentName) VALUES (?, ?, ?)";
                PreparedStatement pstmtStudent = conn.prepareStatement(sqlInsertStudent);
                pstmtStudent.setString(1, String.valueOf(newUserId)); // Using UserID as StudentID for simplicity
                pstmtStudent.setInt(2, newUserId);
                pstmtStudent.setString(3, studentName);
                pstmtStudent.executeUpdate();
                pstmtStudent.close();

                // Link student to parent if parentId is provided
                if (parentId != null && !parentId.isEmpty()) {
                    String sqlLink = "INSERT INTO Student_Parent_Link (StudentID, ParentID) VALUES (?, ?)";
                    PreparedStatement pstmtLink = conn.prepareStatement(sqlLink);
                    pstmtLink.setString(1, String.valueOf(newUserId));
                    pstmtLink.setInt(2, Integer.parseInt(parentId));
                    pstmtLink.executeUpdate();
                    pstmtLink.close();
                }
            }

            session.setAttribute("message", "User added successfully.");

        } else if ("update".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String parentId = request.getParameter("parentId");
            String studentName = request.getParameter("studentName"); // For student type

            // Update Users table
            PreparedStatement pstmtUser = null;
            try {
                StringBuilder sqlUpdateUser = new StringBuilder("UPDATE Users SET Username = ?, UserType = ?, ParentID = ?, Email = ?");
                if (password != null && !password.isEmpty()) {
                    sqlUpdateUser.append(", PasswordHash = ?");
                }
                sqlUpdateUser.append(" WHERE UserID = ?");

                pstmtUser = conn.prepareStatement(sqlUpdateUser.toString());
                int paramIndex = 1;
                pstmtUser.setString(paramIndex++, username);
                pstmtUser.setString(paramIndex++, userType);
                if (parentId != null && !parentId.isEmpty()) {
                    pstmtUser.setInt(paramIndex++, Integer.parseInt(parentId));
                } else {
                    pstmtUser.setNull(paramIndex++, java.sql.Types.INTEGER);
                }
                pstmtUser.setString(paramIndex++, email);
                if (password != null && !password.isEmpty()) {
                    pstmtUser.setString(paramIndex++, PasswordUtil.hashPassword(password));
                }
                pstmtUser.setInt(paramIndex++, userId);
                pstmtUser.executeUpdate();
            } finally {
                if (pstmtUser != null) {
                    pstmtUser.close();
                }
            }

            if ("Student".equals(userType)) {
                PreparedStatement pstmtGetStudentId = null;
                PreparedStatement pstmtStudent = null;
                PreparedStatement pstmtCheck = null;
                PreparedStatement pstmtUpdateLink = null;
                PreparedStatement pstmtInsertLink = null;
                PreparedStatement pstmtDeleteLink = null;
                ResultSet rsStudentId = null;
                try {
                    // Get StudentID from UserID
                    String sqlGetStudentId = "SELECT StudentID FROM Students WHERE UserID = ?";
                    pstmtGetStudentId = conn.prepareStatement(sqlGetStudentId);
                    pstmtGetStudentId.setInt(1, userId);
                    rsStudentId = pstmtGetStudentId.executeQuery();
                    String studentId = null;
                    if (rsStudentId.next()) {
                        studentId = rsStudentId.getString("StudentID");
                    }
                    session.setAttribute("message", "Retrieved student ID: " + studentId);

                    if (studentId != null) {
                        session.setAttribute("message", "Found student ID: " + studentId);
                        // Update Students table
                        String sqlUpdateStudent = "UPDATE Students SET StudentName = ? WHERE StudentID = ?";
                        pstmtStudent = conn.prepareStatement(sqlUpdateStudent);
                        pstmtStudent.setString(1, studentName);
                        pstmtStudent.setString(2, studentId);
                        int studentUpdateResult = pstmtStudent.executeUpdate();
                        session.setAttribute("message", "Student table update result: " + studentUpdateResult);

                        // Update Student_Parent_Link table
                        if (parentId != null && !parentId.isEmpty()) {
                            // Check if link exists
                            String sqlCheckLink = "SELECT COUNT(*) FROM Student_Parent_Link WHERE StudentID = ?";
                            pstmtCheck = conn.prepareStatement(sqlCheckLink);
                            pstmtCheck.setString(1, studentId);
                            ResultSet rsCheck = pstmtCheck.executeQuery();
                            boolean linkExists = false;
                            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                                linkExists = true;
                            }
                            rsCheck.close();
                            session.setAttribute("message", "Parent link exists: " + linkExists);

                            if (linkExists) {
                                String sqlUpdateLink = "UPDATE Student_Parent_Link SET ParentID = ? WHERE StudentID = ?";
                                pstmtUpdateLink = conn.prepareStatement(sqlUpdateLink);
                                pstmtUpdateLink.setInt(1, Integer.parseInt(parentId));
                                pstmtUpdateLink.setString(2, studentId);
                                int linkUpdateResult = pstmtUpdateLink.executeUpdate();
                                session.setAttribute("message", "Parent link update result: " + linkUpdateResult);
                            } else {
                                String sqlInsertLink = "INSERT INTO Student_Parent_Link (StudentID, ParentID) VALUES (?, ?)";
                                pstmtInsertLink = conn.prepareStatement(sqlInsertLink);
                                pstmtInsertLink.setString(1, studentId);
                                pstmtInsertLink.setInt(2, Integer.parseInt(parentId));
                                int linkInsertResult = pstmtInsertLink.executeUpdate();
                                session.setAttribute("message", "Parent link insert result: " + linkInsertResult);
                            }
                        } else {
                            // If parentId is removed, delete the link
                            String sqlDeleteLink = "DELETE FROM Student_Parent_Link WHERE StudentID = ?";
                            pstmtDeleteLink = conn.prepareStatement(sqlDeleteLink);
                            pstmtDeleteLink.setString(1, studentId);
                            int linkDeleteResult = pstmtDeleteLink.executeUpdate();
                            session.setAttribute("message", "Parent link delete result: " + linkDeleteResult);
                        }
                    } else {
                        session.setAttribute("message", "Could not find student ID for user ID: " + userId);
                    }
                } finally {
                    if (rsStudentId != null) {
                        rsStudentId.close();
                    }
                    if (pstmtGetStudentId != null) {
                        pstmtGetStudentId.close();
                    }
                    if (pstmtStudent != null) {
                        pstmtStudent.close();
                    }
                    if (pstmtCheck != null) {
                        pstmtCheck.close();
                    }
                    if (pstmtUpdateLink != null) {
                        pstmtUpdateLink.close();
                    }
                    if (pstmtInsertLink != null) {
                        pstmtInsertLink.close();
                    }
                    if (pstmtDeleteLink != null) {
                        pstmtDeleteLink.close();
                    }
                }
                session.setAttribute("message", "User updated successfully.");
            }

        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));

            // Determine user type to handle associated records
            String userType = null;
            String sqlGetUserType = "SELECT UserType FROM Users WHERE UserID = ?";
            PreparedStatement pstmtGetUserType = conn.prepareStatement(sqlGetUserType);
            pstmtGetUserType.setInt(1, userId);
            ResultSet rsGetUserType = pstmtGetUserType.executeQuery();
            if (rsGetUserType.next()) {
                userType = rsGetUserType.getString("UserType");
            }
            rsGetUserType.close();
            pstmtGetUserType.close();

            if ("Student".equals(userType)) {
                // Delete from Student_Parent_Link first
                String sqlDeleteLink = "DELETE FROM Student_Parent_Link WHERE StudentID = ?";
                PreparedStatement pstmtDeleteLink = conn.prepareStatement(sqlDeleteLink);
                pstmtDeleteLink.setString(1, String.valueOf(userId));
                pstmtDeleteLink.executeUpdate();
                pstmtDeleteLink.close();

                // Delete from Students table
                String sqlDeleteStudent = "DELETE FROM Students WHERE UserID = ?";
                PreparedStatement pstmtDeleteStudent = conn.prepareStatement(sqlDeleteStudent);
                pstmtDeleteStudent.setInt(1, userId);
                pstmtDeleteStudent.executeUpdate();
                pstmtDeleteStudent.close();
            }

            // Finally, delete from Users table
            String sqlDeleteUser = "DELETE FROM Users WHERE UserID = ?";
            PreparedStatement pstmtDeleteUser = conn.prepareStatement(sqlDeleteUser);
            pstmtDeleteUser.setInt(1, userId);
            pstmtDeleteUser.executeUpdate();
            pstmtDeleteUser.close();

            session.setAttribute("message", "User deleted successfully.");
        }
    } catch (Exception e) {
        session.setAttribute("message", "An error occurred: " + e.getMessage());
    }

    response.sendRedirect("user_management.jsp");
%>