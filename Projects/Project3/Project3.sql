/*
  @/tmp/oracle/Project3/Project3.sql
*/

/*
Name: Riya Nagpal
ID: 2220097
Date: 2022/09/23
Description - Databases 2 - Project 3
*/

SPOOL /tmp/oracle/Project3/Project3_SPOOL.txt

SELECT    
    to_char(sysdate, 'DD Month YYYY Year Day HH:MI:SS Am') 
FROM dual;

SET SERVEROUTPUT ON

/*
Question 1: (user scott) 
Create a procedure that accepts an employee number to display the name of the department where he 
works, his name, his annual salary (do not forget his one time commission)
Note that the salary in table employee is monthly salary. 
Handle the error (use EXCEPTION) 
hint: the name of the department can be found from table dept.
*/

connect scott/tiger
CREATE OR REPLACE PROCEDURE EMP_DETAILS(emp_number in NUMBER) AS
v_job emp.job%TYPE;
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;
v_comm emp.comm%TYPE;
BEGIN
 SELECT job, ename, sal*12, comm
 INTO v_job, v_ename, v_sal, v_comm
 FROM emp
 WHERE empno = emp_number;

  DBMS_OUTPUT.PUT_LINE('Employee number ' || emp_number || ' is ' ||
    v_ename || ' earning $' || v_sal ||' annualy with a commission of ' || v_comm || ' as a ' || v_job || '!');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Department ' || v_job ||
' cannot be found');
END;
/
SET SERVEROUTPUT ON
EXEC EMP_DETAILS(7654)
EXEC EMP_DETAILS(1234)

/*
Question 2: (use schemas des02, and script 7clearwater)
Create a procedure that accepts an inv_id to display the item description, price, color, inv_qoh, and the
value of that inventory.
Handle the error ( use EXCEPTION)
Hint: value is the product of price and quantity on hand.
*/
CONNECT des02/des02;
CREATE OR REPLACE PROCEDURE ITEM_DETAILS(p_inv_id IN NUMBER) AS
v_item_desc item.item_desc%TYPE;
v_price inventory.inv_price%TYPE;
v_color inventory.color%TYPE;
v_inv_qoh inventory.inv_qoh%TYPE;
v_value NUMBER;
BEGIN 
 SELECT item_desc, inv_price, color, inv_qoh
 INTO v_item_desc, v_price, v_color, v_inv_qoh
 FROM inventory inv JOIN ITEM i ON inv.ITEM_ID = i.ITEM_ID
 WHERE inv_id = p_inv_id;
 v_value := v_price*v_inv_qoh;

 DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || p_inv_id || chr(10) ||
        'Description: ' || v_item_desc || chr(10) ||
        'Price: $' || v_price || chr(10) ||
        'Color: ' || v_color || chr(10) ||
        'In Stock: ' || v_inv_qoh || chr(10) ||
        'Total Value: $' || v_value);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Item with Inventory ID ''' || p_inv_id || ''' doesn''t exist!');
END;
/

SET SERVEROUTPUT ON
EXEC ITEM_DETAILS(5)
EXEC ITEM_DETAILS(28)

/*
Question 3: (use schemas des03, and script 7northwoods)
Create a function called find_age that accepts a date and return a number. 
The function will use the sysdate and the date inserted to calculate the age of the person with the 
birthdate inserted. 
Create a procedure that accepts a student number to display his name, his birthdate, and his age using 
the function find_age created above. 
Handle the error ( use EXCEPTION)
*/
CONNECT des03/des03;
CREATE OR REPLACE FUNCTION find_age(BIRTH_DATE DATE) RETURN NUMBER AS
BIRTHDAY DATE; 
AGE NUMBER;
BEGIN 
 BIRTHDAY := BIRTH_DATE;
 AGE := to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(BIRTHDAY, 'YYYY'));
RETURN AGE;
END;
/

CREATE OR REPLACE PROCEDURE STUD_DETAILS(STUD_NUMBER IN NUMBER) AS
 FIRST_NAME STUDENT.S_FIRST%TYPE;
 LAST_NAME STUDENT.S_LAST%TYPE;
 BIRTHDATE STUDENT.S_DOB%TYPE;
 AGE NUMBER;
