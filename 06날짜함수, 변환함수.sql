-- 변환 함수

-- 형변환 함수
-- 자동 형변환을 제공해줌 (문자와 숫자, 문자와 날짜)
SELECT * FROM EMPLOYEES WHERE SALARY >= '20000'; -- 문자 -> 숫자 자동형변환 
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '08/01/01'; -- 문자 -> 날짜 자동형변환

-- 강제형변환
--TO_CHAR -> 날짜를 문자로
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') AS 시간 FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD AM HH12:MI:SS') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY"년" MM"월" DD"일"') AS TIME FROM DUAL; -- 포맷값이 아닌 값을 쓰려면 ""를 붙힘

-- TO_CHAR -> 숫자를 문자로
SELECT TO_CHAR(20000, '999999999') AS RESULT FROM DUAL; -- 9자리 문자로 변환
SELECT TO_CHAR(20000, '099999999') AS RESULT FROM DUAL; -- 20000앞에 9자리를 0으로 채움
SELECT TO_CHAR(20000, '999') AS RESULT FROM DUAL; -- 자리수가 부족하면 # 처리됨
SELECT TO_CHAR(20000.123, '999999.9999') AS RESULT FROM DUAL; -- 정수 6자리, 실수 4자리
SELECT TO_CHAR(20000, '$999,999,999') AS RESULT FROM DUAL; -- $기호
SELECT TO_CHAR(20000, 'L999,999,999') AS RESULT FROM DUAL; -- 각 국 지역화폐기호

-- 오늘 환율 1372.17원 일때, SALARY값을 한국돈으로 표현
SELECT FIRST_NAME, TO_CHAR(SALARY * 1372.17 , 'L999,999,999') AS 원화 FROM EMPLOYEES;

-- TO_DATE -> 문자를 날짜로
SELECT SYSDATE - TO_DATE('2024-06-13', 'YY-MM-DD') FROM DUAL; --날짜 모형에 맞춰서 정확히 적으면 됨
SELECT TO_DATE('2024년 06월 13일', 'YYYY"년"MM"월"DD"일"') FROM DUAL; -- 날짜 포맷 문자가 아니라면 ""로
SELECT TO_DATE('24-06-13 11시 30분 23초', 'YYYY-MM-DD HH"시"MI"분"SS"초"') FROM DUAL;

-- 2024년06월13일의 문자로 변환한다면?
SELECT TO_CHAR(TO_DATE('240613', 'YY-MM-DD'),'YYYY"년"MM"월"DD"일"') AS 일 FROM DUAL;

-- TO_NUMBER  -> 문자를 숫자로
SELECT '4000' - 1000 FROM DUAL; -- 자동 형변환
SELECT TO_NUMBER('4000') - 1000 FROM DUAL; -- 명시적변환 후 연산

SELECT '$5,500' - 1000 FROM DUAL; -- 자동 형변환이 불가능
SELECT TO_NUMBER('$5,500', '$999,999') - 1000 FROM DUAL; -- 숫자로 변경이 자동으로 불가능할 경우 명시적 변환

---------------------------------------------------------------------------------------------------
-- NULL처리 함수

-- NVL NULL일 경우 처리
SELECT NVL(1000, 0), NVL(NULL, 0) FROM DUAL;
SELECT NULL + 1000 FROM DUAL; -- NULL에 연산이 들어가면 NULL이 나옴

SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT AS 최종급여 FROM EMPLOYEES; -- NVL 안했을때
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS 최종급여 FROM EMPLOYEES; -- NVL 했을때

-- NVL2 (대상값, 널이아닌경우, 널인경우)
SELECT NVL2(300, 'NULL이 아닙니다', 'NULL입니다') FROM DUAL;

SELECT FIRST_NAME, SALARY, COMMISSION_PCT, NVL2(COMMISSION_PCT, SALARY + SALARY + COMMISSION_PCT, SALARY) AS 최종급여 FROM EMPLOYEES;

