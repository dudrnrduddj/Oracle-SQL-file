-- 8일차
-- 오라클 객체 Trigger
-- 트리거 : 방아쇠, 연쇄반응
-- 특정 이벤트나 DDL, DML 문장이 실행되었을 때
-- 자동적으로 일련의 동작(Operation) 처리가 수행되도록 하는 데이터베이스 객체 중 하나임
-- 예시) 회원탈퇴가 이루어진 경우 탈퇴한 회원 정보를 일정기간 저장해야 하는 경우
-- 예시2) 데이터 변경이 있을 때, 조작한 데이터에 대한 로그(이력)을 남겨야 하는 경우

-- 트리거 사용 방법
-- CREATE TRIGGER 트리거명
-- BEFORE (OR AFTER)
-- DELETE (OR UPDATE OR INSERT) ON 테이블명
-- [FOR EACH ROW]
-- BEGIN
--      (실행문)
-- END;
-- /

-- 예제. 사원 테이블에 새로운 데이터가 들어오면 '신입사원이 입사하였습니다.'를 출력하기


CREATE OR REPLACE TRIGGER TRG_EMP_NEW
AFTER
INSERT ON EMPLOYEE --트리거가 행이 삽입(INSERT)될 때 실행됨
FOR EACH ROW -- 삽입된 각 행에 대해 한 번씩 실행
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사하였습니다.');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
VALUES((SELECT MAX(EMP_ID)+1 FROM EMPLOYEE), '이용자', '000624-3223444', '01011112222', 'J5', 'S5');
--> 신입사원이 입사하였습니다.
--> 1행이(가) 삽입되었습니다.

-- 만약 아래처럼 여러 행을 삽입한다면 trigger실행문이 여러번 실행됨.
-- ex)
--INSERT INTO EMPLOYEE (emp_id, emp_name, hire_date)
--VALUES
--    (1, 'John Doe', SYSDATE),
--    (2, 'Jane Smith', SYSDATE),
--    (3, 'Michael Johnson', SYSDATE);

-- 예제2. EMPLOYEE 테이블에 급여 정보가 변경되면 전후 정보를 화면에 출력하는 트리거를 생성하시오.
CREATE OR REPLACE TRIGGER TRG_EMP_SALARY
AFTER
UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF(:OLD.SALARY != :NEW.SALARY)
    THEN
        DBMS_OUTPUT.PUT_LINE('급여 정보가 변경되었습니다.');
        DBMS_OUTPUT.PUT_LINE('변경 전 : '|| :OLD.SALARY); -- 변경 전의 레코드(OLD)
        DBMS_OUTPUT.PUT_LINE('변경 후 : '|| :NEW.SALARY); -- 변경 후의 레코드(NEW)
    END IF;
END;
/
-- 정보가 나오지 않으면 COMMIT 해보기(메모)
UPDATE EMPLOYEE SET SALARY = 5000000 WHERE EMP_ID = '211';
SELECT * FROM EMPLOYEE WHERE EMP_ID = '211';
ROLLBACK;

-- 의사레코드 OLD, NEW
-- FOR EACH ROW를 사용
-- 1. INSERT : OLD(NULL), NEW
-- 2. UPDATE : OLD, NEW
-- 3. DELETE : OLD, NEW(NULL)





-- @실습예제1
-- 1. 제품 PRODUCT 테이블은 숫자로 된 PCODE컬럼이 있고 PRIMARY KEY로 지정, 문자열 크기 30인
-- PNAME인 컬럼, 문자열 크기 30인 BRAND컬럼, 숫자로 된 PRICE 컬럼, 숫자로 되어 있고 기본값이 0인 STOCK컬럼이 있음.
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 1
);
    
