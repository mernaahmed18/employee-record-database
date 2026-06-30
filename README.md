# Employee Record Database

## Description
A comprehensive relational database schema designed to manage employee records, organizational structures, and HR processes. This project is built for MySQL and includes all necessary tables, relationships, sample data, and analytical views to jumpstart an HR management system.

## Features
- **Core HR Data**: Manage employees, departments, and positions.
- **Projects & Assignments**: Track projects and the employees assigned to them (many-to-many relationships).
- **Payroll & Attendance**: Track employee salaries, deductions, and daily check-ins/check-outs.
- **Leave Management**: Log and manage employee time-off requests.
- **Performance Reviews**: Record performance ratings and managerial feedback.
- **Reporting Views**: Pre-built SQL views (`vw_EmployeeDetails` and `vw_DepartmentSummary`) for instant reporting and analytics.

## Files Included
- `employee record.sql`: The main SQL script containing all `CREATE TABLE` statements, `INSERT` queries for sample data, and `CREATE VIEW` statements.
- `project.mwb` / `project.mwb.bak`: MySQL Workbench model files for visual database design.

## How to Use
1. Open **MySQL Workbench**.
2. Connect to your local or remote MySQL server.
3. Open the `employee record.sql` file.
4. Execute the script (click the lightning bolt icon).
5. The script will automatically create the `employeeRecord` database, build all the tables, insert sample mock data, and generate reporting views.
