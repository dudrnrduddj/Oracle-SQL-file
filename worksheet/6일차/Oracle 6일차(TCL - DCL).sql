-- 6일차 DCL - TCL
-- TCL(Transaction Control Language)
-- COMMIT, ROLLBACK, SAVEPOINT
-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말함.
-- ATM 출금, 계좌이체 등이 트랜잭션의 예
    -- --출금
    -- 1. 카드 투입
    -- 2. 메뉴 선택
    -- 3. 금액 입력
    -- 4. 비밀번호 입력
    -- 5. 출금 완료
    
    -- --계좌이체
    -- 1. 송금 버튼 클릭
    -- 2. 계좌번호 입력
    -- 3. 은행명 선택
    -- 4. 금액 입력
    -- 5. 비밀번호
    -- 6. 이체 버튼 터치 

-- 그럼 ORACLE DBMS 트랜잭션은 무엇인가?
-- INSERT 수행 또는 UPDATE 수행 또는 DELETE 수행이 되있다면 그 뒤에 추가 작업이
-- 있을 것으로간주하고 처리 -> 트랜잭션이 걸렸다.

DESC USER_GRADE;
COMMIT;
ROLLBACK;

-- TCL 명령어
-- 1. COMMIT : 트랜잭션 작업이 정상 완료되어 변경 내용을 영구히 저장(모든 savepoint 삭제)
-- 2. ROLLBACK : 트랜잭션 작업을 모두 취소하고 가장 최근 (COMMIT 시점으로 이동)
-- 3. SAVEPOINT <Savepoint명> : 현재 트랜잭션 작업 시점에 이름을 지정함.
-- 임시저장이라고 하며 하나의 트랜잭션에서 구역을 나눌 수 있음.
CREATE TABLE USER_TCL
(
    USER_NO NUMBER UNIQUE,
    USER_ID VARCHAR2(30) PRIMARY KEY,
    USER_NAME VARCHAR2(20) NOT NULL
);
DESC USER_TCL;

INSERT INTO USER_TCL VALUES(1, 'khuser01', '일용자');

INSERT INTO USER_TCL VALUES(2, 'khuser02', '이용자');

SAVEPOINT UNTIL2; -- savepoint가 생성됨 -> rollback to .. 로 불러올 수 있음.
                   -- 단, commit을 이후에 한다면 savepoint 롤백 불가!!

INSERT INTO USER_TCL VALUES(3, 'khuser03', '삼용자');


--ROLLBACK 시키면? 1행만 남아있음
INSERT INTO USER_TCL VALUES(4, 'khuser04', '사용자');

ROLLBACK TO UNTIL2;
DELETE FROM USER_TCL;
SELECT * FROM USER_TCL;
-- 정리하자면,
-- rollback -> 최종 commit한 시점으로 이동, savepoint 삭제
-- rollback to .. -> savepoint ..로 이동
-- 마지막에 실행한게 commit이라면 rollback to 사용 불가!! 에러발생
-- commit시켰다가 다시 savepoint 명령어 실행 시키면 rollback to 가능!


-- DCL (Data Control Language)
-- DB에 대한 보안, 무결성, 복구 등 DBMS를 제어하기 위한 언어다.
-- GRANT, REVOKE, ( TCL : (COMMIT, ROLLBACK))
-- 권한부여 및 회수는 System_계정에서만 가능

SELECT * FROM CHUN.TB_CLASS; --> KH에게는 CHUN에 있는 TB_CLASS를 조회할 권한이 없음
-- 권한 부여를 해야지만 조회가 가능
GRANT SELECT ON CHUN.TB_CLASS TO KH; -- System계정으로 실행

REVOKE SELECT ON CHUN.TB_CLASS FROM KH; --> 권한 회수하여 조회 차단












