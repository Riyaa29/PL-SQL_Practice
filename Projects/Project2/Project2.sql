/*
  @/tmp/oracle/Project2/Project2.sql
*/



SPOOL /tmp/oracle/Project2/Project2_SPOOL.txt

CONNECT sys/sys as sysdba;
show user

DROP USER Riya29 CASCADE;
CREATE USER Riya29 IDENTIFIED BY 123;
GRANT CONNECT, RESOURCE TO Riya29;
CONNECT Riya29/123;

SELECT    
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am') 
FROM dual;

SET SERVEROUTPUT ON

/*
Question 1:
 Create a function that accepts 2 numbers to calculate the product of them. Test your 
function in SQL*Plus
*/

CREATE OR REPLACE FUNCTION CALC(num1 IN NUMBER, num2 IN NUMBER) RETURN NUMBER AS
 result NUMBER;
BEGIN
 result := num1*num2;
 RETURN result;
END;
/
SELECT 
 CALC(2,3),
 CALC(4,5)
FROM dual;

/*
Question 2:
 Create a procedure that accepts 2 numbers and use the function created in question 1 
to display the following
 For a rectangle of size .x. by .y. the area is .z. 
where x, y is the values supplied on run time by the user
and z is the values calculated using the function of question 1.
Test your procedure in SQL*Plus and hand in code + result for 2cases.
*/

CREATE OR REPLACE PROCEDURE RECT(X IN NUMBER, Y IN NUMBER) AS
 area NUMBER;
BEGIN 
 area := CALC(X,Y);
 DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || X || ' by '|| Y ||' the area is '|| area || '.');
END;
/

EXEC RECT(2,4)

/*
Question 3:
 Modify procedure of question 1 to display “square” when x and y are equal in length.
 */

CREATE OR REPLACE PROCEDURE RECT(X IN NUMBER, Y IN NUMBER) AS
 area NUMBER;
BEGIN 
 area := CALC(X,Y);
 IF X = Y THEN
 DBMS_OUTPUT.PUT_LINE('For a rectangle of equal size : ' || X || ' by '|| Y ||' the area is a square : '|| area || '.');
 ELSE
 DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || X || ' by '|| Y ||' the area is '|| area || '.');
 END IF;
END;
/

EXEC RECT(5,5)
EXEC RECT(5,6)

/*
Question 4 :
Create a procedure that accepts a number represent Canadian dollar and a letter 
represent the new currency. The procedure will convert the Canadian dollar to the new 
currency using the following exchange rate:
 E EURO 1.50
 Y YEN 100
 V Viet Nam DONG 10 000
 Z Endora ZIP 1 000 000
Display Canadian money and new currency in a sentence as the following:
For ``x`` dollars Canadian, you will have ``y`` ZZZ
Where x is dollars Canadian
y is the result of the exchange
ZZZ is the currency 
EX: exec L2Q4 (2,’Y’)
 For 2 dollars Canadian, you will have 200 YEN
 */

CREATE OR REPLACE PROCEDURE CURR(CAD IN NUMBER, NEW_CURRENCY IN VARCHAR) AS 
 result VARCHAR(40);
BEGIN
 IF NEW_CURRENCY = 'E' THEN 
  result := CAD*1.50;
  DBMS_OUTPUT.PUT_LINE('For ' || CAD || ' $ CAD, you will have : '|| result ||' Euros.');
 ELSIF NEW_CURRENCY = 'Y' THEN
  result := CAD*100;
  DBMS_OUTPUT.PUT_LINE('For ' || CAD || ' $ CAD, you will have : '|| result ||' YEN.');
 ELSIF NEW_CURRENCY = 'V' THEN 
  result := CAD*10000;
  DBMS_OUTPUT.PUT_LINE('For ' || CAD || ' $ CAD, you will have : '|| result ||' Viet Nam DONG.');
 ELSIF NEW_CURRENCY ='Z' THEN
  result := CAD*1000000;
  DBMS_OUTPUT.PUT_LINE('For ' || CAD || ' $ CAD, you will have : '|| result ||' Endora ZIP.');
 END IF;
END;
/

EXEC CURR(2,'Y')
EXEC CURR(2,'E')
EXEC CURR(2,'V')
EXEC CURR(2,'Z')

/*
Question 5:
Create a function called YES_EVEN that accepts a number to determine if the number is 
EVEN or not. The function will return TRUE if the number inserted is EVEN otherwise 
the function will return FALSE
*/
CREATE OR REPLACE FUNCTION YES_EVEN(num1 NUMBER) RETURN BOOLEAN AS
BEGIN
 RETURN MOD(num1, 2) = 0 ;
END;
/

/*
Question 6:
 Create a procedure that accepts a numbers and uses the function of question 5 to 
print out EXACTLY the following: 
Number … is EVEN OR Number … is ODD
EX: exec L2Q6 (6)
 Number 6 is EVEN
EX: exec L2Q6 (5)
 Number 5 is ODD
 */
