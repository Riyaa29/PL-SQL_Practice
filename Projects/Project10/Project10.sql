/*
  @/tmp/oracle/Project10/Project10.sql
*/

/*
Name: Riya Nagpal
ID: 2220097
Date: 2022/11/22
Description - Databases 2 - Project 10
*/

SPOOL /tmp/oracle/Project10/Project10_SPOOL.txt

SELECT    
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am') 
FROM dual;

SET SERVEROUTPUT ON;

/* Question 1: (use schemas des02 with script 7clearwater)
We need to know WHO, and WHEN the table CUSTOMER is modified.
Create table, sequence, and trigger to record the needed information.
Test your trigger! */
CONNECT des02/des02

DROP SEQUENCE c_mod_sequence;

CREATE SEQUENCE c_mod_sequence;

DROP TABLE c_mod CASCADE CONSTRAINTS;

CREATE TABLE c_mod(c_mod_id NUMBER,
                    updating_user VARCHAR2(20),
                    date_updated DATE);

CREATE OR REPLACE TRIGGER c_mod_trigger
AFTER INSERT OR UPDATE OR DELETE ON CUSTOMER
BEGIN
    INSERT INTO c_mod
    VALUES(c_mod_sequence.NEXTVAL, user, sysdate);
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON CUSTOMER TO scott;

GRANT SELECT, INSERT, UPDATE, DELETE ON CUSTOMER TO des03;


CONNECT scott/tiger

UPDATE des02.CUSTOMER
SET C_FIRST = 'Riya-Nagpal'
WHERE
    C_ID = 1;
COMMIT;


CONNECT des03/des03

UPDATE des02.CUSTOMER
SET C_ADDRESS = '1603 Brooklyn, Apt.#200'
WHERE
    C_ID = 6;
COMMIT;


CONNECT des02/des02

SET SERVEROUTPUT ON

SELECT * FROM C_MOD;

REVOKE SELECT, INSERT, UPDATE, DELETE ON CUSTOMER FROM scott;

REVOKE SELECT, INSERT, UPDATE, DELETE ON CUSTOMER FROM des03;





/* Question 2:
Table ORDER_LINE is subject to INSERT, UPDATE, and DELETE, 
create a trigger to record who, when, and the action 
performed on the table order_line in a table called order_line_audit.
(hint: use UPDATING, INSERTING, DELETING to verify for 
action performed. For example: IF UPDATING THEN …)
Test your trigger! */
CONNECT des02/des02

DROP SEQUENCE order_line_audit_seq;

CREATE SEQUENCE order_line_audit_seq;

DROP TABLE order_line_audit CASCADE CONSTRAINTS;

CREATE TABLE order_line_audit(order_line_audit_id NUMBER,
                            updating_user VARCHAR2(20),
                            date_updated DATE,
                            action_performed VARCHAR2(30));

CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON ORDER_LINE
BEGIN
    IF INSERTING THEN
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'INSERT');
    ELSIF UPDATING THEN 
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'UPDATE');
    ELSIF DELETING THEN 
        INSERT INTO order_line_audit 
        VALUES(order_line_audit_seq.NEXTVAL, user, sysdate, 'DELETE');
    END IF; 
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_LINE TO scott;

GRANT SELECT, INSERT, UPDATE, DELETE ON ORDER_LINE TO des03;


CONNECT scott/tiger

UPDATE des02.ORDER_LINE
SET OL_QUANTITY = 100
WHERE
    O_ID = 1 AND INV_ID = 1;
COMMIT;

INSERT INTO des02.ORDER_LINE
VALUES(2, 14, 99);
COMMIT;


CONNECT des03/des03

DELETE FROM des02.ORDER_LINE
WHERE
    O_ID = 1 AND INV_ID = 14;
COMMIT;


CONNECT des02/des02

SET SERVEROUTPUT ON

SELECT * FROM order_line_audit;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ORDER_LINE FROM scott;

REVOKE SELECT, INSERT, UPDATE, DELETE ON ORDER_LINE FROM des03;





/* Question 3: (use script 7clearwater)
Create a table called order_line_row_audit to record 
who, when, and the OLD value of ol_quantity every time 
the data of table ORDER_LINE is updated.
Test your trigger! */
CONNECT des02/des02

DROP SEQUENCE order_line_row_audit_seq;

CREATE SEQUENCE order_line_row_audit_seq;

DROP TABLE order_line_row_audit CASCADE CONSTRAINTS;

CREATE TABLE order_line_row_audit(order_line_row_audit_id NUMBER,
                                updating_user VARCHAR2(20),
                                date_updated DATE,
                                old_ol_quantity NUMBER);

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE ON ORDER_LINE
FOR EACH ROW
BEGIN
    INSERT INTO order_line_row_audit
    VALUES(order_line_row_audit_seq.NEXTVAL,
            user,
            sysdate,
            :OLD.OL_QUANTITY);
END;
/

GRANT SELECT, UPDATE ON ORDER_LINE TO scott;

GRANT SELECT, UPDATE ON ORDER_LINE TO des03;


CONNECT scott/tiger

UPDATE des02.ORDER_LINE
SET OL_QUANTITY = 50
WHERE
    O_ID = 3;
COMMIT;


CONNECT des03/des03

UPDATE des02.ORDER_LINE
SET OL_QUANTITY = 250
WHERE
    O_ID = 5;
COMMIT;


CONNECT des02/des02

SET SERVEROUTPUT ON

SELECT * FROM order_line_row_audit;

REVOKE SELECT, UPDATE ON ORDER_LINE FROM scott;

REVOKE SELECT, UPDATE ON ORDER_LINE FROM des03;


SPOOL OFF;