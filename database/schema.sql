-- ============================================
-- Child Vaccination Management System
-- MSSQL Database Schema - V2.3 (English Vaccines, Unaccented Names, ImageUrls)
-- ============================================

-- Step 1: Drop existing database if exists
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VaccinationDB')
BEGIN
    ALTER DATABASE VaccinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VaccinationDB;
    PRINT 'Old database dropped.';
END
GO

-- Step 2: Create new database
CREATE DATABASE VaccinationDB;
GO

PRINT 'New database created.';
GO

USE VaccinationDB;
GO

-- Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('ADMIN', 'RECEPTION', 'MEDICAL', 'PARENT')),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    LastLogin DATETIME,
    ImageUrl NVARCHAR(500) NULL,
    INDEX idx_email (Email),
    INDEX idx_role (Role)
);
GO

-- Centers Table
CREATE TABLE Centers (
    CenterID INT IDENTITY(1,1) PRIMARY KEY,
    CenterName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    City NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    OperatingHours NVARCHAR(200),
    Capacity INT DEFAULT 50,
    CreatedAt DATETIME DEFAULT GETDATE(),
    INDEX idx_active (IsActive)
);
GO

-- Vaccines Table
CREATE TABLE Vaccines (
    VaccineID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineName NVARCHAR(200) NOT NULL, -- English Name
    Manufacturer NVARCHAR(200),
    Description NVARCHAR(MAX), -- English Description
    DiseasesPrevented NVARCHAR(500),
    DosageSchedule NVARCHAR(500),
    RecommendedAge NVARCHAR(100),
    Price DECIMAL(10,2) DEFAULT 0,
    IsFree BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    SideEffects NVARCHAR(MAX),
    Contraindications NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    ImageUrl NVARCHAR(500) NULL,
    INDEX idx_active (IsActive),
    INDEX idx_free (IsFree)
);
GO

-- Children Table
CREATE TABLE Children (
    ChildID INT IDENTITY(1,1) PRIMARY KEY,
    ParentID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    BloodType NVARCHAR(10),
    MedicalHistory NVARCHAR(MAX),
    Allergies NVARCHAR(MAX),
    Weight DECIMAL(5,2),
    Height DECIMAL(5,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ParentID) REFERENCES Users(UserID) ON DELETE CASCADE,
    INDEX idx_parent (ParentID),
    INDEX idx_dob (DateOfBirth)
);
GO

-- Vaccine Stock Table
CREATE TABLE VaccineStock (
    StockID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineID INT NOT NULL,
    CenterID INT NOT NULL,
    BatchNumber NVARCHAR(100) NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    ExpiryDate DATE NOT NULL,
    ReceivedDate DATE DEFAULT CAST(GETDATE() AS DATE),
    Status NVARCHAR(20) CHECK (Status IN ('AVAILABLE', 'RESERVED', 'EXPIRED', 'DEPLETED')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_center_vaccine (CenterID, VaccineID),
    INDEX idx_expiry (ExpiryDate)
);
GO

-- Working Schedule Table
CREATE TABLE WorkingSchedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    CenterID INT NOT NULL,
    DayOfWeek NVARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    SlotDuration INT DEFAULT 30,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_center_day (CenterID, DayOfWeek)
);
GO

-- Staff Assignments Table
CREATE TABLE StaffAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CenterID INT NOT NULL,
    AssignedDate DATE DEFAULT CAST(GETDATE() AS DATE),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    INDEX idx_staff_center (UserID, CenterID)
);
GO

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    ChildID INT NOT NULL,
    VaccineID INT NOT NULL,
    CenterID INT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NULL,
    Status NVARCHAR(20) DEFAULT 'PENDING' CHECK (Status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'REJECTED', 'NO_SHOW')),
    PaymentStatus NVARCHAR(20) DEFAULT 'UNPAID' CHECK (PaymentStatus IN ('UNPAID', 'PAID', 'REFUNDED', 'FREE')),
    PaymentAmount DECIMAL(10,2) NULL,
    Notes NVARCHAR(MAX),
    ConfirmedBy INT NULL,
    ConfirmedAt DATETIME NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ChildID) REFERENCES Children(ChildID) ON DELETE CASCADE,
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (CenterID) REFERENCES Centers(CenterID),
    FOREIGN KEY (ConfirmedBy) REFERENCES Users(UserID),
    INDEX idx_child_vaccine_date (ChildID, VaccineID, AppointmentDate),
    INDEX idx_status (Status)
);
GO