-- 2. 제품 입출고 PRODUCT_IO 테이블은 숫자로 된 IOCODE 컬럼이 있고 PRIMARY KEY로 지정,
-- 숫자로 된 PCODE컬럼, 날짜로 된 PDATE 컬럼, 숫자로된 AMOUNT컬럼, 문자열 크기가 10인
-- STATUS컬럼이 있음. STATUS컬럼은 입고 또는 출고만 입력가능함.
-- PCODE는 PRODUCT 테이블의 PCODE를 참조하여 외래키로 설정되어 있음.
CREATE TABLE PRODUCT_IO(
    IOCODE NUMBER PRIMARY KEY,
    PCODE NUMBER CONSTRAINT FK_PRODUCT_ID REFERENCES PRODUCT(PCODE), -- 컬럼레벨 외래키 선언
    PDATE DATE,
    AMOUNT NUMBER,
    STATUS VARCHAR2(10) CHECK(STATUS IN ('입고', '출고'))
--    CONSTRAINT FK_PRODUCT_ID FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE) -- 테이블 레벨 외래키 선언
);
--ALTER로 외래키 추가 (삭제옵션)
--ALTER TABLE PRODUCT_ID ADD CONSTRAINT FK_PCODE FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE) ON DELETE CASCADE;


-- 3. 시퀀스는 SEQ_PRODUCT_PCODE, SEQ_PRODUCTIO_IOCODE라는 이름으로 기본값으로 설정되어있음.
CREATE SEQUENCE SEQ_PRODUCT_PCODE
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;


CREATE SEQUENCE SEQ_PRODUCTIO_IOCODE
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;


-- 4. 트리거의 이름은 TRG_PRODUCT 이고 PRODUCT_IO 테이블에 입고를 하면 PRODUCT 테이블에
-- STOCK 컬럼에 값을 추가하고 PRODUCT_IO 테이블에 출고를 하면 STOCK 컬럼에 값을 빼주는 역할을 함


CREATE OR REPLACE TRIGGER TRG_PRODUCT
AFTER                                   -- 후에 트리거 실행
INSERT ON PRODUCT_IO                    -- PRODUCT_IO에 insert 되면 실행
FOR EACH ROW                            -- 1행이 insert될때마다 실행
DECLARE
    V_STOCK PRODUCT.STOCK%TYPE;         -- 실행문에서 사용할 변수 사용
BEGIN
    SELECT STOCK                        -- 변수값 테이블에서의 값으로 초기화
    INTO V_STOCK
    FROM PRODUCT
    WHERE PCODE = :NEW.PCODE;

    IF (:NEW.STATUS = '입고')             -- :NEW.STATUS가 입고일떄 실행 -> :NEW는 트리거문 안에서 사용(PRODUCT_IO를 가리킴)하는 레코드의 변경값을 불러옴 (변경후의 레코드)
    THEN
        UPDATE PRODUCT SET STOCK = V_STOCK + :NEW.AMOUNT WHERE PCODE = :NEW.PCODE; 
        -- > product테이블의 stock값에 v_stock + product_IO의 amount값의 변경 후 레코드, 조건은 product의 pcode가 product_io의 pcode의 변경후 레코드와 같은가?를 체크
    ELSE
        IF(V_STOCK - :NEW.AMOUNT >= 0) --> 현재수량에서 새로 변경되는 수량값을 뺀 값이 0보다 커야지 그 수량만큼 출고가 가능!
        THEN
            UPDATE PRODUCT SET STOCK = V_STOCK - :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
        ELSE
            DBMS_OUTPUT.PUT_LINE('재고가 부족합니다. 남은수량 : '|| V_STOCK);
        END IF;
    END IF;
END;
/



INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT_PCODE.NEXTVAL, '갤럭시폰', '삼성', 2000000, DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT_PCODE.NEXTVAL, '아이폰', '애플', 2300000, DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT_PCODE.NEXTVAL, '중국폰', '샤오미', 100000, DEFAULT);


INSERT INTO PRODUCT_IO
VALUES(SEQ_PRODUCTIO_IOCODE.NEXTVAL, 1, SYSDATE, 1, '입고');
INSERT INTO PRODUCT_IO
VALUES(SEQ_PRODUCTIO_IOCODE.NEXTVAL, 1, SYSDATE, 1, '출고');

SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_IO;
DROP TABLE PRODUCT;
DROP TABLE PRODUCT_IO;

DROP SEQUENCE SEQ_PRODUCT_PCODE;
DROP SEQUENCE SEQ_PRODUCTIO_IOCODE;
DESC PRODUCT;
DESC PRODUCT_IO;

-- 주의!! 
-- 실행시킬때마다 시퀀스 객체의 currval이 증가하므로 필요에 따라 시퀀스도 초기화해주어야 함!




.