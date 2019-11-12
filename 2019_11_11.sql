--SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno in (20,30);

SELECT *
FROM emp
WHERE deptno = 20
   OR deptno = 30;
----------------------------------
SELECT *
FROM emp
WHERE deptno in(SELECT deptno 
                 FROM emp 
                 WHERE ename in('SMITH','WARD'));
                 
                 SELECT *
FROM emp
WHERE deptno in(SELECT deptno 
                 FROM emp 
                 WHERE ename in(:name1,:name2));
----------------------------------
-- ANY : set중에 만족하는게 하나라도 있으면 참으로(크기비교)
-- SMITH, WARD 두사람의 급여보다 적은 급여를 받는 직원 정보 조회 
-- 800보다 작거나 1250보다 작은 급여 -> 1250보다 작은 급여받는사람
SELECT *
FROM emp 
WHERE sal < any(SELECT sal --800,1250
                FROM emp
                WHERE ename in ('SMITH','WARD'));

-- ALL 
--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고, WARD보다도 급여가 사람(AND) (1250보다 높은급여)
SELECT *
FROM emp 
WHERE sal > all(SELECT sal --800,1250
                FROM emp
                WHERE ename in ('SMITH','WARD'));
                
-- NOT IN

-- 관리자의 직원정보
-- 1.관리자인 사람만 조회
-- .mgr 컬럼에 값이 나오는 직원
SELECT DISTINCT mgr         --DISTINCT 중복제거
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr      --중복제거할필요없음
                FROM emp);

--관리자 역할을 하지 않는 평사원 정보 조회
--단 NOT IN연산자는 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 다음 6개의 사번에 포함되지 않는 직원
WHERE empno NOT IN (SELECT nvl(mgr,-9999)      
                     FROM emp);
                   --WHERE mgr is not null);
                   
                   
--pair wise (여러개의 컬럼을 동시에 비교)
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--empno 7499의 mgr7698 deptno30
--empno 7782의 mgr7839 deptnop10
--직원중에 관리자와 부서번호가 (7698, 30)이거나 (7839, 10)인 사람
--mgr, deptno 컬럼을 **동시에** 만족시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                        SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499,7782));
                 
                    
--non pairwise
-- (7698, 30), (7698, 10), (7839, 30), (7839, 10)
-- 
SELECT *
FROM emp
WHERE mgr IN (
                SELECT mgr
                FROM emp
                WHERE empno IN(7499,7782))
AND deptno IN ( SELECT deptno
                FROM emp
                WHERE empno IN(7499,7782));
                
--SCALAR SUBQUERY : SELECT 절에 등장하는 서브 컬럼(단 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회 (join쓰는게 나음)
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno=emp.deptno) as dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno=20;
--------------------------------------------------------------
--sub4 데이터 생성
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

--실습sub4
--emp테이블에 있는 부서번호 (10,20,30)가 아닌 deptm테이블의 부서번호,부서이름,지역
SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);

SELECT *
FROM dept;

SELECT *
FROM emp;
--------------------------------------------------------------
--실습sub5
SELECT pid, pnm
FROM product
WHERE pid NOT IN(SELECT pid FROM cycle WHERE cid=1);

--1.cid=1인 고객이 애음하는 제품코드(pid)
SELECT pid
FROM cycle
WHERE cid = 1;


SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM customer;
------------------------------------------------------------
--실습sub6
SELECT *
FROM cycle
WHERE cid =1
AND pid in(SELECT pid FROM cycle WHERE cid = 2);   --2번 고객에 먹는 제품

------------------------------------------------------------
--실습sub7
SELECT a.cid, cnm, a.pid, pnm, day, cnt
FROM 
    (SELECT *
     FROM cycle
     WHERE cid =1
     AND pid in(SELECT pid FROM cycle WHERE cid = 2)) a, customer c, product p
WHERE a.cid=c.cid
AND a.pid = p.pid;
------------------------------------------------------------

--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a  --메인쿼리 서브쿼리 구별
WHERE EXISTS (SELECT 'X' 
              FROM emp 
              WHERE empno=a.mgr );
 
              
--MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a 
WHERE NOT EXISTS (SELECT 'X' 
                  FROM emp 
                  WHERE empno=a.mgr );
                  
--실습 sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE EXISTS (SELECT 'x' 
                FROM emp 
                WHERE deptno = dept.deptno);
                
--부서에 소속된 직원이 있는 부서 정보 조회(IN연산자)   
--dept테이블의 deptno 중 emp테이블의 deptno가 있는것
SELECT *
FROM dept
WHERE deptno in(SELECT deptno
                FROM emp);
                
--sub9 (과제)
SELECT pid, pnm
FROM product
WHERE NOT EXISTS (SELECT 'x' 
                  FROM cycle 
                  WHERE pid = product.pid 
                  and cid=1);


SELECT *
FROM product;
SELECT *
FROM cycle;
----------------------------------------------------------
--집합연산
--UNION : 합집합, 중복을 제거
--         DBMS에서는 중복을 제거하기 위해 데이터를 정렬
--         (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고 위아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리

--사번이 7566 또는 7698인 사원 조회(사번, 이름)
--UNION
SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698

UNION
--사번이 7369, 7499인 사원 조회(사번, 이름)
SELECT empno, ename
FROM emp
--WHERE empno=7369 OR empno=7499;
WHERE empno=7566 OR empno=7698;


--UNION ALL : 중복허용, 위아래 집합을 합치기만 한다.
SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698;

--INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(차집합 : 위 집합에서 아래 집합을 제거) 7369
--순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--7499
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369);

--첫번째 쿼리의 컬럼을 따름
--order by는 맨마지막에
SELECT 1 n, 'X' m
FROM dual
UNION
SELECT 2, 'Y'
FROM dual
ORDER BY m desc;