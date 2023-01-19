/*
  @/tmp/oracle/Project1.sql
*/

/*
Name: Riya Nagpal
ID: 2220097
Date: 2022/09/21
Description - Databases 2 - Project 1
*/

SPOOL /tmp/oracle/Project1_SPOOL.txt

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

--Question 1

CREATE OR REPLACE PROCEDURE GET_Triple (num in NUMBER) AS 
 result NUMBER;
BEGIN 
  result := num*3;
  DBMS_OUTPUT.PUT_LINE('Three time of '|| num || ' is '|| result ||' !');
END;
/

EXEC GET_TRIPLE (3)
EXEC GET_TRIPLE (9)

--Question 2

CREATE OR REPLACE PROCEDURE GET_TEMP_F (num_C in NUMBER) AS
 temp_F NUMBER;
BEGIN
  temp_F := (9/5 * num_C) + 32;
  DBMS_OUTPUT.PUT_LINE('The temperature from '|| num_C || ' Celsius to Fahrenheit is '|| temp_F ||' !');
END;
/

EXEC GET_TEMP_F(15) 
EXEC GET_TEMP_F(20) 
EXEC GET_TEMP_F(5) 

--Question 3

CREATE OR REPLACE PROCEDURE GET_TEMP_C (num_F in NUMBER) AS
 temp_C NUMBER;
BEGIN
 temp_C := (5/9) * (num_F - 32);
 DBMS_OUTPUT.PUT_LINE('The temperature from '|| num_F || ' Fahrenheit to Celsius is '|| temp_C ||' !');
END;
/

EXEC GET_TEMP_C(59) 
EXEC GET_TEMP_C(68) 
EXEC GET_TEMP_C(41) 

--Question 4

CREATE OR REPLACE PROCEDURE GET_TAX (price in NUMBER) AS
 GST NUMBER;
 QST NUMBER;
 TOTAL NUMBER;
 GRAND_TOTAL NUMBER;
BEGIN
 GST := price * 0.05;
 QST := price * 0.0998;
 TOTAL := GST+QST;
 GRAND_TOTAL := price + TOTAL;
 DBMS_OUTPUT.PUT_LINE('For the price of $'|| price || ' You will have to pay $'|| GST ||' GST and $'|| QST ||' QST for a total of $'|| TOTAL ||'. The GRAND TOTAL IS $'|| GRAND_TOTAL||'.');
END;
 /

 EXEC GET_TAX(100)


--Question 5 

CREATE OR REPLACE PROCEDURE RECTANGLE (width in NUMBER, height in NUMBER) AS
 AREA NUMBER;
 PERIMETER NUMBER;
BEGIN
 AREA := width*height;
 PERIMETER := 2*(width+height);
 DBMS_OUTPUT.PUT_LINE('The area of a ' || width || ' by ' || height || ' rectangle is ' || AREA || ' its perimeter is ' || PERIMETER || '.');
END;
/

EXEC RECTANGLE(5,2)

--Question 6

CREATE OR REPLACE FUNCTION F_GET_TEMP_F (num_in_C in NUMBER) RETURN NUMBER AS
 temp_in_F NUMBER;
BEGIN
  temp_in_F := (9/5 * num_in_C) + 32;
  RETURN temp_in_F;
END;
/

SELECT 
 F_GET_TEMP_F(15)"15 Celsius in Fahrenheit",
 F_GET_TEMP_F(20)"20 Celsius in Fahrenheit",
 F_GET_TEMP_F(5)"5 Celsius in Fahrenheit" 
FROM dual;

--Question 7

CREATE OR REPLACE FUNCTION F_GET_TEMP_C (num_in_F in NUMBER) RETURN NUMBER AS
 temp_in_C NUMBER;
BEGIN
 temp_in_C := (5/9) * (num_in_F - 32);
 RETURN temp_in_C;
END;
/

SELECT
 F_GET_TEMP_C(59)"59 Fahrenheit in Celsius", 
 F_GET_TEMP_C(68)"68 Fahrenheit in Celsius", 
 F_GET_TEMP_C(41)"41 Fahrenheit in Celsius"
FROM dual;

SPOOL OFF;



 	

