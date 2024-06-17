-- 3일차
-- 오라클 함수의 종류
-- 1. 단일행 함수 - 결과값 여러개
-- 2, 다중행 함수 - 결과값 1개(그룹함수)
SELECT SUM(SALARY) FROM EMPLOYEE;

-- a. 숫자 처리 함수
--   ABS(절대값), MOD(나머지), TRUNC(소수점 지정 버림), FLOOR(내림), ROUND(반올림), CEIL(올림)
SELECT TRUNC(SYSDATE-HIRE_DATE, 2) FROM EMPLOYEE;
SELECT MOD(35 ,3) FROM DUAL; -- DUAL테이블은 가상의 테이블, 함수의 결과를 확인하기 위해 가상으로 씀
SELECT ABS(-1) FROM DUAL;
SELECT SYSDATE FROM DUAL;

-- b. 문자 처리 함수


-- c. 날짜 처리 함수
-- ADD_MONTHS(), MONTHS_BETWEEN(), LAST_DAY(), EXTRACT, SYSDATE
SELECT ADD_MONTHS(SYSDATE, 2) FROM DUAL; -- 2개월 뒤의 날짜 출력
SELECT MONTHS_BETWEEN(SYSDATE, '24/05/07') FROM DUAL; -- 양수, 음수 나올 수 있음.

-- ex1) EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사 후 3개월이 된 날짜를 조회하시오.
SELECT EMP_NAME "이름", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 3) "입사 후 3개월 뒤 날짜" FROM EMPLOYEE;
-- ex2) EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무 개월수를 조회하시오.
SELECT EMP_NAME "이름", HIRE_DATE "입사일", TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/30) "근무 개월수" FROM EMPLOYEE;

-- LAST DAY() --
SELECT LAST_DAY(SYSDATE)+1 FROM DUAL;
SELECT LAST_DAY('24/02/22') FROM DUAL;

-- ex3) EMPLOYEE 테이블에서 사원이름, 입사일, 입사월의 마지막날을 조회하세요.
SELECT EMP_NAME "사원이름", HIRE_DATE "입사일", LAST_DAY(HIRE_DATE) FROM EMPLOYEE;

-- EXTRACT 년도, 월, 일 추출해줌. (DATE에서 추출)
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL;

-- ex4) EMPLOYEE 테이블에서 사원이름, 입사 년도, 입사 월, 입사 일을 조회하시오.
SELECT EMP_NAME "사원 이름" 
, EXTRACT(YEAR FROM HIRE_DATE)||'년' "입사 년도"
, EXTRACT(MONTH FROM HIRE_DATE)||'월' "입사 월"
, EXTRACT(DAY FROM HIRE_DATE)||'일' "입사 일"
FROM EMPLOYEE;