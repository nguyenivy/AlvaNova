/*
Novasak, Ivan
2024-06-05, updated 2024-06-22
Southern New Hampshire University
IT 650: Principles of Database Design
Wild Wood Apartments SQL Database Code
*/

--  Drop (if exists), Create (if not exist), and Use the database.

DROP DATABASE IF EXISTS WildWoodApts_DB;
CREATE DATABASE IF NOT EXISTS WildWoodApts_DB;
USE WildWoodApts_DB;

-- Create a People table

CREATE TABLE IF NOT EXISTS People (
	personID INT NOT NULL,
	surname VARCHAR(50) NOT NULL,
	givenName VARCHAR(50) NOT NULL,
	middleName VARCHAR(50),
    dob DATE NOT NULL,
    idType VARCHAR(50) NOT NULL,
    idNum VARCHAR(50) NOT NULL,
    ssn CHAR(9),
    phoneNum VARCHAR(30) NOT NULL,
    email VARCHAR(100),
	
    CONSTRAINT People_PK PRIMARY KEY (personID)
);

-- Create the Tenants table

CREATE TABLE IF NOT EXISTS Tenants (
	tenantID INT NOT NULL,
	
    CONSTRAINT Tenants_PK PRIMARY KEY (tenantID),

	CONSTRAINT Tenants_FK1 FOREIGN KEY (tenantID)
            REFERENCES People(personID)
            ON DELETE CASCADE

);

-- Create the PropertyManagers table

CREATE TABLE IF NOT EXISTS PropertyManagers (
	managerID INT NOT NULL,
    stipendAmount DOUBLE,
	
    CONSTRAINT PropertyManagers_PK PRIMARY KEY (managerID),

	CONSTRAINT PropertyManagers_FK1 FOREIGN KEY (managerID)
            REFERENCES People(personID)
            ON DELETE CASCADE

);

-- Create the MaintenanceStaff table

CREATE TABLE IF NOT EXISTS MaintenanceStaff (
	staffID INT NOT NULL,
    jobTitle VARCHAR(30) NOT NULL,
    licenseType VARCHAR(30),
    licenseNum VARCHAR(50),
    hourlyWage DOUBLE NOT NULL,
    hireDate DATE NOT NULL,
	
    CONSTRAINT MaintenanceStaff_PK PRIMARY KEY (staffID),

	CONSTRAINT MaintenanceStaff_FK1 FOREIGN KEY (staffID)
            REFERENCES People(personID)
            ON DELETE CASCADE

);

-- Create the Buildings table

CREATE TABLE IF NOT EXISTS Buildings (
	bldgNum INT NOT NULL,
	bldgName VARCHAR(100),
    streetAddress VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    st CHAR(2),
    postalCode VARCHAR(30),
    country VARCHAR(100),
    bldgPhoneNum VARCHAR(30) NOT NULL,
    bldgEmail VARCHAR(100),

    managedBy_FK INT NOT NULL,
	

    CONSTRAINT Buildings_PK PRIMARY KEY (bldgNum),

    CONSTRAINT Buildings_FK1 FOREIGN KEY (managedBy_FK)
            REFERENCES PropertyManagers(managerID)
            ON DELETE CASCADE

);

-- Create the Apartments table

CREATE TABLE IF NOT EXISTS Apartments (
	aptNum INT NOT NULL,
    floorNum INT,
    sizeArea DOUBLE,
    rentPrice DOUBLE NOT NULL,
    utilityCosts DOUBLE NOT NULL,
    insuranceCosts DOUBLE NOT NULL,
    
    bldgNum_FK INT NOT NULL,

    CONSTRAINT Apartments_PK PRIMARY KEY (aptNum),
    CONSTRAINT Apartments_FK1 FOREIGN KEY (bldgNum_FK)
            REFERENCES Buildings(bldgNum)
            ON DELETE CASCADE

);

-- Create the Leases table

