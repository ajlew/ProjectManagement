Use MedicalPractice;
--data
select * from Appointment
select * from Availability
select * from Patient
select * from Practitioner
select * from PractitionerType
select * from WeekDays
--1. List the first name and last name of female patients who live in St Kilda or Lidcombe
SELECT FirstName, LastName
FROM Patient
WHERE Gender = 'female'
AND (Suburb = 'St Kilda' OR Suburb = 'Lidcombe');
--2 List the first name, last name, state and Medicare Number of any patients who do not live in NSW.
SELECT FirstName, LastName, State, MedicareNumber
FROM Patient
WHERE State <> 'NSW';


--3 List each patient's first name, last name, Medicare Number and their date of birth. Sort the list by date of birth, listing the youngest patients first.
select * from Patient
SELECT FirstName, LastName, MedicareNumber, DateOfBirth
FROM Patient
ORDER BY DateOfBirth;


--4 For each practitioner, list their ID, first name, last name, the total number of days and the total number of hours they are scheduled to work in a standard week at the Medical Practice. Assume a workday is nine hours long.
SELECT
    p.Practitioner_ID,
    p.FirstName,
    p.LastName,
    COUNT(a.WeekDayName_Ref) AS TotalDays,
    COUNT(a.WeekDayName_Ref) * 9 AS TotalHours
FROM Practitioner AS p
LEFT JOIN Availability AS a ON p.Practitioner_ID = a.Practitioner_Ref
GROUP BY p.Practitioner_ID, p.FirstName, p.LastName
ORDER BY p.Practitioner_ID;


--5 List the Patient's first name, last name and the appointment date and time, for all appointments held on the 18/09/2019 by Dr Anne Funsworth.
SELECT
	p.Title AS "Patient_Title",
    p.FirstName AS "Patient_FirstName",
    p.LastName AS "Patient_LastName",
    a.AppDate AS "Appointment_Date",
    a.AppStartTime AS "Appointment_Time"
FROM Appointment AS a
INNER JOIN Practitioner AS pr ON a.Practitioner_Ref = pr.Practitioner_ID
INNER JOIN Patient AS p ON a.Patient_Ref = p.Patient_ID
WHERE pr.FirstName = 'Anne' AND pr.LastName = 'Funsworth'
    AND CONVERT(DATE, a.AppDate) = '2019-09-18'
ORDER BY a.AppDate, a.AppStartTime;


--6 List the ID and date of birth of any patient who has not had an appointment and was born before 1950.
SELECT Patient_ID, DateOfBirth
FROM Patient
WHERE Patient_ID NOT IN (
    SELECT DISTINCT Patient_Ref
    FROM Appointment
) AND YEAR(DateOfBirth) < 1950;


--7 List the patient ID, first name, last name and the number of appointments for patients who have had at least three appointments. List the patients in 'number of appointments' order from most to least
SELECT p.Patient_ID, p.FirstName, p.LastName, COUNT(a.Patient_Ref) AS NumberOfAppointments
FROM Patient p
INNER JOIN Appointment a ON p.Patient_ID = a.Patient_Ref
GROUP BY p.Patient_ID, p.FirstName, p.LastName
HAVING COUNT(a.Patient_Ref) >= 3
ORDER BY NumberOfAppointments DESC;

SELECT p.Patient_ID, p.FirstName, p.LastName, (
    SELECT COUNT(*)
    FROM Appointment a
    WHERE a.Patient_Ref = p.Patient_ID
) AS NumberOfAppointments
FROM Patient p
WHERE p.Patient_ID IN (
    SELECT Patient_Ref
    FROM Appointment
    GROUP BY Patient_Ref
    HAVING COUNT(*) >= 3
);

--8 List the first name, last name, gender, and the number of days since the last appointment of each patient and the 23/09/2019.

SELECT
    p.FirstName,
    p.LastName,
    p.Gender,
    DATEDIFF(DAY, MAX(a.AppDate), '2019-09-23') AS DaysSinceLastAppointment
FROM
    Patient p
LEFT JOIN
    Appointment a ON p.Patient_ID = a.Patient_Ref
GROUP BY
    p.FirstName,
    p.LastName,
    p.Gender;


--9 List the full name and full address of each practitioner in the following format exactly.Dr Mark P. Huston. 21 Fuller Street SUNSHINE, NSW 2343 Make sure you include the punctuation and the suburb in upper case.
--Sort the list by last name, then first name, then middle initial.

SELECT 
    CONCAT(
        CASE 
            WHEN LEN(p.Title) > 0 THEN p.Title + ' '
            ELSE ''
        END,
        p.FirstName, 
        CASE 
            WHEN LEN(p.MiddleInitial) > 0 THEN ' ' + p.MiddleInitial + '.'
            ELSE ''
        END,
        ' ', 
        p.LastName, 
        '. ', 
        p.HouseUnitLotNum, 
        ' ', 
        p.Street, 
        ' ', 
        UPPER(p.Suburb), 
        ', ', 
        UPPER(p.State), 
        ' ', 
        p.PostCode
    ) AS PractitionerInfo
FROM 
    Practitioner p
ORDER BY 
    p.LastName, 
    p.FirstName, 
    p.MiddleInitial;

--10 List the patient id, first name, last name and date of birth of the fifth oldest patient(s)

SELECT TOP 1
    Patient_ID,
    FirstName,
    LastName,
    DateOfBirth
FROM (
    SELECT
        Patient_ID,
        FirstName,
        LastName,
        DateOfBirth,
        ROW_NUMBER() OVER (ORDER BY DateOfBirth ASC) AS RowAsc
    FROM
        Patient
) AS OrderedPatients
WHERE
    RowAsc = 5;

	

--11 List the patient ID, first name, last name, appointment date (in the format 'Tuesday 17 September, 2019') and appointment time (in the format '14:15 PM') for all patients who have had appointments on any Tuesday after 10:00 AM.
--select * from Appointment
SELECT
    p.Patient_ID,
    p.FirstName,
    p.LastName,
    CONCAT(DATENAME(WEEKDAY, a.AppDate), ' ', FORMAT(a.AppDate, 'dd MMMM, yyyy')) AS AppointmentDate,
    FORMAT(CAST(a.AppStartTime AS DATETIME), 'hh:mm tt') AS AppointmentTime
FROM
    Patient p
INNER JOIN
    Appointment a ON p.Patient_ID = a.Patient_Ref
WHERE
    DATENAME(WEEKDAY, a.AppDate) = 'Tuesday'
    AND a.AppStartTime > '10:00:00';


--12 Create an address list for a special newsletter to all patients and practitioners. The mailing list should contain all relevant address fields for each household. Note that each household should only receive one newsletter.
SELECT
    'Patient' AS NewsLetterList,
    Title,
    FirstName,
    LastName,
    HouseUnitLotNum,
    Street,
    Suburb,
    State,
    Postcode
FROM
    Patient

UNION

SELECT
    'Practitioner' AS NewsLetterList,
    Title,
    FirstName,
    LastName,
    HouseUnitLotNum,
    Street,
    Suburb,
    State,
    Postcode
FROM
    Practitioner;