-- Vaccination Records Table
CREATE TABLE VaccinationRecords (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    ChildID INT NOT NULL,
    VaccineID INT NOT NULL,
    VaccinationDate DATETIME NOT NULL,
    BatchNumber NVARCHAR(100) NULL,
    DoseNumber INT NULL,
    AdministeredBy INT NOT NULL,
    HealthCheckNotes NVARCHAR(MAX) NULL,
    VaccinationNotes NVARCHAR(MAX) NULL,
    SideEffectsReported NVARCHAR(MAX) NULL,
    NextDoseDate DATE NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (ChildID) REFERENCES Children(ChildID),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    FOREIGN KEY (AdministeredBy) REFERENCES Users(UserID),
    INDEX idx_child_vaccine (ChildID, VaccineID),
    INDEX idx_vaccination_date (VaccinationDate)
);
GO

-- Notifications Table
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) CHECK (Type IN ('REMINDER', 'CONFIRMATION', 'CANCELLATION', 'UPDATE', 'SYSTEM', 'NEXT_DOSE')),
    IsRead BIT DEFAULT 0,
    RelatedAppointmentID INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    ReadAt DATETIME NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID), -- Removed ON DELETE CASCADE
    FOREIGN KEY (RelatedAppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE SET NULL,
    INDEX idx_user_read (UserID, IsRead)
);
GO

-- Vaccination Schedule Template
CREATE TABLE VaccinationScheduleTemplate (
    TemplateID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineID INT NOT NULL,
    StageName NVARCHAR(200) NOT NULL,
    AgeInMonths DECIMAL(5,2) NOT NULL,
    DoseNumber INT NOT NULL,
    Description NVARCHAR(MAX),
    IsMandatory BIT DEFAULT 1,
    DisplayOrder INT,
    CanCombineWith NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID),
    INDEX idx_age_mandatory (AgeInMonths, IsMandatory),
    INDEX idx_vaccine (VaccineID)
);
GO

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- Insert Default Admin User
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive, ImageUrl)
VALUES ('admin@vaccination.com', 'Admin@123', 'System Administrator', '0900000000', 'ADMIN', 1, '/images/users/admin.jpg');
GO

-- Insert Sample Centers
INSERT INTO Centers (CenterName, Address, City, PhoneNumber, Email, OperatingHours, IsActive) VALUES
('District 1 Medical Center', '123 Le Loi, District 1', 'Ho Chi Minh', '0283822222', 'q1@health.gov.vn', 'Mon-Sat: 7:00-17:00', 1),
('Children Hospital 1', '341 Su Van Hanh, District 10', 'Ho Chi Minh', '0283865100', 'nhi1@health.gov.vn', 'Mon-Sun: 7:00-20:00', 1),
('HCMC Preventive Medicine Center', '159 Hung Phu, District 8', 'Ho Chi Minh', '0283855555', 'yte-dp@health.gov.vn', 'Mon-Fri: 7:00-16:30', 1);
GO