CREATE TABLE IF NOT EXISTS Leases (
	leaseNum INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    rentAmount DOUBLE NOT NULL,
    depositAmount DOUBLE NOT NULL,
    monthsInArrears INT NOT NULL,

    aptNum_FK INT NOT NULL,
    tenantID_FK INT NOT NULL,

    CONSTRAINT Leases_PK PRIMARY KEY (leaseNum),

    CONSTRAINT Leases_FK1 FOREIGN KEY (aptNum_FK)
            REFERENCES Apartments(aptNum)
            ON DELETE CASCADE,

    CONSTRAINT Leases_FK2 FOREIGN KEY (tenantID_FK)
            REFERENCES Tenants(tenantID)
            ON DELETE CASCADE    

);

-- Create the RentPayments table

CREATE TABLE IF NOT EXISTS RentPayments (
	paymentNum INT NOT NULL,
    paymentDate DATE NOT NULL,
    amountPaid DOUBLE NOT NULL,
    amountLate DOUBLE NOT NULL,

    leaseNum_FK INT NOT NULL,

    CONSTRAINT RentPayments_PK PRIMARY KEY (paymentNum),

    CONSTRAINT RentPayments_FK1 FOREIGN KEY (leaseNum_FK)
            REFERENCES Leases(leaseNum)
            ON DELETE CASCADE   

);

-- Create the MaintenanceRequests table

CREATE TABLE IF NOT EXISTS MaintenanceRequests (
	reqNum INT NOT NULL,
    reqDate DATE NOT NULL,
    problem VARCHAR(250) NOT NULL,
    reqType VARCHAR(50),
    resolution VARCHAR(250),
    resolutionDate DATE,
    bExpense DOUBLE,
    tExpense DOUBLE,
    repairDurationHours DOUBLE,

    aptNum_FK INT NOT NULL,
    staffID_FK INT NOT NULL,
    tenantID_FK INT NOT NULL,

    

    CONSTRAINT MaintenanceRequests_PK PRIMARY KEY (reqNum),

    CONSTRAINT MaintenanceRequests_FK1 FOREIGN KEY (aptNum_FK)
            REFERENCES Apartments(aptNum)
            ON DELETE CASCADE,

    CONSTRAINT MaintenanceRequests_FK2 FOREIGN KEY (staffID_FK)
            REFERENCES MaintenanceStaff(staffID)
            ON DELETE CASCADE,    

    CONSTRAINT MaintenanceRequests_FK3 FOREIGN KEY (tenantID_FK)
            REFERENCES Tenants(tenantID)
            ON DELETE CASCADE 

);

-- Insertion of some sample data

-- Insert data into People table
INSERT INTO People (personID, surname, givenName, middleName, dob, idType, idNum, ssn, phoneNum, email)
VALUES
(1, 'Smith', 'John', 'A', '1980-01-15', 'Driver\'s License', 'DL12345678', '123456789', '555-1234', 'john.smith@example.com'),
(2, 'Doe', 'Jane', NULL, '1985-05-20', 'Passport', 'P98765432', '987654321', '555-5678', 'jane.doe@example.com'),
(3, 'Johnson', 'Michael', 'B', '1990-09-10', 'State ID', 'ID34567890', '111223333', '555-8765', 'michael.johnson@example.com'),
(4, 'Williams', 'Susan', 'C', '1975-12-25', 'Driver\'s License', 'DL54321678', '222334444', '555-4321', 'susan.williams@example.com'),
(5, 'Brown', 'Emily', 'D', '1995-03-14', 'Driver\'s License', 'DL67891234', '555666777', '555-2222', 'emily.brown@example.com'),
(6, 'Davis', 'James', 'E', '1988-07-22', 'State ID', 'ID87654321', '888999000', '555-3333', 'james.davis@example.com'),
(7, 'Miller', 'Patricia', 'F', '1992-11-11', 'Passport', 'P55566677', '444555666', '555-4444', 'patricia.miller@example.com'),
(8, 'Wilson', 'Robert', 'G', '1981-04-05', 'Driver\'s License', 'DL99887766', '777888999', '555-5555', 'robert.wilson@example.com');

