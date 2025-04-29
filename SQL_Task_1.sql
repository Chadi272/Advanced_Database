--------------- Dim_Departments Dimension Creation ------------------
CREATE TABLE Dim_Departments (
	DepID INT PRIMARY KEY,
	Dept_Name VARCHAR(12) NOT NULL,
	Location VARCHAR(8) NOT NULL,
	Dept_Email VARCHAR(30) NOT NULL
);

ALTER TABLE Dim_Departments
ADD CONSTRAINT Check_Email
CHECK (Dept_Email LIKE '%@george-hosp.com')

ALTER TABLE Dim_Departments
ADD CONSTRAINT Check_Dept_Name
CHECK (Dept_Name LIKE 'Department[A-Z]')

INSERT INTO Dim_Departments (DepID, Dept_Name, Location, Dept_Email)
VALUES
(1001, 'DepartmentA', 'Wing_1', 'DepartmentA@george-hosp.com'),
(1002, 'DepartmentB', 'Wing_2', 'DepartmentB@george-hosp.com'),
(1003, 'DepartmentC', 'Wing_3', 'DepartmentC@george-hosp.com'),
(1004, 'DepartmentD', 'Wing_4', 'DepartmentD@george-hosp.com'),
(1005, 'DepartmentE', 'Wing_5', 'DepartmentE@george-hosp.com'),
(1006, 'DepartmentF', 'Wing_6', 'DepartmentF@george-hosp.com'),
(1007, 'DepartmentG', 'Wing_7', 'DepartmentG@george-hosp.com');

--------------- Dim_Patient_Address ------------------
CREATE TABLE Dim_Patient_Address (
	PAID INT PRIMARY KEY,
	House_Number VARCHAR(5) NOT NULL,
	Street_Number INT NOT NULL,
	Street_Name VARCHAR(100) NOT NULL,
	Post_Code VARCHAR(10) NOT NULL
);

ALTER TABLE Dim_Patient_Address
ADD CONSTRAINT Check_Postcode
CHECK (Post_Code LIKE '[A-Z]%[A-Z]')

INSERT INTO Dim_Patient_Address (PAID, House_Number, Street_Number, Street_Name, Post_Code)
VALUES
(101001, '67', '123', 'King Street', 'M1 2AD'),
(101002, '118A', '456' ,'Queen Road', 'M2 3BC'),
(101003, '12', '789', 'Prince Avenue', 'M3 4DE'),
(101004, '59', '321', 'Princess Drive', 'M4 5EF'),
(101005, '34B', '654', 'Duke Lane', 'M5 6GH'),
(101006, '23', '987', 'Duchess Way', 'M6 7IJ'),
(101007, '101', '231', 'Earl Boulevard', 'M7 8JK'),
(101008, '81', '564', 'Countess Park', 'M8 9LM'),
(101009, '76', '897', 'Viscount Place', 'M9 0NO'); 

--------------- Dim_Patients Dimension Creation ------------------
CREATE TABLE Dim_Patients (
	PID INT PRIMARY KEY,
	PAID INT NOT NULL,
	First_Name VARCHAR(50) NOT NULL,
	Middle_Name VARCHAR(50),
	Last_Name VARCHAR(50) NOT NULL,
	DoB DATE NOT NULL,
	Insurance_number INT NOT NULL,
	Email VARCHAR(255),
	Telephone_number VARCHAR(16) NOT NULL,
	Left_Date DATE,
	FOREIGN KEY (PAID) REFERENCES [dbo].Dim_Patient_Address(PAID)
);

ALTER TABLE Dim_Patients
ADD CONSTRAINT Check_Email_DP
CHECK (Email LIKE '%@%.com')