BEGIN
    SELECT
        S_FIRST,
        S_LAST,
        S_DOB INTO
        FIRST_NAME,
        LAST_NAME,
        BIRTHDATE
    FROM
        STUDENT
    WHERE
        S_ID = STUD_NUMBER;
    AGE := find_age(BIRTHDATE);
    DBMS_OUTPUT.PUT_LINE('Student No.: ' || STUD_NUMBER || chr(10) ||
        'Name: ' || FIRST_NAME || ' ' || LAST_NAME || chr(10) ||
        'Date of Birthday: ' || BIRTHDATE || chr(10) ||
        'Age: ' || AGE);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student with No. ''' || STUD_NUMBER || ''' doesn''t exist!');
END;
/

SET SERVEROUTPUT ON

exec STUD_DETAILS(4)
exec STUD_DETAILS(6)
exec STUD_DETAILS(2111)


/* Question 4: (use schemas des04, and script 7software)
We need to INSERT or UPDATE data of table consultant_skill, 
create needed functions, procedures … that accepts 
consultant id, skill id, and certification status for the task. 
The procedure should be user friendly enough to handle all possible 
errors such as consultant id, skill id do not exist OR certification 
status is different than ‘Y’, ‘N’. 
Make sure to display: Consultant last, first name, skill description 
and the confirmation of the DML performed 
(hint: Do not forget to add COMMIT inside the procedure) */
CONNECT des04/des04;

CREATE OR REPLACE PROCEDURE cons_skill(cons_id NUMBER, i_skill_id NUMBER, cert_status VARCHAR2) AS
    c_last_name CONSULTANT.C_LAST%TYPE;
    c_first_name CONSULTANT.C_FIRST%TYPE;
    skill_desc SKILL.SKILL_DESCRIPTION%TYPE;
    existing_skill_id NUMBER;
    existing_cons_id NUMBER;
BEGIN
    IF cert_status IN ('Y', 'N') THEN 
        SELECT
            C_LAST,
            C_FIRST,
            SKILL_DESCRIPTION INTO
            c_last_name,
            c_first_name,
            skill_desc
        FROM
            CONSULTANT c JOIN CONSULTANT_SKILL cs ON c.C_ID = cs.C_ID
            JOIN SKILL s ON s.SKILL_ID = cs.SKILL_ID
        WHERE
            cs.C_ID = cons_id AND
            cs.SKILL_ID = i_skill_id;        
        UPDATE
            CONSULTANT_SKILL
        SET
            CERTIFICATION = cert_status
        WHERE
            C_ID = cons_id AND
            SKILL_ID = i_skill_id;    
        DBMS_OUTPUT.PUT_LINE('Skill ID ''' || i_skill_id || ''' of Consultant with ID ''' || cons_id || ''' has been UPDATED!');
        DBMS_OUTPUT.PUT_LINE('Consultant: ' || c_last_name || ' ' || c_first_name || chr(10) ||
            'Skill: ' || skill_desc || chr(10) ||
            'Certification: ' || cert_status);
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Certification Status must be ''Y'' or ''N''!');            
    END IF;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT
                count(*) INTO
                existing_skill_id
            FROM
                SKILL
            WHERE
                SKILL_ID = i_skill_id;
        END;

        BEGIN
            SELECT
                count(*) INTO
                existing_cons_id
            FROM
                CONSULTANT
            WHERE
                C_ID = cons_id;
        END;

        IF (existing_cons_id > 0) AND (existing_skill_id > 0) THEN
            INSERT INTO CONSULTANT_SKILL(
                C_ID,
                SKILL_ID,
                CERTIFICATION
            ) VALUES(
                cons_id,
                i_skill_id,
                cert_status
            );
            DBMS_OUTPUT.PUT_LINE('Skill ID ''' || i_skill_id || ''' of Consultant with ID ''' || cons_id || ''' has been INSERTED!');
            DBMS_OUTPUT.PUT_LINE('Consultant: ' || c_last_name || ' ' || c_first_name || chr(10) ||
                'Skill: ' || skill_desc || chr(10) ||
                'Certification: ' || cert_status);
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Consultant ID or Skill ID is INVALID!');
        END IF;
END;
/

    SET SERVEROUTPUT ON

    SET LINESIZE 200;

    exec cons_skill(100, 9, 'Y')

    exec cons_skill(103, 1, 'Z')

    exec cons_skill(102, 4, 'Y')

    exec cons_skill(100, 8, 'N')

    exec cons_skill(104, 10, 'Y')

    exec cons_skill(110, 3, 'Y')

SPOOL OFF;