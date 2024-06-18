-- 4일차 오라클 JOIN
-- 1. JOIN
-- - 두 개 이상의 테이블에서 연관성을 가지고 있는 데이터들을 따로 분류하여
--   새로운 가상의 테이블을 만듬
-- -> 여러 테이블의 레코드를 조합하여 하나의 레코드로 만듬
-- ANSI 표준 구문 -> 이걸 사용
-- 오라클 전용 구문

SELECT EMP_ID, EMP_NAME, DEPT_CODE , DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT 
ON DEPT_CODE = DEPT_ID;

SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;



SELECT EMP_ID, EMP_NAME, E.JOB_CODE, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E -- 별칭 사용가능
JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE;

-- 조인하는 컬럼 같을때 USING 구문 사용 
SELECT EMP_ID, EMP_NAME, JOB_NAME, JOB_CODE
FROM EMPLOYEE E
JOIN JOB j
USING(JOB_CODE);


SELECT JOB_CODE, JOB_NAME FROM JOB;



-- @실습문제1
-- 부서명과 지역명을 출력하세요.
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

SELECT LOCATION_ID, DEPT_TITLE "부서명", LOCAL_NAME "지역명" 
FROM DEPARTMENT
JOIN LOCATION
ON LOCATION_ID = LOCAL_CODE; 

-- @실습문제2
-- 사원명과 직급명을 출력하세요!
SELECT * FROM JOB;
SELECT * FROM EMPLOYEE;

SELECT JOB_CODE "직업코드", EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE 
JOIN JOB 
USING(JOB_CODE);
-- USING을 쓰게 되면 E.JOB_CODE 와 같이 작성하면 에러 발생!



-- @실습문제3
-- 지역명과 국가명을 출력하세요
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;

SELECT NATIONAL_CODE "국가코드", LOCAL_NAME "지역명", NATIONAL_NAME "국가명" 
FROM NATIONAL
JOIN LOCATION
USING(NATIONAL_CODE);



-- @JOIN 종합실습
--1. 주민번호가 1970년대 생이면서 성별이 여자이고,
-- 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE 
JOIN DEPARTMENT
ON DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE
JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
WHERE EMP_NO LIKE '7______2%' AND EMP_NAME LIKE '전%';

--2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명" 
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_ID = DEPT_CODE
WHERE EMP_NAME LIKE '%형%';


--3. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_CODE "부서코드", DEPT_TITLE "부서명" 
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_ID = DEPT_CODE
JOIN JOB
USING(JOB_CODE)
WHERE DEPT_TITLE LIKE '해외영업%';


--4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", SALARY*BONUS "보너스포인트", LOCAL_NAME "근무지역명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
WHERE BONUS IS NOT NULL;


--5. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명" FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
WHERE DEPT_CODE IN('D2');

--6. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
-- 데이터 없음!
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여", SALARY*(12+NVL(BONUS,0)) "연봉" FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE)
JOIN SAL_GRADE
USING(SAL_LEVEL)
WHERE SALARY > MAX_SAL;


--7. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명", NATIONAL_NAME "국가명" FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID
JOIN LOCATION
ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL
USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('한국', '일본');

--8. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
--단, join과 IN 사용할 것
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여" FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE)
WHERE BONUS IS NULL AND JOB_NAME IN('차장', '사원');

--9. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT DECODE(ENT_YN,'Y', '퇴사', 'N','재직') "퇴사 여부", COUNT(EMP_NAME)||'명' "직원 수" FROM EMPLOYEE
GROUP BY ENT_YN;