INSERT INTO Dim_Patients (PID, PAID, First_Name, Middle_Name, Last_Name, DoB, Insurance_number, Email, Telephone_number, Left_Date)
VALUES
(1, 101001, 'Alan', 'Michael', 'Rice', '1982-02-15', 10059435, 'Alan.Rice@outlook.com', '07700 123456', NULL),
(2, 101002, 'Chris', NULL, 'Frost', '1984-07-27', 10024850, 'Chris.Frost@gmail.com', '07700 123457', NULL),
(3, 101003, 'Kishan', 'Alan', 'Chauhan', '1986-11-03', 10056179, 'Kishan.Chauhan@hotmail.com', '07700 123458', NULL),
(4, 101004, 'George', 'Roy', 'Mokhtar', '1988-04-22', 10082816, 'George.Mokhtar@outlook.com', '07700 123459', NULL),
(5, 101005, 'Ade', NULL, 'Awonaike', '1990-09-09', 10014924, 'Ade.Awonaike@outlook.com', '07700 123460', NULL),
(6, 101006, 'Zac', 'Nassib', 'Hosn', '1992-12-14', 10094318, 'Zac.Hosn@gmail.com', '07700 123461', '2023-09-12'),
(7, 101007, 'Dan', NULL, 'Waterman', '1981-03-18', 10023487, 'Dan.Waterman@hotmail.com', '07700 123462', '2022-03-28'),
(8, 101008, 'Aquilla', NULL, 'Matafwali', '1983-06-25', 10031615, 'Aquilla.Matafwali@outlook.com', '07700 123463', '2023-11-19'),
(9, 101009, 'Tamsin', NULL, 'Anderson', '1985-10-30', 10025893, 'Tamsin.Anderson@gmail.com', '07700 123464', '2022-07-02'),
(10, 101006, 'Claire', NULL, 'Hosn', '1995-05-21', 10027209, 'Claire.Mokhtar@gmail.com', '07750 992731', NULL);

--------------- Dim_Doctors Dimension Creation ------------------
CREATE TABLE Dim_Doctors (
	DID INT PRIMARY KEY,
	First_Name VARCHAR(50) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	Specialty VARCHAR(50) NOT NULL,
	DepID INT NOT NULL,
	Email VARCHAR(255) NOT NULL,
	Room_no VARCHAR(5) NOT NULL,
	Yrs_of_exp INT NOT NULL,
	FOREIGN KEY (DepID) REFERENCES [dbo].[Dim_Departments](DepID)
);

ALTER TABLE Dim_Doctors
ADD CONSTRAINT Check_Email_DD
CHECK (Email LIKE '%@george-hosp.com')

ALTER TABLE Dim_Doctors
ADD CONSTRAINT Check_Room_DD
CHECK (Room_no LIKE '1[0-4][0, 2, 4, 6, 8][A-H]')

INSERT INTO Dim_Doctors (DID, First_Name, Last_Name, Specialty, DepID, Email, Room_no, Yrs_of_exp)
VALUES
(101, 'Jared', 'Night', 'Cardiologist', 1001, 'Jared.N@george-hosp.com', '114A', 7),
(102, 'Phil', 'Greenwood', 'Dermatologist', 1002, 'Phil.G@george-hosp.com', '116B', 11),
(103, 'Claire', 'Dunphy', 'Neurologist', 1001, 'Claire.D@george-hosp.com', '118A', 6),
(104, 'Ben', 'Wood', 'Gastroenterologists', 1002, 'Ben.W@george-hosp.com', '120C', 15),
(105, 'Dylan', 'Carlson', 'Pediatrician', 1003, 'Dylan.C@george-hosp.com', '126F', 9),
(106, 'Dan', 'Barlow', 'Gastroenterologists', 1005, 'Dan.B@george-hosp.com', '124D', 12),
(107, 'Prashant', 'Patel', 'Pediatrician', 1004, 'Prashant.P@george-hosp.com', '120F', 9);

