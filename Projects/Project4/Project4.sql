/*
  @/tmp/oracle/Project4/Project4.sql
*/



SPOOL /tmp/oracle/Project4/Project4_SPOOL.txt

SELECT    
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am') 
FROM dual;

SET SERVEROUTPUT ON

/*
Create a procedure that accepts 3 parameters, the first two are of mode IN with number as
their datatype and the third one is of mode OUT in form of Varchar2. The procedure will
compare the first two numbers and output the result as EQUAL, or DIFFERENT.
Create a second procedure called L8Q1 that accepts the two sides of a rectangle. The
procedure will calculate the area and the perimeter of the rectangle. Use the procedure
created previously to display if the shape is a square or a rectangle. The following are the
example on how we execute the procedure and the expected output.
SQL > exec L4Q1(2,2)
The area of a square size 2 by 2 is 4. It`s perimeter is 8.
SQL > exec L4Q1(2,3)
The area of a rectangle size 2 by 3 is 6. It`s perimeter is 10.
*/

CREATE OR REPLACE PROCEDURE SHAPE(SIDE1 IN NUMBER, SIDE2 IN NUMBER, RESULT OUT VARCHAR2) AS
BEGIN
IF SIDE1 = SIDE2 THEN
 RESULT := 'EQUAL';
ELSE
 RESULT := 'DIFFERENT';
END IF;
END;
/

CREATE OR REPLACE PROCEDURE AREA_PERI(NUM1 IN NUMBER, NUM2 IN NUMBER) AS
AREA NUMBER;
PERIMETER NUMBER;
OUTPUT_SHAPE VARCHAR2(20);
SHAPE_TYPE VARCHAR2(20);
BEGIN 
 SHAPE(NUM1, NUM2, OUTPUT_SHAPE);
 IF OUTPUT_SHAPE = 'EQUAL' THEN
  SHAPE_TYPE := 'SQUARE';
 ELSE
  SHAPE_TYPE := 'RECTANGLE';
 END IF;

 AREA := (NUM1 * NUM2);
 PERIMETER := 2 * (NUM1 + NUM2);

DBMS_OUTPUT.PUT_LINE('The area of a ' || SHAPE_TYPE ||
    ' size ' || NUM1 || ' by ' || NUM2 || ' is ' || AREA ||
    '. It`s perimeter is ' || PERIMETER || '.');
END;
/

SET SERVEROUTPUT ON
EXEC AREA_PERI(2,2);
EXEC AREA_PERI(2,4);

/*
Question 2:
Create a pseudo function called pseudo_fun that accepts 2 parameters represented the 
height and width of a rectangle. The pseudo function should return the area and the 
perimeter of the rectangle.
Create a second procedure called L4Q2 that accepts the two sides of a rectangle. The 
procedure will use the pseudo function to display the shape, the area and the perimeter.
SQL > exec L4Q2(2,2)
The area of a square size 2 by 2 is 4. It`s perimeter is 8.
SQL > exec L4Q2(2,3)
The area of a rectangle size 2 by 3 is 6. It`s perimeter is 10
*/

CREATE OR REPLACE FUNCTION PSEUD0_FUN(HEIGHT IN OUT NUMBER, WIDTH IN OUT NUMBER) RETURN VARCHAR2 AS
AREA2 NUMBER;
PERIMETER2 NUMBER;
SHAPE_T VARCHAR2(20);
BEGIN
 IF HEIGHT = WIDTH THEN
  SHAPE_T := 'SQUARE';
  ELSE
  SHAPE_T := 'RECTANGLE';
 END IF;

 AREA2 := (HEIGHT * WIDTH);
 PERIMETER2 := 2 * (HEIGHT + WIDTH);

 HEIGHT := AREA2;
 WIDTH := PERIMETER2;
 
 RETURN SHAPE_T;

 END;
 /

