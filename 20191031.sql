--����
-- ���̺� ���� ������ ��ȸ
SELECT 'TEST'
FROM emp;

/*
    SELECT �÷� | express(���ڿ� ���) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ����(condition)
*/

--�÷��� ���ִ��� �� �� ������
--desc
DESC user_tables;

SELECT table_name, 
    'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE table_name = 'EMP';
--��ü�Ǽ� -1


--���� �񱳿���
--�μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ������ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

--�μ���ȣ(deptno)�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
--WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');    ---3��
--WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD');     ---11��

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('01011982', 'MMDDYYYY');

SELECT*
FROM emp
WHERE hiredate<'82/01/01';

-- col BETWEEN X AND Y ����
-- �÷��� ���� x ���� ũ�ų� ����, Y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal between 1000 and 2000;

--���� BETWEEN AND ������ �Ʒ��� <=, >=���հ� ����
SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal <= 2000
  AND deptno = 30;

--emp ���̺��� �Ի����ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�� �����ڴ� between�� ����Ѵ�.(�ǽ� where1)
SELECT ename, hiredate
FROM emp
WHERE  hiredate between TO_DATE('19820101', 'YYYYMMDD') AND 
                        TO_DATE('19830101', 'YYYYMMDD');

--emp ���̺��� �Ի����ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�� �����ڴ� �񱳿����ڸ� ����Ѵ�.(�ǽ� where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate > TO_DATE('19820101', 'YYYYMMDD')
  AND hiredate < TO_DATE('19830101', 'YYYYMMDD');
  
--IN ������
--COL IN (values...)
--�μ���ȣ�� 10Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in(10,20);

--IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
   or deptno = 20;

--IN �ǽ� where3   
--users ���̺��� userid�� brown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ�(IN ������ ���)
SELECT userid ���̵�, usernm �̸�
FROM users
WHERE userid in('brown','cony','sally');

SELECT *
FROM users;

--COL LIKE 'S%'
--COL�� ���� �빮�� s�� �����ϴ� ��� ��
--COL LIKE 's____'  (_�װ�)
--COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

--emp ���̺��� �����̸��� s�� �����ϴ� ��� ���� ȣ��
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';
--_���� ������ ��ȸ�ȵ�

--�ǽ� WHERE4
--member���̺��� ȸ���� ���� �ž��� ����� ��mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��__';

--�ǽ� WHERE5
--member���̺��� ȸ���� �̸��� ���� �̰� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ����
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';      --mem_name�� ���ڿ��ȿ� ������ �����ϴ� ������ (������)
--WHERE mem_name LIKE '��%';     --mem_name�� �����ν����ϴ� ������           (������)

--NULL ��
--col IS NULL
--emp ���̺��� mgr������ ���� ���(NULL)
SELECT *
FROM emp
WHERE mgr is NULL;
--WHERE mgr != NULL;        null�� ����

--�Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';   
-- =, !=
--is null !is null


--�ǽ� WHERE 6
--emp ���̺��� ��(comm)�� �ִ� ȸ���� ���� ��ȸ
SELECT *
FROM emp
WHERE comm is not null;

-- AND / OR
-- ������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
 AND sal >= 1000;
 
-- ������(mgr) ���(mgr)�� 7698�̰ų� �޿�(sal)�� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
 OR sal >= 1000;
 
-- emp���̺��� ������mgr ����� 7698�� �ƴϰ� 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);      --IN -->OR

--���������� AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
--IN, NOT IN �������� NULLó��
--emp ���̺��� ������(mgr)����� 7698 Ȥ�� 7839 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
    AND mgr IS NOT NULL;
--IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�

--�ǽ� WHERE7
--emp ���̺��� job�� SALESMAN�̰� �Ի����ڰ� 1981�� 6��1�� ������ ������ ����
SELECT *
FROM emp
WHERE job='SALESMAN'
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');
 
--�ǽ� where8
SELECT *
FROM emp
WHERE deptno != 10
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');
 
--�ǽ� where9
SELECT *
FROM emp
WHERE deptno NOT IN (10)
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');

--�ǽ� where10 
SELECT *
FROM emp
WHERE deptno IN(20,30)
  AND  hiredate > TO_DATE('19810601', 'YYYYMMDD');    
    
--�ǽ� where11
SELECT *
FROM emp
WHERE job='SALESMAN'
  OR hiredate > TO_DATE('19810601', 'YYYYMMDD');

--�ǽ� where 12
SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno LIKE '78%';
   

    