--------------- Fact_Appointments Creation ------------------
CREATE TABLE Fact_Appointments (
	PID INT NOT NULL,
	DID INT NOT NULL,
	Date DATE NOT NULL,
	Time TIME NOT NULL,
	DepID INT NOT NULL,
	Status VARCHAR(10) NOT NULL,
	Rebooking_Flag TINYINT NOT NULL,
	Review VARCHAR(255),
	FOREIGN KEY (PID) REFERENCES [dbo].[Dim_Patients](PID),
	FOREIGN KEY (DID) REFERENCES [dbo].[Dim_Doctors](DID),
	FOREIGN KEY (DepID) REFERENCES [dbo].[Dim_Departments](DepID)
);

ALTER TABLE Fact_Appointments
ADD CONSTRAINT Check_Status
CHECK (Status = 'Completed' OR Status = 'Cancelled' OR Status = 'Pending' OR Status = 'Available')

INSERT INTO Fact_Appointments (PID, DID, Date, Time, DepID, Status, Rebooking_Flag, Review)
VALUES
(6, 105, '2024-01-09', '13:15:00', 1005, 'Completed', 0, NULL),
(7, 103, '2024-01-12', '10:45:00', 1001, 'Completed', 0, 'I waited for such a while!'),
(3, 106, '2024-01-15', '11:15:00', 1004, 'Completed', 0, 'Thank you'),
(9, 105, '2024-01-27', '14:45:00', 1002, 'Cancelled', 1, NULL),
(9, 102, '2024-01-29', '12:45:00', 1004, 'Completed', 0, 'Friendly staff'),
(9, 104, '2024-01-30', '14:30:00', 1002, 'Completed', 0, 'Great experience, friendly Dr.'),
(1, 101, '2024-02-11', '11:00:00', 1001, 'Completed', 0, 'Thank you Dr.'),
(4, 102, '2024-02-12', '13:00:00', 1001, 'Completed', 0, NULL),
(1, 101, '2024-02-15', '11:30:00', 1001, 'Cancelled', 1, NULL),
(5, 107, '2024-04-29', '16:15:00', 1003, 'Cancelled', 1, NULL),
(6, 101, '2024-06-26', '13:30:00', 1003, 'Cancelled', 1, NULL);

--------------- Fact_Appointments Creation ------------------
CREATE TABLE Fact_Appointments_Future (
	PID INT NOT NULL,
	DID INT NOT NULL,
	Date DATE NOT NULL,
	Time TIME NOT NULL,
	DepID INT NOT NULL,
	Status VARCHAR(10) NOT NULL,
	Rebooking_Flag TINYINT NOT NULL,
	Review VARCHAR(255),
	FOREIGN KEY (PID) REFERENCES [dbo].[Dim_Patients](PID),
	FOREIGN KEY (DID) REFERENCES [dbo].[Dim_Doctors](DID),
	FOREIGN KEY (DepID) REFERENCES [dbo].[Dim_Departments](DepID)
);

ALTER TABLE Fact_Appointments_Future
ADD CONSTRAINT Check_Status_Future
CHECK (Status = 'Cancelled' OR Status = 'Pending' OR Status = 'Available')

ALTER TABLE Fact_Appointments_Future
ADD CONSTRAINT Check_Date_Future
CHECK (Date >= GETDATE())

INSERT INTO Fact_Appointments_Future (PID, DID, Date, Time, DepID, Status, Rebooking_Flag, Review)
VALUES
(7, 103, '2024-04-29', '09:00:00', 1001, 'Pending', 0, NULL),
(5, 102, '2024-05-16', '15:45:00', 1003, 'Pending', 0, NULL),
(2, 104, '2024-05-08', '15:45:00', 1002, 'Pending', 0, NULL),
(4, 102, '2024-07-02', '13:15:00', 1001, 'Pending', 0, NULL),
(2, 104, '2024-06-30', '14:00:00', 1002, 'Pending', 0, NULL);

