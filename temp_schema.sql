-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: dbms_project
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alert_log`
--

DROP TABLE IF EXISTS `alert_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alert_log` (
  `AlertID` int(11) NOT NULL AUTO_INCREMENT,
  `ParentID` int(11) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Content` text DEFAULT NULL,
  PRIMARY KEY (`AlertID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Alert_Log_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `SessionDate` date DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`AttendanceID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Attendance_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course_sessions`
--

DROP TABLE IF EXISTS `course_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_sessions` (
  `CourseSessionID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `SessionID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CourseSessionID`),
  KEY `CourseID` (`CourseID`),
  KEY `SessionID` (`SessionID`),
  CONSTRAINT `Course_Sessions_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`CourseID`),
  CONSTRAINT `Course_Sessions_ibfk_2` FOREIGN KEY (`SessionID`) REFERENCES `sessions` (`SessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `CourseID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) DEFAULT NULL,
  `CourseDescription` text DEFAULT NULL,
  `CourseFee` decimal(10,2) DEFAULT NULL,
  `CourseCode` varchar(50) DEFAULT NULL,
  `CreditHours` int(11) DEFAULT NULL,
  `SemesterID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `EnrollmentID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(255) DEFAULT NULL,
  `CourseID` int(11) DEFAULT NULL,
  `EnrollmentDate` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Enrolled',
  `SessionID` int(11) DEFAULT NULL,
  PRIMARY KEY (`EnrollmentID`),
  KEY `StudentID` (`StudentID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Enrollments_ibfk_2` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `EventID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `EventName` varchar(100) DEFAULT NULL,
  `EventType` varchar(50) DEFAULT NULL,
  `EventDate` date DEFAULT NULL,
  PRIMARY KEY (`EventID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Events_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grades` (
  `GradeID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `GradePercentage` decimal(5,2) DEFAULT NULL,
  `GradeLetter` varchar(5) DEFAULT NULL,
  `GradedByUserID` int(11) DEFAULT NULL,
  `GradeDate` date DEFAULT NULL,
  PRIMARY KEY (`GradeID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  KEY `GradedByUserID` (`GradedByUserID`),
  CONSTRAINT `Grades_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `enrollments` (`EnrollmentID`),
  CONSTRAINT `Grades_ibfk_2` FOREIGN KEY (`GradedByUserID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
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
  CONSTRAINT `Messages_ibfk_1` FOREIGN KEY (`SenderUserID`) REFERENCES `users` (`UserID`),
  CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`ReceiverUserID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER After_Message_Insert
AFTER INSERT ON Messages
FOR EACH ROW
BEGIN
    
    
    
    INSERT INTO User_Message_Status (UserID, UnreadCount)
    VALUES (NEW.ReceiverUserID, 1)
    ON DUPLICATE KEY UPDATE UnreadCount = UnreadCount + 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_message_insert
AFTER INSERT ON Messages
FOR EACH ROW
BEGIN
    INSERT INTO user_message_counts (user_id, unread_count, total_count)
    VALUES (NEW.ReceiverUserID, 1, 1)
    ON DUPLICATE KEY UPDATE
        unread_count = unread_count + 1,
        total_count = total_count + 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_message_update
AFTER UPDATE ON Messages
FOR EACH ROW
BEGIN
    IF OLD.IsRead != NEW.IsRead THEN
        IF NEW.IsRead = 1 THEN
            UPDATE user_message_counts
            SET unread_count = unread_count - 1
            WHERE user_id = NEW.ReceiverUserID;
        ELSE
            UPDATE user_message_counts
            SET unread_count = unread_count + 1
            WHERE user_id = NEW.ReceiverUserID;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_message_delete
AFTER DELETE ON Messages
FOR EACH ROW
BEGIN
    UPDATE user_message_counts
    SET
        total_count = total_count - 1,
        unread_count = unread_count - (CASE WHEN OLD.IsRead = 0 THEN 1 ELSE 0 END)
    WHERE user_id = OLD.ReceiverUserID;

    DELETE FROM user_message_counts
    WHERE user_id = OLD.ReceiverUserID AND total_count <= 0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `NotificationID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  `UserRole` varchar(50) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `IsRead` tinyint(1) DEFAULT 0,
  `Link` varchar(255) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `AlertID` int(11) DEFAULT NULL,
  PRIMARY KEY (`NotificationID`),
  KEY `UserID` (`UserID`),
  KEY `fk_notification_alert` (`AlertID`),
  CONSTRAINT `Notifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
  CONSTRAINT `fk_notification_alert` FOREIGN KEY (`AlertID`) REFERENCES `alert_log` (`AlertID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_notification_insert
AFTER INSERT ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO user_notification_counts (user_id, unread_count, total_count)
    VALUES (NEW.UserID, 1, 1)
    ON DUPLICATE KEY UPDATE
        unread_count = unread_count + 1,
        total_count = total_count + 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_notification_update
AFTER UPDATE ON Notifications
FOR EACH ROW
BEGIN
    IF OLD.IsRead != NEW.IsRead THEN
        IF NEW.IsRead = 1 THEN
            
            UPDATE user_notification_counts
            SET unread_count = unread_count - 1
            WHERE user_id = NEW.UserID;
        ELSE
            
            UPDATE user_notification_counts
            SET unread_count = unread_count + 1
            WHERE user_id = NEW.UserID;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dbms_user`@`localhost`*/ /*!50003 TRIGGER trg_notification_delete
AFTER DELETE ON Notifications
FOR EACH ROW
BEGIN
    UPDATE user_notification_counts
    SET
        total_count = total_count - 1,
        unread_count = unread_count - (CASE WHEN OLD.IsRead = 0 THEN 1 ELSE 0 END)
    WHERE user_id = OLD.UserID;

    
    DELETE FROM user_notification_counts
    WHERE user_id = OLD.UserID AND total_count <= 0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `parents`
--

DROP TABLE IF EXISTS `parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parents` (
  `ParentID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `PhotoURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ParentID`),
  UNIQUE KEY `UserID` (`UserID`),
  CONSTRAINT `fk_Parents_UserID` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedules` (
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
  CONSTRAINT `Schedules_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`CourseID`),
  CONSTRAINT `Schedules_ibfk_2` FOREIGN KEY (`TeacherUserID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `semesters`
--

DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `semesters` (
  `SemesterID` int(11) NOT NULL AUTO_INCREMENT,
  `SemesterName` varchar(50) NOT NULL,
  `SemesterLevel` int(11) NOT NULL,
  PRIMARY KEY (`SemesterID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `SessionID` int(11) NOT NULL AUTO_INCREMENT,
  `SessionName` varchar(50) NOT NULL,
  `Year` int(11) NOT NULL,
  `Term` varchar(20) NOT NULL,
  PRIMARY KEY (`SessionID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_parent_link`
--

DROP TABLE IF EXISTS `student_parent_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_parent_link` (
  `LinkID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` varchar(255) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`LinkID`),
  KEY `StudentID` (`StudentID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Student_Parent_Link_ibfk_2` FOREIGN KEY (`ParentID`) REFERENCES `parents` (`ParentID`),
  CONSTRAINT `fk_Student_Parent_Link_StudentID` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
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
  `PhotoURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`StudentID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `TeacherID` varchar(255) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `TeacherName` varchar(255) NOT NULL,
  `SubjectTaught` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `RegistrationCode` varchar(255) DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Pending',
  `PhotoURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TeacherID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_message_counts`
--

DROP TABLE IF EXISTS `user_message_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_message_counts` (
  `user_id` int(11) NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  `total_count` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `user_message_counts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_message_status`
--

DROP TABLE IF EXISTS `user_message_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_message_status` (
  `UserID` int(11) NOT NULL,
  `UnreadCount` int(11) DEFAULT 0,
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`UserID`),
  CONSTRAINT `user_message_status_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_notification_counts`
--

DROP TABLE IF EXISTS `user_notification_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_notification_counts` (
  `user_id` int(11) NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  `total_count` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `user_notification_counts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
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
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'dbms_project'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-29 11:15:41
