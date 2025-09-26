INSERT INTO `Notifications` (`UserID`, `UserRole`, `Message`, `Timestamp`, `IsRead`, `Link`, `Type`) VALUES
(1, NULL, 'Welcome to the Academic Center Management System!', NOW(), 0, '/dashboard.jsp', 'System'),
(1, NULL, 'Your grades for Mathematics have been updated.', NOW(), 0, '/view_grades.jsp', 'GradeUpdate'),
(NULL, 'All', 'New academic year registration is now open!', NOW(), 0, '/register.jsp', 'Announcement'),
(1, NULL, 'You have a new message from your teacher.', NOW(), 0, '/messages.jsp', 'Message');