-- Insert Vaccines (FREE - English Names & Descriptions)
PRINT 'Inserting Free Vaccines...';
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, DosageSchedule, RecommendedAge, Price, IsFree, IsActive, ImageUrl) VALUES
('Hepatitis B (Newborn)', 'Vabiotech', 'Hepatitis B vaccine for newborns.', 'Hepatitis B', 'Inject within the first 24 hours after birth.', '0-24 hours', 0, 1, 1, '/images/vaccines/viem-gan-b-so-sinh.jpg'),
('Tuberculosis (BCG)', 'Vabiotech', 'Vaccine against Tuberculosis.', 'Tuberculosis (TB)', 'Inject 1 dose, as soon as possible after birth.', '0-1 month', 0, 1, 1, '/images/vaccines/lao-bcg.jpg'),
('5-in-1 (Quinvaxem/ComBE Five)', 'SII/Biological E', 'Combination vaccine against Diphtheria, Pertussis, Tetanus, Hepatitis B, Hib (Dose 1).', 'Diphtheria, Pertussis, Tetanus, Hib, Hepatitis B', 'Dose 1 at 2 months old.', '2 months', 0, 1, 1, '/images/vaccines/5-trong-1.jpg'),
('5-in-1 (Dose 2)', 'SII/Biological E', 'Combination vaccine against Diphtheria, Pertussis, Tetanus, Hepatitis B, Hib (Dose 2).', 'Diphtheria, Pertussis, Tetanus, Hib, Hepatitis B', 'Dose 2 at 3 months old (min. 1 month after dose 1).', '3 months', 0, 1, 1, '/images/vaccines/5-trong-1.jpg'),
('5-in-1 (Dose 3)', 'SII/Biological E', 'Combination vaccine against Diphtheria, Pertussis, Tetanus, Hepatitis B, Hib (Dose 3).', 'Diphtheria, Pertussis, Tetanus, Hib, Hepatitis B', 'Dose 3 at 4 months old (min. 1 month after dose 2).', '4 months', 0, 1, 1, '/images/vaccines/5-trong-1.jpg'),
('Oral Polio (OPV Dose 1)', 'Polio Sabin', 'Oral Polio vaccine, dose 1 (usually given with 5-in-1 dose 1).', 'Poliomyelitis', 'Dose 1 at 2 months old.', '2 months', 0, 1, 1, '/images/vaccines/bai-liet-opv.jpg'),
('Oral Polio (OPV Dose 2)', 'Polio Sabin', 'Oral Polio vaccine, dose 2 (usually given with 5-in-1 dose 2).', 'Poliomyelitis', 'Dose 2 at 3 months old.', '3 months', 0, 1, 1, '/images/vaccines/bai-liet-opv.jpg'),
('Oral Polio (OPV Dose 3)', 'Polio Sabin', 'Oral Polio vaccine, dose 3 (usually given with 5-in-1 dose 3).', 'Poliomyelitis', 'Dose 3 at 4 months old.', '4 months', 0, 1, 1, '/images/vaccines/bai-liet-opv.jpg'),
('Inactivated Polio (IPV)', 'Sanofi/GSK', 'Inactivated Polio vaccine (injectable, 1 dose only).', 'Poliomyelitis', 'Inject 1 dose at 5 months old.', '5 months', 0, 1, 1, '/images/vaccines/bai-liet-ipv.jpg'),
('Measles (MVVac)', 'Polyvac', 'Measles vaccine (Dose 1).', 'Measles', 'Inject 1 dose at 9 months old.', '9 months', 0, 1, 1, '/images/vaccines/soi-mvvac.jpg'),
('Japanese Encephalitis (Jevax)', 'Vabiotech', 'Japanese Encephalitis B vaccine (Dose 1).', 'Japanese Encephalitis B', 'Inject dose 1 at 12 months old.', '12 months', 0, 1, 1, '/images/vaccines/viem-nao-nhat-ban-jevax.jpg'),
('Japanese Encephalitis (Dose 2)', 'Vabiotech', 'Japanese Encephalitis B vaccine (Dose 2).', 'Japanese Encephalitis B', 'Inject dose 2 1-2 weeks after dose 1.', '~12.5 months', 0, 1, 1, '/images/vaccines/viem-nao-nhat-ban-jevax.jpg'),
('Measles - Rubella (MR)', 'Polyvac', 'Combination vaccine against Measles and Rubella (Measles dose 2).', 'Measles, Rubella', 'Inject 1 dose at 18 months old.', '18 months', 0, 1, 1, '/images/vaccines/soi-rubella-mr.jpg'),
('5-in-1 (Dose 4 - Booster)', 'SII/Biological E', 'Combination Diphtheria, Pertussis, Tetanus, Hepatitis B, Hib (Booster dose).', 'Diphtheria, Pertussis, Tetanus, Hib, Hepatitis B', 'Booster injection at 18 months old (min. 6 months after dose 3).', '18 months', 0, 1, 1, '/images/vaccines/5-trong-1.jpg'),
('Japanese Encephalitis (Dose 3)', 'Vabiotech', 'Japanese Encephalitis B vaccine (Dose 3).', 'Japanese Encephalitis B', 'Inject dose 3 one year after dose 2.', '24 months', 0, 1, 1, '/images/vaccines/viem-nao-nhat-ban-jevax.jpg'),
('Diphtheria - Tetanus (Td)', 'Vabiotech', 'Reduced dose Diphtheria - Tetanus vaccine (Booster).', 'Diphtheria, Tetanus', 'Booster injection for school-aged children (usually 7 years old).', '7 years', 0, 1, 1, '/images/vaccines/bach-hau-uon-van-td.jpg');
GO

