-- Create a procedures to display a greeting message to the user
CREATE OR REPLACE PROCEDURE greetUser
AS
    msg VARCHAR(100);
BEGIN
    msg:= 'Hello from Stored Procedures';
    DBMS_OUTPUT.PUT_LINE(msg);
END;

-- INVOKE Procedures as a standalone program
EXECUTE GREETUSER;

-- INVOKE the procedure inside a PLSQL block
BEGIN
    GREETUSER;
END;

-- Create a PROCEDURE to accept bank balance and interest rate as 
-- parameters and display the interest rate
-- interest amount = bank balance * interest rate

CREATE OR REPLACE PROCEDURE bankB(balance NUMBER, interestRate NUMBER)
AS
    interestAmount NUMBER;
BEGIN
    interestAmount := balance * interestRate;
    DBMS_OUTPUT.PUT_LINE('Interest Amount : '|| interestAmount);
END;

-- Invoke the procedure as a stand alone application..
EXECUTE BANKB(25000.00, 0.10);


-- Inoke the procedure as a stand alone application..
SET SERVEROUTPUT ON
ACCEPT balance NUMBER PROMPT 'Enter the Balance : ';
ACCEPT interestRate NUMBER PROMPT 'Enter the interest rate ';
DECLARE
    v_balance NUMBER;
    v_rate NUMBER;
    v_amount NUMBER;
BEGIN
    v_balance := '&balance';
    v_rate := '&interestRate';
    BANKB(v_balance, v_rate);
END;


/* Create a procedure to accept two numbers as parameters and return the maximum 
Use proper parameters types*/
CREATE OR REPLACE PROCEDURE findMax(num1 IN NUMBER, num2 IN NUMBER, max_num OUT NUMBER)
AS
    
BEGIN
    IF num1 > num2 THEN
        max_num := num1;
    ELSE
        max_num := num2;
    END IF;
END;

-- invok the procedures
DECLARE
    max_no NUMBER;
BEGIN
    findMax(34, 56, max_no);
    DBMS_OUTPUT.PUT_LINE('Maximum : ' || max_no);
END;



/* Create the following tables for a manufacturing DB products
(product_id integer autoincreament primary key,
product_name varchar(100) unique,
price decimal/ number default 100.00,
stock int can not be less than 0)

productions
(id integer autoincreament prmary key,
product_id foreign key,
manufacture_date varchar/date,
manufactured_quantity int can not be less than 0)
*/

CREATE TABLE DB_products(
    product_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
    product_name VARCHAR(100) UNIQUE,
    price DECIMAL(20, 2) DEFAULT 100.00,
    stock INT CHECK (stock >= 0)
);

CREATE TABLE productions(
    id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
    product_id INTEGER,
    manufacture_date DATE,
    manufactured_quantity INT CHECK (manufactured_quantity >= 0),
    FOREIGN KEY (product_id)REFERENCES DB_products(product_id)
    -- CONSTRAINTS fk_productsID FOREIGN KEY (product_id) REFERENCES DB_products(product_id)
);

-- Create a procedure to register a product by accepting name , price and opening 
-- stock of product as parameters 
CREATE OR REPLACE PROCEDURE registerProduct(name IN VARCHAR, price IN DECIMAL, stock IN INT)
AS
BEGIN
    INSERT INTO DB_products(product_name, price, stock) VALUES(name, price, stock);
    DBMS_OUTPUT.PUT_LINE('product registered successfuly');
    COMMIT; -- to make sure all the changes are applied...
END;


-- invoke the procedure as a standalone application
EXECUTE registerProduct('pen', 10.00, 100);

-- invoke the procedure as a PLSQL block
BEGIN
    registerProduct('pen', 10.00, 100);
END;

-- Create a procedure to update a product by accpeting id , name , price and available stock
CREATE OR REPLACE PROCEDURE updateProduct(OldName IN VARCHAR, NewName IN VARCHAR , price IN DECIMAL, Stock IN INT)
AS
BEGIN
    UPDATE DB_products SET product_name = NewName, price = price, stock = stock WHERE prodcut_name = OldName;
    DBMS_OUTPUT.PUT_LINE('Product updated successfully');
    COMMIT; 
END;

-- invoke the procedure using stand alone application......
EXECUTE updateProduct(1, 'pen', 20.00, 200);

-- invoke the procedure using PLSQL block....
BEGIN
    updateProduct(1, 'pen', 30.00, 300);
