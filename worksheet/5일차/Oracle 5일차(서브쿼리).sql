-- 5일차 서브쿼리(SubQuery)
-- 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문
-- 메인 쿼리가 서브쿼리를 포함하는 종속적인 관계
-- 서브쿼리는 반드시 소괄호로 묶어야 함
-- 서브쿼리 안에 ORDER BY는 지원 안됨 주의

-- 예제1
-- 전지연 직원의 관리자 이름을 출력하세요.
SELECT EMP_NAME FROM EMPLOYEE
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '전지연');


-- [전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.]
-- 서브쿼리를 쓰지 않는 경우
SELECT AVG(SALARY) FROM EMPLOYEE;
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047663;

--1.2.1 단일행 서브쿼리
-- 서브쿼리를 쓰는 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);


-- 1.2 서브쿼리의 종류
-- 1.2.1 단일행 서브쿼리
-- 1.2.2 다중행 서브쿼리
-- 1.2.3 다중열 서브쿼리
-- 1.2.4 다중행 다중열 서브쿼리
-- 1.2.5 상(호연)관 서브쿼리
-- 1.2.6 스칼라 서브쿼리



-- 1.2.2 다중행 서브쿼리
-- 서브쿼리의 결과값이 다중행으로 나오기 때문에 연산자 IN을 사용!

-- 송종기나 박나라가 속한 부서에 속한 직원들의 정보를 출력하세요.

SELECT * FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN('송종기','박나라'));




----------실습------------
-- @실습문제1
-- 차태연, 전지연 사원의 급여등급과 같은 사원의 직급명, 사원명을 출력하세요.
SELECT JOB_NAME "직급명", EMP_NAME "사원명" FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE)
WHERE SAL_LEVEL IN(SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN('차태연','전지연'));


-- @실습문제2
-- Asia1지역에 근무하는 직원의 정보(부서코드, 사원명)를 출력하세요.


SELECT DEPT_CODE "부서코드", EMP_NAME "사원명" FROM EMPLOYEE

--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
--JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
--WHERE LOCAL_NAME = UPPER('Asia1');

-- 서브쿼리를 쓰는 경우 --
--WHERE EMP_NAME IN(
--SELECT EMP_NAME FROM EMPLOYEE
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
--JOIN LOCATION ON LOCATION_ID = LOCAL_CODE 
--WHERE LOCAL_NAME = 'ASIA1');
-- 만약 메인쿼리에서도 JOIN해야 하는 컬럼이 있다면 JOIN시켜주고 SELECT해줘야함


-- ↓↓↓ 더 나은 풀이(서브쿼리에서 JOIN 한번쓸 수 있음)
--WHERE DEPT_CODE IN(SELECT DEPT_ID FROM DEPARTMENT
--JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
--WHERE LOCAL_NAME = 'ASIA1')
--ORDER BY DEPT_CODE ASC;


--  ↓↓↓  JOIN 안쓰고 서브쿼리로만 쓸 수도 있음
WHERE DEPT_CODE IN(SELECT DEPT_ID FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION
WHERE LOCAL_NAME = 'ASIA1'
));

-- 1.2.5 상(호연)관 서브쿼리
-- - 메인쿼리의 값이 서브쿼리에 사용되는 것
-- - 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인 쿼리로 반환해서 수행하는 것
-- -상호연관 관계를 가지고 실행하는 쿼리이다.


-- EXISTS를 통해 참/거짓을 판별함 
-- 참이면 메인쿼리의 resultSet이 나오게되고
-- 거짓이면 메인쿼리의 resultSet이 안나오게됨
SELECT * FROM EMPLOYEE WHERE EXISTS (SELECT 1 FROM DUAL);
-- 서브쿼리의 result set이 있는 예시
SELECT * FROM EMPLOYEE WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE EMP_ID = '2000');
-- 서브쿼리의 result set이 없는 예시

-- SELECT 실행순서
-- FROM - WHERE - SELECT
--      GROUP BY - HAVING
--                      ORDER BY

SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);

-- 실습 --
-- 부하직원이 한명이라도 있는 직원의 정보를 출력하시오.
SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
-- 왜 별칭을 주는가?
-- 메인쿼리의 테이블과 서브쿼리의 테이블을 마치 2중 반복문과 같이 동작하는 것
-- 메인쿼리의 한행에 대해서 서브쿼리가 한행씩 실행되는 원리이다.
-- 따라서 서브쿼리의 조건문에 메인쿼리의 한행에대한 필드와 서브쿼리의 각행에대한 필드를
-- 비교해야 하기 때문이다,
-- 만약 별칭을 주지 않게 되면 서브쿼리의 테이블에  대한 비교가 이루어져 서브쿼리의 한행에 대한 두 필드를 비교하게 되고
-- 이 테이블에서는 그 두 필드가 서로 다른 값을 갖고있기때문에 result set이 나오지 않는 것이다.



-- @실습문제1
-- 가장 많은 급여를 받는 직원을 출력하시오.
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);

-- @실습문제2
-- 가장 적은 급여를 받는 직원을 출력하시오.
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);

-- @실습문제3
-- 심봉선과 같은 부서의 사원의 부서코드, 사원명, 월평균급여를 조회하시오.
SELECT DEPT_CODE "부서코드", EMP_NAME "사원명", 
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선')) "월평균급여" 
FROM EMPLOYEE E
WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE E.DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선'));


-- @실습문제4 
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.


SELECT DEPT_CODE "부서코드",EMP_NAME "사원명", 
E.SALARY "급여",
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE E.DEPT_CODE = DEPT_CODE)  "부서별 급여평균"
FROM EMPLOYEE E
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE JOB_CODE NOT IN('J1','J2','J3')
AND E.SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE))
ORDER BY DEPT_CODE ASC;

-- 집계함수 사용 시 만드시 집계함수 컬럼을 제외한 나머지를 그룹화 시켜줘야 동작함!!!


