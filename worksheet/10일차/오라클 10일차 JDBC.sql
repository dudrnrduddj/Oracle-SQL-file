
CREATE TABLE MEMBER_TBL
(
    MEMBER_ID VARCHAR2(20) PRIMARY KEY,
    MEMBER_PW VARCHAR2(30) NOT NULL,
    MEMBER_NAME VARCHAR2(30) NOT NULL,
    GENDER VARCHAR2(6),
    AGE NUMBER,
    EMAIL VARCHAR2(50),
    PHONE VARCHAR2(12),
    ADDRESS VARCHAR2(200),
    HOBBY VARCHAR2(300),
    REG_DATE DATE DEFAULT SYSDATE  
);

INSERT INTO MEMBER_TBL 
VALUES('OrdinaryID5', 'OrdinaryPW', 'LEECHOONGMOO', '남', 25, 
'cm000519@naver.com', '01085137681', '서울시 도봉구', '운동' , DEFAULT);

SELECT * FROM MEMBER_TBL WHERE MEMBER_ID = 'user01' AND MEMBER_PW = 'userPW01';


SELECT * FROM MEMBER_TBL WHERE MEMBER_ID = '' or 'a'='a'--;
--WHERE member_id = '' or 'a'='a'
-- 아래처럼 sql문을 작성하면 정보에 접근이 가능해짐(해킹)
-- SQL Ingection을 통해서 데이터가 유출되는 문제가 발생한다.
-- 
-- Statement를 사용하여 전달받은 쿼리에 대한 입력값 검증없이 그대로 실현하기 때문임.
;



COMMIT;


