-- 7일차 PL/SQL
-- Oracle's Procedural Language Extension to SQL의 약자
-- 1.개요
--  - 오라클 자체에 내장되어 있는 절차적 언어로써, SQL의 단점을 보완하여 SQL문장
--  내에서 변수의 정의, 조건처리, 반복처리 등을 지원함.

-- 2. 구조(익명블록) -        블록문법
-- 1. 선언부(선택)           : DECLARE
-- 2. 실행부(필수)           : BEGIN
-- 3. 예외처리부(선택)       : EXCEPTION
-- 4. END;(필수)             : END;
-- 5. /(필수)                : /

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;
/
-- 출력 메시지를 화면에 표시하도록 설정
SET SERVEROUTPUT ON; -- developer 껐으면 실행해줘야 함!

DECLARE
    VID NUMBER;
BEGIN
--    VID := 1023;  --변수에 직접 값넣을때 방법 (초기화)
    SELECT SALARY
    INTO VID
    FROM EMPLOYEE
    WHERE EMP_NAME = '선동일';
    DBMS_OUTPUT.PUT_LINE('ID : '||VID);  -- ||로 결합
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA~');
END;
/
-- 2. PL/SQL 변수
DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE;  -- 테이블의 변수 타입을 갖고올 수 있다.
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSAL    NUMBER;     -- 직접 타입선언하기 힘들때 위처럼
    VHDATE  DATE;
BEGIN
    SELECT EMP_NO, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPNO, VENAME, VSAL, VHDATE
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE(VEMPNO || ' : ' || VENAME || ' : '|| VSAL || ' : ' || VHDATE);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA~');
END;
/


-- @실습문제1
-- 사번, 사원명, 직급명을 담을 수 있는 참조변수(%TYPE)를 통해서
-- 송종기 사원의 사번, 사원명, 직급명을 익명블럭을 통해 출력하세요.


DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_NO, EMP_NAME, JOB_NAME 
    INTO VEMPNO, VEMPNAME, VJOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMPNO || ', 사원명 : ' || VEMPNAME || ', 직급명 : ' || VJOBNAME);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA~');
END;
/

--PL/SQL 입력 받기
DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO VEMP       -- 하나의 변수에 모든 컬럼을 가져올 수 있음
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMP.EMP_ID || ', 이름 : ' || VEMP.EMP_NAME);
END;
/


-- @실습문제2
-- 사원번호를 입력받아서 해당 사원의 사원번호, 이름, 부서코드, 부서명을 출력하세요.

DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VDPCODE EMPLOYEE.DEPT_CODE%TYPE;
    VDPNAME DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPID, VEMPNAME, VDPCODE, VDPNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || VEMPID ||', 이름 : ' || VEMPNAME ||' 부서코드 : ' || VDPCODE ||', 부서명 : ' || VDPNAME);
END;
/



-- @실습문제3
-- EMPLOYEE 테이블에서 사번의 마지막 번호를 구한뒤 +1한 사번에 사용자로부터
-- 입력받은 이름, 주민번호, 전화번호, 직급코드, 급여등급을 등록하는 PL/SQL을 작성하시오.


DECLARE
    LAST_NUM EMPLOYEE.EMP_ID%TYPE;
BEGIN
    SELECT MAX(EMP_ID) 
    INTO LAST_NUM
    FROM EMPLOYEE;
    
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(LAST_NUM + 1, '&NAME', '&EMPNO', '&PHONE', '&JOBCODE', '&SALLEVEL');
    COMMIT;
END;
/

-- @실습문제1
-- 사원번호를 입력받아서 사원의 사번, 이름, 급여, 보너스율을 출력하시오
-- 단, 직급코드가 J1인 경우 '저희 회사 대표님입니다.'를 출력하시오.
-- 사번 : 222
-- 이름 : 이태림
-- 급여 : 2460000
-- 보너스율 : 0.35
-- 저희 회사 대표님입니다.

DECLARE
    VEMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || VEMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || VEMP.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || VEMP.BONUS * 100 || '%');
    
    IF(VEMP.JOB_CODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('저희 회사 대표님입니다.');
    ELSIF(VEMP.JOB_CODE = 'J6') THEN DBMS_OUTPUT.PUT_LINE('이태림');
    ELSE DBMS_OUTPUT.PUT_LINE('일반 직원입니다.');

    END IF;
END;
/
-- 2. IF (조건식) THEN 실행문 ELSE 실행문 END IF;

-- @실습문제2
-- 사원번호를 입력받아서 사원의 사번, 이름, 부서명, 직급명을 출력하시오.
-- 단, 직급코드가 J1인 경우 '대표', 그 외에는 '일반직원'으로 출력하시오.
-- 사번 : 201
-- 이름 : 송종기
-- 부서명 : 총무부
-- 직급명 : 부사장
-- 소속 : 일반직원
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VDPTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
    VJOBCODE JOB.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO VEMPID, VEMPNAME, VDPTITLE, VJOBNAME
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT OUTER JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMP_ID';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || VDPTITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : ' || VJOBNAME);
    
    IF(VJOBCODE = 'J1')
    THEN DBMS_OUTPUT.PUT_LINE('소속 : 대표');
    ELSE DBMS_OUTPUT.PUT_LINE('소속 : 일반직원');

    END IF;
END;
/

-- 3. IF (조건식) THEN 실행문 ELSIF (조건식) THEN 실행문 END IF;

-- @실습문제3
-- 사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오.
-- 500만원 이상(그외) : A
-- 400만원 ~ 499만원 : B
-- 300만원 ~ 399만원 : C
-- 200만원 ~ 299만원 : D
-- 100만원 ~ 199만원 : E
-- 0만원 ~ 99만원 : F

DECLARE 
    VEMP EMPLOYEE%ROWTYPE;
    LEVEL VARCHAR(2);
BEGIN
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    IF (VEMP.SALARY >= 5000000)
    THEN LEVEL := 'A';
    
    ELSIF(VEMP.SALARY >= 4000000)
    THEN LEVEL := 'B';
    
    ELSIF(VEMP.SALARY >= 3000000)
    THEN LEVEL := 'C';
    
    ELSIF(VEMP.SALARY >= 2000000)
    THEN LEVEL := 'D';
    
    ELSIF(VEMP.SALARY >= 1000000)
    THEN LEVEL := 'E';
   
    ELSE 
    LEVEL := 'F';
   
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || VEMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || VEMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || VEMP.SALARY);
    DBMS_OUTPUT.PUT_LINE('급여 등급 : ' || LEVEL);
END;
/


SELECT * FROM EMPLOYEE;
-- ELSIF와 대응되는 CASE문
-- CASE 변수
--  WHEN 값1 THEN 실행문1;
--  WHEN 값2 THEN 실행문2;
--  WHEN 값3 THEN 실행문3;
--  WHEN 값4 THEN 실행문4;
--  ELSE 실행문;
-- END CASE;

-- 위의 코드를 아래와 같이도 바꿀 수 있다
--SAL := FLOOR(1000000);
--CASE SAL
--    WHEN 0 THEN LEVEL := 'F';
--    WHEN 1 THEN LEVEL := 'E'; 
--    WHEN 2 THEN LEVEL := 'D';
--    WHEN 3 THEN LEVEL := 'C';
--    WHEN 4 THEN LEVEL := 'B';
--    ELSE LEVEL := 'A';
--END CASE;
--    