-- COALESE (값, 값, 값....) - NULL이 아닌 첫번째 값을 반환 시켜줌
SELECT COALESCE(1, 2, 3) FROM DUAL; -- 1 출력
SELECT COALESCE(NULL, 2, 3, 4) FROM DUAL; -- NULL을 건너뛰고 2 출력
SELECT COALESCE(NULL, NULL, 3, NULL) FROM DUAL; -- NULL을 건너뛰고 3 출력
SELECT COALESCE(COMMISSION_PCT, 0) FROM EMPLOYEES; -- NVL과 같음

-- DECODE (대상값, 비교값, 결과값, 비교값, 결과값.... ELSE문)
SELECT DECODE('A', 'A', 'A입니다') FROM DUAL; --IF문 
SELECT DECODE('X', 'A', 'A입니다', 'A가아닙니다') FROM DUAL; -- IF ~ ELSE문
SELECT DECODE('B', 'A', 'B', 'B입니다', 'C', 'C입니다', '전부아닙니다')FROM DUAL;
SELECT DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1, 'AD_VP', SALARY * 1.2, 'FI_MGR', SALARY * 1.3, SALARY) AS 급여 FROM EMPLOYEES;

-- CASE WHEN THEN ELSE END (SWITCH문과 비슷)
SELECT FIRST_NAME, JOB_ID,

       CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 1.1
                   WHEN 'AD_VP' THEN SALARY * 1.2
                   WHEN 'FI_MGR' THEN SALARY * 1.3
                   ELSE SALARY
       END AS 급여
       
FROM EMPLOYEES;

--비교에 대한 조건을 WHEN절에 쓸 수 있음
SELECT FIRST_NAME, JOB_ID,
       
       CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.1
            WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.2
            WHEN JOB_ID = 'FI_MGR' THEN SALARY * 1.3
       END AS 급여
       
FROM EMPLOYEES;

---------------------------------------------------------------------------------------------------

--날짜함수, 변환함수 연습문제

--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.

  SELECT EMPLOYEE_ID AS 사원번호,
         CONCAT(FIRST_NAME || ' ', LAST_NAME) AS 사원명,
         HIRE_DATE AS 입사일자, TRUNC((SYSDATE - HIRE_DATE) / 365) AS 근속년수
  FROM EMPLOYEES
  WHERE TRUNC((SYSDATE - HIRE_DATE) / 365) >= 10
  ORDER BY 근속년수 DESC;

--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
--조건 2) DECODE구문으로 표현해보세요.
--조건 3) CASE구문으로 표현해보세요.

  SELECT FIRST_NAME AS 이름, MANAGER_ID,
  DECODE(MANAGER_ID, 100, '부장',
                     120, '과장',
                     121, '대리',
                     122, '주임',
                     '사원') AS 직급
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID = 50;
  -------------------------------------------------
    SELECT FIRST_NAME AS 이름, MANAGER_ID,
    CASE MANAGER_ID WHEN 100 THEN '부장'
                 WHEN 120 THEN '과장'
                 WHEN 121 THEN '대리'
                 WHEN 122 THEN '주임'
                 ELSE '사원'
                 END AS 직급
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID = 50;

--문제 3. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상 을 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
        -- 근속년수를 구해서 -> MOD로 나머지를 구하고 -> DECODE 이용해서 진급대상출력
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
  
  SELECT CONCAT(FIRST_NAME || ' ', LAST_NAME) AS 이름,
         TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS 입사일,
         SALARY + SALARY * NVL(COMMISSION_PCT, 0),
         TO_CHAR((SALARY + SALARY * NVL(COMMISSION_PCT, 0))* 1300, 'L999,999,999') AS 급여,
         TRUNC((SYSDATE - HIRE_DATE) / 365),
         DECODE(MOD(TRUNC((SYSDATE - HIRE_DATE) / 365) , 5), 0, '진급대상', '진급대상 아님') AS 진급대상
  FROM EMPLOYEES
  WHERE DEPARTMENT_ID IS NOT NULL;
  
  
  