--------------- Fact_Billing Dimension Creation ------------------
CREATE TABLE Fact_Billing (
	PID INT NOT NULL,
	DID INT NOT NULL,
	DepID INT NOT NULL,
	Date_Charged DATE NOT NULL,
	Amount_Charged DECIMAL NOT NULL,
	Amount_Due DECIMAL NOT NULL,
	Payment_Status VARCHAR(10),
	Date_updated DATE,
	FOREIGN KEY (PID) REFERENCES [dbo].[Dim_Patients](PID),
	FOREIGN KEY (DID) REFERENCES [dbo].[Dim_Doctors](DID),
	FOREIGN KEY (DepID) REFERENCES [dbo].[Dim_Departments](DepID)
);

ALTER TABLE Fact_Billing
ADD CONSTRAINT Check_Status_Payment
CHECK (Payment_Status = 'Paid' OR Payment_Status = 'Unpaid' OR Payment_Status = 'Partial')

INSERT INTO Fact_Billing (PID, DID, DepID, Date_Charged, Amount_Charged, Amount_Due, Payment_Status, Date_updated)
VALUES
(5, 105, 1001, '2023-03-12', 1598, 984.56, 'Partial', '2023-05-27'),
(2, 101, 1001, '2022-06-29', 1197.36, 1197.36, 'Unpaid', NULL),
(3, 102, 1001, '2022-09-02', 2729.41, 1675.25, 'Partial', NULL),
(4, 103, 1001, '2023-09-12', 1913.67, 0, 'Paid', NULL),
(1, 106, 1001, '2023-04-18', 5243.46, 5243.46, 'Unpaid', '2023-11-18'),
(7, 104, 1001, '2022-11-05', 942.50, 268.67, 'Partial', NULL),
(6, 107, 1001, '2023-10-20', 2264, 0, 'Paid', NULL);

--------------- Medicine Table Creation ------------------
CREATE TABLE Dim_Medicines (
	MID VARCHAR(5) PRIMARY KEY,
	Medicine_Name VARCHAR(50) NOT NULL,
	Base_formula VARCHAR(50) NOT NULL
);

INSERT INTO Dim_Medicines (MID, Medicine_Name, Base_formula)
VALUES
('AAABA', 'Tranquillia-XR', 'Corticosteroids '),
('AAABB', 'RespiroSol', 'Omeprazole'),
('AAABC', 'AlliumMend', 'Amlodipine'),
('AAABD', 'Lumizol', 'Ramipril'),
('AAABE', 'CardioNova', 'Lansoprazole'),
('AAABF', 'DermaRegen', 'Colecalciferol');


--------------- Fact_Medical_Records Creation ------------------
CREATE TABLE Fact_Medical_Records (
	PID INT NOT NULL,
	DID INT NOT NULL,
	MID VARCHAR(5),
	Diagnosis VARCHAR(255) NOT NULL,
	Dose INT NOT NULL,
	Prescription_Date DATE,
	Allergies VARCHAR(255),
	FOREIGN KEY (PID) REFERENCES [dbo].[Dim_Patients](PID),
	FOREIGN KEY (DID) REFERENCES [dbo].[Dim_Doctors](DID),
	FOREIGN KEY (MID) REFERENCES [dbo].[Dim_Medicines](MID)
);

ALTER TABLE Fact_Medical_Records
ADD CONSTRAINT prescription_date_for_medicine
CHECK
	(MID IS NOT NULL and Prescription_Date IS NOT NULL);

