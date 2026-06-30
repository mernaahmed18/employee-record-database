-- Create the database
CREATE DATABASE IF NOT EXISTS employeeRecord;

-- Use the database
USE employeeRecord;

-- Create the Department table first as it is referenced by the Employee table
CREATE TABLE IF NOT EXISTS Department (
    Department_ID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Create the Employee table
CREATE TABLE IF NOT EXISTS Employee (
    Emp_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    SEX CHAR(1),
    Phone VARCHAR(20),
    Address VARCHAR(200),
    Date_of_Birth DATE,
    E_mail VARCHAR(100),
    Department_ID INT,
    Manager_ID INT,
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID)
);

-- Create the Position table (Fixed spelling from Postion to Position)
CREATE TABLE IF NOT EXISTS Position (
    Position_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT
);

-- Create the Project table (Added Project_Name)
CREATE TABLE IF NOT EXISTS Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100),
    Manager_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID)
);

-- Create the Employee_Project table for many-to-many relationship between Employee and Project
CREATE TABLE IF NOT EXISTS Employee_Project (
    Emp_ID INT,
    Project_ID INT,
    PRIMARY KEY (Emp_ID, Project_ID),
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

-- Create the Attendance table
CREATE TABLE IF NOT EXISTS Attendance (
    Att_ID INT PRIMARY KEY,
    Emp_ID INT,
    Date DATE,
    Check_in TIME,
    Check_out TIME,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
);

-- Create the Salary table
CREATE TABLE IF NOT EXISTS Salary (
    Salary_ID INT PRIMARY KEY,
    Emp_ID INT,
    Base DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Deduction DECIMAL(10,2),
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
);

-- Create the Job History table (Updated foreign key to reference Position)
CREATE TABLE IF NOT EXISTS Job_History (
    History_ID INT PRIMARY KEY,
    Emp_ID INT,
    Position_ID INT,
    Start_date DATE,
    End_date DATE,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Position_ID) REFERENCES Position(Position_ID)
);

-- Create Leave Request table
CREATE TABLE IF NOT EXISTS Leave_Request (
    Leave_ID INT PRIMARY KEY,
    Emp_ID INT,
    Leave_Type VARCHAR(50),
    Start_Date DATE,
    End_Date DATE,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
);

-- Create Performance Review table
CREATE TABLE IF NOT EXISTS Performance_Review (
    Review_ID INT PRIMARY KEY,
    Emp_ID INT,
    Reviewer_ID INT,
    Review_Date DATE,
    Score INT CHECK (Score BETWEEN 1 AND 5),
    Comments TEXT,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Reviewer_ID) REFERENCES Employee(Emp_ID)
);

-- ==========================================
-- TEST DATA (Mock data to verify the logic)
-- ==========================================

-- 1. Insert Departments
INSERT IGNORE INTO Department (Department_ID, Name) VALUES 
(1, 'Human Resources'),
(2, 'Information Technology');

-- 2. Insert Employees (Manager first, then subordinate)
INSERT IGNORE INTO Employee (Emp_ID, Name, SEX, Phone, Address, Date_of_Birth, E_mail, Department_ID, Manager_ID) VALUES 
(1, 'Alice Smith', 'F', '123-456-7890', '123 Corporate Blvd', '1985-04-12', 'alice.smith@example.com', 2, NULL),
(2, 'Bob Johnson', 'M', '987-654-3210', '456 Tech Lane', '1990-08-22', 'bob.johnson@example.com', 2, 1);

-- 3. Insert Positions
INSERT IGNORE INTO Position (Position_ID, Title, Description) VALUES 
(1, 'IT Manager', 'Oversees the IT department and projects.'),
(2, 'Software Engineer', 'Develops and maintains software applications.');

-- 4. Insert Job History
INSERT IGNORE INTO Job_History (History_ID, Emp_ID, Position_ID, Start_date, End_date) VALUES 
(1, 1, 1, '2020-01-15', NULL),
(2, 2, 2, '2022-03-01', NULL);

-- 5. Insert Projects
INSERT IGNORE INTO Project (Project_ID, Project_Name, Manager_ID) VALUES 
(1, 'Cloud Migration', 1),
(2, 'Internal HR App', 1);

-- 6. Insert Employee_Project associations
INSERT IGNORE INTO Employee_Project (Emp_ID, Project_ID) VALUES 
(1, 1),
(2, 1),
(2, 2);

-- 7. Insert Salaries
INSERT IGNORE INTO Salary (Salary_ID, Emp_ID, Base, Bonus, Deduction) VALUES 
(1, 1, 95000.00, 5000.00, 0.00),
(2, 2, 75000.00, 3000.00, 0.00);

-- 8. Insert Attendance
INSERT IGNORE INTO Attendance (Att_ID, Emp_ID, Date, Check_in, Check_out) VALUES 
(1, 1, CURDATE(), '08:50:00', '17:10:00'),
(2, 2, CURDATE(), '09:05:00', '17:00:00');

-- 9. Insert Leave Requests
INSERT IGNORE INTO Leave_Request (Leave_ID, Emp_ID, Leave_Type, Start_Date, End_Date, Status) VALUES 
(1, 2, 'Sick Leave', '2023-11-10', '2023-11-11', 'Approved');

-- 10. Insert Performance Reviews
INSERT IGNORE INTO Performance_Review (Review_ID, Emp_ID, Reviewer_ID, Review_Date, Score, Comments) VALUES 
(1, 2, 1, '2023-12-01', 4, 'Good performance, meets expectations.');

-- ==========================================
-- VIEWS FOR REPORTING
-- ==========================================

-- View: Employee Details with Department
CREATE OR REPLACE VIEW vw_EmployeeDetails AS
SELECT e.Emp_ID, e.Name, d.Name AS Department, e.E_mail
FROM Employee e
LEFT JOIN Department d ON e.Department_ID = d.Department_ID;

-- View: Department Employee Count
CREATE OR REPLACE VIEW vw_DepartmentSummary AS
SELECT d.Name AS Department, COUNT(e.Emp_ID) AS Total_Employees
FROM Department d
LEFT JOIN Employee e ON d.Department_ID = e.Department_ID
GROUP BY d.Name;

-- ==========================================
-- QUERIES TO VERIFY
-- ==========================================
SELECT * FROM Employee;
SELECT * FROM Project;
SELECT e.Name AS Employee_Name, p.Project_Name
FROM Employee e
JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
JOIN Project p ON ep.Project_ID = p.Project_ID;