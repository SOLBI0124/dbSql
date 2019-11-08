--조인복습
--조인 왜??
--RDBS의 특성상 데이터 중복을 최대 배제한 설계를 한다
--EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 부서번호만 갖고있고,
--부서번호를 통해 dept테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE  emp.deptno=dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
--count(col) : col값이 존재하면1, null:0
--              행수가 궁금하면 *
SELECT e.deptno, dname, cnt
FROM
    (SELECT deptno, count(deptno) cnt
    FROM emp
    GROUP BY deptno) e, dept
WHERE  e.deptno=dept.deptno;

--***개념적으로 이해
--OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가 나오도록 하는 조인 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회기준이 되도록 하는 조인 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회기준이 되도록 하는 조인 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGTH OUTER JOIN -중복제거

--직원 정보와, 해당 직원의 관리자 정보 outer join
--직원 번호, 직원이름, 관리자 번호, 관리자 이름
--LEFT OUTER JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr=b.empno);

--일반JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr=b.empno);

--oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr=b.empno(+); --데이터 없는쪽에 (+)

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr=b.empno 
                                      AND b.deptno=10); --조인조건

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr=b.empno)
WHERE b.deptno=10;

--oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 outer joing이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr=b.empno);


--실습 outerjoin1 구매일자 맞는 데이터3품목인데 모든품목 나오게하기
--oracle)
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');
--ansi)
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                        AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--실습 outerjoin2
SELECT TO_DATE('05/01/25', 'YY/MM/DD') BUY_DATE, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

----실습 outerjoin3
SELECT TO_DATE('05/01/25', 'YY/MM/DD') BUY_DATE, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

----실습 outerjoin4
--oracle)
SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1;
--ansi)
SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c RIGHT OUTER JOIN product p ON (c.pid = p.pid AND cid=1);

----실습 outerjoin5
--oracle)
SELECT pid, pnm, a.cid, cnm, day, cnt
FROM
(SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1)a, customer
WHERE a.cid=customer.cid;

--실습 corssjoin1
--oracle)
SELECT cid, cnm, pid, pnm
FROM customer, product;
--ansi)
SELECT c.cid, cnm, pid, pnm
FROM customer c CROSS JOIN product p;

---------------------------------------------------------------------------------
--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 : 
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리여야 한다)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now 
FROM emp;



SELECT deptno   --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

--합치기
SELECT *
FROM emp
WHERE deptno = (SELECT deptno           --20
                FROM emp
                WHERE ename = 'SMITH');
                
--실습sub1
--평균급여ㅂ먼저계산
--높은사람 조회

SELECT avg(sal)
FROM emp;

SELECT count(*)
FROM emp
WHERE sal > (SELECT avg(sal)
                FROM emp);
                
--실습sub2
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)
                FROM emp);
                
--실습sub3
SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ENAME = 'SMITH' or ename = 'WARD');

SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ENAME in('SMITH','WARD'));
                
                
SELECT deptno
FROM emp
WHERE ename ='SMITH' OR ename = 'WARD';