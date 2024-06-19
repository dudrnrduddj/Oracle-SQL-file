-- 오라클 실습 과제 --
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
--------------------------------------------
--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 핚다. 그 대상자들의
--학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.