INSERT INTO Fact_Medical_Records (PID, DID, MID, Diagnosis, Dose, Prescription_Date, Allergies)
VALUES
(1, 105, 'AAABA ', 'Hypertension', 100, '2022-03-14', 'Pollen'),
(1, 104, 'AAABB', 'Cancer', 250, '2023-11-02', NULL),
(2, 106, 'AAABC', 'Asthma', 100, '2022-05-21', 'Dust'),
(2, 103, 'AAABD', 'Chronic Obstructive Pulmonary Disease (COPD)', 500, '2023-04-03', NULL),
(3, 107, 'AAABE', 'Rheumatoid Arthritis', 20, '2023-08-30', NULL),
(4, 103, 'AAABF', 'Osteoporosis', 5, '2023-02-09', 'Dog'),
(5, 102, 'AAABA', 'Hyperthyroidism', 50, '2023-05-17', 'Peanuts'),
(5, 101, 'AAABB', 'Hypothyroidism', 100, '2022-09-11', NULL),
(6, 103, 'AAABC', 'Gastroesophageal Reflux Disease (GERD)', 250, '2022-10-13', 'Kiwi'),
(7, 107, 'AAABD', 'Peptic Ulcer Disease', 300, '2023-04-11', NULL),
(8, 101, 'AAABE', 'Migraine', 250, '2023-06-21', NULL),
(9, 104, 'AAABF', 'Psoriasis', 10, '2022-12-07', NULL),
(9, 106, 'AAABA', 'Eczema', 50, '2022-07-19', NULL);

--------------- UserAuth Table Creation ------------------
CREATE TABLE User_Auth_tbl (
	PID INT UNIQUE,
	Username VARCHAR(100) NOT NULL,
	Password VARCHAR(50) NOT NULL,
	FOREIGN KEY (PID) REFERENCES [dbo].[Dim_Patients](PID)
);

INSERT INTO User_Auth_tbl (PID, Username, Password)
VALUES
(1, 'AlanRice', 'Admin1'),
(2, 'ChrisFrost', 'Admin2'),
(3, 'KishanChauhan', 'Admin3'),
(4, 'GeorgeMokhtar', 'Admin4'),
(5, 'AdeAwonaike', 'Admin5'),
(6, 'ZacHosn', 'Admin6'),
(7, 'DanWaterman', 'Admin7'),
(8, 'AquillaMatafwali', 'Admin8'),
(9, 'TamsinAnderson', 'Admin9'),
(10, 'ClaireHosn', 'Admin10');

ALTER TABLE User_Auth_tbl
ADD CONSTRAINT Check_Password
CHECK (PATINDEX('%[A-Z]%', Password) > 0
	AND PATINDEX('%[0-9]%', Password) > 0
	AND PATINDEX('%[a-z]%', Password) > 0
	AND LEN(Password) >= 6);

-- Appointments table --
CREATE VIEW Fact_Appointment AS
SELECT * FROM [dbo].[Fact_Appointments]
UNION ALL
SELECT * FROM [dbo].[Fact_Appointments_Future]

--(2) Add the constraint to check that the appointment date is not in the past.
CREATE VIEW Future_appointments AS
SELECT *
FROM Fact_Appointments
WHERE Date >= CONVERT(DATE, GETDATE());

SELECT * FROM Future_appointments

--(3) List all the patients older than 40 and have Cancer in diagnosis.
SELECT
	dp.PID
	,dp.First_Name
	,dp.Last_Name
	,DATEDIFF(YEAR,dp.DoB,GETDATE()) AS Age
	,fmr.Diagnosis
FROM [dbo].[Dim_Patients] dp
INNER JOIN Fact_Medical_Records fmr
	ON dp.PID = fmr.PID
WHERE DATEDIFF(YEAR,dp.DoB,GETDATE()) >= 40
	and fmr.Diagnosis like '%cancer%'

--(4)(a) Search the database of the hospital for matching character strings by name of medicine. Results should be sorted with most recent medicine prescribed date first.
CREATE FUNCTION Search_By_Medicine (@med_char_str NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT TOP 100 PERCENT
        fmr.PID,
        fmr.Diagnosis,
        mdc.Medicine_Name,
		fmr.Dose,
        fmr.Prescription_Date,
        fmr.Allergies
    FROM 
        [dbo].[Fact_Medical_Records] fmr
	INNER JOIN Dim_Medicines mdc
		ON mdc.MID = fmr.MID
    WHERE 
        mdc.Medicine_Name LIKE '%' + @med_char_str + '%'
    ORDER BY 
        fmr.Prescription_Date DESC
);

