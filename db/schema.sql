/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.0-MariaDB, for Android (aarch64)
--
-- Host: localhost    Database: academic_center_db
-- ------------------------------------------------------
-- Server version	11.8.0-MariaDB

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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Alert_Log` (
  `AlertID` int(11) NOT NULL AUTO_INCREMENT,
  `ParentID` int(11) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`AlertID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Alert_Log_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Attendance`
--

DROP TABLE IF EXISTS `Attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Attendance` (
  `AttendanceID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `SessionDate` date DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`AttendanceID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Attendance_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `Enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Courses` (
  `CourseID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(100) DEFAULT NULL,
  `CourseDescription` text DEFAULT NULL,
  `CourseFee` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Enrollments`
--

DROP TABLE IF EXISTS `Enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Enrollments` (
  `EnrollmentID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` int(11) DEFAULT NULL,
  `CourseID` int(11) DEFAULT NULL,
  `EnrollmentDate` date DEFAULT NULL,
  PRIMARY KEY (`EnrollmentID`),
  KEY `StudentID` (`StudentID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Enrollments_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `Students` (`StudentID`),
  CONSTRAINT `Enrollments_ibfk_2` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Events`
--

DROP TABLE IF EXISTS `Events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Events` (
  `EventID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) DEFAULT NULL,
  `EventName` varchar(100) DEFAULT NULL,
  `EventType` varchar(50) DEFAULT NULL,
  `EventDate` date DEFAULT NULL,
  PRIMARY KEY (`EventID`),
  KEY `CourseID` (`CourseID`),
  CONSTRAINT `Events_ibfk_1` FOREIGN KEY (`CourseID`) REFERENCES `Courses` (`CourseID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Grades`
--

DROP TABLE IF EXISTS `Grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Messages`
--

DROP TABLE IF EXISTS `Messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Messages` (
  `MessageID` int(11) NOT NULL AUTO_INCREMENT,
  `SenderUserID` int(11) DEFAULT NULL,
  `ReceiverUserID` int(11) DEFAULT NULL,
  `Subject` varchar(255) DEFAULT NULL,
  `Content` text DEFAULT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `IsRead` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`MessageID`),
  KEY `SenderUserID` (`SenderUserID`),
  KEY `ReceiverUserID` (`ReceiverUserID`),
  CONSTRAINT `Messages_ibfk_1` FOREIGN KEY (`SenderUserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `Messages_ibfk_2` FOREIGN KEY (`ReceiverUserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Parents`
--

DROP TABLE IF EXISTS `Parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Parents` (
  `ParentID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ParentID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Payments` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `EnrollmentID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `EnrollmentID` (`EnrollmentID`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`EnrollmentID`) REFERENCES `Enrollments` (`EnrollmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Schedules`
--

DROP TABLE IF EXISTS `Schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Student_Parent_Link`
--

DROP TABLE IF EXISTS `Student_Parent_Link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Student_Parent_Link` (
  `LinkID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` int(11) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`LinkID`),
  KEY `StudentID` (`StudentID`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Student_Parent_Link_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `Students` (`StudentID`),
  CONSTRAINT `Student_Parent_Link_ibfk_2` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Students`
--

DROP TABLE IF EXISTS `Students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Students` (
  `StudentID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  PRIMARY KEY (`StudentID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `UserID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) DEFAULT NULL,
  `PasswordHash` varchar(255) DEFAULT NULL,
  `UserType` varchar(20) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`),
  KEY `ParentID` (`ParentID`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `Parents` (`ParentID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-08-16 13:53:02