END;

-- CREATE A PROCEDURE TO DELETE a product by accepting id as parameters
CREATE OR REPLACE PROCEDURE deleteProduct(id IN INTEGER, productName OUT VARCHAR)
AS
BEGIN
    productName := SELECT product_name WHERE product_id = id;
    DELETE FROM productions WHERE product_id = id;
    DELETE FROM DB_products WHERE product_id = id;
    DBMS_OUTPUT.PUT_LINE('product succesfully deleted' + productName);
    COMMIT;
END;

-- Create a procedure to DEMOSTRATE SALES OPERATION BY ACCEPTING product name,
-- quantity sold as parameters and RETURNS sales amount,
-- sales amount = unit price * quantity sold
-- UPDATE THE stock of the prodcut acccordingly ..
CREATE OR REPLACE PROCEDURE Demonstrate(productName IN VARCHAR, soldQuantity IN NUMBER, amount OUT DECIMAL(20, 2))
AS
    v_price DB_products.price%TYPE;
BEGIN
    SELECT price INTO v_price FROM PRODUCT WHERE product_name = v_name;
    amount := quantity * v_price;
    UPDATE products SET stock = stock - soldQuantity WHERE product_name = v_name;
    COMMIT;
END;

-- invoke the procedures as standlone program
EXECUTE demonstrate;

-- invoke the procedure inside a PLSQL block
BEGIN
    demonstrate;
END;


-- CREATE A Procedure to record daily productions by accepting product name,
-- manufacture date and manufactured quantity as parameters....
-- Update the stock of the product accordingly...

CREATE OR REPLACE PROCEDURE records(v_product_name IN VARCHAR, manu_date IN DATE, manu_quantity INT NUMBER)
AS
    v_id DB_products.product_id%TYPE;
BEGIN
    v_id := SELECT product_id FROM productions WHERE product_name = product_name;
    --SELECT product_id INTO v_id  FROM productions WHERE product_name = product_name;
    INSERT INTO products(product_id, manufacture_date, manufactured_quantity)VALUES (v_id, manu_date, manu_quantity);
    UPDATE DB_products SET stock = stock+manu_quantity WHERE product_id = v_id;
    COMMIT;
END;

-- insert at least 3 records to products table using the procedure created
BEGIN
    Demonstrate('ABC 10G', 200.00, 10);
    Demonstrate('ABC 50G', 350.00, 5);
    Demonstrate('CDE 200G', 1200.00, 0);
END;

-- insert at least 3 record to productions table using the procedure created
BEGIN
    record('ABC 10G', 2025-02-20, 10);
    record('ABC 50G', 2025-02-30, 100);
    record('CDE 200G', 2025-02-20, 20);
END;
SELECT * FROM DB_products;
SELECT * FROM productions;

-- CREATE a PLSQL bloc kto accept item name and quantity sold from the user and 
-- display sales amount using the procedure created.
ACCEPT _name CHAR PROMPT 'Enter Item name : ';
ACCEPT _quantity NUMBER PROMPT 'Enter quantity sold : ';
DECLARE
    v_name VARCHAR(100);
    v_quantity NUMBER;
    v_amount DECIMAL(20, 2);
BEGIN
    v_name := '&_name';
    v_quantity := '&_quantity';
    Demonstrate(v_name, v_quantity, v_amount);
    DBMS_OUTPUT.PUT_LINE('Sales Amount : ' || v_amount);
END;

DROP TABLE productions;
DROP TABLE DB_products;

/* UPDATE the previous PLSQL BLOCK that used to display sales amount according
-- to the following
1. display proper message when there is no record associated with the specified item name
2. display a proper message when there are more than one record with the specified item name
3. Display a proper message when any other runtime error is created
*/
ACCEPT _name CHAR PROMPT 'Enter Item name : ';
ACCEPT _quantity NUMBER PROMPT 'Enter quantity sold : ';
DECLARE
    v_name VARCHAR(100);
    v_quantity NUMBER;
    v_amount DECIMAL(20, 2);
BEGIN
    v_name := '&_name';
    v_quantity := '&_quantity';
    Demonstrate(v_name, v_quantity, v_amount);
    DBMS_OUTPUT.PUT_LINE('Sales Amount : ' || v_amount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No item can be found with the item name provided');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple items are available with the item name ');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Somthing when wrong');
END;