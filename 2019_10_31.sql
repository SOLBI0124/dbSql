--복습
-- 테이블 에서 데이터 조회
SELECT 'TEST'
FROM emp;

/*
    SELECT 컬럼 | express(문자열 상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건(condition)
*/

--컬럼에 뭐있는지 알 수 없을때
--desc
DESC user_tables;

SELECT table_name, 
    'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE table_name = 'EMP';
--전체건수 -1


--숫자 비교연산
--부서번호가 30번 보다 크거나 같은 부서에 속한 직원조회
SELECT *
FROM emp
WHERE deptno >= 30;

--부서번호(deptno)가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

--입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');    ---3명
--WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD');     ---11명

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('01011982', 'MMDDYYYY');

SELECT*
FROM emp
WHERE hiredate<'82/01/01';

-- col BETWEEN X AND Y 연산
-- 컬럼의 값이 x 보다 크거나 같고, Y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal between 1000 and 2000;

--위의 BETWEEN AND 연산자 아래의 <=, >=조합과 같다
SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal <= 2000
  AND deptno = 30;

--emp 테이블에서 입사일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오
--단 연산자는 between을 사용한다.(실습 where1)
SELECT ename, hiredate
FROM emp
WHERE  hiredate between TO_DATE('19820101', 'YYYYMMDD') AND 
                        TO_DATE('19830101', 'YYYYMMDD');

--emp 테이블에서 입사일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오
--단 연산자는 비교연산자를 사용한다.(실습 where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate > TO_DATE('19820101', 'YYYYMMDD')
  AND hiredate < TO_DATE('19830101', 'YYYYMMDD');
  
--IN 연산자
--COL IN (values...)
--부서번호가 10혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno in(10,20);

--IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
   or deptno = 20;

--IN 실습 where3   
--users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오(IN 연산자 사용)
SELECT userid 아이디, usernm 이름
FROM users
WHERE userid in('brown','cony','sally');

SELECT *
FROM users;

--COL LIKE 'S%'
--COL의 값이 대문자 s로 시작하는 모든 값
--COL LIKE 's____'  (_네개)
--COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

--emp 테이블에서 직원이름이 s로 시작하는 모든 직원 호출
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';
--_길이 넘으면 조회안됨

--실습 WHERE4
--member테이블에서 회원의 성이 신씨인 사람으 ㅣmem_id, mem_name을 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신__';

--실습 WHERE5
--member테이블에서 회원의 이름에 글자 이가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%진%';      --mem_name이 문자열안에 진으로 시작하는 데이터 (이진영)
--WHERE mem_name LIKE '진%';     --mem_name이 진으로시작하는 데이터           (진현경)

--NULL 비교
--col IS NULL
--emp 테이블에서 mgr정보가 없는 사람(NULL)
SELECT *
FROM emp
WHERE mgr is NULL;
--WHERE mgr != NULL;        null비교 실패

--소속 부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';   
-- =, !=
--is null !is null


--실습 WHERE 6
--emp 테이블에서 상여(comm)가 있는 회원의 정보 조회
SELECT *
FROM emp
WHERE comm is not null;

-- AND / OR
-- 관리자(mgr) 사번이 7698이고 급여가 1000 이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
 AND sal >= 1000;
 
-- 관리자(mgr) 사번(mgr)이 7698이거나 급여(sal)가 1000 이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
 OR sal >= 1000;
 
-- emp테이블에서 관리자mgr 사번이 7698이 아니고 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);      --IN -->OR

--위의쿼리를 AND/OR 연산자로 반환
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
--IN, NOT IN 연산자의 NULL처리
--emp 테이블에서 관리자(mgr)사번이 7698 혹은 7839 또는 null이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
    AND mgr IS NOT NULL;
--IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다

--실습 WHERE7
--emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월1일 이후인 직원의 정보
SELECT *
FROM emp
WHERE job='SALESMAN'
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');
 
--실습 where8
SELECT *
FROM emp
WHERE deptno != 10
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');
 
--실습 where9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');

--실습 where10 
SELECT *
FROM emp
WHERE deptno IN(20,30)
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');    
    
--실습 where11
SELECT *
FROM emp
WHERE job='SALESMAN'
  OR hiredate > TO_DATE('19810601', 'YYYYMMDD');

--실습 where 12
SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno LIKE '78%';
   

    