-- Insert data into Tenants table
INSERT INTO Tenants (tenantID)
VALUES
(1),
(2),
(5),
(6),
(7),
(8);

-- Insert data into PropertyManagers table
INSERT INTO PropertyManagers (managerID, stipendAmount)
VALUES
(3, 2000.00),
(8, 2500.00);

-- Insert data into MaintenanceStaff table
INSERT INTO MaintenanceStaff (staffID, jobTitle, licenseType, licenseNum, hourlyWage, hireDate)
VALUES
(4, 'Electrician', 'Electrician License', 'E123456', 25.50, '2010-06-01'),
(5, 'Plumber', 'Plumbing License', 'P23456789', 30.00, '2012-08-15'),
(6, 'Carpenter', 'Carpentry License', 'C34567890', 28.00, '2015-09-10');

-- Insert data into Buildings table
INSERT INTO Buildings (bldgNum, bldgName, streetAddress, city, st, postalCode, country, bldgPhoneNum, bldgEmail, managedBy_FK)
VALUES
(1, 'Sunset Apartments', '123 Sunset Blvd', 'Springfield', 'IL', '62704', 'USA', '555-0001', 'contact@sunsetapartments.com', 3),
(2, 'Lakeview Towers', '456 Lakeview Rd', 'Springfield', 'IL', '62705', 'USA', '555-0002', 'contact@lakeviewtowers.com', 8),
(3, 'Pine Hill Apartments', '789 Pine Hill', 'Springfield', 'IL', '62706', 'USA', '555-0003', 'contact@pinehillapartments.com', 3);

-- Insert data into Apartments table
INSERT INTO Apartments (aptNum, floorNum, sizeArea, rentPrice, utilityCosts, insuranceCosts, bldgNum_FK)
VALUES
(1, 1, 750, 1200.00, 150.00, 100.00, 1),
(2, 2, 850, 1300.00, 160.00, 110.00, 1),
(3, 1, 700, 1150.00, 140.00, 90.00, 2),
(4, 3, 900, 1400.00, 170.00, 120.00, 2),
(5, 1, 650, 1100.00, 130.00, 85.00, 3),
(6, 2, 800, 1250.00, 160.00, 105.00, 3);

-- Insert data into Leases table
INSERT INTO Leases (leaseNum, startDate, endDate, rentAmount, depositAmount, monthsInArrears, aptNum_FK, tenantID_FK)
VALUES
(1, '2023-01-01', '2023-12-31', 1200.00, 1200.00, 0, 1, 1),
(2, '2023-02-01', '2024-01-31', 1300.00, 1300.00, 1, 2, 2),
(3, '2023-03-01', '2024-02-28', 1150.00, 1150.00, 0, 3, 5),
(4, '2023-04-01', '2024-03-31', 1400.00, 1400.00, 0, 4, 6),
(5, '2023-05-01', '2024-04-30', 1100.00, 1100.00, 0, 5, 7),
(6, '2023-06-01', '2024-05-31', 1250.00, 1250.00, 0, 6, 8);

-- Insert data into RentPayments table
INSERT INTO RentPayments (paymentNum, paymentDate, amountPaid, amountLate, leaseNum_FK)
VALUES
(1, '2023-01-05', 1200.00, 0.00, 1),
(2, '2023-02-05', 1300.00, 0.00, 2),
(3, '2023-03-05', 1150.00, 0.00, 3),
(4, '2023-04-05', 1400.00, 0.00, 4),
(5, '2023-05-05', 1100.00, 0.00, 5),
(6, '2023-06-05', 1250.00, 0.00, 6);