-- Insert Vaccines (PAID - English Names & Descriptions)
PRINT 'Inserting Paid Vaccines...';
INSERT INTO Vaccines (VaccineName, Manufacturer, Description, DiseasesPrevented, DosageSchedule, RecommendedAge, Price, IsFree, IsActive, ImageUrl) VALUES
('6-in-1 (Infanrix Hexa)', 'GSK', 'Combination vaccine: Diphtheria, Tetanus, Pertussis, Polio, Hib, Hepatitis B.', 'Diphtheria, Pertussis, Tetanus, Polio, Hib, Hepatitis B', 'Primary series: 3 doses at 2, 3, 4 months. Booster at 18 months.', '2, 3, 4, 18 months', 1015000, 0, 1, '/images/vaccines/6-trong-1-infanrix.jpg'),
('6-in-1 (Hexaxim)', 'Sanofi Pasteur', 'Combination vaccine: Diphtheria, Tetanus, Pertussis, Polio, Hib, Hepatitis B.', 'Diphtheria, Pertussis, Tetanus, Polio, Hib, Hepatitis B', 'Primary series: 3 doses at 2, 3, 4 months. Booster at 18 months.', '2, 3, 4, 18 months', 1010000, 0, 1, '/images/vaccines/6-trong-1-hexaxim.jpg'),
('Rotavirus (Rotarix)', 'GSK', 'Oral vaccine against Rotavirus gastroenteritis (strain G1P[8]).', 'Rotavirus Diarrhea', '2 oral doses. First dose at 6 weeks, second dose min. 4 weeks later. Complete before 6 months old.', 'From 6 weeks old', 850000, 0, 1, '/images/vaccines/rota-rotarix.jpg'),
('Rotavirus (Rotateq)', 'Merck Sharp & Dohme', 'Oral vaccine against Rotavirus gastroenteritis (5 strains G1-G4, P[8]).', 'Rotavirus Diarrhea', '3 oral doses. First dose at 7.5-12 weeks, subsequent doses 4-10 weeks apart. Complete before 32 weeks old.', 'From 7.5 weeks old', 750000, 0, 1, '/images/vaccines/rota-rotateq.jpg'),
('Pneumococcal (Prevenar 13)', 'Pfizer', 'Vaccine against diseases caused by Pneumococcus (13 strains), like pneumonia, meningitis, otitis media.', 'Pneumococcal Pneumonia, Meningitis, Otitis Media', 'Schedule depends on age at first dose. <6m: 3+1. 7-11m: 2+1. 12-23m: 2 doses. >24m: 1 dose.', 'From 6 weeks old', 1280000, 0, 1, '/images/vaccines/phe-cau-prevenar13.jpg'),
('Pneumococcal (Synflorix)', 'GSK', 'Vaccine against diseases caused by Pneumococcus (10 strains).', 'Pneumococcal Pneumonia, Meningitis, Otitis Media', 'Schedule similar to Prevenar 13, depending on age at start.', 'From 6 weeks - 5 years old', 990000, 0, 1, '/images/vaccines/phe-cau-synflorix.jpg'),
('Seasonal Flu (Vaxigrip Tetra/Influvac Tetra)', 'Sanofi/Abbott', 'Vaccine against seasonal influenza (4 strains).', 'Seasonal Influenza', 'Children 6m-9y (first time): 2 doses 1 month apart, then 1 dose annually. >9y and adults: 1 dose annually.', 'From 6 months old', 350000, 0, 1, '/images/vaccines/cum-tetra.jpg'),
('Measles - Mumps - Rubella (MMR II)', 'Merck Sharp & Dohme', 'Combination vaccine against Measles, Mumps, Rubella.', 'Measles, Mumps, Rubella', 'Dose 1 at 12-15 months. Dose 2 at 4-6 years (or min. 1 month after dose 1).', 'From 12 months old', 380000, 0, 1, '/images/vaccines/mmr-ii.jpg'),
('Measles - Mumps - Rubella (Priorix)', 'GSK', 'Combination vaccine against Measles, Mumps, Rubella.', 'Measles, Mumps, Rubella', 'Schedule similar to MMR II.', 'From 12 months old', 390000, 0, 1, '/images/vaccines/mmr-priorix.jpg'),
('Chickenpox (Varivax)', 'Merck Sharp & Dohme', 'Vaccine against Chickenpox (Varicella).', 'Chickenpox', 'Children 12m-12y: 2 doses min. 3 months apart. >13y: 2 doses min. 1 month apart.', 'From 12 months old', 900000, 0, 1, '/images/vaccines/thuy-dau-varivax.jpg'),
('Chickenpox (Varilrix)', 'GSK', 'Vaccine against Chickenpox (Varicella).', 'Chickenpox', 'Children 9m-12y: 2 doses min. 3 months apart. >13y: 2 doses min. 1 month apart.', 'From 9 months old', 850000, 0, 1, '/images/vaccines/thuy-dau-varilrix.jpg'),
('Hepatitis A (Avaxim)', 'Sanofi Pasteur', 'Vaccine against Hepatitis A.', 'Hepatitis A', 'Children 12m-15y: 2 doses 6-18 months apart.', 'From 12 months old', 600000, 0, 1, '/images/vaccines/viem-gan-a-avaxim.jpg'),
('Hepatitis A+B (Twinrix)', 'GSK', 'Combination vaccine against Hepatitis A and Hepatitis B.', 'Hepatitis A, Hepatitis B', 'Schedule: 3 doses at 0, 1, 6 months.', 'From 1 year old', 700000, 0, 1, '/images/vaccines/viem-gan-ab-twinrix.jpg'),
('Meningococcal BC (VA-Mengoc-BC)', 'Finlay Institute', 'Vaccine against Meningitis caused by Meningococcus types B and C.', 'Meningococcal Meningitis (B, C)', 'Inject 2 doses 6-8 weeks apart.', 'From 6 months old', 400000, 0, 1, '/images/vaccines/nao-mo-cau-bc-mengoc.jpg'),
('Meningococcal ACYW-135 (Menactra)', 'Sanofi Pasteur', 'Vaccine against Meningitis caused by Meningococcus types A, C, Y, W-135.', 'Meningococcal Meningitis (A, C, Y, W-135)', 'Children 9-23m: 2 doses 3 months apart. >2y: 1 single dose.', 'From 9 months old', 1350000, 0, 1, '/images/vaccines/nao-mo-cau-acyw-menactra.jpg'),
('HPV (Gardasil)', 'Merck Sharp & Dohme', 'Vaccine against Cervical Cancer and diseases caused by HPV (4 types 6, 11, 16, 18).', 'Cervical Cancer, Genital Warts, diseases by HPV 6, 11, 16, 18', 'Females 9-26 years old. Schedule: 3 doses at 0, 2, 6 months.', '9-26 years (Female)', 1800000, 0, 1, '/images/vaccines/hpv-gardasil.jpg');
GO

