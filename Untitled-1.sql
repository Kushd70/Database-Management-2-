/*
Create a PLSQL to display a greeting message 
*/

SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;

-- Variables in PLSQL

/* 
--- Declare variable....
    <variable name> <data type>(length/size)
    ** Length/ size is optional for numerical data types

--Assigning a value
<   <variable_name> := <name value>
*/
/*
SET SERVEROUTPUT ON
DECLARE
    msg VARCHAR(100);

BEGIN
    msg := 'Hello, World!';
    -- displaying values stored in the variables 
    DBMS_OUTPUT.PUT_LINE(msg);
    DBMS_OUTPUT.PUT_LINE('Message : '||msg);
END;
*/
-- Accepting user inputs.........
-- Displaying a prompt message to the user
ACCEPT _name CHAR PROMPT 'Enter your name:'
SET SERVEROUTPUT ON
DECLARE
    v_name VARCHAR(100);
BEGIN
    v_name := '&_name';
    DBMS_OUTPUT.OUT_LINE('Hello, ' || v_name);
END;


/* Create a PLSQL block that accepts two numerical values from the user and display their total and difference.*/
ACCEPT number1 NUMBER PROMPT 'Enter first number:'
ACCEPT number2 NUMBER PROMPT 'Enter second number:'
SET SERVEROUTPUT ON
DECLARE
    v_number1 NUMBER;
    v_number2 NUMBER;
    v_total NUMBER;
    v_difference NUMBER;
BEGIN  
    v_number1 := &number1;
    v_number2 := &number2;
    v_total := v_number1 + v_number2;
    v_difference := v_number1 - v_number2;
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Difference' || v_difference);
END;


/* Create a PLSQL block to accept employee salary from the user and 
display the tax amount and net salary using the following criteria
if salary > 500000.00, tax rate = 0.15
if salary > 300000.00, tax rate = 0.10
if 
salary > 100000.00, tax rate = 0.08
else tax rate = 0.00 */
ACCEPT salary NUMBER PROMPT 'Enter employee salary: '

SET SERVEROUTPUT ON

DECLARE
    v_salary NUMBER;
    v_tax NUMBER;
BEGIN
    v_salary := &salary;
    IF v_salary > 500000 THEN
        v_tax := 0.15;
    ELSIF v_salary > 300000 THEN
        v_tax := 0.10;
    ELSIF v_salary > 100000 THEN
        v_tax := 0.08;
    ELSE
        v_tax := 0.00;
    END IF;

    v_net := v_salary -(v_salary * v_tax);
    DBMS_OUTPUT.PUT_LINE('Tax : '|| v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Salary : ' || v_net);
END;


-- Create a PLSQL block to pint number from 0 to 30.....
DECLARE
    counter NUMBER;
BEGIN
    counter:= 0;
    LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        
        EXIT WHEN counter < 30;
        counter := counter + 1;
    END LOOP;
END;

-- Create a PLSQL block that displays the number of employees who got 
/*salary increments based on the following criteria 
update the basic salary of all employees whose basic salary is greater that or equals to 50000 by a margin of 0.05.
display a proper message id none of employees got the increments 
*/

UPDATE EMPLOYEES SET BASIC_SALARY = BASIC_SALARY + (BASIC_SALARY * 0.05) WHERE BASIC_SALARY >= 50000;

DECLARE
    row_count NUMBER;
BEGIN
    UPDATE EMPLOYEES SET basic_salary=basic_salary + (basic_salary * 0.05)
        WHERE basic_salary >= 50000;
    IF SQL%FOUND THEN
        row_count := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Number of Employees who got increment :' || row_count);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No employees got the increment');
    END IF;
END;

/* Create PLSQL block to accept employee id from the user and display the final salary of the employee using 
final salary = basic salary + allowances - deductions
display a proper message id the employee can not be found to the given id*/
SET SERVEROUTPUT ON
ACCEPT e_id NUMBER PROMPT 'Enter employee id : ';
DECLARE
    v_id EMPLOYEES.e_index%TYPE;
    v_basic EMPLOYEES.basic_salary%TYPE;
    v_allow EMPLOYEES.allowances%TYPE;
    v_deduct EMPLOYEES.deductions%TYPE;
    v_final NUMBER;
BEGIN
    v_id:= '&e_id';
    SELECT basic_salary, allowances, deductions INTO v_basic, v_allow, v_deduct
        FROM EMPLOYEES WHERE e_index = v_id;
    IF SQL%FOUND THEN
        v_final:= v_basic+ v_allow - v_deduct;
        DBMS_OUTPUT.PUT_LINE('final salary : ' || v_final);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee id not found');
    END IF;
END;


-- Explicit cursor
-- Use a cursor to calculate and display employee name and final salary of all the employees...

SET SERVEROUTPUT ON
DECLARE
    CURSOR c1 IS
        SELECT e_index, basic_salary, allowances, deductions
            FROM EMPLOYEES;
    v_name employees.e_name%TYPE;
    v_basic employees.basic_salary%TYPE;
    v_allowances employees.allowances%TYPE;
    v_deduct employees.deductions%TYPE;
    v_final NUMBER;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO v_name, v_basic, v_allowances, v_deduct;
        EXIT WHEN c1%NOTFOUND;
        v_final := v_basic + v_allowances - v_deduct;
        DBMS_OUTPUT.PUT_LINE('Employee Name : ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Final Salary : ' || v_final);
    END LOOP;
    CLOSE c1;
END;

/* Add a new column to the employees table to store tax amount for the employees
Use a cursor to calculate the tax amount for all the employees and update 
their records in the table by inserting their tax amounts
Criteria to calculate tax amount
if gross salary >= 500000.00 , tax rate = 0.15;
else if gross salary >= 300000.00, tax rate = 0.10;
else if gross salary >= 100000.00, tax rate = 0.08;
else tax rate = 0.02;
gross salary = basic salary + allowances - deductions;
tax amount = gross salary * tax rate;
Display employee name and tax amount after updating employee details. */

ALTER TABLE EMPLOYEES ADD tax_amount DECIMAL(20,2);

SET SERVEROUTPUT ON
DECLARE
    CURSOR c2 IS
        SELECT e_index, basic_salary, allowances, deductions
            FROM EMPLOYEES;
        v_id employees.e_index%TYPE;
        v_name employees.e_name%TYPE;
        v_basic employees.basic_salary%TYPE;
        v_allowances employees.allowances%TYPE;
        v_deduct employees.deductions%TYPE;
        v_final DECIMAL(20,2);
        v_tax DECIMAL(20,2);
BEGIN
    OPEN c2;
    LOOP
        FETCH c2 INTO v_name, v_basic, v_allowances, v_deduct;
        EXIT WHEN c2%NOTFOUND;
        v_final := v_basic + v_allowances - v_deduct;
        IF v_final >= 500000 THEN
            v_tax := v_final * 0.15;
        ELSIF v_final >= 300000 THEN
            v_tax := v_final * 0.10;
        ELSIF v_final >= 100000 THEN
            v_tax := v_final * 0.08;
        ELSE
            v_tax := v_final * 0.02;
        END IF;
        UPDATE EMPLOYEES SET tax_amount = v_tax WHERE e_index = v_id;
        DBMS_OUTPUT.PUT_LINE('Employee Name : ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Tax Amount : ' || v_tax);
    END LOOP;
    CLOSE c2;
END;