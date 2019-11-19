DROP TABLE emp_Test;

--multiple insert�� ���� ��[��Ʈ ���̺� ����
--empno, ename, �ΰ��� �÷��� ���� emp_test, emp_tes2 ���̺���
--emp ���̺�κ��� �����Ѵ� (CTAS)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;                      --����� ���� ���������� ����(������ ����X)

--INSERT ALL
--�ϳ��� INSERT SQL�������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1,'brown' FROM dual UNION ALL
SELECT 2,'sally' FROM dual;

SELECT *
FROM emp_test;

--INSERT �÷� ����. ������ ���� ���� ���̺� �Է�(�Ϻ� �÷��� �Է°���) 
ROLLBACK;

INSERT ALL
    INTO emp_test(empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;


--multiple insert(conditional insert)
--������ ���� ���ǿ� ���� ���̺� �Է�
INSERT ALL
    WHEN empno<10 THEN
        INTO emp_test(empno) VALUES (empno)
    ELSE    --������ ������� ���Ҷ��� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL  --emp_test2
SELECT 2 empno, 'sally' ename FROM dual;            --emp_test

SELECT *
FROM emp_test2;

--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT������ ����
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
--****MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--            ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

--empno�� 7369�� �����͸� emp���̺�κ��� emp_test���̺� ����(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno='7369';

SELECT *
FROM emp_test;

--emp���̺��� �������� emp_Test ���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ��� 
--emp_test.ename = ename || '_merge'������ update
--�����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));

MERGE INTO emp_test
USING (SELECT empno, ename
        FROM emp
        WHERE emp.empno IN(7369, 7499)) 
 ON (emp.empno = emp_test.empno)                 --���α���
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOt MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
SELECT *
FROM emp_test;
rollback;

--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge�ϴ� ���

--empno =1, ename ='brown'
--empno�� ���� ���� ������ ename�� 'brown'���� update
--empno�� ���� ���� ������ �ű� insert

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
WHEN MATCHED THEN 
 UPDATE set ename = 'brown' || '_merge'         --empno�� 1�� ������ ����
WHEN NOT MATCHED THEN 
 INSERT VALUES (1, 'brown');

------------------------------------------------------------------------- 
--�ǽ�GROP_AD1
--�μ���ȣ�� sal��
SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno

UNION ALL                   --union all : ������, �ߺ��� �������� ����

--��������� �޿� ��
SELECT null,sum(sal)
FROM emp;


--ROLLUP ����
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (deptno);
       
--ROLLUP
--group by �� ���� �׷��� ������
--GROUP BY ROLLUP( {col, } )
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� GROUP BY �Ͽ� UNION �ѰͰ� ����
--ex : GROUP BY ROLLUP (job, deptno)
--      GROUP BY job, deptno
--      UNION
--      GROUP BY job
--      UNION
--      GROUP bY --> �Ѱ� (��� �࿡���� �׷��Լ� ����)

SELECT job, deptno, sum(sal)
FROM emp
GROUP BY ROLLUP (job, deptno);

------------------------------------------------------------------------
--GROUPING SETS(col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GORUP BY ���� �̿�ȴ�
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp���̺��� �̿��Ͽ� �μ��� �޿��հ� ������(job)�� �޿����� ���Ͻÿ�
--�μ���ȣ, job, �޿��հ�
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