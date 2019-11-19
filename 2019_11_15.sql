--emp���̺� empno�÷��� �������� PRIMARY KEY�� ����
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

--empno�� Primary_Key(UNIQUE + NOT NULL) -> index rowid�� ã�� /access
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

--��ȹ����
SELECT *
FROM TABLE(dbms_xplan.display);



--empno�÷����� �ε����� �����ϴ� ��Ȳ����
--�ٸ� �÷� ������ �����͸� ��ȸ�ϴ°��

--job�� Primary_Key(UNIQUE + NOT NULL) �ƴ�. --> ACCESS FULL�� ã�� /filter
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--�ε��� ���� �÷��� SELECT���� ����Ұ��
--���̺� ������ �ʿ����/access
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--*******************************************************************************
------------------------------------------------------------------------------
--�÷��� �ߺ��� ������ non-unique�ε��� ���� �� 
--unique index���� �����ȹ ��

--PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
--non-unique�ε��� ����
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

--��ȹ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

--��ȹ����
--unique scan -> range scan
--7782�� ����, �ٷιر��� Ȯ��(���ĵǾ�����)(�ߺ��Ȱ� �����������ϱ�)
SELECT *
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------
--emp ���̺� job�÷����� �ι�° �ε��� ����(non-unique index)
--job�÷��� �ٸ� �ο��� job�÷��� �ߺ��� ������ �÷��̴�
CREATE INDEX idx_emp_02 ON emp (job);

--��ȹ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%';

--��ȹ����
SELECT *
FROM TABLE(dbms_xplan.display);
------------------------------------------------------------------------------
--emp ���̺� job,ename �÷��� �������� non-nuique�ε��� ����
CREATE INDEX idx_emp_03 ON emp(job, ename);         --�÷������߿�
--��ȹ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE 'C%';

--��ȹ����
SELECT *
FROM TABLE(dbms_xplan.display);

   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
------------------------------------------------------------------------------
--emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX idx_emp_04 ON emp(ename, job);         --�÷������߿�
                                                    
--��ȹ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER'
AND ename LIKE '%C';

--��ȹ����
SELECT *
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------
--HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03) */ *
FROM emp
WHERE job='MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

--*******************************************************************************

--�ǽ� idx1
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX idx_dept_test_01 ON dept_test (deptno);
CREATE INDEX idx_dept_test_02 ON dept_test (dname);
CREATE INDEX idx_dept_test_03 ON dept_test (deptno, dname);

--�ǽ� idx2
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;
DROP INDEX idx_dept_test_03;

--�ǽ� idx3
SELECT *
FROM emp;
WHERE empno=7298;