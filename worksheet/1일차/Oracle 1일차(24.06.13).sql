show user;
-- 명령어는 지우지 않는 이상 계속 남아있음 필요하면 실행시켜주면 됨.

-- 데이터 제어(DCL: Data Control Language) ex) GRANT, REVOKE
GRANT RESOURCE TO KHUSER01;

-- 데이터 정의(DDL : Data Definition Language) ex) CREATE, ALTER, DROP
CREATE TABLE EMPLOYEE(
    NAME VARCHAR2(20), --VARCHAR2(크기) -> (가변길이)문자타입 / CHAR 는 고정길이
    T_CODE VARCHAR2(10),
    D_CODE VARCHAR2(10),
    AGE NUMBER          --NUMBER -> 숫자타입
);

-- 1. column의 데이터 타입 없이 테이블 생성 -> 오류 발생
--  -> 데이터 타입 작성
-- 2. 권한도 없이 테이블을 생성하여 오류 발생 (insufficient privileges)
--  -> System_계정에서 RESOURCE 권한 부여 (GRANT RESOURCE TO KHUSER01;)
-- 3. 접속 해제 후 다시 접속, 새로운 워크시트 말고 기존 워크시트의 우측상단에서 접속해주면 됨.


--데이터 조작(DML: Data Manipulation Language) ex) SELECT, INSERT, UPDATE, DELETE
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE) -- 행 삽입 (레코드, 튜플 생성)
VALUES ('일용자', 'T1', 'D1', 33);
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE)
VALUES ('이용자', 'T2', 'D1', 44);
INSERT INTO EMPLOYEE(NAME, T_CODE, D_CODE, AGE)
VALUES ('삼용자', 'T1', 'D2', 32);

DROP TABLE EMPLOYEE; -- 테이블 자체를 통채로 날림

DELETE FROM EMPLOYEE; -- 테이블 안의 데이터만 날림 (테이블 껍데기는 존재)

DELETE FROM EMPLOYEE WHERE NAME = '일용자'; -- where절로 조건을 줄 수 있음

UPDATE EMPLOYEE SET T_CODE = 'T3' WHERE EMPLOYEE.NAME = '일용자'; -- 조건에 맞는 셀의 레코드 수정

-- table 생성 > CREATE TABLE 테이블명
-- table 삭제 > DROP TABLE 테이블명
-- 데이터 삽입 > INSERT INTO 테이블명(필드명) VALUES (값)
-- 데이터 수정 > UPDATE 테이블명 SET 필드명=값 WHERE 조건
-- 데이터 삭제 > DELETE FROM 테이블명 WHERE 조건

-- 명령어로 조회하는 법
SELECT NAME, T_CODE, D_CODE, AGE FROM EMPLOYEE WHERE NAME='일용자';
-- 모든 필드 조회
SELECT * FROM EMPLOYEE;

-----------------실습-----------------
-- 이름이 student_tbl인 테이블을 만드세요
-- 이름, 나이, 학년, 주소를 저장할 수 있도록 하며
-- 일용자, 21, 1, 서울시 중구를 저장해주세요
-- 일용자를 사용자로 바꿔주세요
-- 데이터를 삭제하는 쿼리문을 작성하고 삭제를 확인하시고
-- 테이블을 삭제하는 쿼리문을 작성하여 테이블이 사라진 것을 확인하세요

CREATE TABLE student_tbl(
    NAME VARCHAR2(20),
    AGE NUMBER,
    GRADE NUMBER,
    ADDRESS VARCHAR2(20)
);

INSERT INTO student_tbl(NAME, AGE, GRADE, ADDRESS)
VALUES ('일용자', 21, 1, '서울시 중구');

UPDATE student_tbl SET NAME='사용자' WHERE NAME='일용자';


DELETE FROM student_tbl;

DROP TABLE student_tbl;

SELECT * FROM student_tbl;
---------------------------------------------

------------실습2------------
-- 아이디가 KHUSER02 비밀번호가 KHUSER02인 계정을 생성하고
-- 접속이 되도록하고 테이블도 만들 수 있도록 하세요.

-- system 계정에서 명령--
--계정 생성--
CREATE USER KHUSER02 IDENTIFIED BY KHUSER02;
show user;
--연결 권한 부여--
GRANT CONNECT TO KHUSER02;
--생성 권한 부여--
GRANT RESOURCE TO KHUSER02;

--테이블 생성--
CREATE TABLE student_tbl(
    NAME VARCHAR2(20),
    AGE NUMBER,
    PHONE NUMBER,
    ADDRESS VARCHAR2(200)
);

--데이터 추가--
INSERT INTO student_tbl(NAME, AGE, PHONE, ADDRESS) VALUES('이용자',1,11,'111');
--데이터 조회--
SELECT * FROM student_tbl;
--------------------------------------------
ROLLBACK; -- 롤백을 하면 이 문장 이후의 작업이 사라짐.
COMMIT; -- 최종 저장하는 기능
-- rollback을 통해 commit한 시점으로 돌아갈 수 있음.
-- 따라서 전으로 돌아가려 하는데 commit을 해버리면 전으로 rollback 불가능

