USE BUDT703_Project_0507_03;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS GuestRewards;
DROP TABLE IF EXISTS Ridership;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Station;
DROP TABLE IF EXISTS State;

-- CREATE TABLE statements:

-- State Table
CREATE TABLE State(
stateID CHAR(2) NOT NULL, 
stateName VARCHAR(50) NOT NULL, 
CONSTRAINT pk_State_stateID PRIMARY KEY (stateID)
)

--Station Table
CREATE TABLE Station (
stationCityCode CHAR(3) NOT NULL, 
stationCityName VARCHAR(75) , 
stateID CHAR(2) NOT NULL, 
CONSTRAINT pk_Station_stationCityCode PRIMARY KEY (stationCityCode),
CONSTRAINT fk_Station_stateID FOREIGN KEY (stateID)
	REFERENCES State (stateID)
	ON DELETE CASCADE ON UPDATE CASCADE
)

-- GuestRewards Table (Weak Entity)
CREATE TABLE GuestRewards (
stateID CHAR(2) NOT NULL,
[year] Int NOT NULL,
countOfMembers INT,
CONSTRAINT pk_GuestRewards_stateID_year PRIMARY KEY (stateID, [year]),
CONSTRAINT fk_GuestRewards_stateID FOREIGN KEY (stateID)
	REFERENCES State (stateID)
	ON DELETE CASCADE ON UPDATE CASCADE
);


-- Employment Table (Weak Entity)
CREATE TABLE Employee (
stateID CHAR(2) NOT NULL,
[year] INT NOT NULL,
employeeCount INT,
employeeSalary INT,
CONSTRAINT pk_Employee_stateID_year PRIMARY KEY (stateID, [year]),
CONSTRAINT fk_Employee_stateID FOREIGN KEY (stateID)
	REFERENCES State (stateID)
	ON DELETE CASCADE ON UPDATE CASCADE
);


-- Ridership Table (Weak Entity)
CREATE TABLE Ridership (
stationCityCode CHAR(3) NOT NULL,
[year] INT NOT NULL,
ridership INT,
stationCityName VARCHAR(75)
CONSTRAINT pk_Ridership_stationCityCode_year PRIMARY KEY (stationCityCode, [year]),
CONSTRAINT fk_Ridership_stationCityCode FOREIGN KEY (stationCityCode)
	REFERENCES Station (stationCityCode)
	ON DELETE CASCADE ON UPDATE CASCADE
);