CREATE OR REPLACE PROCEDURE Check_EVEN(num IN NUMBER) AS
BEGIN
 IF YES_EVEN(NUM) THEN
 DBMS_OUTPUT.PUT_LINE('Number ' || num || ' is Even. ');
 ELSE
 DBMS_OUTPUT.PUT_LINE('Number ' || num || ' is Odd. ');
 END IF;
 END;
/

EXEC Check_EVEN(5)
EXEC Check_EVEN(6)

/*
BONUS QUESTION
 Modify question 4 to convert the money in any direction.
Ex: exec L2Qbonus (2,’Y’,’V’)
 For 2 YEN, you will have 200 Viet Nam DONG
 exec L2Qbonus (20000,’V’,’C’)
 For 20000 Viet Nam DONG, you will have 2 dollars Canadian

 E EURO 1.50
 Y YEN 100
 V Viet Nam DONG 10 000
 Z Endora ZIP 1 000 000
 */

 CREATE OR REPLACE PROCEDURE CURRENCY(DOLLARS IN NUMBER, OLD_CURRENCY IN VARCHAR, NEW_CURRENCY IN VARCHAR) AS 
 result VARCHAR(100);
BEGIN
 IF OLD_CURRENCY = 'E' THEN 
  IF NEW_CURRENCY = 'C' THEN
  result := DOLLARS*1.50;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Euros, you will have : '|| result ||' CAD.');
  ELSIF NEW_CURRENCY = 'Y' THEN
  result := DOLLARS*138.8;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Euros, you will have : '|| result ||' YEN.');
  ELSIF NEW_CURRENCY = 'V' THEN
  result := DOLLARS*22704.6;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Euros, you will have : '|| result ||' Vietnam DONG.');
  ELSIF NEW_CURRENCY = 'Z' THEN
  result := DOLLARS*64892.9;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Euros, you will have : '|| result ||' ENDORA ZIP.');
  END IF;

 ELSIF OLD_CURRENCY = 'C' THEN
  IF NEW_CURRENCY = 'E' THEN
  result := DOLLARS*1.50;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' CAD, you will have : '|| result ||' Euros.');
  ELSIF NEW_CURRENCY = 'Y' THEN
  result := DOLLARS*100;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' CAD, you will have : '|| result ||' YEN.');
  ELSIF NEW_CURRENCY = 'V' THEN 
  result := DOLLARS*10000;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' CAD, you will have : '|| result ||' Viet Nam DONG.');
  ELSIF NEW_CURRENCY ='Z' THEN
  result := DOLLARS*1000000;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' CAD, you will have : '|| result ||' Endora ZIP.');
 END IF;

 ELSIF OLD_CURRENCY = 'Y' THEN
  IF NEW_CURRENCY = 'E' THEN
  result := DOLLARS*0.0071;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' YEN, you will have : '|| result ||' Euros.');
  ELSIF NEW_CURRENCY = 'C' THEN
  result := DOLLARS*0.0094;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' YEN, you will have : '|| result ||' CAD.');
  ELSIF NEW_CURRENCY = 'V' THEN 
  result := DOLLARS*164.006;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' YEN, you will have : '|| result ||' Viet Nam DONG.');
  ELSIF NEW_CURRENCY ='Z' THEN
  result := DOLLARS*10000;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' YEN, you will have : '|| result ||' Endora ZIP.');
 END IF;

 ELSIF OLD_CURRENCY = 'V' THEN
  IF NEW_CURRENCY = 'E' THEN
  result := DOLLARS*0.000043;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Viet Nam DONG, you will have : '|| result ||' Euros.');
  ELSIF NEW_CURRENCY = 'C' THEN
  result := DOLLARS*0.000057;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Viet Nam DONG, you will have : '|| result ||' CAD.');
  ELSIF NEW_CURRENCY = 'Y' THEN 
  result := DOLLARS*0.0061;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Viet Nam DONG, you will have : '|| result ||' YEN.');
  ELSIF NEW_CURRENCY ='Z' THEN
  result := DOLLARS*100;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Viet Nam DONG, you will have : '|| result ||' Endora ZIP.');
 END IF;

  ELSIF OLD_CURRENCY = 'Z' THEN
  IF NEW_CURRENCY = 'E' THEN
  result := DOLLARS/1000000/1.5;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Endora ZIP, you will have : '|| result ||' Euros.');
  ELSIF NEW_CURRENCY = 'C' THEN
  result := DOLLARS/1000000;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Endora ZIP, you will have : '|| result ||' CAD.');
  ELSIF NEW_CURRENCY = 'Y' THEN 
  result := DOLLARS/10000;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Endora ZIP, you will have : '|| result ||' YEN.');
  ELSIF NEW_CURRENCY ='V' THEN
  result := DOLLARS/100;
  DBMS_OUTPUT.PUT_LINE('For ' || DOLLARS || ' Endora ZIP, you will have : '|| result ||' Viet Nam DONG.');
 END IF;
 

END IF;

END;
/

EXEC CURRENCY(2,'E','V')
EXEC CURRENCY(2,'C','Z')
EXEC CURRENCY(2,'Y','C')
EXEC CURRENCY(2,'V','Y')
EXEC CURRENCY(2,'Z','E')





SPOOL OFF;
