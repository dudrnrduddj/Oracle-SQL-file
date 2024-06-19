--5일차 JOIN

 --------------------- 4일차 진행한 실습(4일차 함수) 문제풀이--------------------
 
-- @함수 종합실습 - 형변환 함수, 기타 함수
--10. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME "직원명", NVL(DEPT_CODE,'X') "직급코드", TO_CHAR(SALARY*(12+NVL(BONUS,0)), 'L999,999,999') "연봉" 
FROM EMPLOYEE;

--11. 사원명과, 부서명을 출력하세요.
--   부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
SELECT EMP_NAME "사원명",
CASE 
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
END "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D6','D9')
ORDER BY 부서명 ASC;
-- ↓↓↓↓↓↓↓ JOIN으로도 가능 ---
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명" FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_ID = DEPT_CODE
WHERE DEPT_CODE IN('D5','D6','D9')
ORDER BY DEPT_TITLE ASC;

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT DECODE(ENT_YN,'Y', '퇴사', 'N','재직') "퇴사 여부", COUNT(EMP_NAME)||'명' "직원 수" FROM EMPLOYEE
GROUP BY ENT_YN;


---------------JOIN 실습---------------

-- @JOIN 종합실습
--1. 주민번호가 1970년대 생이면서 성별이 여자이고,
-- 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE 
JOIN DEPARTMENT
ON DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE
JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
WHERE EMP_NO LIKE '7%-2%' AND EMP_NAME LIKE '전%';

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
-- !! 주의 이중 JOIN을 할때 주의 할 점!
-- A, B, C TABLE이 있다고 할때 B,C가 A에게 JOIN하면 JOIN구문의 순서는 상관 없음!
-- 단, B가 A를 JOIN하고 C가 B를 JOIN할때는 반드시 JOIN의 순서를 지켜줘야함!!





--5. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명" FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
-- LOCATION은 DEPARTMENT에 JOIN 해야하므로 반드시 DEPARTMENT 뒤에 오도록 해야한다.
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


-- 1. JOIN의 종류
-- 1.1 INNER JOIN: 교집합, 일반적으로 사용하는 조인
-- 1.2 OUTER JOIN: 합집합, 모두 출력하는 조인
-- ex) 사원명과 부서명을 출력하시오
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
INNER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; -- > 21행 -> 이유? DEPT_CODE가 NULL인 데이터는 포함 안됨!
SELECT * FROM EMPLOYEE; -- 23행
-- >> 이것을 INNER JOIN이라고 함!
-- 일반적인 JOIN을 쓰면 INNER JOIN이 쓰이는 것임!

-- LEFT OUTER JOIN은 왼쪽 테이블이 가지고 있는 모든 데이터를 출력
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- LEFT TABLE : FROM의 TABLE
-- RIGHT TABLE : JOIN의 TABLE


-- FULL OUTER JOIN은 양쪽 테이블이 가지고 있는 모든 데이터를 출력
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
