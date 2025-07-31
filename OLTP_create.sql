-- create database CA2ST1501;
-- use CA2ST1501;

-- Disable foreign key checks to drop tables in any order
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Building;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

create table Building(
BuildingID VARCHAR(10) PRIMARY KEY,	
BuildingName VARCHAR(50) NOT NULL
);

create table Department(
DepartmentID VARCHAR(10) PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL
);

Create table Room(
BuildingID VARCHAR(10),
RoomID VARCHAR(10),
PRIMARY KEY(BuildingID, RoomID),
Purpose VARCHAR(50) NOT NULL,
DepartmentID VARCHAR(10) NOT NULL,
FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID),
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

create table Doctor(
DoctorID VARCHAR(10) PRIMARY KEY,
DoctorName VARCHAR(50) NOT NULL,
Contact VARCHAR(10) NOT NULL,
Email VARCHAR(50) NOT NULL,
DepartmentID VARCHAR(10) NOT NULL,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

create table Patient(
PatientID VARCHAR(10) PRIMARY KEY,
PatientName VARCHAR(50) NOT NULL,
Contact VARCHAR(10) NOT NULL,
DOB DATE NOT NULL,
Sex CHAR(1) NOT NULL,
Address VARCHAR(100) NOT NULL,
Email VARCHAR(50) NOT NULL
);

create table Appointment(
PatientID VARCHAR(10),
DoctorID VARCHAR(10),
BuildingID VARCHAR(10),
RoomID VARCHAR(10),
ScheduledStart DATETIME NOT NULL,
PRIMARY KEY(PatientID, DoctorID, BuildingID, RoomID, ScheduledStart),
ScheduledEND DATETIME NOT NULL,
ArrivalTime DATETIME NULL,
StartTime DATETIME NULL,
FinishTime DATETIME NULL,
Weight FLOAT NULL,
Temperature FLOAT NULL,
DoctorComment VARCHAR(200) NULL,
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
FOREIGN KEY (BuildingID, RoomID) REFERENCES Room(BuildingID, RoomID)
);

-- Enable local infile for the session
SET GLOBAL local_infile = 1;

-- Load Building data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_building.csv'
INTO TABLE Building
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Department data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_department.csv'
INTO TABLE Department
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Room data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_room.csv'
INTO TABLE Room
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Doctor data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_doctor.csv'
INTO TABLE Doctor
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Patient data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_patient.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Appointment data
LOAD DATA LOCAL INFILE 'C:\\Singapore Polytechnic\\Year2 Semester 1\\Data Engineering\\CA2\\cleaned_appointment.csv'
INTO TABLE Appointment
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  PatientID,
  DoctorID,
  BuildingID,
  RoomID,
  ScheduledStart,
  ScheduledEND,
  @ArrivalTime,
  @StartTime,
  @FinishTime,
  @Weight,
  @Temperature,
  @DoctorComment
)
SET
  ArrivalTime = NULLIF(@ArrivalTime, '0000-00-00 00:00:00'),
  StartTime = NULLIF(@StartTime, '0000-00-00 00:00:00'),
  FinishTime = NULLIF(@FinishTime, '0000-00-00 00:00:00'),
  Weight = NULLIF(NULLIF(@Weight, '0'), ''),
  Temperature = NULLIF(NULLIF(@Temperature, '0'), ''),
  DoctorComment = NULLIF(@DoctorComment, '');

SET GLOBAL local_infile = 0;





