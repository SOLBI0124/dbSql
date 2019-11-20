-- GROUPING (cube, rollup 절에 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0
SELECT job, deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- job 컬럼
-- case1. GROUPING(job)=1 AND GROUPING(deptno)=1
--        job --> '총계'
-- case else
--        job --> job
SELECT CASE WHEN GROUPING(job)=1 AND                      
                 GROUPING(deptno) =1 THEN '총계'          --job null->총계
            ELSE job
        END as job, deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT CASE WHEN GROUPING(job)=1 AND GROUPING(deptno) =1 THEN '총계'          
            ELSE job
        END as job 
        ,CASE WHEN GROUPING(job)=0 AND GROUPING(deptno) = 1 THEN job || ' 소계'
        ELSE TO_CHAR(deptno)
        END as deptno 
        ,GROUPING(job), GROUPING(deptno)
        ,sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--실습GROUP_AD3
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--실습GROUP_AD4
SELECT dname, job, sum(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);

--실습GROUP_AD5
SELECT CASE WHEN grouping(dname)=1 AND grouping(job)=1 THEN '총합'
            ELSE dname
            END as dname
        , job, sum(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);
---------------------------------------------------------------------------
--CUBE(col, col2...)
--GROUP BY CUBE(job, deptno)
--CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY -- 모든 데이터에 대해서...(총계)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);
---------------------------------------------------------------------------
--GROUP BY 다시
SELECT deptno, MIN(ename), sum(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, sum(sal)             --group by절에 없는 컬럼을 select절에 기술하면 안됨
FROM emp                            --group by절에 있는 컬럼을 select절에 기술안하는건 상관없음
GROUP BY deptno, job;
---------------------------------------------------------------------------
--subquery를 통한 업데이트

DROP TABLE emp_test;
--emp테이블의 데이터를 포함해서 모든 컬럼을 emp_test테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test테이블에 dept테이블에서 관리되고있는 dname컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

--emp_test테이블에 dname컬럼을 dept테이블에 있는 dname컬럼 값으로 없데이트하는 쿼리작성
UPDATE emp_test SET dname = (SELECT dname 
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (7369,7399);
COMMIT;

SELECT *
FROM emp_Test;


--실습 sub_a1
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER(6));

UPDATE dept_test SET empcnt = (SELECT count(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);
---------------------------------------------------------------------------
--실습 sub_a2
insert into dept_test values(99, 'it', 'daejeon', 0);
insert into dept_test values(98, 'it', 'daejeon', 0);

SELECT *
FROM dept_Test;

SELECT *
FROM emp;

DELETE FROM dept_test
WHERE NOT EXISTS (SELECT 'x'
                    FROM emp
                    WHERE deptno = dept_test.deptno);
                
--실습 sub_a3
SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = sal+200
WHERE SAL < (SELECT AVG(sal)
             FROM emp_test b
             WHERE b.deptno=a.deptno);

--emp, emp_test empno컬럼으로 같은 값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno=emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal 해당 사원(emp테이블 기준)이 속한 급여평균

SELECT a.empno, a.ename, a.sal, a.sal1, a.deptno, b.avg
     FROM 
        (SELECT emp.empno empno , emp.ename ename, emp.sal sal , emp_test.sal sal1, emp.deptno deptno
         FROM emp, emp_test
         WHERE emp.empno=emp_test.empno) a, (select deptno, round(avg(sal),2) avg
                                             from emp
                                             group by deptno) b
WHERE a.deptno=b.deptno
order by empno;

select deptno, round(avg(sal),2)
from emp
group by deptno;