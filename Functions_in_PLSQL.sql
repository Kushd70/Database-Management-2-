/*
Create a PLSQL function to accept unit price and discount rate as parameters 
and return the discounted price
discounted price = unit price - (unit price * discount rate)
*/

CREATE OR REPLACE FUNCTION discountedPrice(unitPrice IN DECIMAL, discountRate IN DECIMAL)
RETURN DECIMAL
AS
    discounted_price DECIMAL(20, 2);
BEGIN
    discounted_price := unitPrice - (unitPrice * discountRate);
    RETURN discounted_price;
END;


-- invoke the function
-- Using dual table (Instead of EXECUTE)....
SELECT discountedPrice(120.00, 0.05) AS discounted FROM DUAL;

-- Using s PLSQL block;
BEGIN
    DBMS.OUTPUT.PUT_LINE('Discounted Price: ' || discountedPrice(120.00, 0.05));
END;

-- another method
DECLARE
    new_price NUMBER;
BEGIN
    new_price := discountedPrice(120.00, 0.05);
    DBMS_OUTPUT.PUT_LINE('Discounted Price: ' || new_price);
END;

--Inside select statement when retrieving data from a table
-- USE a Select statement to retrieve product name , unit price, stock and discounted price if the discount rate is set to 0.10
SELECT product_name, price, stock, discountedPrice(price, 0.10) AS discounted
FROM DB_products;


/* Create a function to calculate stock value of a product accepting unit price and 
available stock as parameters.
Use the created function when displaying name , unit price , stock and stock value for all the products available in the table.


display manufacture date, item name , manufactured quantity and stock value for manufactured quantity using a select query
*/
CREATE OR REPLACE FUNCTION stockValue(unitPrice IN DECIMAL, availableStock IN NUMBER)
RETURN DECIMAL
AS
    stock_value NUMBER;
BEGIN
    stock_value := unitPrice * availableStock;
    RETURN stock_value;
END;

-- invoke the function
SELECT product_name, price, stock, stockValue(price, stock) as stock_value
FROM DB_products;

-- invoke the function
SELECT 
productions.manufacture_date,
DB_products.product_name,
productions.manufactured_quantity,
DB_products.price,
stockValue(DB_products.price, productions.manufactured_quantity) as stock_value
FROM DB_products INNER JOIN productions
ON DB_products.product_id = productions.product_id;


/* Create a before trigger to validate the manufacturing quantity used when 
inserting a new record to productions table.
if manufacturing quantity is null set the value to 75
*/

CREATE OR REPLACE TRIGGER validate_manufacturing
BEFORE INSERT ON productions
FOR EACH ROW
BEGIN
    IF :NEW.manufactured_quantity is NUll THEN
        NEW.manufactured_quantity := 75;
    END IF;
    DBMS.DBMS_OUTPUT.PUT_LINE('Validation');
END;

-- Create an after trigger to display the changes performed when executing Insert , Update on products table
CREATE OR REPLACE TRIGGER productLog
AFTER INSERT OR UPDATE OR DELETE ON DB_products
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('Record Inserted.');
        DBMS_OUTPUT.PUT_LINE('Name : '|| :NEW.product_name);
        DBMS_OUTPUT.PUT_LINE('Price : ' || :NEW.price);
        DBMS_OUTPUT.PUT_LINE('Stock : ' || :NEW.stock);
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Record Updated.');
        DBMS_OUTPUT.PUT_LINE('Name Updated from  ' || :OLD.product_name || ' to ' || :NEW.product_name);
        DBMS_OUTPUT.PUT_LINE('Price update from' || :OLD.price || ' to ' || :NEW.price);
        DBMS_OUTPUT.PUT_LINE('Stock update from ' || :OLD.stock || ' to ' || :NEW.stock);
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Record Deleted.');
        DBMS_OUTPUT.PUT_LINE('Deleted product name : ' || :OLD.product_name);
    END IF;
END;

-- Instead of Triggers
-- Create a instead of trigger to display the message 'can not delete products '
-- instead of deleting the record when user executes a delete query
CREATE OR REPLACE TRIGGER deleteProduct
INSTEAD OF DELETE ON DB_products
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Can not delete products');
END;