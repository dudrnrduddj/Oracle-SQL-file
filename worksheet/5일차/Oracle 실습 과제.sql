-- 오라클 실습 과제 --

-- Basic SELECT--
--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이
--들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서
--찾아 내도록 하자)


SELECT STUDENT_NAME FROM TB_STUDENT
JOIN TB_DEPARTMENT
USING(DEPARTMENT_NO)
WHERE ABSENCE_YN = 'Y' AND DEPARTMENT_NAME = '국어국문학과'
AND STUDENT_SSN LIKE '%-2%';

SELECT STUDENT_NAME FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
AND STUDENT_SSN LIKE '%-2%'
AND DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '국어국문학과');
--------------------------------------------------
--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의
--학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
-- A513079, A513090, A513091, A513110, A513119

SELECT STUDENT_NAME FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079','A513090','A513091','A513110','A513119')
ORDER BY 1 DESC;
--------------------------------------------------
-- Additional SELECT 함수 --

--4. 교수들의 이름 중 성을 제외핚 이름맊 출력하는 SQL 문장을 작성하시오. 출력 헤더는
--"이름" 이 찍히도록 핚다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
SELECT SUBSTR(PROFESSOR_NAME,2) "이름" FROM TB_PROFESSOR;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 
--19 살에 입학하면 재수를 하지 않은 것으로 갂주핚다.
-- 생년월일 - 입학날짜 > 19 재수생
SELECT STUDENT_NAME FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(STUDENT_SSN,1,6),'YYYYMMDD')) > 19;


--6. 2020 년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('20201225','YYYYMMDD'),'DAY') "2020년 크리스마스 요일" FROM DUAL;