SELECT * FROM Search_By_Medicine('Lumizol')

--(4)(b) Return a full list of diagnosis and allergies for a specific patient who has an appointment today (i.e., the system date when the query is run)
CREATE FUNCTION Patient_Current_Info (@patient_name NVARCHAR(255), @patient_last_name NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT
        fmr.Diagnosis,
        fmr.Allergies
    FROM 
        [dbo].[Fact_Medical_Records] fmr
    WHERE 
        fmr.PID in (
			SELECT pt.PID
			FROM [dbo].[Dim_Patients] pt
			RIGHT JOIN [dbo].[Fact_Appointments] fa
				ON pt.PID = fa.PID
			WHERE First_Name like  '%' + @patient_name + '%'
				and Last_Name like '%' + @patient_last_name + '%'
				and fa.Date = CAST(GETDATE() AS DATE)
		)
);

SELECT * FROM Patient_Current_Info('Chris', 'Frost')

--(4)(c) Update the details for an existing doctor
CREATE PROCEDURE Update_Doctor_Details
    @DID INT,
    @FirstName NVARCHAR(255),
    @LastName NVARCHAR(255),
    @Specialty NVARCHAR(255),
    @DepID INT,
    @Email NVARCHAR(255),
    @Room_no NVARCHAR(255),
    @Yrs_of_exp INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Dim_Doctors] WHERE DID = @DID) -- or = 1
    BEGIN
        UPDATE [dbo].[Dim_Doctors]
        SET 
            First_Name = IIF(@FirstName = '', (SELECT First_Name FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @FirstName),
            Last_Name = IIF(@LastName = '', (SELECT Last_Name FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @LastName),
            Specialty = IIF(@Specialty = '', (SELECT Specialty FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @Specialty),
            DepID = IIF(@DepID = '', (SELECT DepID FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @DepID),
            Email = IIF(@Email = '', (SELECT Email FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @Email),
            Room_no = IIF(@Room_no = '', (SELECT Room_no FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @Room_no),
            Yrs_of_exp = IIF(@Yrs_of_exp = -1, (SELECT Yrs_of_exp FROM [dbo].[Dim_Doctors] WHERE DID = @DID), @Yrs_of_exp)
        WHERE 
            DID = @DID;
    END
    ELSE
    BEGIN
        RAISERROR ('No doctor found with the provided Doctor ID.', 16, 1);
    END
END

EXEC Update_Doctor_Details
    @DID = 107,
    @FirstName = '',
    @LastName = '',
    @Specialty = 'Gastroenterologists',
    @DepID = '',
    @Email = '',
    @Room_no = '120D',
    @Yrs_of_exp = 3;

--(4)(d) Delete the appointment who status is already completed 
CREATE PROCEDURE Delete_Completed_Appointments AS
BEGIN
	DELETE FROM [dbo].[Fact_Appointments]
	WHERE [Status] = 'Completed'
END

EXEC Delete_Completed_Appointments

--(5) The hospitals wants to view the appointment date and time, showing all previous and current appointments for all doctors, and including details of the department (the doctor is associated with), doctor’s specialty and any associate review/feedback given for a doctor. You should create a view containing all the required information.
CREATE VIEW all_appointments AS
SELECT
	fa.Date AS [Appointment Date],
	fa.Time AS [Appointment Time],
	'Dr. ' + dd.First_Name + ' ' + dd.Last_Name AS [Doctor Name],
	ddep.Dept_Name AS [Department Name],
	ddep.Location AS [Hospital Wing],
	dd.Room_no AS [Examination Room],
	dd.Specialty AS [Dr's Specialty],
	fa.Review AS Feedback
FROM [dbo].[Fact_Appointments] fa
INNER JOIN [dbo].[Dim_Doctors] dd
	ON fa.DID = dd.DID
LEFT JOIN [dbo].[Dim_Departments] ddep
	ON ddep.DepID = dd.DepID
WHERE fa.Date <= GetDate()

SELECT *
FROM [dbo].[all_appointments]

--(6) Create a trigger so that the current state of an appointment can be changed to available when it is cancelled.
CREATE TRIGGER Status_Change ON [dbo].[Fact_Appointments]
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        UPDATE [dbo].[Fact_Appointments]
        SET Status = 'Available'
        FROM [dbo].[Fact_Appointments] fa
        WHERE fa.Status = 'Cancelled';
    END
END;


UPDATE [dbo].[Fact_Appointments]
SET Status = 'Cancelled'
WHERE PID = 9
	and DID = 105
	and DepID = 1002

--(7) Write a select query which allows the hospital to identify the number of completed appointments with the specialty of doctors as ‘Gastroenterologists’.
----- Option 1 ----- JOIN
SELECT
	'Count of Appointments where Dr specialty is Gastroenterologists: ' AS Detail
	,COUNT(fa.DID) AS [Count]
FROM [dbo].[Fact_Appointments] fa
INNER JOIN [dbo].[Dim_Doctors] dd
	ON fa.DID = dd.DID
WHERE fa.Status = 'Completed'
	and dd.Specialty like '%Gastroenterologists%'

----- Option 2 ----- SUB-QUERY
SELECT
	'Count of Appointments where Dr specialty is Gastroenterologists: ' AS Detail
	,COUNT(DID) AS [Count]
FROM [dbo].[Fact_Appointments]
WHERE Status = 'Completed'
	and DID in (
	SELECT DID
	FROM [dbo].[Dim_Doctors]
	WHERE Specialty like '%Gastroenterologists%'
	)
--------------------- Notes and Extra Info ---------------------
SELECT 
	TABLE_NAME,
	COLUMN_NAME,
	CASE
		WHEN DATA_TYPE = 'varchar'
		THEN CONCAT(DATA_TYPE, '(', CHARACTER_MAXIMUM_LENGTH, ')')
		ELSE DATA_TYPE
		END AS DATA_TYPE,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'George_Hospital'
	and TABLE_NAME not in ('all_appointments', 'sysdiagrams')
ORDER BY TABLE_NAME, DATA_TYPE Asc

--------------------- DB security ---------------------
CREATE LOGIN Chadi_Ghosn
WITH PASSWORD = 'Salford2024!'

CREATE USER Chadi_Ghosn
FOR LOGIN Chadi_Ghosn

CREATE ROLE AdminCenter
GRANT SELECT, UPDATE, DELETE, INSERT ON [dbo].[Dim_Departments] TO AdminCenter

ALTER ROLE AdminCenter ADD MEMBER Chadi_Ghosn

--------------------- Additional Queries ---------------------
-- Patient Billing Information -- View
CREATE VIEW Patient_Billing AS
SELECT
	CONCAT(p.First_Name, ' ',p.Last_Name) AS [Patient Name],
	CONCAT('Dr. ', d.First_Name, ' ', d.Last_Name) AS [Doctor Name],
	d.Specialty AS [Doctor Speciality],
	b.Date_Charged AS [Date Charged],
	FORMAT(b.Amount_Charged, 'C', 'en-gb') AS [Amount Charged],
	FORMAT(b.Amount_Due, 'C', 'en-gb') AS [Amount Due],
	b.Payment_Status AS [Payment Status]
FROM [dbo].[Fact_Billing] b
LEFT JOIN [dbo].[Dim_Patients] p
	ON b.PID = p.PID
LEFT JOIN [dbo].[Dim_Doctors] d
	ON d.DID = b.DID

SELECT * FROM Patient_Billing

-- Update Billing Procedure -- Stored Procedure
CREATE PROCEDURE Update_Billing
    @PID INT,
    @DID INT,
    @DepID INT,
    @Date_Charged DATE,
    @Amount_Charged DECIMAL,
    @Amount_Due DECIMAL,
    @Payment_Status VARCHAR(10),
    @Date_updated DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Fact_Billing] WHERE PID = @PID )
    BEGIN
        UPDATE [dbo].[Fact_Billing]
        SET 
            DID = IIF(@DID = '', (SELECT DID FROM [dbo].[Fact_Billing] WHERE PID = @PID), @DID),
            DepID = IIF(@DepID = '', (SELECT DepID FROM [dbo].[Fact_Billing] WHERE PID = @PID), @DepID),
            Date_Charged = IIF(@Date_Charged = '', (SELECT Date_Charged FROM [dbo].[Fact_Billing] WHERE PID = @PID), @Date_Charged),
            Amount_Charged = IIF(@Amount_Charged = -1, (SELECT Amount_Charged FROM [dbo].[Fact_Billing] WHERE PID = @PID), @Amount_Charged),
            Amount_Due = IIF(@Amount_Due = -1, (SELECT Amount_Due FROM [dbo].[Fact_Billing] WHERE PID = @PID), @Amount_Due),
            Payment_Status = IIF(@Payment_Status = '', (SELECT Payment_Status FROM [dbo].[Fact_Billing] WHERE PID = @PID), @Payment_Status),
            Date_updated = IIF(@Date_updated = '', (SELECT Date_updated FROM [dbo].[Fact_Billing] WHERE PID = @PID), @Date_updated)
        WHERE 
            PID = @PID;
    END
    ELSE
    BEGIN
        RAISERROR ('No patient found with the provided patient ID', 16, 1);
    END
END

EXEC Update_Billing
    @PID = 3,
    @DID = 102,
    @DepID = '',
    @Date_Charged = '',
    @Amount_Charged = 2729,
    @Amount_Due = 634,
    @Payment_Status = '',
    @Date_updated = '2024-04-01'
	
SELECT * FROM [dbo].[Fact_Billing]

-- Patient Prescriptions -- Systems functions and user defined function
CREATE FUNCTION Patient_Prescriptions (@patient_name NVARCHAR(255), @patient_last_name NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT
        fmr.Diagnosis,
		md.Medicine_Name,
		fmr.Dose,
		fmr.Prescription_Date
    FROM 
        [dbo].[Fact_Medical_Records] fmr
	INNER JOIN [dbo].[Dim_Medicines] md
		ON fmr.MID = md.MID
    WHERE 
        fmr.PID in (
			SELECT pt.PID
			FROM [dbo].[Dim_Patients] pt
			RIGHT JOIN [dbo].[Fact_Appointments] fa
				ON pt.PID = fa.PID
			WHERE First_Name like  '%' + @patient_name + '%'
				and Last_Name like '%' + @patient_last_name + '%'
		)
);

SELECT * FROM Patient_Prescriptions('Chris', 'Frost')

-- Removing Patient Info
CREATE TRIGGER Remove_Expired_Patients ON [dbo].[Dim_Patients]
AFTER UPDATE AS
BEGIN
    DELETE FROM [dbo].[Dim_Patients]
    WHERE ABS(DATEDIFF(year, Left_Date, GETDATE())) >= 3
END

UPDATE [dbo].[Dim_Patients]
SET Left_Date = '2021-01-26'
WHERE PID = 21

SELECT
	PID,
	First_Name,
	Last_Name,
	Left_Date,
	ABS(DATEDIFF(year, Left_Date, GETDATE())) AS Years_since_left
FROM [dbo].[Dim_Patients]

-- Selecting billing info
SELECT
	p.First_Name,
	p.Last_Name,
	b.Date_Charged,
	b.Amount_Due
FROM [dbo].[Fact_Billing] b
INNER JOIN [dbo].[Dim_Patients] p
	ON p.PID = b.PID
WHERE b.DID in (
	SELECT DID
	FROM [dbo].[Dim_Doctors]
	WHERE Specialty LIKE 'Gastro%'
)
