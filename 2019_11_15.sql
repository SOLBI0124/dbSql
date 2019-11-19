--emp테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE ==> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

--empno는 Primary_Key(UNIQUE + NOT NULL) -> index rowid로 찾음 /access
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

--계획보기
SELECT *
FROM TABLE(dbms_xplan.display);



--empno컬럼으로 인덱스가 존재하는 상황에서
--다른 컬럼 값으로 데이터를 조회하는경우

--job은 Primary_Key(UNIQUE + NOT NULL) 아님. --> ACCESS FULL로 찾음 /filter
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--인덱스 구성 컬럼만 SELECT절에 기술할경우
--테이블 접근이 필요없음/access
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--*******************************************************************************
------------------------------------------------------------------------------
--컬럼에 중복이 가능한 non-unique인덱스 생성 후 
--unique index와의 실행계획 비교

--PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
--non-unique인덱스 생성
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

--계획설명
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

--계획보기
--unique scan -> range scan
--7782에 접근, 바로밑까지 확인(정렬되어있음)(중복된값 있을수있으니까)
SELECT *
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------
--emp 테이블에 job컬럼으로 두번째 인덱스 생성(non-unique index)
--job컬럼은 다른 로우의 job컬럼과 중복이 가능한 컬럼이다
CREATE INDEX idx_emp_02 ON emp (job);

--계획설명
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%';

--계획보기
SELECT *
FROM TABLE(dbms_xplan.display);
------------------------------------------------------------------------------
--emp 테이블에 job,ename 컬럼을 기준으로 non-nuique인덱스 생성
CREATE INDEX idx_emp_03 ON emp(job, ename);         --컬럼순서중요
--계획설명
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%';

--계획보기
SELECT *
FROM TABLE(dbms_xplan.display);

   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
------------------------------------------------------------------------------
--emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_emp_04 ON emp(ename, job);         --컬럼순서중요
                                                    
--계획설명
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE '%C';

--계획보기
SELECT *
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------
--HINT를 사용한 실행계획 제어
EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03) */ *
FROM emp
WHERE job='MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

--*******************************************************************************

--실습 idx1
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX idx_dept_test_01 ON dept_test (deptno);
CREATE INDEX idx_dept_test_02 ON dept_test (dname);
CREATE INDEX idx_dept_test_03 ON dept_test (deptno, dname);

--실습 idx2
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;
DROP INDEX idx_dept_test_03;

--실습 idx3
SELECT *
FROM emp;
WHERE empno=7298;