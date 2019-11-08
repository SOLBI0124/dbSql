--���κ���
--���� ��??
--RDBS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�
--EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� �μ���ȣ�� �����ְ�,
--�μ���ȣ�� ���� dept���̺�� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE  emp.deptno=dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
--count(col) : col���� �����ϸ�1, null:0
--              ����� �ñ��ϸ� *
SELECT e.deptno, dname, cnt
FROM
    (SELECT deptno, count(deptno) cnt
    FROM emp
    GROUP BY deptno) e, dept
WHERE  e.deptno=dept.deptno;

--***���������� ����
--OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� �������� �ϴ� ���� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ������ �ǵ��� �ϴ� ���� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ������ �ǵ��� �ϴ� ���� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGTH OUTER JOIN -�ߺ�����

--���� ������, �ش� ������ ������ ���� outer join
--���� ��ȣ, �����̸�, ������ ��ȣ, ������ �̸�
--LEFT OUTER JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr=b.empno);

--�Ϲ�JOIN
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr=b.empno);

--oracle outer join (left, right�� ���� fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr=b.empno(+); --������ �����ʿ� (+)

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr=b.empno 
                                      AND b.deptno=10); --��������

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr=b.empno)
WHERE b.deptno=10;

--oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� outer joing�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr=b.empno);


--�ǽ� outerjoin1 �������� �´� ������3ǰ���ε� ���ǰ�� �������ϱ�
--oracle)
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');
--ansi)
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                        AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--�ǽ� outerjoin2
SELECT TO_DATE('05/01/25', 'YY/MM/DD') BUY_DATE, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

----�ǽ� outerjoin3
SELECT TO_DATE('05/01/25', 'YY/MM/DD') BUY_DATE, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buyprod.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

----�ǽ� outerjoin4
--oracle)
SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1;
--ansi)
SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c RIGHT OUTER JOIN product p ON (c.pid = p.pid AND cid=1);

----�ǽ� outerjoin5
--oracle)
SELECT pid, pnm, a.cid, cnm, day, cnt
FROM
(SELECT p.pid, pnm, 1 cid, nvl(day, 0) day , nvl(cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1)a, customer
WHERE a.cid=customer.cid;

--�ǽ� corssjoin1
--oracle)
SELECT cid, cnm, pid, pnm
FROM customer, product;
--ansi)
SELECT c.cid, cnm, pid, pnm
FROM customer c CROSS JOIN product p;

---------------------------------------------------------------------------------
--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ : 
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �������� �Ѵ�)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*���糯¥*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now 
FROM emp;



SELECT deptno   --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

--��ġ��
SELECT *
FROM emp
WHERE deptno = (SELECT deptno           --20
                FROM emp
                WHERE ename = 'SMITH');
                
--�ǽ�sub1
--��ձ޿����������
--������� ��ȸ

SELECT avg(sal)
FROM emp;

SELECT count(*)
FROM emp
WHERE sal > (SELECT avg(sal)
                FROM emp);
                
--�ǽ�sub2
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)
                FROM emp);
                
--�ǽ�sub3
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