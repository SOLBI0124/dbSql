--sub7 (����)
--1�� ���� �Դ� ������ǰ
--2�� ���� �Դ� ������ǰ
--���� �߰�
SELECT cycle.cid, customer.cnm, product.pid, day, cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid FROM cycle WHERE cid=2);

--sub9 (����)
SELECT pid, pnm
FROM product
WHERE NOT EXISTS (SELECT 'x'
                  FROM cycle
                  WHERE pid = product.pid
                  and cid=1);
--------------------------------------------------------------
INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);

SELECT *
FROM emp
WHERE empno=9999;

rollback;

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name='EMP'; --���̺�� �빮�ڷ� ã�ƾ���

INSERT INTO emp 
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null,40);
rollback;

--SELECT��� (������)�� INSERT

INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;
commit;

--UPDATE
--UPDATE ���̺� SET �÷�=��, �÷�=��....
--WHERE condition

UPDATE dept SET dname='���IT', loc='ym'
WHERE deptno=99;

SELECT *
FROM emp;

--DELETE ���̺��
--WHERE coldition

--�����ȣ�� 9999�� ������ emp���̺��� ����
DELETE emp
WHERE empno=9999;

--�μ����̺��� �̿��ؼ� emp���̺� �Է��� 5���� �����͸� ����
--10,20,30,40,99 --> empno < 100 , empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;
rollback;

--SELECT���� Ȯ��
SELECT *
FROM emp
WHERE empno < 100; 

DELETE emp
WHERE empno BETWEEN 10 AND 99;
rollback;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

DELETE emp WHERE empno=9999;
commit;

--DDL : AUTO COMMIT, rollback�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,           --���� Ÿ��
    ranger_name VARCHAR2(50),   --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : sysdate
);
desc ranger_new;

SELECT *
FROM ranger_new;

--ddl�� rollback�� ������� �ʴ´�
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brwons');
commit;

--EXTRACT : ��¥ Ÿ�Կ��� Ư�� �ʵ尡������ 
--ex) sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, 
        TO_CHAR(reg_dt, 'MM'),
        EXTRACT(MONTH FROM reg_dt) mn, 
        EXTRACT(YEAR FROM reg_dt) year,
        EXTRACT(day FROM reg_dt) day
FROM ranger_new;

--��������
--DEPT ����ؼ� DEPT_TEST����
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,   --deptno�÷��� �ĺ��ڷ� ����
    dname varchar2(14),             --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������, null�� ���� ����.
    loc varchar2(13)
);
desc dept_test;

--primary key�������� Ȯ��
--1.deptno�÷��� null�� �� �� ����
--2.deptno�÷��� �ߺ��� ���� ��� �� �� ����.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES(1, 'ddit','daejeon');
INSERT INTO dept_test VALUES(1, 'ddit2','daejeon');

rollback;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY, 
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT  �������� �÷� �ϳ��� ��
DROP table dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');   --dname �ٸ��� ������ ��

rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(1,null,'daejeon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(2,'ddit','daejeon');   --dname ���Ƽ� ����(unique��������)
rollback;