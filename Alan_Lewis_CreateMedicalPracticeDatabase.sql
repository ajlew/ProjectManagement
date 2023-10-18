CREATE DATABASE MedicalPractice;
--PART 1
Use MedicalPractice;--AK means UNIQUE Contsraint

CREATE TABLE Patient (
    Patient_ID INTEGER PRIMARY KEY, -- Patient's unique system-generated identifier
    Title NVARCHAR(20), -- Patient's title, e.g. Mr, Ms, Mrs, Dr, etc.
    FirstName NVARCHAR(50) NOT NULL, -- Patient's first name
    MiddleInitial NCHAR(1), -- Patient's middle initial of their name
    LastName NVARCHAR(50) NOT NULL, -- Patient's last name
    HouseUnitLotNum NVARCHAR(5) NOT NULL, -- Number of Patient's residence, unit, or lot
    Street NVARCHAR(50) NOT NULL, -- Name of street, road, etc. where patient resides
    Suburb NVARCHAR(50) NOT NULL, -- Name of suburb where patient resides
    State NVARCHAR(3) NOT NULL, -- Name of state where patient resides
    PostCode NCHAR(4) NOT NULL, -- Post Code of Patient's residential address
    HomePhone NCHAR(10), -- Patient's home phone number
    MobilePhone NCHAR(10), -- Patient's mobile phone number
    MedicareNumber NCHAR(16), -- Patient's Medicare number
    DateOfBirth DATE NOT NULL, -- Patient's date of birth
    Gender NCHAR(20) NOT NULL -- Patient's gender
);

CREATE TABLE PractitionerType (
    PractitionerType NVARCHAR(50) PRIMARY KEY-- no fk reference
	)


CREATE TABLE Practitioner (
    Practitioner_ID INTEGER PRIMARY KEY,
    Title NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleInitial NCHAR(1),
    LastName NVARCHAR(50) NOT NULL,
    HouseUnitLotNum NVARCHAR(5) NOT NULL,
    Street NVARCHAR(50) NOT NULL,
    Suburb NVARCHAR(50) NOT NULL,
    State NVARCHAR(3) NOT NULL,
    PostCode NCHAR(4) NOT NULL,
    HomePhone NCHAR(10),
    MobilePhone NCHAR(10),
	MedicareNumber NCHAR(16) NOT NULL,
	MedicalRegistrationNumber NCHAR(11) UNIQUE NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NCHAR(20) NOT NULL,
    PractitionerType_Ref NVARCHAR(50) NOT NULL,
    FOREIGN KEY (PractitionerType_Ref) REFERENCES PractitionerType(PractitionerType) -- fk reference for PractitionerType table
);




CREATE TABLE WeekDays (
    WeekDayName NVARCHAR(9) PRIMARY KEY,-- no fk reference
   );

   	 

CREATE TABLE Availability (
    Practitioner_Ref INTEGER,
    WeekDayName_Ref NVARCHAR(9),
    CONSTRAINT PK_Availability PRIMARY KEY (Practitioner_Ref, WeekDayName_Ref),
    CONSTRAINT FK_WeekDays_Availability FOREIGN KEY (WeekDayName_Ref) REFERENCES WeekDays (WeekDayName),
    CONSTRAINT FK_Practitioner_Availability FOREIGN KEY (Practitioner_Ref) REFERENCES Practitioner (Practitioner_ID)
);



CREATE TABLE Appointment (
    Practitioner_Ref INTEGER NOT NULL,
    AppDate DATE NOT NULL,
    AppStartTime TIME NOT NULL,
    Patient_Ref INTEGER NOT NULL,
    PRIMARY KEY (Practitioner_Ref, AppDate, AppStartTime),
    UNIQUE (Patient_Ref, AppDate, AppStartTime),
    FOREIGN KEY (Practitioner_Ref) REFERENCES Practitioner(Practitioner_ID), --fk reference for Practitioner table
    FOREIGN KEY (Patient_Ref) REFERENCES Patient(Patient_ID) --fk reference for Patient table
);

--CSV
/*Code that might be helpful to import the data in the skills assessment (replace Student with the actual table you are importing and replace the path and
filename in the second line):*/
--a. 12_AppointmentData.csv
--b. 13_AvailabilityData.csv
--c. 15_PatientData.csv
--d. 16_PractitionerData.csv
--e. 17_PractitionerTypeData.csv
--f. 19_WeekDaysData.csv
--C:\Tafe\DatabaseCSVFilesSQLServer\


--#1
BULK INSERT WeekDays
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\19_WeekDaysData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)
--#2
BULK INSERT Appointment
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\12_AppointmentData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)
--#3
BULK INSERT Patient
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\15_PatientData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)
--#4
BULK INSERT Practitioner
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\16_PractitionerData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)
--#5
BULK INSERT PractitionerType
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\17_PractitionerTypeData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)
--#6
BULK INSERT Availability
FROM 'C:\Tafe\DatabaseCSVFilesSQLServer\13_AvailabilityData.csv'
WITH
(
 FORMAT = 'CSV',
 FIELDQUOTE = '"',
 FIRSTROW = 1,
 FIELDTERMINATOR = ',', --CSV field delimiter
 ROWTERMINATOR = '\n', --Use to shift the control to next row
 TABLOCK
)




select * from Appointment
select * from Availability
select * from Patient
select * from Practitioner
select * from PractitionerType
select * from WeekDays
