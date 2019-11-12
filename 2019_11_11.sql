--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
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
-- ANY : set�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
-- SMITH, WARD �λ���� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ 
-- 800���� �۰ų� 1250���� ���� �޿� -> 1250���� ���� �޿��޴»��
SELECT *
FROM emp 
WHERE sal < any(SELECT sal --800,1250
                FROM emp
                WHERE ename in ('SMITH','WARD'));

-- ALL 
--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ����, WARD���ٵ� �޿��� ���(AND) (1250���� �����޿�)
SELECT *
FROM emp 
WHERE sal > all(SELECT sal --800,1250
                FROM emp
                WHERE ename in ('SMITH','WARD'));
                
-- NOT IN

-- �������� ��������
-- 1.�������� ����� ��ȸ
-- .mgr �÷��� ���� ������ ����
SELECT DISTINCT mgr         --DISTINCT �ߺ�����
FROM emp;

--� ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr      --�ߺ��������ʿ����
                FROM emp);

--������ ������ ���� �ʴ� ���� ���� ��ȸ
--�� NOT IN�����ڴ� ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 ���� 6���� ����� ���Ե��� �ʴ� ����
WHERE empno NOT IN (SELECT nvl(mgr,-9999)      
                     FROM emp);
                   --WHERE mgr is not null);
                   
                   
--pair wise (�������� �÷��� ���ÿ� ��)
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--empno 7499�� mgr7698 deptno30
--empno 7782�� mgr7839 deptnop10
--�����߿� �����ڿ� �μ���ȣ�� (7698, 30)�̰ų� (7839, 10)�� ���
--mgr, deptno �÷��� **���ÿ�** ������Ű�� ���� ���� ��ȸ
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
                
--SCALAR SUBQUERY : SELECT ���� �����ϴ� ���� �÷�(�� ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ (join���°� ����)
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno=emp.deptno) as dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno=20;
--------------------------------------------------------------
--sub4 ������ ����
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
commit;

--�ǽ�sub4
--emp���̺� �ִ� �μ���ȣ (10,20,30)�� �ƴ� deptm���̺��� �μ���ȣ,�μ��̸�,����
SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);

SELECT *
FROM dept;

SELECT *
FROM emp;
--------------------------------------------------------------
--�ǽ�sub5
SELECT pid, pnm
FROM product
WHERE pid NOT IN(SELECT pid FROM cycle WHERE cid=1);

--1.cid=1�� ���� �����ϴ� ��ǰ�ڵ�(pid)
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
--�ǽ�sub6
SELECT *
FROM cycle
WHERE cid =1
AND pid in(SELECT pid FROM cycle WHERE cid = 2);   --2�� ���� �Դ� ��ǰ

------------------------------------------------------------
--�ǽ�sub7
SELECT a.cid, cnm, a.pid, pnm, day, cnt
FROM 
    (SELECT *
     FROM cycle
     WHERE cid =1
     AND pid in(SELECT pid FROM cycle WHERE cid = 2)) a, customer c, product p
WHERE a.cid=c.cid
AND a.pid = p.pid;
------------------------------------------------------------

--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a  --�������� �������� ����
WHERE EXISTS (SELECT 'X' 
              FROM emp 
              WHERE empno=a.mgr );
 
              
--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a 
WHERE NOT EXISTS (SELECT 'X' 
                  FROM emp 
                  WHERE empno=a.mgr );
                  
--�ǽ� sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
SELECT *
FROM dept
WHERE EXISTS (SELECT 'x' 
                FROM emp 
                WHERE deptno = dept.deptno);
                
--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(IN������)   
--dept���̺��� deptno �� emp���̺��� deptno�� �ִ°�
SELECT *
FROM dept
WHERE deptno in(SELECT deptno
                FROM emp);
                
--sub9 (����)
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
--���տ���
--UNION : ������, �ߺ��� ����
--         DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--         (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ� ���Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION �����ں��� ���ɸ鿡�� ����

--����� 7566 �Ǵ� 7698�� ��� ��ȸ(���, �̸�)
--UNION
SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698

UNION
--����� 7369, 7499�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
--WHERE empno=7369 OR empno=7499;
WHERE empno=7566 OR empno=7698;


--UNION ALL : �ߺ����, ���Ʒ� ������ ��ġ�⸸ �Ѵ�.
SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno=7566 OR empno=7698;

--INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(������ : �� ���տ��� �Ʒ� ������ ����) 7369
--������ ����
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

--ù��° ������ �÷��� ����
--order by�� �Ǹ�������
SELECT 1 n, 'X' m
FROM dual
UNION
SELECT 2, 'Y'
FROM dual
ORDER BY m desc;