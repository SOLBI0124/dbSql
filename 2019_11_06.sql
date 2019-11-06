--복습
--multi row funciton : 여러개의 행을 입력으로 하나의 결과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT절에는 GROUP BY절에 기술된 COL, EXPRESS 표기 가능

--직원중 가장 높은 급여를 조회
--14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--group function 실습 grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING', 
                      20,'RESEARCH', 
                      30, 'SALES',
                      40, 'OPERATIONS',
                                'ddit') as dname, 
        max(sal) max_sal, min(sal) min_sal, 
        round(avg(sal),2) avg_sal, 
        sum(sal) sum_sal, 
        count(sal) count_sal, count(mgr) count_mgr, count(*) count_all
FROM emp
GROUP BY deptno;

--group function 실습 grp4
SELECT TO_CHAR(hiredate,'YYYYMM') as hire_yyyymm, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

--group function 실습 grp5
SELECT TO_CHAR(hiredate,'YYYY') as hire_yyyy, count(*) as cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

--group function 실습 grp6
SELECT count(deptno) as cnt
FROM dept;
-------------------------------------------------------------
--JOIN*****
--emp 테이블에는 dname 컬럼이 없다 --> 부서번호(deptno)밖에 없음
desc emp;

--emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));   --Table EMP가 변경되었습니다.

SELECT *
FROM emp;

--emp테이블에 deptno에 따라 dname추가
UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO=10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO=20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO=30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

--emp테이블 dname 지우기
ALTER TABLE emp DROP COLUMN DNAME;

SELECT *
FROM emp;

--ansi natural join : 조인하는 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT DEPTNO, ename, DNAME
FROM emp NATURAL JOIN dept;

--ORACLE join
SELECT emp.empno, emp.ENAME, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno; --같으면 연결하겠다

SELECT e.empno, e.ENAME, e.deptno, d.dname, d.loc
FROM emp e, dept d              --테이블명대신 별칭사용가능
WHERE e.deptno = d.deptno;

--ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from절에 조인 대상 테이블 나열 (oracle문법***)
--where절에 조인조건 기술
--기존에 사용하단 조건 제약도 기술가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job='SALESMAN'; --job이 SALESMAN인 사람만 대상으로 조회

SELECT emp.empno, emp.ename, dept.dname, emp.job
FROM emp, dept
WHERE emp.job='SALESMAN'
    AND emp.deptno = dept.deptno;   --WHERE절과 AND절 순서 바껴도 상관없음
    
--JOIN with ON(개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);


--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr 정보를 참고하기 위해서 emp테이블과 조인을 해야한다.
--a:직원정보, b:관리자
--1)ANSI
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)   
WHERE a.empno between 7369 and 7698;

--2)ORACLE
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
  AND a.empno between 7369 and 7698;

--------------------------------------------------
--non-equijoin (등식 조인이 아닌경우) 꼭 equlals(=)로 조인해야하는건 아님
--직원의 급여 등급은??? (sal이 몇grade에 해당하는지)
SELECT *
FROM salgrade;

SELECT empno, ename, sal
FROM emp;

--1)oracle
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--2)ansi
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--14개. 실행될수 있는 모든 조합
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno='7369';

--실습 join0
SELECT  e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--실습 join0_1
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
--AND (e.deptno=10 OR e.deptno=30)
  AND e.deptno IN(10, 30)
ORDER BY empno;

--실습 join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND e.sal > 2500
ORDER BY sal desc;

--실습 join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno=d.deptno
  AND e.sal > 2500
  AND e.empno > 7600;

--실습 join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500 and e.empno > 7600
  AND d.dname = 'RESEARCH';

--

 

desc emp;

SELECT*
FROM dept;