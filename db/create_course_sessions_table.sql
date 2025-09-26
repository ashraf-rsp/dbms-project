CREATE TABLE Course_Sessions (
    CourseSessionID INT PRIMARY KEY AUTO_INCREMENT,
    CourseID INT,
    SessionID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (SessionID) REFERENCES Sessions(SessionID)
);