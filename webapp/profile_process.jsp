<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.logging.*, java.util.ArrayList, java.util.List" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ include file="db_connection.jsp" %>
<%@ include file="includes/auth_check.jspf" %>
<%
    Logger logger = Logger.getLogger(this.getClass().getName());
    int targetUserId = -1;

    String targetUserIdStr = null;
    String studentName = null;
    String email = null;
    String dateOfBirth = null;
    FileItem photoItem = null;

    String status = "error";
    String message = "An unknown error occurred.";

    if (!ServletFileUpload.isMultipartContent(request)) {
        message = "Form must be multipart/form-data.";
    } else {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        try {
            List<FileItem> formItems = upload.parseRequest(request);
            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (item.isFormField()) {
                        switch (item.getFieldName()) {
                            case "userId": targetUserIdStr = item.getString(); break;
                            case "email": email = item.getString(); break;
                            // Other fields will be retrieved using request.getParameter in role-specific blocks
                            default:
                                // This ensures all form fields are processed, even if not explicitly handled here
                                // This is important for multipart forms where all fields are FileItems
                                break;
                        }
                    } else {
                        if (item.getFieldName().equals("profilePhoto") && item.getSize() > 0) {
                            photoItem = item;
                        }
                    }
                }
            }
        } catch (FileUploadException e) {
            message = "Error parsing uploaded file: " + e.getMessage();
            logger.log(Level.SEVERE, "FileUploadException", e);
        }
    }

    if (targetUserIdStr != null) {
        targetUserId = Integer.parseInt(targetUserIdStr);

        boolean canEdit = false;
        if (("Student".equals(userRole) || "Teacher".equals(userRole)) && loggedInUserId == targetUserId) {
            canEdit = true; // Student and Teacher can only edit their own profile
        }
        // Add more roles as needed (e.g., Admin can edit any profile)

        if (canEdit) {
            StringBuilder sqlUpdate = new StringBuilder();
            List<Object> params = new ArrayList<>();
            String photoURL = null;

            // Handle photo upload first, as it's common
            if (photoItem != null && photoItem.getSize() > 0) {
                String fileName = new File(photoItem.getName()).getName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profile_pics";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                File storeFile = new File(uploadPath + File.separator + uniqueFileName);
                try {
                    photoItem.write(storeFile);
                    photoURL = "uploads/profile_pics/" + uniqueFileName;
                } catch (Exception e) {
                    message = "Error saving uploaded photo.";
                    logger.log(Level.SEVERE, "File write error", e);
                }
            }

            if ("Student".equals(userRole)) {
                sqlUpdate.append("UPDATE Students s JOIN Users u ON s.UserID = u.UserID SET s.StudentName = ?, s.DOB = ?, u.Email = ? ");
                params.add(studentName);
                params.add(dateOfBirth.isEmpty() ? null : dateOfBirth);
                params.add(email);
                if (photoURL != null) {
                    sqlUpdate.append(", s.PhotoURL = ?");
                    params.add(photoURL);
                }
                sqlUpdate.append(" WHERE s.UserID = ?");
                params.add(targetUserId);
            } else if ("Teacher".equals(userRole)) {
                // Assuming teacherName and other teacher-specific fields are passed from the form
                // For now, we'll just update TeacherName and Email
                String teacherName = request.getParameter("teacherName"); // Assuming form field name
                
                sqlUpdate.append("UPDATE Teachers t JOIN Users u ON t.UserID = u.UserID SET t.TeacherName = ?, u.Email = ? ");
                params.add(teacherName);
                params.add(email);
                if (photoURL != null) {
                    sqlUpdate.append(", t.PhotoURL = ?");
                    params.add(photoURL);
                }
                sqlUpdate.append(" WHERE t.UserID = ?");
                params.add(targetUserId);
            } else if ("Parent".equals(userRole)) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String phone = request.getParameter("phone");

                sqlUpdate.append("UPDATE Parents p JOIN Users u ON p.UserID = u.UserID SET p.FirstName = ?, p.LastName = ?, p.Phone = ?, u.Email = ? ");
                params.add(firstName);
                params.add(lastName);
                params.add(phone);
                params.add(email);
                if (photoURL != null) {
                    sqlUpdate.append(", p.PhotoURL = ?");
                    params.add(photoURL);
                }
                sqlUpdate.append(" WHERE p.UserID = ?");
                params.add(targetUserId);
            } else if ("Admin".equals(userRole)) {
                String adminName = request.getParameter("adminName");

                sqlUpdate.append("UPDATE Admins a JOIN Users u ON a.UserID = u.UserID SET a.AdminName = ?, u.Email = ? ");
                params.add(adminName);
                params.add(email);
                if (photoURL != null) {
                    sqlUpdate.append(", a.PhotoURL = ?");
                    params.add(photoURL);
                }
                sqlUpdate.append(" WHERE a.UserID = ?");
                params.add(targetUserId);
            }
            // Add more else if blocks for other roles (Admin, Parent) as needed

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    status = "success";
                    message = "Profile updated successfully!";
                    session.setAttribute("message", message);
                } else {
                    message = "No changes were made to the profile.";
                }
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                logger.log(Level.SEVERE, "SQLException on update", e);
            }
        } else {
            message = "You are not authorized to perform this action.";
        }
    } else {
        message = "Invalid request. User ID was not provided.";
    }

    session.setAttribute("message", message);
    if ("Teacher".equals(userRole)) {
        response.sendRedirect("teacher_profile.jsp?userId=" + targetUserId);
    } else {
        response.sendRedirect("profile.jsp?userId=" + targetUserId);
    }
%>