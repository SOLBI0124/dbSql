DROP TABLE emp_Test;

--multiple insert를 위한 ㅌ[스트 테이블 생성
--empno, ename, 두개의 컬럼을 갖는 emp_test, emp_tes2 테이블을
--emp 테이블로부터 생성한다 (CTAS)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;                      --절대로 참이 나오지않을 조건(데이터 복사X)

--INSERT ALL
--하나의 INSERT SQL문장으로 여러 테이블에 데이터를 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1,'brown' FROM dual UNION ALL
SELECT 2,'sally' FROM dual;

SELECT *
FROM emp_test;

--INSERT 컬럼 정의. 동일한 값을 여러 테이블에 입력(일부 컬럼만 입력가능) 
ROLLBACK;

INSERT ALL
    INTO emp_test(empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;


--multiple insert(conditional insert)
--동일한 값을 조건에 따라 테이블에 입력
INSERT ALL
    WHEN empno<10 THEN
        INTO emp_test(empno) VALUES (empno)
    ELSE    --조건을 통과하지 못할때만 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL  --emp_test2
SELECT 2 empno, 'sally' ename FROM dual;            --emp_test

SELECT *
FROM emp_test2;

--INSERT FIRST
--조건에 만족하는 첫번째 INSERT구문만 실행
ROLLBACK;

INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test(empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT *
FROM emp_test;

rollback;
------------------------------------------------------------------------
--****MERGE : 조건에 만족하는 데이터가 있으면 UPDATE
--            조건에 만족하는 데이터가 없으면 INSERT

--empno가 7369인 데이터를 emp테이블로부터 emp_test테이블에 복사(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno='7369';

SELECT *
FROM emp_test;

--emp테이블의 데이터중 emp_Test 테이블의 empno와 같은 값을 갖는 데이터가 있을 경우 
--emp_test.ename = ename || '_merge'값으로 update
--데이터가 없을 경우에는 emp_test테이블에 insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));

MERGE INTO emp_test
USING (SELECT empno, ename
        FROM emp
        WHERE emp.empno IN(7369, 7499)) 
 ON (emp.empno = emp_test.empno)                 --조인기준
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOt MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
SELECT *
FROM emp_test;
rollback;

--다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로 merge하는 경우

--empno =1, ename ='brown'
--empno가 같은 값이 있으면 ename을 'brown'으로 update
--empno가 같은 값이 없으면 신규 insert

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
WHEN MATCHED THEN 
 UPDATE set ename = 'brown' || '_merge'         --empno가 1인 데이터 없음
WHEN NOT MATCHED THEN 
 INSERT VALUES (1, 'brown');

------------------------------------------------------------------------- 
--실습GROP_AD1
--부서번호별 sal합
SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno

UNION ALL                   --union all : 합집합, 중복을 제거하지 않음

--모든직원의 급여 합
SELECT null,sum(sal)
FROM emp;


--ROLLUP 형태
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (deptno);
       
--ROLLUP
--group by 의 서브 그룹을 생성해
--GROUP BY ROLLUP( {col, } )
--컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을 GROUP BY 하여 UNION 한것과 동일
--ex : GROUP BY ROLLUP (job, deptno)
--      GROUP BY job, deptno
--      UNION
--      GROUP BY job
--      UNION
--      GROUP bY --> 총계 (모든 행에대해 그룹함수 적용)

SELECT job, deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (job, deptno);

------------------------------------------------------------------------
--GROUPING SETS(col1, col2...)
--GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GORUP BY 절에 이용된다
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp테이블을 이용하여 부서별 급여합과 담당업무(job)별 급여합을 구하시오
--부서번호, job, 급여합계
SELECT deptno, null as job, sum(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, sum(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, sum(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));