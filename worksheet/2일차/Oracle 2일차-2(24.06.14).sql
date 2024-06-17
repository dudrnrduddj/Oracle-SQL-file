-- CHAR(SIZE) -> 지정한 크기보다 작은 문자(열)이 입력되고 남는 공간을 공백으로 채움.
--vs
--VARCHAR(SIZE) -> 지정한 크기보다 작은 문자(열)이 입력되고 남는 공간을 공백으로 채우지 않음.

CREATE TABLE USER_NO_CONSTRAINT (
    USER_NO NUMBER,
    USER_ID VARCHAR(20),
    USER_PWD VARCHAR(30),
    USER_NAME VARCHAR(10),
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)

);

SELECT * FROM USER_NO_CONSTRAINT;

INSERT INTO USER_NO_CONSTRAINT(USER_NO, USER_ID, USER_PWD, USER_NAME, USER_GENDER, USER_PHONE,
USER_EMAIL) VALUES(1, 'khuser01', 'password01', '일용자', '남', '01012345678','khuser01@gmail.com');

COMMIT;

-- 제약 조건!
-- null을 넣고도 회원가입이 되면 안됨.
INSERT INTO USER_NO_CONSTRAINT 
VALUES(2, 'khuser02', null, null, null, null, null);

-- 제약 조건 1. NOT NULL
-- COLUMN LEVEL 방식의 제약 조건 주기
-- NOT NULL
CREATE TABLE USER_NOTNULL (
    USER_NO NUMBER,
    USER_ID VARCHAR(20) NOT NULL,
    USER_PWD VARCHAR(30) NOT NULL,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)
);

INSERT INTO USER_NOTNULL 
VALUES(2, 'khuser02', '02', '이용자', null, null, null);

--제약 조건에 어긋나면 오류 발생하고 실행 X
INSERT INTO USER_NOTNULL 
VALUES(2, null, null, '이용자', null, null, null);

SELECT * FROM USER_NOTNULL;

-- 제약조건 2. UNIQUE
CREATE TABLE USER_UNIQUE (
    USER_NO NUMBER,
    USER_ID VARCHAR(20) UNIQUE,
    USER_PWD VARCHAR(30) UNIQUE,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)
);
INSERT INTO  USER_UNIQUE
VALUES(2, 'khuser01', '01', '이용자', null, null, null);
INSERT INTO  USER_UNIQUE
VALUES(1, 'khuser01', '01', '일용자', null, null, null); -- 오류 발생! 아이디, 비밀번호 중복

SELECT * FROM USER_UNIQUE;



-- 제약 조건 3. UNIQUE NOT NULL
CREATE TABLE USER_UNIQUE_NOT_NULL (
    USER_NO NUMBER,
    USER_ID VARCHAR(20) UNIQUE NOT NULL,
    USER_PWD VARCHAR(30) UNIQUE NOT NULL,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)
);
-- unique 지만 null이 들어가는 문제 발생
-- not null도 추가 ( UNIQUE NOT NULL)
INSERT INTO  USER_UNIQUE_NOT_NULL
VALUES(1, null, null, '일용자', null, null, null);
SELECT * FROM USER_UNIQUE_NOT_NULL;


-- 제약 조건 4. PRIMARY KEY ( UNIQUE NOT NULL기능을 하면서 테이블끼리 연결까지 함.)
-- 관계형 데이터베이스는 key가 필요한데 이 key역할을 하게 됨.
-- 테이블끼리 연결을 할 수 있는 Column이 될 수 있음.
CREATE TABLE USER_PRIMARY_KEY (
    USER_NO NUMBER,
    USER_ID VARCHAR(20) UNIQUE,
    USER_PWD VARCHAR(30) PRIMARY KEY,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)
);

INSERT INTO USER_PRIMARY_KEY
VALUES(2, 'khuser02', '02', '이용자', null, null, null);
INSERT INTO  USER_PRIMARY_KEY
VALUES(1, 'khuser01', '01', '일용자', null, null, null);
SELECT * FROM USER_PRIMARY_KEY;


-- 위 요약!
-- 제약 조건을 넣었을 때 조건에 해당하지 않는 값을 넣게 되면 오류가 발생!
-- 1. NOT NULL -> NULL 값을 못넣음
-- 2. UNIQUE -> 고유한 값이 들어감(중복 X) 하지만 NULL값이 들어감
-- 3. NOT NULL UNIQUE -> 두 제약조건을 기능함. 하지만 테이블간의 관계를 줄 수 없음.
-- 4. PRIMARY KEY -> NOT NULL UNIQUE 기능을 하면서 테이블간의 연결 기능도 할 수 있음.


