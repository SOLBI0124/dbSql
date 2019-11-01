-- 복습

-- WHERE
-- 연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : 다수의 문자열과 매칭, 
--            _ : 정확히 한글자 매칭)
-- IS NULL (!= NULL 아님)
-- AND, OR, NOT

-- emp테이블에서 입사일자가 1981년 6월 1일보터 1986년 12월 31일 사이에 있는 직원 정보수
SELECT *
FROM emp
WHERE  hiredate between TO_DATE('19810601', 'YYYYMMDD') 
  AND TO_DATE('19861231', 'YYYYMMDD');

-- >=, >=
SELECT *
FROM emp
WHERE  hiredate >= TO_DATE('19810601', 'YYYYMMDD') 
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
--emp테이블에서 관리자가 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr is not null;

------------------------------------------------------------------------
--실습 where12
SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno LIKE '78%';


--실습 where13
--empno는 정수 4자리까지 허용
--empno : 78, 780, 7
--         7800~7899
--         780~789
--         78

desc emp;

SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno BETWEEN 7800 AND 7899
   OR empno BETWEEN 780 AND 789
   OR empno = 78;
   
   
--실습 where 14
SELECT *
FROM emp
WHERE job='SALESMAN'
    OR (empno LIKE '78%' 
        AND hiredate > TO_DATE('19810601', 'YYYYMMDD'));

--ORDER BY 컬럼명 | 별칭 | 컬럼 인덱스 [ASC | DESC]
--ORDER BY 구문은 WHERE절 다음에 기술
--WHERE절이 없을 경우 FROM절 다음에 기술
--ename기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : default
--ASC를 안붙여도 위 쿼리와 동일
SELECT *
FROM emp
ORDER BY ename; --ASC

--이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

--job을 기준으로 내림차순으로 정렬, 만약 사번(empno)으로 올림차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;


--별칭으로 정렬하기
--사원 번호(empno), 사원명(ename), 연봉(sal*12) as year_sal
--year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 2;
--2 이름순
--4 연봉순

--실습 orderby1
desc dept;

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY LOC DESC;

--실습 orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, EMPNO;

--실습 orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--실습 orderby4
--1500넘는 : sal > 1500
SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30)
--WHERE deptno IN (10,30)
    AND sal > 1500
ORDER bY ENAME DESC;



desc emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1;
--WHERE ROWNUM = 2; 안됨(1번부터 읽어야함)
--WHERE ROWNUM <= 5; 가능
--WHERE ROWNUM > 10; 안됨(1~10까지 안읽었기 때문)

--emp테이블에서 사번(empno), 이름(ename)을 급여기준으로 오름차순, 
--정렬된 결과순으로 ROWNUM적용
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

--inline view
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;
--인라인뷰 뒤에 * 별칭써야함

--row_1
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

--row_2 (ROWNUM값이 11~14인값) ROWNUM별칭, 결과를 인라인으로 묶고 where절에 
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)
WHERE rn between 11 and 14;

-----------------------------------------------
--FUNCTION
--DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

--문자열 대소문자 관련된 함수
--LOWER, UPPER, INITCAP(첫글자만대문자)
SELECT LOWER('HELLO, WORLD'), UPPER('hello, world'), INITCAP('hello, world')
FROM dual;

--일반테이블에서 하면 데이터 건수만큼 나옴
SELECT 'HELLO WORLD'
FROM emp;

--FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--개발자 7거지악
--1.좌변을 가공하지 말아라
--좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
--Function BAsed Index -> FBI

--CONCAT : 문자열 결합 
--두개의 문자열을 결합하는 함수
SELECT CONCAT('HELLO', ', WORLD') as CONCAT
FROM dual;
--문자열 세개 결합
--SUBSTR : 문자열의 부분 문자열(java : String.substring) 1이상5이하
--LENGTH : 문자열의 길이
--INSTR : 문자열에 특정 문자열이 등장하는 첫번째 인덱스
--LPAD : 문자열에 특정 문자열을 삽입
SELECT CONCAT(CONCAT('HELLO', ','), 'WORLD') as CONCAT,
        SUBSTR('HELLO, WORLD', 0 ,5) substr1,
         SUBSTR('HELLO, WORLD', 1 ,5) substr2,
         LENGTH('HELLO, WORLD') length,
         INSTR('HELLO, WORLD', 'O') instr1,
         --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
         INSTR('HELLO, WORLD', 'O', 6) instr2,
         --LPAD(문자열, 전체 문자열길이, 문자열이 전체문자열 길이에 미치지 못할경우 왼쪽에 추가할 문자)
         LPAD('HELLO, WORLD',15,'*') lpad1,
         LPAD('HELLO, WORLD',15) lpad2,         --lapd2, lapd3동일
         LPAD('HELLO, WORLD',15,' ') lpad3,
         RPAD('HELLO, WORLD',15,'*') rpad1
FROM dual;