-- Insert data into MaintenanceRequests table
INSERT INTO MaintenanceRequests (reqNum, reqDate, problem, reqType, resolution, resolutionDate, bExpense, tExpense, repairDurationHours, aptNum_FK, staffID_FK, tenantID_FK)
VALUES
(1, '2023-02-15', 'Leaky faucet', 'Plumbing', 'Replaced faucet', '2023-02-16', 50.00, 0.00, 2.0, 1, 5, 1),
(2, '2023-03-10', 'Noisy heating', 'HVAC', 'Fixed heating system', '2023-03-11', 200.00, 0.00, 3.0, 2, 4, 2),
(3, '2023-03-15', 'Broken window', 'Carpentry', 'Replaced window', '2023-03-16', 100.00, 0.00, 4.0, 3, 6, 5),
(4, '2023-04-20', 'Clogged drain', 'Plumbing', 'Cleared drain', '2023-04-21', 80.00, 0.00, 2.5, 4, 5, 6),
(5, '2023-05-10', 'Faulty light switch', 'Electrical', 'Replaced switch', '2023-05-11', 50.00, 0.00, 1.5, 5, 4, 7),
(6, '2023-06-18', 'Leaking roof', 'Roofing', 'Repaired roof', '2023-06-19', 200.00, 0.00, 5.0, 6, 5, 8);

-- Queries

-- 1) Display the surname, given name, and phone numbers of all people in the People table with a driver's license.
SELECT surname, givenName, phoneNum
FROM People
WHERE idType = 'Driver\'s License';

-- 2) Display all maintenance request dates, problems, resolutions, and resolution dates that took longer than 2 hours to complete.
SELECT reqDate, problem, resolution, resolutionDate
FROM MaintenanceRequests
WHERE repairDurationHours > 2.0;

-- 3) Display the average rent payment amount for all payments
SELECT AVG(amountPaid) AS 'Average Payment Amount'
FROM RentPayments;

-- 4) Display the total rent collected in the first quarter (January to March) of 2023
SELECT SUM(amountPaid) AS 'Total amount collected in 2023 Qr 1'
FROM RentPayments
WHERE paymentDate BETWEEN '2023-01-01' AND '2023-03-31';

-- 5) Display the tenants' surnames, given names, and their apartment numbers from the leases
SELECT surname AS 'Surname', givenName AS 'Given Name', aptNum_FK AS 'Apartment Number'
FROM People
INNER JOIN Tenants
ON People.personID = Tenants.tenantID
INNER JOIN Leases
ON Tenants.tenantID = Leases.tenantID_FK;

-- 6) Display the maintenance staff names, phone numbers, their job titles, and licenses.
SELECT surname AS 'Maintenance Surname', givenName AS ' Maintenance Given Name', phoneNum AS 'Phone Number', jobTitle AS 'Job Title', licenseType AS 'License' 
FROM People
INNER JOIN MaintenanceStaff
ON People.personID = MaintenanceStaff.staffID;


-- 7) Insert a new person into the database. Make them a property manager. Display the results to show the change by listing the names, phone numbers, and email addresses of everyone who are property managers.
INSERT INTO People (personID, surname, givenName, middleName, dob, idType, idNum, ssn, phoneNum, email)
VALUES
(9, 'Irizarry', 'Wanda', 'Evette', '1961-09-22', 'Driver\'s License', 'DL9998887776', '111770077', '426-5636', 'lovewandy@fakeemail.com');

INSERT INTO PropertyManagers (managerID, stipendAmount)
VALUES
(9, 8000.00);

SELECT surname AS 'Prop Mgr Surname', givenName AS 'Given Name', middleName AS 'Middle Name', phoneNum AS 'Phone Number', email AS 'E-mail'
FROM People
INNER JOIN PropertyManagers
ON People.personID = PropertyManagers.managerID;

-- 8) Dusplay the ID numbers and names of the property managers.
SELECT personID AS 'Manager ID', surname AS 'Prop Mgr Surname', givenName AS 'Given Name', middleName AS 'Middle Name'
FROM People
INNER JOIN PropertyManagers
ON People.personID = PropertyManagers.managerID;


