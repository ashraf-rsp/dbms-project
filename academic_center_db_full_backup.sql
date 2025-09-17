/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Android (aarch64)
--
-- Host: localhost    Database: academic_center_db
-- ------------------------------------------------------
-- Server version	12.0.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Alert_Log`
--

DROP TABLE IF EXISTS `Alert_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Alert_Log` (
  `AlertID` int(11) NOT NULL AUTO_INCREMENT,
  `ParentID` int(11) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Content` text DEFAULT NULL,
  PRIMARY KEY (`AlertID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Alert_Log_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alert_Log`
--

set autocommit=0;
INSERT INTO `Alert_Log` VALUES
(1,1,'Direct Insert Test','2025-08-14 12:31:08','Direct Insert Test',''),
(2,1,'Your parent-teacher meeting is scheduled for next week.','2025-08-21 08:22:22','Your parent-teacher meeting is scheduled for next week.',''),
(3,NULL,'Test Announcement\nThis is a test announcement from curl.','2025-08-26 16:13:41','Test Announcement','This is a test announcement from curl.'),
(4,NULL,'Test Announcement\nThis is a test announcement.','2025-08-31 04:14:22','Test Announcement','This is a test announcement.');
commit;

--
-- Table structure for table `Attendance`
--

DROP TABLE IF EXISTS `Attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Attendance` (
  `AttendanceID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `SessionDate` date DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`AttendanceID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Attendance_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `Enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attendance`
--

set autocommit=0;
INSERT INTO `Attendance` VALUES
(13,1,'2025-08-30','Present'),
(14,1,'2025-09-01','Absent'),
(15,1,'2025-09-03','Late');
commit;

--
-- Table structure for table `Course_Sessions`
--

DROP TABLE IF EXISTS `Course_Sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Course_Sessions` (
  `CourseSessionID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `SessionID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CourseSessionID`),
  KEY `CourseID` (`CourseID`),
  KEY `SessionID` (`SessionID`),
  CONSTRAINT `Course_Sessions_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`),
  CONSTRAINT `Course_Sessions_ibfk_2` FOREIGN KEY (`SessionID`) REFERENCES `Sessions` (`SessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Course_Sessions`
--

set autocommit=0;
commit;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Courses` (
  `CourseID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) DEFAULT NULL,
  `CourseDescription` text DEFAULT NULL,
  `CourseFee` decimal(10,2) DEFAULT NULL,
  `CourseCode` varchar(50) DEFAULT NULL,
  `CreditHours` int(11) DEFAULT NULL,
  `SemesterID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

set autocommit=0;
INSERT INTO `Courses` VALUES
(1,'Chemistry',NULL,50.00,'CHE 1111-0531',3,1),
(2,'Chemistry Lab',NULL,50.00,'CHE 1112-0531',1,1),
(3,'Structured Programming Language',NULL,50.00,'CSE 1213-0613',3,NULL),
(4,'Structured Programming Language Lab',NULL,50.00,'CSE 1214-0613',1,NULL),
(5,'Organizational Behaviors',NULL,50.00,'HUM 1111-0031',3,1),
(6,'Bangladesh Studies',NULL,50.00,'HUM 1113-0222',3,1),
(7,'Mathematics-I',NULL,50.00,'MATH 1111-0541',3,1),
(8,'Physics',NULL,50.00,'PHY 1111-0533',3,1),
(9,'Physics Lab',NULL,50.00,'PHY 1112-0533',1,1),
(10,'Discrete Mathematics',NULL,50.00,'CSE 1203-0611',3,2),
(11,'Object Oriented Programming Language',NULL,50.00,'CSE 2141-0613',3,2),
(12,'Object Oriented Programming Language Lab',NULL,50.00,'CSE 2142-0613',1,2),
(13,'Electrical Circuit Analysis',NULL,50.00,'EEE 1211-0714',3,2),
(14,'Electrical Circuit Analysis Lab',NULL,50.00,'EEE 1212-0714',1,2),
(15,'Communicative English',NULL,50.00,'ENG 1213-0231',3,2),
(16,'Mathematics-II',NULL,50.00,'MATH 1213-0541',3,2),
(17,'Fundamentals of Computer and Office Applications',NULL,50.00,'CSE 1111-0611',3,3),
(18,'Fundamentals of Computer Lab',NULL,50.00,'CSE 1112-0611',1,3),
(19,'Competitive Programming-I',NULL,50.00,'CSE 2105-0613',1,3),
(20,'Engineering Drawing',NULL,50.00,'CSE 2144-0611',1,3),
(21,'Numerical Analysis with MATLAB',NULL,50.00,'CSE 2234-0613',3,3),
(22,'Arts of Presentation',NULL,50.00,'HUM 2125-0031',3,3),
(23,'Mathematics-III',NULL,50.00,'MATH 2115-0541',3,3),
(24,'Business Communication',NULL,50.00,'BBA 2211-0414',3,4),
(25,'Competitive Programming-II',NULL,50.00,'CSE 2205-0613',1,4),
(26,'Data Structures and Algorithms',NULL,50.00,'CSE 2215-0613',3,4),
(27,'Data Structures and Algorithms Lab',NULL,50.00,'CSE 2216-0613',1,4),
(28,'System Analysis and Design',NULL,50.00,'CSE 2221-0613',3,4),
(29,'System Analysis and Design Lab',NULL,50.00,'CSE 2222-0613',1,4),
(30,'Data Communicaiton and Networking',NULL,50.00,'CSE 3131-0612',3,4),
(31,'Data Communicaiton and Networking Lab',NULL,50.00,'CSE 3132-0612',1,4),
(32,'Math-IV (Probability and Statistics)',NULL,50.00,'MATH 2217-0542',3,4),
(33,'Integrated Design Project I',NULL,50.00,'CSE 3108-0613',1,5),
(34,'Theory of Computing',NULL,50.00,'CSE 3143-0611',3,5),
(35,'Digital Logic Design',NULL,50.00,'CSE 3151-0414',3,5),
(36,'Digital Logic Design Lab',NULL,50.00,'CSE 3152-0414',1,5),
(37,'Microprocessor and Assembly Language',NULL,50.00,'CSE 3253-0714',3,5),
(38,'Microprocessor and Assembly Language Lab',NULL,50.00,'CSE 3254-0714',1,5),
(39,'Electronics Devices and Circuits',NULL,50.00,'EEE 2113-0714',3,5),
(40,'Electronics Devices and Circuits Lab',NULL,50.00,'EEE 2114-0714',1,5),
(41,'Integrated Design Project II',NULL,50.00,'CSE 3208-0613',1,6),
(42,'Compiler Construction',NULL,50.00,'CSE 3219-0613',3,6),
(43,'Compiler Construction Lab',NULL,50.00,'CSE 3220-0613',1,6),
(44,'Database Management System',NULL,50.00,'CSE 3223-0612',3,6),
(45,'Database Management System Lab',NULL,50.00,'CSE 3224-0612',1,6),
(46,'Web Programming',NULL,50.00,'CSE 3246-0613',3,6),
(47,'Network and Server Administration',NULL,50.00,'CSE 4277-0612',3,6),
(48,'Network and Server Administration Lab',NULL,50.00,'CSE 4278-0612',1,6),
(49,'Principles of Management',NULL,50.00,'HUM 3103-0413',3,6);
commit;

--
-- Table structure for table `Enrollments`
--

DROP TABLE IF EXISTS `Enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Enrollments` (
  `EnrollmentID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(255) DEFAULT NULL,
  `CourseID` int(11) DEFAULT NULL,
  `EnrollmentDate` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Enrolled',
  `SessionID` int(11) DEFAULT NULL,
  PRIMARY KEY (`EnrollmentID`),
  KEY `StudentID` (`StudentID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Enrollments_ibfk_2` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Enrollments`
--

set autocommit=0;
INSERT INTO `Enrollments` VALUES
(1,'test-student-01',3,'2025-08-31','Enrolled',NULL),
(2,'25S010003',1,'2025-09-01','Enrolled',NULL),
(3,'33',1,'2025-09-05','Enrolled',NULL),
(4,'33',2,'2025-09-05','Enrolled',NULL),
(5,'33',8,'2025-09-06','Enrolled',NULL);
commit;

--
-- Table structure for table `Events`
--

DROP TABLE IF EXISTS `Events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Events` (
  `EventID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `EventName` varchar(100) DEFAULT NULL,
  `EventType` varchar(50) DEFAULT NULL,
  `EventDate` date DEFAULT NULL,
  PRIMARY KEY (`EventID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Events_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Events`
--

set autocommit=0;
INSERT INTO `Events` VALUES
(1,1,'Midterm Exam','Test','2025-09-01'),
(2,1,'Project Deadline','Deadline','2025-09-15'),
(3,NULL,'Summer Break','Holiday','2025-08-20'),
(4,NULL,'iupc','Contest',NULL),
(5,1,'Midterm Exam','Exam','2025-10-15'),
(6,2,'Book Report Due','Assignment','2025-09-30');
commit;

--
-- Table structure for table `Grades`
--

DROP TABLE IF EXISTS `Grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Grades` (
  `GradeID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `GradePercentage` decimal(5,2) DEFAULT NULL,
  `GradeLetter` varchar(5) DEFAULT NULL,
  `GradedByUserID` int(11) DEFAULT NULL,
  `GradeDate` date DEFAULT NULL,
  PRIMARY KEY (`GradeID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  KEY `GradedByUserID` (`GradedByUserID`),
  CONSTRAINT `Grades_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `Enrollments` (`EnrollmentID`),
  CONSTRAINT `Grades_ibfk_2` FOREIGN KEY (`GradedByUserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Grades`
--

set autocommit=0;
INSERT INTO `Grades` VALUES
(4,1,6.00,'',9,'2025-09-03');
commit;

--
-- Table structure for table `Messages`
--

DROP TABLE IF EXISTS `Messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Messages` (
  `MessageID` int(11) NOT NULL AUTO_INCREMENT,
  `SenderUserID` int(11) DEFAULT NULL,
  `ReceiverUserID` int(11) DEFAULT NULL,
  `Subject` varchar(255) DEFAULT NULL,
  `Content` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `IsRead` tinyint(1) DEFAULT 0,
  `DeletedBySender` tinyint(1) NOT NULL DEFAULT 0,
  `DeletedByReceiver` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`MessageID`),
  KEY `SenderUserID` (`SenderUserID`),
  KEY `ReceiverUserID` (`ReceiverUserID`),
  CONSTRAINT `Messages_ibfk_1` FOREIGN KEY (`SenderUserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`ReceiverUserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Messages`
--

set autocommit=0;
INSERT INTO `Messages` VALUES
(1,4,1,'Welcome to Mathematics 101','Dear John, Welcome to the class!','2025-08-21 08:22:22',1,0,0),
(2,1,4,'Re: Welcome to Mathematics 101','Thank you, teacher!','2025-08-21 08:22:22',0,0,0),
(3,9,10,'Test Message','Hello from t_teacher!','2025-08-26 16:17:22',1,0,0),
(5,9,10,'Test Subject','Hello from teacher!','2025-08-31 04:12:58',1,0,0),
(6,15,9,'Test Message from Admin','Hello Teacher, this is a test message from the Admin.','2025-09-04 08:41:44',1,0,0),
(7,15,9,'Test Message from Admin','Hello Teacher, this is a test message from the Admin.','2025-09-04 08:55:15',0,0,0),
(8,15,14,'Test Message to Student','Hello Student, this is a test message from the Admin.','2025-09-04 08:55:50',1,0,1),
(9,15,9,'Test Message from Admin','Hello t_teacher, this is a test message from the Admin.','2025-09-04 10:16:16',0,1,1),
(10,9,9,'Test Message from Student','Hello t_teacher, this is a test message from the Student.','2025-09-04 10:18:08',0,1,1),
(11,15,9,'Test Message from Admin (Error Debug)','Hello t_teacher, this is a test message from the Admin to debug the error.','2025-09-04 10:58:24',0,0,0),
(12,15,9,'Frontend Test Message','This message is to test frontend form submission.','2025-09-04 11:03:11',0,0,0),
(13,15,9,'Test Message from Gemini','This is a test message to verify end-to-end message sending.','2025-09-05 19:03:26',0,0,0),
(14,15,9,'Test Message from Gemini (Fixed)','This is a test message to verify the fix.','2025-09-05 19:13:51',1,0,1),
(15,9,15,'abc','aerrtt','2025-09-05 19:29:48',1,0,0),
(16,15,10,'Hey ! parents','I got a message for you. JK.. nothing','2025-09-05 19:30:57',1,0,0),
(17,10,9,'Re: Hey ! parents','ok.. got you','2025-09-05 19:31:55',1,0,0),
(18,15,10,'A Notice to your kid','This is to notify you that, your kid is not attending school today.','2025-09-05 21:15:26',1,0,0),
(19,10,9,'A Notice to your kid','He is not doing great','2025-09-12 08:14:42',1,0,0);
commit;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notifications` (
  `NotificationID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `UserRole` varchar(50) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `IsRead` tinyint(1) DEFAULT 0,
  `Link` varchar(255) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`NotificationID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `Notifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notifications`
--

set autocommit=0;
INSERT INTO `Notifications` VALUES
(1,1,NULL,'Welcome to the Academic Center Management System!','2025-09-06 10:24:42',0,'/dashboard.jsp','System'),
(2,1,NULL,'Your grades for Mathematics have been updated.','2025-09-06 10:24:42',0,'/view_grades.jsp','GradeUpdate'),
(3,NULL,'All','New academic year registration is now open!','2025-09-06 10:24:42',0,'/register.jsp','Announcement'),
(4,1,NULL,'You have a new message from your teacher.','2025-09-06 10:24:42',0,'/messages.jsp','Message'),
(5,15,NULL,'This is a test notification for AshrafM.','2025-09-06 12:25:19',0,NULL,NULL),
(6,14,NULL,'This is a test notification from Gemini.','2025-09-11 16:33:45',0,NULL,NULL);
commit;

--
-- Table structure for table `Parents`
--

DROP TABLE IF EXISTS `Parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Parents` (
  `ParentID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ParentID`),
  UNIQUE KEY `UserID` (`UserID`),
  CONSTRAINT `fk_Parents_UserID` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Parents`
--

set autocommit=0;
INSERT INTO `Parents` VALUES
(1,'Test','Parent','123-456-7890',NULL),
(2,'John','Doe','123-456-7890',NULL),
(3,'Jane','Smith','098-765-4321',NULL),
(4,'Peter','Jones','111-222-3333',NULL),
(5,'Abc','Parents ','012454547',10),
(6,'Jane','Smith','987-654-3210',NULL),
(7,'Test','Parent','9998887777',1);
commit;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payments` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `Enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payments`
--

set autocommit=0;
INSERT INTO `Payments` VALUES
(6,1,150.00,'2025-08-31');
commit;

--
-- Table structure for table `Schedules`
--

DROP TABLE IF EXISTS `Schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Schedules` (
  `ScheduleID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `DayOfWeek` varchar(10) DEFAULT NULL,
  `StartTime` time DEFAULT NULL,
  `EndTime` time DEFAULT NULL,
  `Room` varchar(50) DEFAULT NULL,
  `TeacherUserID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ScheduleID`),
  KEY `CourseID` (`CourseID`),
  KEY `TeacherUserID` (`TeacherUserID`),
  CONSTRAINT `Schedules_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`),
  CONSTRAINT `Schedules_ibfk_2` FOREIGN KEY (`TeacherUserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Schedules`
--

set autocommit=0;
INSERT INTO `Schedules` VALUES
(1,1,'Monday','09:00:00','10:30:00','Room 101',4),
(2,1,'Wednesday','09:00:00','10:30:00','Room 101',4),
(3,2,'Tuesday','11:00:00','12:30:00','Room 102',4),
(4,2,'Thursday','11:00:00','12:30:00','Room 102',4),
(5,1,'TBD','00:00:00','00:00:00','TBD',5),
(6,3,'Mon/Wed','14:00:00','15:00:00','Room 103',9),
(7,1,'TBD','00:00:00','00:00:00','TBD',9),
(8,8,'TBD','00:00:00','00:00:00','TBD',9),
(9,6,'TBD','00:00:00','00:00:00','TBD',13);
commit;

--
-- Table structure for table `Semesters`
--

DROP TABLE IF EXISTS `Semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Semesters` (
  `SemesterID` int(11) NOT NULL AUTO_INCREMENT,
  `SemesterName` varchar(50) NOT NULL,
  `SemesterLevel` int(11) NOT NULL,
  PRIMARY KEY (`SemesterID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Semesters`
--

set autocommit=0;
INSERT INTO `Semesters` VALUES
(1,'1st Semester - Freshman',1),
(2,'2nd Semester - Freshman',2),
(3,'3rd Semester - Sophomore',3),
(4,'4th Semester - Sophomore',4),
(5,'5th Semester - Junior',5),
(6,'6th Semester - Junior',6),
(7,'7th Semester - Senior',7),
(8,'8th Semester - Senior',8);
commit;

--
-- Table structure for table `Sessions`
--

DROP TABLE IF EXISTS `Sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sessions` (
  `SessionID` int(11) NOT NULL AUTO_INCREMENT,
  `SessionName` varchar(50) NOT NULL,
  `Year` int(11) NOT NULL,
  `Term` varchar(20) NOT NULL,
  PRIMARY KEY (`SessionID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sessions`
--

set autocommit=0;
INSERT INTO `Sessions` VALUES
(1,'Fall 2023',2023,'Fall'),
(2,'Summer 2024',2024,'Summer'),
(3,'Fall 2024',2024,'Fall');
commit;

--
-- Table structure for table `Student_Parent_Link`
--

DROP TABLE IF EXISTS `Student_Parent_Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Student_Parent_Link` (
  `LinkID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(255) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`LinkID`),
  KEY `StudentID` (`StudentID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Student_Parent_Link_ibfk_2` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`),
  CONSTRAINT `fk_Student_Parent_Link_StudentID` FOREIGN KEY (`StudentID`) REFERENCES `Students` (`StudentID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Student_Parent_Link`
--

set autocommit=0;
INSERT INTO `Student_Parent_Link` VALUES
(6,'25S010001',1),
(7,'25S010003',5),
(8,'test-student-01',5),
(9,'33',2);
commit;

--
-- Table structure for table `Students`
--

DROP TABLE IF EXISTS `Students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Students` (
  `StudentID` varchar(255) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `StudentName` varchar(255) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `RegistrationCode` varchar(255) DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Pending',
  `ParentNameProvided` varchar(255) DEFAULT NULL,
  `ParentEmailProvided` varchar(255) DEFAULT NULL,
  `ParentPhoneProvided` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`StudentID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Students`
--

set autocommit=0;
INSERT INTO `Students` VALUES
('25S010001',18,'Test Student','1234567890','2005-01-01','REG-TEST-12345','Active','Test Parent','parent@example.com','0987654321'),
('25S010002',26,'Test Student','1234567890','2005-01-01','manual_reg_code','Active','Test Parent','parent@example.com','0987654321'),
('25S010003',14,'New Student Name Again','1234567890','2010-01-01','REG-ABC-12345','Active','Test Parent','parent@example.com','0987654321'),
('33',33,'Student 1',NULL,NULL,NULL,'Pending',NULL,NULL,NULL),
('TEST_ID_2',999,'Test Student Name',NULL,NULL,NULL,'Pending',NULL,NULL,NULL),
('test-student-01',NULL,'Test Student',NULL,'2010-01-01',NULL,'Pending',NULL,NULL,NULL);
commit;

--
-- Table structure for table `Teachers`
--

DROP TABLE IF EXISTS `Teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Teachers` (
  `TeacherID` varchar(255) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `TeacherName` varchar(255) NOT NULL,
  `SubjectTaught` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `RegistrationCode` varchar(255) DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Pending',
  PRIMARY KEY (`TeacherID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Teachers`
--

set autocommit=0;
INSERT INTO `Teachers` VALUES
('T001',9,'Test Teacher','Math','t_teacher@example.com','1112223333','1980-01-01','REG-T001','Active');
commit;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) DEFAULT NULL,
  `PasswordHash` varchar(255) DEFAULT NULL,
  `UserType` varchar(20) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  `RegistrationCode` varchar(255) DEFAULT NULL,
  `AdminName` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`),
  UNIQUE KEY `Email` (`Email`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

set autocommit=0;
INSERT INTO `Users` VALUES
(1,'parent1','$2a$12$1OMkGfc3296g/I7z8vyKUeb4fS68xooOayTrDDenEPeG12x2IytQK','Parent',1,NULL,NULL,NULL,1),
(3,'jane.smith','$2a$12$QGVcl2Z6TQdfZb.40KWc9OHjZ7zcz3YlZOK27YLG1bSw5RnuSAHSy','Parent',2,NULL,NULL,NULL,1),
(4,'peter.jones','$2a$12$h5bQZca5SX7M4SkdNJnF4ejuWrcwoC4Wb8Xedkt0o5VyD2lEr8KH.','Parent',3,NULL,NULL,NULL,1),
(5,'teacher.susan','$2a$12$SX6jH/X3cKlHkneQkQ7KXe/O3nDzB2dkh8Bp/ajTTCIrZ7UNw7yJm','Teacher',NULL,NULL,NULL,NULL,1),
(7,'test_parent_user_123','$2a$12$/NpehSB/2Ry/Oqh3944.6udrvgFPxcP/Cy7zJDICroOaFHvCGuGlG','Parent',NULL,NULL,NULL,NULL,1),
(8,'admin','$2a$12$Euqe6jdns0XsDbaPHYwfS.6SRaid20UHaUhi5QkgU4Yb5euOsqIMS','admin',NULL,NULL,NULL,NULL,1),
(9,'t_teacher','$2a$12$VYTZaDSjbzLXUTMH65zi0uLKCN.ggd95XweSi89e3vABv.YmxxBkG','Teacher',NULL,NULL,NULL,NULL,1),
(10,'t_parent','$2a$12$l6QDGMUubadA4BVdtCEIb.TI238AknWVApt9.Jug86oPfZC14u4by','Parent',5,NULL,NULL,NULL,1),
(13,'new_teacher','$2a$12$9FDFOkRJbMXbdVgDnpswouaJsnpMeXeJ//PwDzpkT3qrvO4BPQ4hy','Teacher',NULL,NULL,NULL,NULL,1),
(14,'Std1','$2a$12$mwHPc.DA7MjpIznDtREGk.kLg/BpkP0jfTjZd7g3.pBzJvbWAuUiK','Student',5,NULL,NULL,'std1@test.com',1),
(15,'AshrafM','$2a$12$r/Kbjlc2.e0SbPOkw2dflev5CjesCjd377jm4.WSwywcGcd9hntiC','Admin',NULL,NULL,'Shuvo','ashraf@test.com',1),
(16,'MGR','$2a$12$MQi6CRqRPNc7KvJlJ9buy.TBlNNxXKhjL10wJxXkiWYpKwNXZ7X46','Student',NULL,'e07f5ed7-0224-4735-90a8-384348cc0a99',NULL,NULL,1),
(32,'teacher ','$2a$12$pZOL8IeYl3oB88w3ospPneUklbzrc6kJ8gTRdBVxzDxVph.0DTKLS','Teacher',NULL,NULL,NULL,NULL,1),
(33,'testStd','$2a$12$IdHlYZSK7pJNVLmX8DWHaeQU3ZA5Ew.ZDtF/.XpwMvFm53r9jVNau','Student',2,NULL,NULL,NULL,1);
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-09-17 23:41:57