-- 제약조건 5. CHECK(필드명 IN(값1, 값2, 값3, ...))
-- USER_GENDER 값이 의미는 같지만 서로 다른 식으로 표현하고 있는 상황!!
CREATE TABLE USER_CHECK (
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR(20) PRIMARY KEY,
    USER_PWD VARCHAR(30) NOT NULL,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M', 'F')),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50)
);

INSERT INTO USER_CHECK
VALUES(1, 'khuser01', 'pass01', '일용자', '남', null, null);
INSERT INTO USER_CHECK
VALUES(2, 'khuser02', 'pass02', '이용자', 'M', null, null);
INSERT INTO USER_CHECK
VALUES(3, 'khuser03', 'pass03', '삼용자', 'Male', null, null);

SELECT * FROM USER_CHECK;




---- 제약 조건 6. DEFAULT 
CREATE TABLE USER_DEFAULT (
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR(20) PRIMARY KEY,
    USER_PWD VARCHAR(30) NOT NULL,
    USER_NAME VARCHAR(10) NOT NULL,
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M', 'F')),
    USER_PHONE VARCHAR(30),
    USER_EMAIL VARCHAR(50),
    USER_DATE DATE DEFAULT SYSDATE
);
INSERT INTO USER_DEFAULT
VALUES(1, 'khuser01', 'pass01', '일용자', 'M', '01022223333', 'khuser02@naver.com', '24/06/14');

INSERT INTO USER_DEFAULT
VALUES(2, 'khuser02', 'pass02', '이용자', 'M', '01077778888', 'khuser01@naver.com', SYSDATE+7);

INSERT INTO USER_DEFAULT
VALUES(3, 'khuser03', 'pass03', '삼용자', 'M', '01077778888', 'khuser01@naver.com', DEFAULT);

SELECT * FROM USER_DEFAULT;

-- 요약
--  5. CHECK : 지정된 값만 저장되도록 함
--  6. DEFAULT : 지정된 함수나 표현식으로 실행되도록 함



---- 7. FOREIGN KEY(외래키)

CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
SELECT * FROM USER_GRADE;
INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');
INSERT INTO USER_GRADE VALUES(40, 'VIP회원');

DELETE FROM USER_GRADE WHERE GRADE_CODE=40; -- -> 참조무결성을 지켜야 하기 때문에
-- 참조를 받고 있는 필드가 있는 한 삭제시킬 수 없다.


CREATE TABLE USER_FOREIGN_KEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE NOT NULL,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M', 'F')),
    USER_PHONE VARCHAR2(30),
    USER_EMAIL VARCHAR2(50),
    USER_DATE DATE DEFAULT SYSDATE,
    GRADE_CODE NUMBER REFERENCES USER_GRADE(GRADE_CODE) ON DELETE CASCADE --SET NULL
    -- > REFERENCES : USER_GRADE테이블의 GRADE_CODE 값을 참조하는 조건 제약
    -- > ON DELETE SET NULL : REFERENCES의 테이블에서 삭제시켰을때 이 테이블에서 값이 NULL로 세팅됨.
    -- > ON DELETE CASCADE : 삭제시켰을 때 이 테이블에서 레코드 삭제됨.
);

SELECT * FROM USER_FOREIGN_KEY;

INSERT INTO USER_FOREIGN_KEY(USER_NO, USER_ID, USER_PWD, USER_NAME, USER_GENDER, USER_PHONE, USER_EMAIL, USER_DATE, GRADE_CODE)
VALUES(1, 'khuser01', 'pass01', '일용자', 'M', null, null, DEFAULT, 10);

INSERT INTO USER_FOREIGN_KEY
VALUES(2, 'khuser02', 'pass02', '이용자', 'M', null, null, DEFAULT, 20);

INSERT INTO USER_FOREIGN_KEY
VALUES(3, 'khuser03', 'pass03', '삼용자', 'M', null, null, DEFAULT, 30);
-- USER_FOREIGN_KEY에 있는 GRADE_CODE는 USER_GRADE의 GRADE_CODE가 가지고 있는 10, 20, 30만 넣게 하고 싶을 때
-- 조건 제약 7. REFERENCES
INSERT INTO USER_FOREIGN_KEY
VALUES(4, 'khuser04', 'pass04', '사용자', 'M', null, null, DEFAULT, 40);
-- 만약 GRADE_CODE 값 40을 갖는 필드를 추가하고 싶다면 참조하고 있는 테이블에 레코드를 추가해주면 됨.

