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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alert_log`
--

LOCK TABLES `alert_log` WRITE;
/*!40000 ALTER TABLE `alert_log` DISABLE KEYS */;
INSERT INTO `alert_log` VALUES (2,1,'Your parent-teacher meeting is scheduled for next week.','2025-08-21 08:22:22','Your parent-teacher meeting is scheduled for next week.',''),(3,NULL,'Test Announcement\nThis is a test announcement from curl.','2025-08-26 16:13:41','Test Announcement','This is a test announcement from curl.'),(4,NULL,'Test Announcement\nThis is a test announcement.','2025-08-31 04:14:22','Test Announcement','This is a test announcement.'),(5,NULL,NULL,'2025-09-26 17:52:33','test','test notification'),(8,NULL,NULL,'2025-09-26 19:20:14','we are happy','because of holiday'),(12,NULL,NULL,'2025-09-26 19:58:11','aadd','adfdf'),(14,NULL,NULL,'2025-09-26 21:41:26','a','aa');
/*!40000 ALTER TABLE `alert_log` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (13,1,'2025-08-30','Present'),(14,1,'2025-09-01','Absent'),(15,1,'2025-09-03','Late');
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `course_sessions`
--

LOCK TABLES `course_sessions` WRITE;
/*!40000 ALTER TABLE `course_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_sessions` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Chemistry',NULL,50.00,'CHE 1111-0531',3,1),(2,'Chemistry Lab',NULL,50.00,'CHE 1112-0531',1,1),(3,'Structured Programming Language',NULL,50.00,'CSE 1213-0613',3,NULL),(4,'Structured Programming Language Lab',NULL,50.00,'CSE 1214-0613',1,NULL),(5,'Organizational Behaviors',NULL,50.00,'HUM 1111-0031',3,1),(6,'Bangladesh Studies',NULL,50.00,'HUM 1113-0222',3,1),(7,'Mathematics-I',NULL,50.00,'MATH 1111-0541',3,1),(8,'Physics',NULL,50.00,'PHY 1111-0533',3,1),(9,'Physics Lab',NULL,50.00,'PHY 1112-0533',1,1),(10,'Discrete Mathematics',NULL,50.00,'CSE 1203-0611',3,2),(11,'Object Oriented Programming Language',NULL,50.00,'CSE 2141-0613',3,2),(12,'Object Oriented Programming Language Lab',NULL,50.00,'CSE 2142-0613',1,2),(13,'Electrical Circuit Analysis',NULL,50.00,'EEE 1211-0714',3,2),(14,'Electrical Circuit Analysis Lab',NULL,50.00,'EEE 1212-0714',1,2),(15,'Communicative English',NULL,50.00,'ENG 1213-0231',3,2),(16,'Mathematics-II',NULL,50.00,'MATH 1213-0541',3,2),(17,'Fundamentals of Computer and Office Applications',NULL,50.00,'CSE 1111-0611',3,3),(18,'Fundamentals of Computer Lab',NULL,50.00,'CSE 1112-0611',1,3),(19,'Competitive Programming-I',NULL,50.00,'CSE 2105-0613',1,3),(20,'Engineering Drawing',NULL,50.00,'CSE 2144-0611',1,3),(21,'Numerical Analysis with MATLAB',NULL,50.00,'CSE 2234-0613',3,3),(22,'Arts of Presentation',NULL,50.00,'HUM 2125-0031',3,3),(23,'Mathematics-III',NULL,50.00,'MATH 2115-0541',3,3),(24,'Business Communication',NULL,50.00,'BBA 2211-0414',3,4),(25,'Competitive Programming-II',NULL,50.00,'CSE 2205-0613',1,4),(26,'Data Structures and Algorithms',NULL,50.00,'CSE 2215-0613',3,4),(27,'Data Structures and Algorithms Lab',NULL,50.00,'CSE 2216-0613',1,4),(28,'System Analysis and Design',NULL,50.00,'CSE 2221-0613',3,4),(29,'System Analysis and Design Lab',NULL,50.00,'CSE 2222-0613',1,4),(30,'Data Communicaiton and Networking',NULL,50.00,'CSE 3131-0612',3,4),(31,'Data Communicaiton and Networking Lab',NULL,50.00,'CSE 3132-0612',1,4),(32,'Math-IV (Probability and Statistics)',NULL,50.00,'MATH 2217-0542',3,4),(33,'Integrated Design Project I',NULL,50.00,'CSE 3108-0613',1,5),(34,'Theory of Computing',NULL,50.00,'CSE 3143-0611',3,5),(35,'Digital Logic Design',NULL,50.00,'CSE 3151-0414',3,5),(36,'Digital Logic Design Lab',NULL,50.00,'CSE 3152-0414',1,5),(37,'Microprocessor and Assembly Language',NULL,50.00,'CSE 3253-0714',3,5),(38,'Microprocessor and Assembly Language Lab',NULL,50.00,'CSE 3254-0714',1,5),(39,'Electronics Devices and Circuits',NULL,50.00,'EEE 2113-0714',3,5),(40,'Electronics Devices and Circuits Lab',NULL,50.00,'EEE 2114-0714',1,5),(41,'Integrated Design Project II',NULL,50.00,'CSE 3208-0613',1,6),(42,'Compiler Construction',NULL,50.00,'CSE 3219-0613',3,6),(43,'Compiler Construction Lab',NULL,50.00,'CSE 3220-0613',1,6),(44,'Database Management System',NULL,50.00,'CSE 3223-0612',3,6),(45,'Database Management System Lab',NULL,50.00,'CSE 3224-0612',1,6),(46,'Web Programming',NULL,50.00,'CSE 3246-0613',3,6),(47,'Network and Server Administration',NULL,50.00,'CSE 4277-0612',3,6),(48,'Network and Server Administration Lab',NULL,50.00,'CSE 4278-0612',1,6),(49,'Principles of Management',NULL,50.00,'HUM 3103-0413',3,6);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (1,'test-student-01',3,'2025-08-31','Enrolled',NULL),(2,'25S010003',1,'2025-09-01','Enrolled',NULL),(3,'33',1,'2025-09-05','Enrolled',NULL),(4,'33',2,'2025-09-05','Enrolled',NULL),(5,'33',8,'2025-09-06','Enrolled',NULL);
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,1,'Midterm Exam','Test','2025-09-01'),(2,1,'Project Deadline','Deadline','2025-09-15'),(3,NULL,'Summer Break','Holiday','2025-08-20'),(4,NULL,'iupc','Contest',NULL),(5,1,'Midterm Exam','Exam','2025-10-15'),(6,2,'Book Report Due','Assignment','2025-09-30');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
INSERT INTO `grades` VALUES (4,1,6.00,'',9,'2025-09-03');
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,4,1,'Welcome to Mathematics 101','Dear John, Welcome to the class!','2025-08-21 08:22:22',1,0,0),(2,1,4,'Re: Welcome to Mathematics 101','Thank you, teacher!','2025-08-21 08:22:22',0,0,0),(3,9,10,'Test Message','Hello from t_teacher!','2025-08-26 16:17:22',1,0,0),(5,9,10,'Test Subject','Hello from teacher!','2025-08-31 04:12:58',1,0,0),(6,15,9,'Test Message from Admin','Hello Teacher, this is a test message from the Admin.','2025-09-04 08:41:44',1,0,0),(7,15,9,'Test Message from Admin','Hello Teacher, this is a test message from the Admin.','2025-09-04 08:55:15',1,1,0),(9,15,9,'Test Message from Admin','Hello t_teacher, this is a test message from the Admin.','2025-09-04 10:16:16',1,1,1),(10,9,9,'Test Message from Student','Hello t_teacher, this is a test message from the Student.','2025-09-04 10:18:08',1,1,1),(11,15,9,'Test Message from Admin (Error Debug)','Hello t_teacher, this is a test message from the Admin to debug the error.','2025-09-04 10:58:24',1,0,0),(12,15,9,'Frontend Test Message','This message is to test frontend form submission.','2025-09-04 11:03:11',1,1,0),(13,15,9,'Test Message from Gemini','This is a test message to verify end-to-end message sending.','2025-09-05 19:03:26',1,0,0),(14,15,9,'Test Message from Gemini (Fixed)','This is a test message to verify the fix.','2025-09-05 19:13:51',1,0,1),(15,9,15,'abc','aerrtt','2025-09-05 19:29:48',1,0,0),(16,15,10,'Hey ! parents','I got a message for you. JK.. nothing','2025-09-05 19:30:57',1,0,0),(17,10,9,'Re: Hey ! parents','ok.. got you','2025-09-05 19:31:55',1,0,0),(18,15,10,'A Notice to your kid','This is to notify you that, your kid is not attending school today.','2025-09-05 21:15:26',1,0,0),(19,10,9,'A Notice to your kid','He is not doing great','2025-09-12 08:14:42',1,0,0),(20,15,10,'tst msg','adf\nefd\nedf\nadfd\nadfad','2025-09-22 23:51:56',1,1,0),(21,9,15,'message notification check','this is a sample message to test','2025-09-22 23:53:38',1,0,0),(22,15,9,'message notification check','hello teacher','2025-09-22 23:54:55',1,1,0),(23,15,10,'message notification check','abcdef','2025-09-26 17:46:25',1,1,0),(24,10,15,'tst msg','kire, Ashraf. eita test message','2025-09-26 17:47:41',1,0,0),(25,15,9,'tst msg','afdfd','2025-09-26 21:47:59',1,1,0),(26,15,10,'abc','afd','2025-09-26 21:55:29',1,1,0),(27,10,15,'adfaf','adfdf','2025-09-26 21:58:15',1,0,1),(28,15,10,'adfaf','adf','2025-09-26 21:59:05',1,1,0),(29,15,9,'important message','an important discussion','2025-09-26 22:17:42',1,1,0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,NULL,'Welcome to the Academic Center Management System!','2025-09-06 10:24:42',0,'/dashboard.jsp','System',NULL),(2,1,NULL,'Your grades for Mathematics have been updated.','2025-09-06 10:24:42',0,'/view_grades.jsp','GradeUpdate',NULL),(4,1,NULL,'You have a new message from your teacher.','2025-09-06 10:24:42',0,'/messages.jsp','Message',NULL),(5,15,NULL,'This is a test notification for AshrafM.','2025-09-06 12:25:19',1,NULL,NULL,5),(6,14,NULL,'This is a test notification from Gemini.','2025-09-11 16:33:45',0,NULL,NULL,5),(7,5,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(8,7,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(9,8,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(10,9,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',1,NULL,NULL,NULL),(11,13,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(12,15,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',1,NULL,NULL,NULL),(13,16,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(14,32,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(15,34,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(16,1,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(17,3,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(18,33,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(19,4,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(20,10,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',1,NULL,NULL,NULL),(21,14,NULL,'New announcement posted: Broken','2025-09-26 19:19:47',0,NULL,NULL,NULL),(22,5,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(23,7,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(24,8,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(25,9,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',1,NULL,NULL,8),(26,13,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(27,15,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',1,NULL,NULL,8),(28,16,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(29,32,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(30,34,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(31,1,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(32,3,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(33,33,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(34,4,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(35,10,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',1,NULL,NULL,8),(36,14,NULL,'New announcement posted: we are happy','2025-09-26 19:20:14',0,NULL,NULL,8),(37,5,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(38,7,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(39,8,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(40,9,NULL,'New announcement posted: abc','2025-09-26 19:54:07',1,NULL,NULL,NULL),(41,13,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(42,15,NULL,'New announcement posted: abc','2025-09-26 19:54:07',1,NULL,NULL,NULL),(43,16,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(44,32,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(45,34,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(46,1,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(47,3,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(48,33,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(49,4,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(50,10,NULL,'New announcement posted: abc','2025-09-26 19:54:07',1,NULL,NULL,NULL),(51,14,NULL,'New announcement posted: abc','2025-09-26 19:54:07',0,NULL,NULL,NULL),(52,5,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(53,7,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(54,8,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(55,9,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',1,NULL,NULL,12),(56,13,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(57,15,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',1,NULL,NULL,12),(58,16,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(59,32,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(60,34,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(61,1,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(62,3,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(63,33,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(64,4,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(65,10,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',1,NULL,NULL,12),(66,14,NULL,'New announcement posted: aadd','2025-09-26 19:58:11',0,NULL,NULL,12),(67,5,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(68,7,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(69,8,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(70,9,NULL,'New announcement posted: a','2025-09-26 20:11:06',1,NULL,NULL,NULL),(71,13,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(72,15,NULL,'New announcement posted: a','2025-09-26 20:11:06',1,NULL,NULL,NULL),(73,16,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(74,32,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(75,34,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(76,1,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(77,3,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(78,33,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(79,4,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(80,10,NULL,'New announcement posted: a','2025-09-26 20:11:06',1,NULL,NULL,NULL),(81,14,NULL,'New announcement posted: a','2025-09-26 20:11:06',0,NULL,NULL,NULL),(82,5,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(83,7,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(84,8,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(85,9,NULL,'New announcement posted: a','2025-09-26 21:41:26',1,NULL,NULL,14),(86,13,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(87,15,NULL,'New announcement posted: a','2025-09-26 21:41:26',1,NULL,NULL,14),(88,16,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(89,32,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(90,34,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(91,1,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(92,3,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(93,33,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(94,4,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14),(95,10,NULL,'New announcement posted: a','2025-09-26 21:41:26',1,NULL,NULL,14),(96,14,NULL,'New announcement posted: a','2025-09-26 21:41:26',0,NULL,NULL,14);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;
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
  PRIMARY KEY (`ParentID`),
  UNIQUE KEY `UserID` (`UserID`),
  CONSTRAINT `fk_Parents_UserID` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parents`
