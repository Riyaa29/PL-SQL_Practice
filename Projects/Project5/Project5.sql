/*
  @/tmp/oracle/Project5/Project5.sql
*/



SPOOL /tmp/oracle/Project5/Project5_SPOOL.txt

SELECT    
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am') 
FROM dual;

SET SERVEROUTPUT ON

/*
Question 1 : 
Run script 7northwoods.
Using cursor to display many rows of data, create a procedure to display the all 
the rows of table term. 
*/
connect des03/des03

set serveroutput ON

CREATE OR REPLACE PROCEDURE DISPLAY_ROWS AS
CURSOR TERM_CURSOR IS
    SELECT
        TERM_ID,
        TERM_DESC,
        STATUS
    FROM
        TERM;
v_term_id TERM.TERM_ID%TYPE;
v_term_desc TERM.TERM_DESC%TYPE;
v_status TERM.STATUS%TYPE;
BEGIN
    OPEN
        TERM_CURSOR;
    LOOP
        FETCH
            TERM_CURSOR INTO
            v_term_id,
            v_term_desc,
            v_status;
        EXIT WHEN TERM_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Term ' || v_term_id || '. ' || v_term_desc || ': ' || v_status);
    END LOOP;
    CLOSE
        TERM_CURSOR;
END;
/

exec DISPLAY_ROWS

/* Question 2 : 
Run script 7clearwater.
Using cursor to display many rows of data, create a procedure to display the 
following data from the database: Item description, price, color, and quantity on 
hand. */

connect des02/des02

set serveroutput ON

CREATE OR REPLACE PROCEDURE DISPLAY_ROWS AS
CURSOR ITEM_CURSOR IS
    SELECT
        ITEM_DESC,
        INV_PRICE,
        COLOR,
        INV_QOH
    FROM
        ITEM IT JOIN INVENTORY INV ON IT.ITEM_ID = INV.ITEM_ID;
v_item_desc ITEM.ITEM_DESC%TYPE;
v_inv_price INVENTORY.INV_PRICE%TYPE;
v_color INVENTORY.COLOR%TYPE;
v_inv_qoh INVENTORY.INV_QOH%TYPE;
BEGIN
    OPEN
        ITEM_CURSOR;
    LOOP
        FETCH
            ITEM_CURSOR INTO
            v_item_desc,
            v_inv_price,
            v_color,
            v_inv_qoh;
        EXIT WHEN ITEM_CURSOR%NOTFOUND;
        IF v_inv_qoh > 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_item_desc || ': $' || v_inv_price || ', ' || v_color ||
                                ', ' || v_inv_qoh || ' pieces left');
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_item_desc || ': $' || v_inv_price || ', ' || v_color ||
                                ', UNAVAILABLE');
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
        END IF;
    END LOOP;
    CLOSE
        ITEM_CURSOR;
END;
/

exec DISPLAY_ROWS


/* Question 3 : 
Run script 7clearwater.
Using cursor to update many rows of data, create a procedure that accepts a 
number represent the percentage increase in price. The procedure will display the 
old price, new price and update the database with the new price. */
CREATE OR REPLACE PROCEDURE UPDATE_ROWS(PERCENT_INC IN INVENTORY.INV_PRICE%TYPE) AS
CURSOR PRICE_CURSOR IS
    SELECT
        INV_PRICE,
        INV_PRICE + (INV_PRICE / 100 * PERCENT_INC)
    FROM
        INVENTORY;
    v_old_price INVENTORY.INV_PRICE%TYPE;
    v_new_price INVENTORY.INV_PRICE%TYPE;
BEGIN
    OPEN
        PRICE_CURSOR;
    IF PERCENT_INC > -100 THEN 
        LOOP
            FETCH
                PRICE_CURSOR INTO
                v_old_price,
                v_new_price;
            v_new_price := v_old_price + (v_old_price / 100 * PERCENT_INC);
            UPDATE
                INVENTORY
            SET
                INV_PRICE = v_new_price
            WHERE
                INV_PRICE = v_old_price;
            COMMIT; 
            EXIT WHEN PRICE_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Old price: $' || v_old_price || ', New price: $' || v_new_price);
            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Incorrect Percentage! Unless it''s a FREE GIVE AWAY!');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    END IF;
    CLOSE
        PRICE_CURSOR;
END;
/

exec UPDATE_ROWS(-100)

exec UPDATE_ROWS(3)


/* Question 4 : 
Run script scott_emp_dept.
Create a procedure that accepts a number represent the number of employees 
who earns the highest salary. Display employee name and his/her salary
Ex: SQL> exec L5Q4(2) 
SQL> top 2 employees are
KING 5000
FORD 3000 */
connect scott/tiger

set serveroutput ON

CREATE OR REPLACE PROCEDURE EMP_DETAILS(HIGH_SAL_EMP IN NUMBER) AS
CURSOR EMP_CURSOR IS
    SELECT
        ENAME,
        SAL
    FROM
        EMP
    ORDER BY
        SAL DESC;
    v_name EMP.ENAME%TYPE;
    v_sal EMP.SAL%TYPE;
BEGIN
    OPEN
        EMP_CURSOR;
    DBMS_OUTPUT.PUT_LINE('Top ' || HIGH_SAL_EMP || ' employees are:');
    FOR i IN 1 .. HIGH_SAL_EMP LOOP
        FETCH
            EMP_CURSOR INTO
            v_name,
            v_sal;
        EXIT WHEN EMP_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
    END LOOP;
    CLOSE
        EMP_CURSOR;
END;
/

exec EMP_DETAILS(2)

exec EMP_DETAILS(30)


/* Question 5:
Modify question 4 to display ALL employees who make the top salary entered 
Ex: SQL> exec L5Q5(2) 
SQL> Employee who make the top 2 salary are
KING 5000
FORD 3000
SCOTT 3000 */
CREATE OR REPLACE PROCEDURE EMP_DETAILS2(TOP_SAL IN NUMBER) AS
CURSOR EMP_CURSOR IS
    WITH x AS (
                SELECT
                    DISTINCT desc_order.SAL
                FROM (
                        SELECT
                            SAL
                        FROM
                            EMP
                        ORDER BY
                            SAL DESC
                        ) desc_order
                WHERE ROWNUM <= TOP_SAL
                )
    SELECT
        ENAME,
        SAL
    FROM
        EMP
    WHERE SAL IN (
                    SELECT
                        SAL
                    FROM
                        x
                    )
    ORDER BY
        SAL DESC;    
    v_name EMP.ENAME%TYPE;
    v_sal EMP.SAL%TYPE;
BEGIN
    OPEN
        EMP_CURSOR;
    DBMS_OUTPUT.PUT_LINE('Employee who make the top ' || TOP_SAL || ' salary are:');
    LOOP
        FETCH
            EMP_CURSOR INTO
            v_name,
            v_sal;
        EXIT WHEN EMP_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');ab
    END LOOP;
    CLOSE
        EMP_CURSOR;
END;
/

exec EMP_DETAILS2(2)

exec EMP_DETAILS2(3)

exec EMP_DETAILS2(30)

SPOOL OFF;
