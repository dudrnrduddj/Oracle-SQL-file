-- 8일차 PL/SQL
-- Oracle's Procedural Language Extension to SQL의 약자

-- 블록문법
-- DECLARE
-- BEGIN 
-- EXCEPTION 
-- END;
-- /
SET SERVEROUTPUT ON;

DECLARE 
    --SALARY EMPLOYEE.SALARY%TYPE;
    EINFO EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EINFO
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMPID';
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EINFO.EMP_NAME || ', 급여 : '||EINFO.SALARY);
END;
/


-- PL/SQL IF문
-- IF (조건식) THEN 실행문 END IF;
-- IF (조건식) THEN 실행문 ELSE 실행문2 END IF;
-- IF (조건식) TEHN 실행문 ELSIF (조건식2) THEN 실행문2 ELSE 실행문3 END IF;



-- @실습문제3
-- 사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오.
-- 그때 출력 값은 사번, 이름, 급여, 급여등급을 출력하시오.
-- 500만원 이상(그외) : A
-- 400만원 ~ 499만원 : B
-- 300만원 ~ 399만원 : C
-- 200만원 ~ 299만원 : D
-- 100만원 ~ 199만원 : E
-- 0만원 ~ 99만원 : F

-- 사번 : 201
-- 이름 : 송종기
-- 급여 : 5000000
-- 급여등급 : A


DECLARE
    EMPID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    SLEVEL VARCHAR2(3);
    SALARYIF NUMBER;
    SALARYCASE NUMBER;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EMPID, ENAME, SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    SALARYIF := SALARY / 10000;
    SALARYCASE := FLOOR(SALARY / 1000000); -- 소수점 없애줘야함.
--    IF (SALARYIF BETWEEN 0 AND 99)
--    THEN SLEVEL := 'F';
--    ELSIF (SALARYIF BETWEEN 100 AND 199)
--    THEN SLEVEL := 'E';
--    ELSIF (SALARYIF BETWEEN 200 AND 299)
--    THEN SLEVEL := 'D';
--    ELSIF (SALARYIF BETWEEN 300 AND 399)
--    THEN SLEVEL := 'C';
--    ELSIF (SALARYIF BETWEEN 400 AND 499)
--    THEN SLEVEL := 'B';
--    ELSE SLEVEL := 'A';
--    END IF;
        
    CASE SALARYCASE
        WHEN 0 THEN SLEVEL := 'F';
        WHEN 1 THEN SLEVEL := 'E';
        WHEN 2 THEN SLEVEL := 'D';
        WHEN 3 THEN SLEVEL := 'C';
        WHEN 4 THEN SLEVEL := 'B';
        ELSE SLEVEL := 'A';
    END CASE;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    DBMS_OUTPUT.PUT_LINE('등급 : ' || SLEVEL);
END;
/

SELECT * FROM EMPLOYEE ORDER BY SALARY DESC;

-- CASE문
-- CASE 변수 
--      WHEN 변수가 가지는 값1 THEN 실행문1
--      WHEN 변수가 가지는 값2 THEN 실행문2
--      WHEN 변수가 가지는 값3 THEN 실행문3
--      WHEN 변수가 가지는 값4 THEN 실행문4
-- END CASE;

DECLARE
    INPUT NUMBER;
BEGIN
    INPUT := '&입력';
    CASE INPUT
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('빨간색입니다.');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('노란색입니다.');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('초록색입니다.');
    END CASE;
END;
/



-- PL/SQL의 반복문
-- 1. LOOP
-- 2. WHILE LOOP
-- 3. FOR LOOP

-- 예제 1~5까지 반복 출력하기
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        EXIT WHEN N > 5;
    END LOOP;
--    DBMS_OUTPUT.PUT_LINE();
--    DBMS_OUTPUT.PUT_LINE(3);
--    DBMS_OUTPUT.PUT_LINE(4);
--    DBMS_OUTPUT.PUT_LINE(5);
END;
/



-- @실습문제1
-- 1 ~ 10 사이의 난수를 5개 출력해보시오.

DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(FLOOR(DBMS_RANDOM.VALUE(1, 11)));
        N := N + 1;
    EXIT WHEN N > 5;
    END LOOP;
END;
/

-- 2. WHILE LOOP
-- 제어 조건이 TRUE인 동안만 문장이 반복 실행됨
-- LOOP를 실행할 때 조건이 처음부터 FALSE이면 한번도 수행되지 않을 수 있음.
-- EXIT절이 없어도 조건절에 반복문 중지 조건을 기술할 수 있음.
-- WHILE(조건식) LOOP 시행문 END LOOP;

DECLARE
    N NUMBER := 1;
BEGIN
    WHILE(N <= 5)
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/

-- @실습문제2
-- 사용자로부터 2~9사이의 수를 입력받아 구구단을 출력하시오.

