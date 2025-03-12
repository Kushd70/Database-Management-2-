-- Create a PLSQL block to pint number from 0 to 30.....
DECLARE
    counter NUMBER;
BEGIN
    counter:= 0;
    LOOP
        DBMS_OUTPUT.PUT_LINE(counter);
        EXIT WHEN counter > 30;
        counter := counter + 1;
    END LOOP;
END;

-- Create a PLSQL block to display only the numbers that can be divided by 3
-- without any remainders which are between 10 and 50

SET SERVEROUTPUT ON;
DECLARE
    counter NUMBER;
BEGIN
    counter := 10;
    WHILE counter <= 50 LOOP
        IF MOD(counter, 3) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(counter);
        END IF;
        counter := counter + 1;
    END LOOP;
END;


-- Create a PLSQL block to display the number from the 10 to 20 using a for loop
BEGIN
    FOR counter IN 10..20 loop
        DBMS_OUTPUT.PUT_LINE(counter);
    END LOOP;
END;

--Create a PLSQL block to display the number from 50 to 100 in the rreverse order
BEGIN
    FOR counter IN REVERSE 50..100 loop
        DBMS_OUTPUT.PUT_LINE(counter);
    END LOOP;
END;

/* Create the following table with their constraints table Name: employee
column
-id integer/number autoincrement primary key
-e_index varchar should start with EID-
-e_name varchar
-basic_salary decimal(20,2) default 2500.00
-allowances decimal(20,2) default 0.00 should not be less than 0
- deductions decimal(20, 2)default 0.00 should not be less than 0
*/

CREATE TABLE employees(
    id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
    e_index VARCHAR(100) CHECK (e_index LIKE 'EID-%'),
    e_name VARCHAR(100)  NOT NULL,
    basic_salary DECIMAL(20,2) DEFAULT 0.00 CHECK (basic_salary>= 0.00),
    allowances DECIMAL(20,2) DEFAULT 0.00 CHECK (allowances >= 0.00),
    deductions DECIMAL(20,2) DEFAULT 0.00 CHECK (deductions >= 0.00)
);

-- Insert at least 3 records into employees table. Use your own data...
INSERT INTO employees(e_index, e_name, basic_salary, allowances, deductions) VALUES('EID-001', 'jhone', 450000.00, 120000.00, 50000.00);
COMMIT;

-- Working with table data...
-- SELECT INTO statement...
-- Create a PLSQL block to display the final salary of the employee
-- with the index EID-0003
-- final salary = basic salary + allowances - deductions

SET SERVEROUTPUT ON 
DECLARE
			v_name employee.e_name%TYPE;
			v_basic employee.basic_salary%TYPE;
			v_allowance employees.allowances%TYPE;
			v_deduct employee.deductions%TYPE;
			v_final NUMBER;
			
BEGIN
			SELECT e_name, basic_salary, allowances, deductions INTO v_name, v_basic, v_allowances, v_deduct 
            FROM employee WHERE e_index = 'EID-001' FETCH FIRST 1 ROW ONLY;
			v_final := v_basic + v_allowance - v_deduct;
			DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
			DBMS_OUTPUT.PUT_LINE('Net Salary: ' || v_final);
END;

/* CREATE PLSQL 

	SET SERVEROUTPUT ON
	ACCEPT _name CHAR PROMPT 'Enter Employee Name: ';
	DECLARE 
		v_name employee.E_NAME%TYPE;
		v_basic employee.BASIC_SALARY%TYPE;
		v_allowance employee.ALLOWANCES%TYPE;
		v_deduct employees.DEDUCTIONS%TYPE;
		v_final NUMBER;
		
	BEGIN
		v_name := '&_name';
		SELECT basic_salary, allowances, deductions
		INTO v_basic, v_allowances, v_deduct FROM EMPLOYEES
		WHERE e_name = v_name FETCH FIRST 1 ROW ONLY;
		v_final := v_basic + v_allowance - v_deduct;
		DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
		DBMS_OUTPUT.PUT_LINE('Salary: ' || v_final);
END;*/