-- 9) Insert a new building into the database for Wanda Irizarry to manage. Verify the result by displaying the results showing the list of building names, addresses, phone numbers, and manager name
INSERT INTO Buildings (bldgNum, bldgName, streetAddress, city, st, postalCode, country, bldgPhoneNum, bldgEmail, managedBy_FK)
VALUES
(4, 'Fishtown Luxury Lofts', '9354 Crease Street', 'Philadelphia', 'PA', '19125', 'USA', '555-9999', 'ownerwanda@fakefishtownluxlofts.com', 9);

SELECT surname AS 'Manager Surname', givenName AS ' Manager Given Name', bldgName AS 'Building Name', streetAddress AS 'Address', city AS 'City', st AS 'State', postalCode AS 'Postal Code', country AS 'Country', bldgPhoneNum AS 'Bldg Phone', bldgEmail AS 'Bldg E-mail'
FROM People
INNER JOIN PropertyManagers
ON People.personID = PropertyManagers.managerID
INNER JOIN Buildings
ON PropertyManagers.managerID = Buildings.managedBy_FK;


-- 10) Update Wanda Irizarry's surname to 'Irizarry-Nieves'. Verify the change by displaying the contents of the People table.
UPDATE People
SET surname = 'Irizarry-Nieves'
WHERE surname = 'Irizarry' AND personID = 9;

SELECT *
FROM People;

-- 11) Check the current data for lease #6. Update lease #6 to start 2024-06-01 and end 2025-05-31 and change the rent to $1400.00. Verify the change took place.
SELECT *
FROM Leases
WHERE leaseNum = 6;

-- Update the respective values.
UPDATE Leases
SET startDate = '2024-06-01',
endDate = '2025-05-31',
rentAmount = 1400.00
WHERE leaseNum = 6;

SELECT *
FROM Leases
WHERE leaseNum = 6;

-- Alter the MaintenanceRequests table to add the costs of a job.
ALTER TABLE MaintenanceRequests
ADD Cost DECIMAL(10, 2);

-- Set the cost for request #1 to $150.00 and #2 to $200.00.
UPDATE MaintenanceRequests 
SET Cost = 150.00
WHERE reqNum = 1;

UPDATE MaintenanceRequests
SET Cost = 200.00
WHERE reqNum = 2;

-- Create a View to display revenue, expenses, and profit/loss
CREATE VIEW FinancialReport AS
SELECT 
    (SELECT COALESCE(SUM(amountPaid), 0) FROM RentPayments) AS TotalRevenue,
    (SELECT COALESCE(SUM(Cost), 0) FROM MaintenanceRequests) AS TotalExpenses,
    (
        (SELECT COALESCE(SUM(amountPaid), 0) FROM RentPayments) -
        (SELECT COALESCE(SUM(Cost), 0) FROM MaintenanceRequests)
    ) AS ProfitOrLoss;

-- Enter some example payments
INSERT INTO RentPayments (paymentNum, paymentDate, amountPaid, amountLate, leaseNum_FK)
VALUES 
(7, '2023-02-01', 1200.00, 0.00, 1),
(8, '2023-02-05', 1500.00, 0.00, 2);

-- Example Maintenance Costs
INSERT INTO MaintenanceRequests (reqNum, reqDate, problem, reqType, resolution, resolutionDate, bExpense, tExpense, repairDurationHours, aptNum_FK, staffID_FK, tenantID_FK, Cost)
VALUES
(7, '2023-02-15', 'Leaking faucet in the kitchen', 'plumbing', 'Resolved', '2023-02-15', 0.00, 0.00, 2, 1, 5, 1, 100.00),
(8, '2023-03-10', 'Air conditioning not working', 'HVAC', 'Resolved', '2023-03-10', 0.00, 0.00, 3, 2, 4, 2, 200.00);


-- Query the financial report view
SELECT *
FROM FinancialReport;