-- Insert Vaccination Schedule Template
PRINT 'Inserting Schedule Templates...';
-- Lấy ID động
DECLARE @vgbID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Hepatitis B (Newborn)%');
DECLARE @bcgID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Tuberculosis (BCG)%');
DECLARE @5in1_1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE '5-in-1 (Quinvaxem/ComBE Five)%');
DECLARE @opv1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Oral Polio (OPV Dose 1)%');
DECLARE @ipvID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Inactivated Polio (IPV)%');
DECLARE @soi1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Measles (MVVac)%');
DECLARE @vnnB1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Japanese Encephalitis (Jevax)');
DECLARE @mrID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Measles - Rubella (MR)%');
DECLARE @5in1_4ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE '5-in-1 (Dose 4%');
DECLARE @tdID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Diphtheria - Tetanus (Td)%');
DECLARE @rota1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Rotavirus (Rotarix)%');
DECLARE @phecau1ID INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Pneumococcal (Prevenar 13)%');

INSERT INTO VaccinationScheduleTemplate (VaccineID, StageName, AgeInMonths, DoseNumber, Description, IsMandatory, DisplayOrder, CanCombineWith) VALUES
(@vgbID, 'Newborn (0-24 hours)', 0, 1, 'Inject 1 dose within first 24 hours', 1, 1, CAST(@bcgID AS VARCHAR)),
(@bcgID, 'Newborn (within 1 month)', 0.5, 1, 'Inject 1 dose (min. 24h after HepB)', 1, 2, CAST(@vgbID AS VARCHAR)),
(@5in1_1ID, '2 months old', 2, 1, 'Dose 1 (EPI)', 1, 3, CAST(@opv1ID AS VARCHAR) + ',' + ISNULL(CAST(@rota1ID AS VARCHAR),'') + ',' + ISNULL(CAST(@phecau1ID AS VARCHAR),'')),
(@opv1ID, '2 months old', 2, 1, 'Dose 1 (Oral - EPI)', 1, 4, CAST(@5in1_1ID AS VARCHAR)),
(@rota1ID, '2 months old', 2, 1, 'Dose 1 (Oral - Optional)', 0, 5, CAST(@5in1_1ID AS VARCHAR) + ',' + ISNULL(CAST(@phecau1ID AS VARCHAR),'')),
(@phecau1ID, '2 months old', 2, 1, 'Dose 1 (Injectable - Optional)', 0, 6, CAST(@5in1_1ID AS VARCHAR) + ',' + ISNULL(CAST(@rota1ID AS VARCHAR),'')),
-- ... (Thêm đầy đủ các lịch tiêm khác tương tự) ...
(@tdID, '7 years old', 84, 1, 'Booster (EPI)', 1, 20, NULL);
GO

