SET SERVEROUTPUT ON;

-- Drop table if exists (optional, ignore error if first time)
DROP TABLE employee;

-- Create table
CREATE TABLE employee (
emp_id NUMBER PRIMARY KEY,
emp_name VARCHAR2(20),
salary NUMBER
);

-- Insert data
INSERT INTO employee VALUES (1,'Alice',30000);
INSERT INTO employee VALUES (2,'Bob',40000);
INSERT INTO employee VALUES (3,'Charlie',50000);
INSERT INTO employee VALUES (4,'David',45000);
INSERT INTO employee VALUES (5,'Eva',35000);

COMMIT;

-- Display table
SELECT * FROM employee;

--------------------------------------------------

-- Package Specification
CREATE OR REPLACE PACKAGE emp_pkg AS
PROCEDURE display_emps;
PROCEDURE increase_salary(p_amount NUMBER);
PROCEDURE display_high_salary(p_min_salary NUMBER);
PROCEDURE display_with_ref_cursor;
END emp_pkg;
/

--------------------------------------------------

-- Package Body
CREATE OR REPLACE PACKAGE BODY emp_pkg AS

CURSOR emp_cur IS
SELECT emp_name,salary FROM employee;

CURSOR emp_cur_filtered(p_min_salary NUMBER) IS
SELECT emp_name,salary FROM employee WHERE salary>=p_min_salary;

-- Display all employees
PROCEDURE display_emps IS
v_name employee.emp_name%TYPE;
v_salary employee.salary%TYPE;
BEGIN
DBMS_OUTPUT.PUT_LINE('--- All Employees ---');
OPEN emp_cur;
LOOP
FETCH emp_cur INTO v_name,v_salary;
EXIT WHEN emp_cur%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_name||' earns '||v_salary);
END LOOP;
CLOSE emp_cur;
END display_emps;

-- Increase salary
PROCEDURE increase_salary(p_amount NUMBER) IS
BEGIN
DBMS_OUTPUT.PUT_LINE('--- Salary Increased ---');
FOR rec IN emp_cur LOOP
UPDATE employee SET salary=salary+p_amount WHERE emp_name=rec.emp_name;
END LOOP;
COMMIT;
END increase_salary;

-- Display filtered employees
PROCEDURE display_high_salary(p_min_salary NUMBER) IS
v_name employee.emp_name%TYPE;
v_salary employee.salary%TYPE;
BEGIN
DBMS_OUTPUT.PUT_LINE('--- Salary Filter ---');
OPEN emp_cur_filtered(p_min_salary);
LOOP
FETCH emp_cur_filtered INTO v_name,v_salary;
EXIT WHEN emp_cur_filtered%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_name||' earns '||v_salary);
END LOOP;
CLOSE emp_cur_filtered;
END display_high_salary;

-- REF cursor display
PROCEDURE display_with_ref_cursor IS
TYPE ref_cursor_type IS REF CURSOR;
c_ref ref_cursor_type;
v_name employee.emp_name%TYPE;
v_salary employee.salary%TYPE;
BEGIN
DBMS_OUTPUT.PUT_LINE('--- REF Cursor Output ---');
OPEN c_ref FOR SELECT emp_name,salary FROM employee;
LOOP
FETCH c_ref INTO v_name,v_salary;
EXIT WHEN c_ref%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_name||' earns '||v_salary);
END LOOP;
CLOSE c_ref;
END display_with_ref_cursor;

END emp_pkg;
/

--------------------------------------------------

-- Execute procedures
BEGIN
emp_pkg.display_emps;
emp_pkg.increase_salary(1000);
emp_pkg.display_high_salary(40000);
emp_pkg.display_with_ref_cursor;
END;
/