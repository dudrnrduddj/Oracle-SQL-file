-- 6일차 서브쿼리

-- 1.2.5 상(호연)관 서브쿼리
-- - 메인쿼리의 값이 서브쿼리에 사용되는 것
-- - 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인 쿼리로 반환해서 수행하는 것
-- -상호연관 관계를 가지고 실행하는 쿼리이다.

-- 예시) 동작원리
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
-- 메인쿼리의 값이 서브쿼리로 넘어가고 서브쿼리를 수행한 다음 결과를 다시 메인쿼리로 반환한다.
--서브쿼리에서 SALARY > E.SALARY 조건을 만족하는 행이 하나라도 있으면, NOT EXISTS 조건이 거짓이 되어 메인 쿼리는 그 행을 반환하지 않습니다.
--서브쿼리에서 SALARY > E.SALARY 조건을 만족하는 행이 하나도 없으면, NOT EXISTS 조건이 참이 되어 메인 쿼리는 그 행을 반환합니다.

-- @실습문제4 
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
SELECT DEPT_CODE "부서코드",EMP_NAME "사원명", 
E.SALARY "급여",
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE E.DEPT_CODE = DEPT_CODE)  "부서별 급여평균"
FROM EMPLOYEE E
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE E.JOB_CODE NOT IN('J1','J2','J3')
AND E.SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE))
ORDER BY DEPT_CODE ASC;

-- 답!! --
SELECT DEPT_CODE "부서코드",EMP_NAME "사원명", 
E.SALARY "급여",
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE)  "부서별 급여평균"
FROM EMPLOYEE E
WHERE JOB_CODE NOT IN('J1','J2','J3')
AND SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE)
ORDER BY DEPT_CODE ASC;
-- >> 결과가 다르게 나왔었던 이유!!!1 (첫번째 코드는 수정한 코드임)
-- 컬럼명에 접근할때 서브쿼리인지 메인쿼리인지를 지정해주지 않아서 조건문이 제대로 실행되지않았음!!
-- JOB_CODE -> E.JOB_CODE 로 수정함
-- 서브쿼리의 같은 레벨에 있을 경우 메인쿼리로 접근하려면 반드시 별칭으로 접근을 해주어야 정상적으로 실행됨!!!



-- 1.2.6 스칼라 서브쿼리
-- 결과값이 1개인 상관서브쿼리, SELECT문 뒤에 사용됨.
-- SQL에서 단일값을 스칼라값이라고 함.

-- @실습문제1
-- 사원명, 부서명, 부서의 평균임금(자신이 속한 부서의 평균임금)을 스칼라 서브쿼리를 이용해서
-- 출력하세요. 
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "부서 평균임금"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- @실습문제2
-- 모든 직원의 사번, 이름, 소속부서를 조회한 후 부서명을 오름차순으로 정렬하시오.
SELECT EMP_ID "사번", EMP_NAME "이름", (SELECT DEPT_TITLE FROM DEPARTMENT WHERE E.DEPT_CODE = DEPT_ID) "부서명"
FROM EMPLOYEE E
ORDER BY (SELECT DEPT_TITLE FROM DEPARTMENT WHERE E.DEPT_CODE = DEPT_ID) ASC;
-- JOIN을 할 필요없이 스칼라 서브쿼리를 이용해서 구할 수 있다.


-- @실습문제3
-- 직급이 J1이 아닌 사원 중에서 자신의 부서 평균급여보다 적은 급여를 받는 사원을 출력하시오
-- 부서코드, 사원명, 급여, 부서의 급여평균을 출력하시오.
SELECT DEPT_CODE "부서코드", EMP_NAME "사원명", SALARY "급여", 
(SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "부서 평균급여"
FROM EMPLOYEE E
WHERE JOB_CODE != 'J1'
AND SALARY < (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);



-- @실습문제4
-- 자신이 속한 직급의 평균급여보다 많이 받는 직원의 이름, 직급, 급여를 출력하시오.
SELECT EMP_NAME "이름", JOB_CODE "직급", SALARY "급여"
FROM EMPLOYEE E
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE);


-- @실습문제5
-- 자신이 속한 직급의 평균급여보다 많이 받는 직원의 이름, 직급의 이름, 급여를 출력하시오.
SELECT EMP_NAME "이름", JOB_NAME "직급의 이름", SALARY "급여"
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE);