-- Insert Sample Users (Unaccented Vietnamese Names)
PRINT 'Inserting Sample Users...';
INSERT INTO Users (Email, Password, FullName, PhoneNumber, Role, IsActive, ImageUrl) VALUES
('parent1@test.com', '123456', 'Nguyen Van An', '0901234567', 'PARENT', 1, '/images/users/parent1.jpg'),
('parent2@test.com', '123456', 'Tran Thi Binh', '0909876543', 'PARENT', 1, '/images/users/parent2.jpg'),
('parent3@test.com', '123456', 'Le Hoang Cuong', '0903456789', 'PARENT', 1, '/images/users/parent3.jpg'),
('reception1@test.com', '123456', 'Pham Minh Duc', '0912345678', 'RECEPTION', 1, '/images/users/reception1.jpg'),
('reception2@test.com', '123456', 'Vo Thi Em', '0913456789', 'RECEPTION', 1, '/images/users/reception2.jpg'),
('doctor1@test.com', '123456', 'Bac si Hoang Thi Hoa', '0923456789', 'MEDICAL', 1, '/images/users/doctor1.jpg'),
('doctor2@test.com', '123456', 'Bac si Dang Van Khoa', '0924567890', 'MEDICAL', 1, '/images/users/doctor2.jpg'),
('doctor3@test.com', '123456', 'Bac si Tran Ngoc Lan', '0925678901', 'MEDICAL', 1, '/images/users/doctor3.jpg');
GO

