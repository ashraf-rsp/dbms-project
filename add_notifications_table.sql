
-- SQL to create the Notifications table

CREATE TABLE `Notifications` (
  `NotificationID` INT(11) NOT NULL AUTO_INCREMENT,
  `UserID` INT(11) DEFAULT NULL,
  `UserRole` VARCHAR(50) DEFAULT NULL,
  `Message` TEXT DEFAULT NULL,
  `Timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP(),
  `IsRead` TINYINT(1) DEFAULT 0,
  `Link` TEXT DEFAULT NULL,
  `Type` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`NotificationID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `Notifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