--

LOCK TABLES `parents` WRITE;
/*!40000 ALTER TABLE `parents` DISABLE KEYS */;
INSERT INTO `parents` VALUES (1,'Test','Parent','123-456-7890',NULL),(2,'John','Doe','123-456-7890',NULL),(3,'Jane','Smith','098-765-4321',NULL),(4,'Peter','Jones','111-222-3333',NULL),(5,'Abc','Parents ','012454547',10),(6,'Jane','Smith','987-654-3210',NULL),(7,'Test','Parent','9998887777',1);
/*!40000 ALTER TABLE `parents` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (6,1,150.00,'2025-08-31');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,1,'Monday','09:00:00','10:30:00','Room 101',4),(2,1,'Wednesday','09:00:00','10:30:00','Room 101',4),(3,2,'Tuesday','11:00:00','12:30:00','Room 102',4),(4,2,'Thursday','11:00:00','12:30:00','Room 102',4),(5,1,'TBD','00:00:00','00:00:00','TBD',5),(6,3,'Mon/Wed','14:00:00','15:00:00','Room 103',9),(7,1,'TBD','00:00:00','00:00:00','TBD',9),(8,8,'TBD','00:00:00','00:00:00','TBD',9),(9,6,'TBD','00:00:00','00:00:00','TBD',13);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `semesters`
--

LOCK TABLES `semesters` WRITE;
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
INSERT INTO `semesters` VALUES (1,'1st Semester - Freshman',1),(2,'2nd Semester - Freshman',2),(3,'3rd Semester - Sophomore',3),(4,'4th Semester - Sophomore',4),(5,'5th Semester - Junior',5),(6,'6th Semester - Junior',6),(7,'7th Semester - Senior',7),(8,'8th Semester - Senior',8);
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (1,'Fall 2023',2023,'Fall'),(2,'Summer 2024',2024,'Summer'),(3,'Fall 2024',2024,'Fall');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `student_parent_link`
--

LOCK TABLES `student_parent_link` WRITE;
/*!40000 ALTER TABLE `student_parent_link` DISABLE KEYS */;
INSERT INTO `student_parent_link` VALUES (6,'25S010001',1),(7,'25S010003',5),(8,'test-student-01',5),(9,'33',2);
/*!40000 ALTER TABLE `student_parent_link` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`StudentID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES ('25S010001',18,'Test Student','1234567890','2005-01-01','REG-TEST-12345','Active','Test Parent','parent@example.com','0987654321'),('25S010002',26,'Test Student','1234567890','2005-01-01','manual_reg_code','Active','Test Parent','parent@example.com','0987654321'),('25S010003',14,'New Student Name Again','1234567890','2010-01-01','REG-ABC-12345','Active','Test Parent','parent@example.com','0987654321'),('33',33,'Student 1',NULL,NULL,NULL,'Pending',NULL,NULL,NULL),('test-student-01',NULL,'Test Student',NULL,'2010-01-01',NULL,'Pending',NULL,NULL,NULL),('TEST_ID_2',999,'Test Student Name',NULL,NULL,NULL,'Pending',NULL,NULL,NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`TeacherID`),
  UNIQUE KEY `UserID` (`UserID`),
  UNIQUE KEY `RegistrationCode` (`RegistrationCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES ('T001',9,'Test Teacher','Math','t_teacher@example.com','1112223333','1980-01-01','REG-T001','Active');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user_message_counts`
--

LOCK TABLES `user_message_counts` WRITE;
/*!40000 ALTER TABLE `user_message_counts` DISABLE KEYS */;
INSERT INTO `user_message_counts` VALUES (1,0,1),(4,1,1),(9,0,13),(10,0,8),(15,0,4);
/*!40000 ALTER TABLE `user_message_counts` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user_message_status`
--

LOCK TABLES `user_message_status` WRITE;
/*!40000 ALTER TABLE `user_message_status` DISABLE KEYS */;
INSERT INTO `user_message_status` VALUES (9,3,'2025-09-26 16:17:42'),(10,4,'2025-09-26 15:59:05'),(15,3,'2025-09-26 15:58:15');
/*!40000 ALTER TABLE `user_message_status` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user_notification_counts`
--

LOCK TABLES `user_notification_counts` WRITE;
/*!40000 ALTER TABLE `user_notification_counts` DISABLE KEYS */;
INSERT INTO `user_notification_counts` VALUES (1,9,9),(3,6,6),(4,6,6),(5,6,6),(7,6,6),(8,6,6),(9,0,6),(10,0,6),(13,6,6),(14,7,7),(15,0,7),(16,6,6),(32,6,6),(33,6,6),(34,6,6);
/*!40000 ALTER TABLE `user_notification_counts` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'parent1','$2a$12$1OMkGfc3296g/I7z8vyKUeb4fS68xooOayTrDDenEPeG12x2IytQK','Parent',1,NULL,NULL,NULL,1),(3,'jane.smith','$2a$12$QGVcl2Z6TQdfZb.40KWc9OHjZ7zcz3YlZOK27YLG1bSw5RnuSAHSy','Parent',2,NULL,NULL,NULL,1),(4,'peter.jones','$2a$12$h5bQZca5SX7M4SkdNJnF4ejuWrcwoC4Wb8Xedkt0o5VyD2lEr8KH.','Parent',3,NULL,NULL,NULL,1),(5,'teacher.susan','$2a$12$SX6jH/X3cKlHkneQkQ7KXe/O3nDzB2dkh8Bp/ajTTCIrZ7UNw7yJm','Teacher',NULL,NULL,NULL,NULL,1),(7,'test_parent_user_123','$2a$12$/NpehSB/2Ry/Oqh3944.6udrvgFPxcP/Cy7zJDICroOaFHvCGuGlG','Parent',NULL,NULL,NULL,NULL,1),(8,'admin','$2a$12$Euqe6jdns0XsDbaPHYwfS.6SRaid20UHaUhi5QkgU4Yb5euOsqIMS','admin',NULL,NULL,NULL,NULL,1),(9,'t_teacher','$2a$12$VYTZaDSjbzLXUTMH65zi0uLKCN.ggd95XweSi89e3vABv.YmxxBkG','Teacher',NULL,NULL,NULL,NULL,1),(10,'t_parent','$2a$12$l6QDGMUubadA4BVdtCEIb.TI238AknWVApt9.Jug86oPfZC14u4by','Parent',5,NULL,NULL,NULL,1),(13,'new_teacher','$2a$12$9FDFOkRJbMXbdVgDnpswouaJsnpMeXeJ//PwDzpkT3qrvO4BPQ4hy','Teacher',NULL,NULL,NULL,NULL,1),(14,'Std1','$2a$12$mwHPc.DA7MjpIznDtREGk.kLg/BpkP0jfTjZd7g3.pBzJvbWAuUiK','Student',5,NULL,NULL,'std1@test.com',1),(15,'AshrafM','$2a$12$r/Kbjlc2.e0SbPOkw2dflev5CjesCjd377jm4.WSwywcGcd9hntiC','Admin',NULL,NULL,'Shuvo','ashraf@test.com',1),(16,'MGR','$2a$12$MQi6CRqRPNc7KvJlJ9buy.TBlNNxXKhjL10wJxXkiWYpKwNXZ7X46','Student',NULL,'e07f5ed7-0224-4735-90a8-384348cc0a99',NULL,NULL,1),(32,'teacher ','$2a$12$pZOL8IeYl3oB88w3ospPneUklbzrc6kJ8gTRdBVxzDxVph.0DTKLS','Teacher',NULL,NULL,NULL,NULL,1),(33,'testStd','$2a$12$IdHlYZSK7pJNVLmX8DWHaeQU3ZA5Ew.ZDtF/.XpwMvFm53r9jVNau','Student',2,NULL,NULL,NULL,1),(34,'gemini_admin','$2a$12$LrPY/a/VnpoBFK6zHcuPye3XhuN/k2dyEE9ATn.//uMtvapOiiEi2','Admin',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-27  9:48:36