DECLARE
    N NUMBER;
    X NUMBER := 1;
BEGIN
    N := '&단';
    WHILE(X < 9)
    LOOP
        IF (N BETWEEN 2 AND 9)
        THEN
            WHILE(X < 10)
            LOOP
                DBMS_OUTPUT.PUT_LINE(N||' * '|| X || ' = ' || N * X);
                X := X + 1;
            END LOOP;
        ELSE 
            X := 10;
            DBMS_OUTPUT.PUT_LINE('2 ~ 9 사이의 숫자를 입력해주세요!');
        END IF;
    END LOOP;
    
END;
/


-- @실습문제3
-- 1 ~ 30까지의 수 중에서 홀수만 출력하시오~
-- CONTINUE WHEN 조건식
-- EXIT WHEN 조건식
--> EXIT이 JAVA의 BREAK역할을 함


DECLARE
    N NUMBER := 0;
BEGIN
    WHILE(N < 30)
    LOOP
    
    
    N := N + 1;
    CONTINUE WHEN MOD(N,2) = 0; -- 나머지가 0이면 짝수니까 
   
    DBMS_OUTPUT.PUT_LINE(N);
            
    
    END LOOP;
END;
/

-- 3. FOR LOOP
-- FOR LOOP문에서 카운트용 변수는 자동선언됨, 따로 선언할 필요가 없음
-- 카운트 값은 자동으로 1씩 증가함.
BEGIN 
    FOR D IN 1..100
    LOOP
        DBMS_OUTPUT.PUT_LINE(D);
    END LOOP;
END;
/

-- @실습문제4
-- EMPLOYEE 테이블의 사번이 200 ~ 210인 직원들의 사원번호, 사원명, 이메일을 출력하시오~!
DECLARE
    EINFO EMPLOYEE%ROWTYPE;
BEGIN
    FOR EMP_IDS IN 200.. 210    -- for문에서 쓰이는 변수는 declare문에서 선언할 필요 없음!
    LOOP
        SELECT *
        INTO EINFO
        FROM EMPLOYEE
        WHERE EMP_ID = EMP_IDS;
    
        DBMS_OUTPUT.PUT_LINE('사원번호 : ' || EINFO.EMP_ID);
        DBMS_OUTPUT.PUT_LINE('사원명 : ' || EINFO.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('이메일 : ' || EINFO.EMAIL);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/


-- @실습문제5
-- KH_NUMBER_TBL은 숫자타입의 컬럼 NO와 날짜타입의 컬럼 INPUT_DATE를 가지고 있다.
-- KH_NUMBER_TBL 테이블에 0 ~ 99 사이의 난수를 10개 저장하시오. 날짜는 상관없음.

CREATE TABLE KH_NUMBER_TBL(
    NO NUMBER,
    INPUT_DATE DATE
);


DECLARE
    X NUMBER;
BEGIN
    FOR I IN 1..10
    LOOP
    X := FLOOR(DBMS_RANDOM.VALUE(0, 100));
    INSERT INTO KH_NUMBER_TBL(NO) VALUES(X);
    END LOOP;
END;
/

SELECT * FROM KH_NUMBER_TBL;
DELETE FROM KH_NUMBER_TBL;



-- PL/SQL 예외처리
-- 시스템 오류(메모리 초과, 인덱스 중복 키 등)는 오라클이 정의하는 에러로
-- 보통 PL/SQL 실행 엔진이 오류 조건을 탐지하여 발생시키는 예외임.

-- NO_DATA_FOUND
-- SELECT INTO 문장의 결과로 선택된 행이 하나도 없을 경우
-- DUP_VAL_ON_INDEX
-- UNIQUE 인덱스가 설정된 컬럼에 중복 데이터를 입력할 경우
-- CASE_NOT_FOUND
-- CASE문장에서 ELSE 구문도 없고 WHEN절에 명시된 조건을 만족하는 것이 없을 경우
-- ACCESS_INTO_NULL
-- 초기화되지 않은 오브젝트에 값을 할당하려고 할 때
-- COLLECTION_IS_NULL
-- 초기화되지 않은 중첩 테이블이나 VARRAY같은 컬렉션을 EXISTS외에 다른 메소드로 접근을 시도할 경우
-- CURSOR_ALREADY_OPEN
-- 이미 오픈된 커서를 다시 오픈하려고 시도하는 경우
-- INVALID_CURSOR
-- 허용되지 않은 커서에 접근할 경우 (OPEN되지 않은 커서를 닫으려고 할 경우)
-- INVALID_NUMBER
-- SQL문장에서 문자형 데이터를 숫자형으로 변환할 때 제대로 된 숫자로 변환되지 않을 경우
-- LOGIN_DENIED
-- 잘못된 사용자명이나 비밀번호로 접속을 시도할 때