-- Insert Working Schedule
PRINT 'Inserting Working Schedules...';
INSERT INTO WorkingSchedule (CenterID, DayOfWeek, StartTime, EndTime, SlotDuration, IsActive) VALUES
(1, 'Monday', '07:30', '17:00', 15, 1), (1, 'Tuesday', '07:30', '17:00', 15, 1), (1, 'Wednesday', '07:30', '17:00', 15, 1),
(1, 'Thursday', '07:30', '17:00', 15, 1), (1, 'Friday', '07:30', '17:00', 15, 1), (1, 'Saturday', '08:00', '12:00', 15, 1),
(2, 'Monday', '07:00', '20:00', 20, 1), (2, 'Tuesday', '07:00', '20:00', 20, 1), (2, 'Wednesday', '07:00', '20:00', 20, 1),
(2, 'Thursday', '07:00', '20:00', 20, 1), (2, 'Friday', '07:00', '20:00', 20, 1), (2, 'Saturday', '07:00', '17:00', 20, 1), (2, 'Sunday', '08:00', '12:00', 20, 1),
(3, 'Monday', '07:00', '16:30', 30, 1), (3, 'Tuesday', '07:00', '16:30', 30, 1), (3, 'Wednesday', '07:00', '16:30', 30, 1),
(3, 'Thursday', '07:00', '16:30', 30, 1), (3, 'Friday', '07:00', '16:30', 30, 1);
GO

-- Insert Staff Assignments
PRINT 'Inserting Staff Assignments...';
DECLARE @reception1ID INT = (SELECT UserID FROM Users WHERE Email = 'reception1@test.com');
DECLARE @reception2ID INT = (SELECT UserID FROM Users WHERE Email = 'reception2@test.com');
DECLARE @doctor1ID INT = (SELECT UserID FROM Users WHERE Email = 'doctor1@test.com');
DECLARE @doctor2ID INT = (SELECT UserID FROM Users WHERE Email = 'doctor2@test.com');
DECLARE @doctor3ID INT = (SELECT UserID FROM Users WHERE Email = 'doctor3@test.com');

INSERT INTO StaffAssignments (UserID, CenterID, IsActive) VALUES
(@reception1ID, 1, 1),
(@reception2ID, 2, 1),
(@doctor1ID, 1, 1),
(@doctor2ID, 2, 1),
(@doctor3ID, 3, 1);
GO

-- Insert Sample Vaccine Stock
PRINT 'Inserting Vaccine Stock...';
DECLARE @vgbID_stock INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Hepatitis B (Newborn)%');
DECLARE @bcgID_stock INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE 'Tuberculosis (BCG)%');
DECLARE @5in1ID_stock INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE '5-in-1 (Quinvaxem/ComBE Five)%');
DECLARE @6in1InfanrixID_stock INT = (SELECT VaccineID FROM Vaccines WHERE VaccineName LIKE '6-in-1 (Infanrix Hexa)%');

INSERT INTO VaccineStock (VaccineID, CenterID, BatchNumber, Quantity, ExpiryDate, Status) VALUES
(@vgbID_stock, 1, 'VGB2025001', 500, '2026-12-31', 'AVAILABLE'),
(@bcgID_stock, 1, 'BCG2025001', 300, '2026-06-30', 'AVAILABLE'),
(@5in1ID_stock, 1, '5IN12025001A', 400, '2026-08-31', 'AVAILABLE'),
(@6in1InfanrixID_stock, 1, 'INFANRIX2025XYZ', 200, '2027-01-31', 'AVAILABLE'),
(@vgbID_stock, 2, 'VGB2025002', 600, '2026-12-31', 'AVAILABLE'),
(@5in1ID_stock, 2, '5IN12025002B', 500, '2026-09-30', 'AVAILABLE'),
(@6in1InfanrixID_stock, 2, 'INFANRIX2025ABC', 300, '2027-02-28', 'AVAILABLE');
GO

PRINT '===================================================================';
PRINT ' Database setup completed with English names & placeholder ImageUrls! ';
PRINT ' Please add actual image files to /images/vaccines/ and /images/users/. ';
PRINT '===================================================================';
GO