UPDATE USER_FOREIGN_KEY
SET GRADE_CODE = null WHERE GRADE_CODE=40;

--DROP TABLE USER_FOREIGN_KEY;

-- 외래키 특징 --
-- REFERENCES 를 통해 참조하고 있는 테이블이 있다면 참조 받고 있는 테이블에서 데이터를 삭제시킬 수 없다.
-- 그래서 참조하고 있는 테이블에서 필드값을 null로 수정해주고 그다음 참조해주는 테이블에서 데이터를 삭제 시켜야 했다.
-- 이 과정이 귀찮기 때문에 ON DELETE SET NULL을 통해 참조를 해주는 테이블에서 값을 삭제시켜도
-- 자동으로 참조받는 테이블에서 값이 NULL이 되도록 바꿔줄 수 있다!!



---------- 실습 1 -----------
-- 테이블명: SHOP_MEMBER
-- 저장해야할 데이터 : 1, khuser01, pass01, 일용자, M, 01012345678, khuser01@naver.com

-- 테이블명 : SHOP_BUY
-- 저장해야할 데이터 : 01, khuser01, 농구화, 24/06/14(주문일자)


CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE NOT NULL,
    USER_PW VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(10) NOT NULL,
    USER_GENDER VARCHAR2(10) CHECK(USER_GENDER IN('M', 'F')),
    USER_PHONE VARCHAR2(20),
    USER_EMAIL VARCHAR2(30)
);
SELECT * FROM SHOP_MEMBER;
INSERT INTO SHOP_MEMBER
VALUES(1, 'khuser01', 'pass01', '일용자', 'M', '01012345678', 'khuser01@naver.com');
INSERT INTO SHOP_MEMBER
VALUES(2, 'khuser02', 'pass02', '이용자', 'M', '01011112222', 'khuser02@naver.com');

DELETE FROM SHOP_MEMBER WHERE USER_NO=1;

COMMIT;

CREATE TABLE SHOP_BUY(
    BUY_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE CASCADE,
    PRODUCT_NAME VARCHAR2(20),
    REG_DATE DATE DEFAULT SYSDATE
);
SELECT * FROM SHOP_BUY;

INSERT INTO SHOP_BUY
VALUES(1, 'khuser01', '농구화', DEFAULT);

INSERT INTO SHOP_BUY
VALUES(2, 'khuser01', '농구화', DEFAULT);

INSERT INTO SHOP_BUY
VALUES(3, 'khuser02', '축구화', DEFAULT);

INSERT INTO SHOP_BUY
VALUES(4, 'khuser02', '축구공', DEFAULT);


------------------------------------
-- 외래키 FOREIGN KEY
-- 자식테이블에서 부모 테이블이 가지고 있는 Column의 필드값으로만 INSERT하도록 하는 것
-- 참조 무결성을 보장하는 제약 조건임.
-- 외래키 설정방법
-- Column 레벨 : REFERENCES 부모테이블(Column명) 삭제 옵션(ON DELETE SET NULL, ON DELETE CASCADE)
-- 외래키 삭제옵션
-- 1. 기본 옵션 ON DELETE RESTRICTED (default값임 생략 가능)
-- 2. 연관된 모든 것 삭제 옵션 : ON DELETE CASCADE
-- 3. NULL로 만드는 삭제 옵션 : ON DELETE SET NULL
-- 부모테이블의 데이터 삭제 시도시 자식 테이블의 데이터를 처리하는 방법


----------------------------------------------------
COMMIT;

-- DATA DEfinition Language 데이터 정의어
-- 오라클의 객체를 생성, 수정, 삭제하는 명령어, 명령어의 종류로는
-- CREATE, ALTER, DROP, TRUNCATE, ...

COMMENT ON COLUMN EMPLOYEE.NAME IS '사원명';
COMMENT ON COLUMN EMPLOYEE.T_CODE IS '직급코드';
COMMENT ON COLUMN EMPLOYEE.D_CODE IS '부서코드';
COMMENT ON COLUMN EMPLOYEE.AGE IS '나이';


-- DESC 또는 DESCRIBE 명령어는 테이블의 구조를 보여준다. 테이블의 각 컬럼, 데이터 타입, 널 여부 등을 확인할 수 있다.
DESC EMPLOYEE;

DESC USER_UNIQUE;

DESC SHOP_MEMBER;

DESC SHOP_BUY;




