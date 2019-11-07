--emp 테이블에는 부서번호(deptno)만 조 ㄴ재
--emp 테이블에서 부서명을 조회하기 위해서는
--dept 테이블과 조인을 통해 부서명 조회

--조인 문법
--ANSI : 테이블명 JOIN 테이블명2 ON (테이블.COL = 테이블2.COL )
--      emp JOIN dept ON(emp.deptno = dept.deptno)
--ORALCE : FROM 테이블, 테이블2 WHERE 테이블.col = 테이블2.col
--       FROM emp, dept WHERE emp.deptno = dept.deptno

--사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;


--실습join0_2
--oracle)
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND e.sal > 2500;
--ansi)
SELECT empno, ename, sal, dept.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
 AND sal > 2500;

--실습join0_3
--oracle)
SELECT empno, ename, sal, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500 
AND empno >7600;
--ansi)
SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno=dept.deptno)
AND sal > 2500 
AND empno >7600;

--실습join0_4
--oracle)
SELECT empno, ename, sal, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno=dept.deptno
 AND sal > 2500 AND empno > 7600
 AND dname='RESEARCH';
--ansi)
SELECT empno, ename, sal, dept.deptno, dname
FROM emp JOIN dept ON(emp.deptno=dept.deptno)
 AND sal > 2500 AND empno > 7600
 AND dname='RESEARCH';
 
--실습join1
--oracle)
SELECT lprod_gu, lprod_nm, prod.prod_id, prod_name
FROM lprod , prod 
WHERE lprod.lprod_gu = prod.prod_lgu;
--ansi)
SELECT lprod_gu, lprod_nm, prod.prod_id, prod_name
FROM lprod JOIN prod ON (lprod.lprod_gu = prod.prod_lgu);

--실습join2
--oracle)
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;
--ansi)
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON (prod.prod_buyer = buyer.buyer_id);

--실습join3
--oracle)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;
--ansi)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);

--실습join4
--oracle)
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm in ('brown','sally');
--ansi)
SELECT customer.cid, cnm, pid, day, cnt
FROM customer JOIN cycle ON ( customer.cid = cycle.cid)
AND cnm in ('brown','sally');

--실습join5
--oracle)
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND cnm in ('brown','sally');
--ansi)
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid)
              JOIN product ON (cycle.pid = product.pid)
AND cnm in ('brown','sally');              

--**********************************************************
--실습join6
--SELECT cnm, count(pnm)
--FROM customer, product
SELECT customer.cid, cnm, cycle.pid, pnm, sum(cnt) as cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;     --값이 같은애들 묶음


--1)고객, 제품별 애음 건수를 구한다
SELECT cid, pid, sum(cnt)   --count는 row수
FROM cycle
GROUP BY cid, pid;  --그룹기준 두개
--2)1번에서 나온 inline-view를 customer, product테이블과 조인한다.
SELECT customer.cid, cnm, a.pid, pnm, a.cnt
FROM 
    (SELECT cid, pid, sum(cnt) as cnt          
    FROM cycle
    GROUP BY cid, pid) a, customer, product
WHERE customer.cid = a.cid
AND a.pid = product.pid;

--with 사용
with cycle_groupby as(
    SELECT cid, pid, sum(cnt) as cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid, cnm, product.pid, pnm, cnt
FROM cycle_groupby, customer, product
WHERE customer.cid = cycle_groupby.cid
AND cycle_groupby.pid = product.pid;
--**************************************************************

--실습 join7
SELECT cycle.pid, pnm, sum(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;

SELECT a.pid, pnm, aCNT
FROM
    (SELECT pid, sum(cnt) aCNT
    FROM cycle
    GROUP BY pid)a, product
WHERE a.pid=product.pid;
--**************************************************************

SELECT empno, count(*)
FROM emp
GROUP BY empno;