CREATE OR REPLACE PROCEDURE AREA_PERI2(HEIGHT IN NUMBER, WIDTH IN NUMBER) AS
AREA2 NUMBER;
PERIMETER2 NUMBER;
SHAPE_T VARCHAR2(20);
BEGIN 
 AREA2 := HEIGHT;
 PERIMETER2 := WIDTH;
 SHAPE_T := PSEUD0_FUN(AREA2, PERIMETER2);

DBMS_OUTPUT.PUT_LINE('The area of a ' || SHAPE_T ||
    ' size ' || HEIGHT || ' by ' || WIDTH || ' is ' || AREA2 ||
    '. It`s perimeter is ' || PERIMETER2 || '.');
END;
/

SET SERVEROUTPUT ON
EXEC AREA_PERI2(2,2);
EXEC AREA_PERI2(2,4);

-- Question 3:
-- Create a pseudo function that accepts 2 parameters represented the inv_id, and the 
-- percentage increase in price. The pseudo function should first update the database with 
-- the new price then return the new price and the quantity on hand.
-- Create a second procedure called L4Q3 that accepts the inv_id and the percentage 
-- increase in price. The procedure will use the pseudo function to display the new value of 
-- the inventory (hint: value = price X quantity on hand

CONNECT des02/des02;

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION PSEUDO_FUNC(P_INV_ID IN INVENTORY.INV_ID%TYPE, P_PERCENTAGE IN OUT INVENTORY.INV_PRICE%TYPE) RETURN NUMBER AS
    PRICE INVENTORY.INV_PRICE%TYPE;
    STOCK INVENTORY.INV_QOH%TYPE;
    NEW_PRICE INVENTORY.INV_PRICE%TYPE;
 BEGIN
 
 SELECT
  INV_PRICE,
  INV_QOH
  INTO
  PRICE,
  STOCK
  FROM
  INVENTORY
  WHERE INV_ID = P_INV_ID;

  NEW_PRICE := PRICE + (PRICE*(P_PERCENTAGE/100));

   DBMS_OUTPUT.PUT_LINE('The inventory_id: ' || P_INV_ID ||
    ' with the price: ' || PRICE ||
    ' will be increase by ' || P_PERCENTAGE ||
    '% and the final price will be: ' || NEW_PRICE);

 UPDATE INVENTORY 
 SET 
 INV_PRICE = NEW_PRICE
 WHERE INV_ID = P_INV_ID;
 COMMIT;

 DBMS_OUTPUT.PUT_LINE('The inventory_id: ' || P_INV_ID || 
    ' was updated with the new price: ' || NEW_PRICE);

P_PERCENTAGE := NEW_PRICE;

RETURN STOCK;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Inventory ID ' || p_inv_id || ' doesn''t EXIST!');
    RETURN NULL;
END;
/

CREATE OR REPLACE PROCEDURE L4Q3(INV_ID IN INVENTORY.INV_ID%TYPE, P_PERCENTAGE IN INVENTORY.INV_PRICE%TYPE ) AS
 V_PRICE NUMBER;
 V_QOH NUMBER;
BEGIN
  IF P_PERCENTAGE <= 0 THEN
    DBMS_OUTPUT.PUT_LINE('Invalid percentage of increase:' || P_PERCENTAGE);
  ELSE
   V_PRICE := (P_PERCENTAGE);
   V_QOH := PSEUDO_FUNC(INV_ID, V_PRICE);
   IF V_QOH IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('The new price of the inventory id: '|| INV_ID || 
            ' is: ' || V_PRICE ||
            ' the quantity on hand is: ' || V_QOH || 
            ' , and the new value of the inventory is: ' || (V_PRICE * V_QOH) );
        ELSE
            DBMS_OUTPUT.PUT_LINE('The inventory_id: ' || INV_ID || ' could not be updated.');
        END IF;
    END IF;
    
END;
/


EXEC L4Q3(1, 10);
EXEC L4Q3(1, -100);
EXEC L4Q3(100, 1);


SPOOL OFF;
