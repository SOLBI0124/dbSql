--unique table level contraint
drop table dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    --CONSTRAINT �������� �� CONSTRAINT TYPE [(�÷�....)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname, loc)
);
INSERT INTO dept_test VALUES (1,'ddit','daejeon');
--ù��° ������ ���� dname, loc���� �ߺ��ǹǷ� �ι�° ������ ������� ���Ѵ�.
INSERT INTO dept_test VALUES (2,'ddit','daejeon');

--foreign key(��������)
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1,'ddit','daejeon');
commit;

--emp_test (empno, ename, deptno)
CREATE TABLE emp_test(
    empno NUMBER(4)primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

--dept_test ���̺� 1�� �μ���ȣ�� �����ϰ� 
--fk ������ dept_test.deptno �÷��� �����ϵ��� �����Ͽ� 
--1���̿��� �μ���ȣ�� emp_test�� �Էµ� �� ����.

--emp_test fk �׽�Ʈ insert
INSERT INTO emp_test VALUES(9999, 'brown', 1);

--2���μ��� dept_test ���̺� ���������ʴ� �������̱� ������ 
--fk���࿡ ���� INSERT�� ���������� �������� ���Ѵ�.
INSERT INTO emp_test VALUES(9998, 'sally', 2);

--���Ἲ ���࿡�� �߻��� �� �ؾߵɱ�??
--�Է��Ϸ��� �ϴ� ���� �´°ǰ�?? (2���� �³�? 1���Ƴ�?)
-- .�θ����̺� ���� �� �Է¾ȵƴ��� Ȯ�� (dept_test Ȯ��)

--fk���� talbe level constraint
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(2) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno)
);

--FK������ �����Ϸ��� �����Ϸ��� �÷��� �ε����� �����Ǿ� �־�� �Ѵ�.
DROP TABLE emp_test;        --�ڽ����̺� ���� ��������
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),  /* PRIMARY KEY --> UNIQUE ����X --> �ε��� ����X */
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptno�÷��� �ε����� ���⶧���� ���������� fk������ ������ �� ����.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

--���̺� ����
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptno�÷��� �ε����� ���⶧���� ���������� fk������ ������ �� ����.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--��������
DELETE dept_test WHERE deptno=1;

--dept_test���̺���deptno���� �����ϴ� �����Ͱ� ���� ��� ������ �Ұ���
--��, �ڽ����̺��� �����ϴ� �����Ͱ� ����� �θ����̺��� �����͸� ���� �����ϴ�
DELETE emp_test WHERE empnono=9999;
DELETE dept_test WHERE deptno=1;

--FK���� �ɼ�
--defulat : ������ �Է�/������ ���������� ó������� fk ������ �������� ����
--ON DELETE CASCADE : �θ� ������ ������ �����ϴ� �ڽ� ���̺� ���� ����
--ON DELETE NULL : �θ� ������ ������ �����ϴ� �ڽ� ���̺� �� NULL����
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--fk���� default�ɼǽÿ��� �θ����̺��� �����͸� �����ϱ� ���� �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸� ���� �����Ѵ�.
--1.���� ������ ���������� ���� �Ǵ���? o
DELETE dept_test
WHERE deptno=1;   
--2.�ڽ� ���̺� �����Ͱ� ���� �Ǿ�����? o
SELECT *
FROM emp_test;


--fk���� ON DELETE SET NULL
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--fk���� default�ɼǽÿ��� �θ����̺��� �����͸� �����ϱ� ���� �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE SET NULL�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �������� ���� �÷��� NULL�� �����Ѵ�.
--1.���� ������ ���������� ���� �Ǵ���? o
DELETE dept_test
WHERE deptno=1;   
--2.�ڽ� ���̺� �����Ͱ� NULL�� ����Ǿ�����? o
SELECT *
FROM emp_test;

--CHECK ����: �÷��� ���� ������ ����, Ȥ�� ���� �����Բ� ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK(sal >= 0) 
);

--sal �÷��� CHECK���� ���ǿ� ���� 0�̰ų� , 0���� ū���� �Է��� �����ϴ�.
INSERT INTO emp_test VALUES(9999,'brown',10000);
INSERT INTO emp_test VALUES(9999,'sally',-10000);

--
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01-������, 02-����
    emp_gb VARCHAR2(2) CHECK (emp_gb in ('01','02'))
);

INSERT INTO emp_test VALUES(9999,'brown','01');
--emp_gb�÷� üũ���࿡ ���� 01,02�� �ƴ� ���� �Էµ� �� ����.
INSERT INTO emp_test VALUES(9998,'sally','03');


--SELECT ����� �̿��� TABLE ����
--Create Talbe ���̺�� AS
--SELECT ����
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

--CUSTOMER ���̺��� ����Ͽ� CUSTOMER_TEST ���̺�� ����
--CUSTOMER ���̺��� �����͵� ���� ����, primary key�� foreign key, check���� ���� �ȵ�. �����ϰ� �����͸� ��������
CREATE TABLE CUSTOMER_test AS
SELECT *
FROM CUSTOMER;

SELECT *
FROM CUSTOMER_test;

create table test AS
SELECT sysdate dt
from dual;

SELECT *
from test;

DROP TABLE test;

--�����ʹ� �������� �ʰ� Ư�� ���̺��� �÷� ���ĸ� �����ü� ������?
DROP TABLE customer_test;

CREATE TABLE CUSTOMER_test AS
SELECT *
FROM CUSTOMER
WHERE 1=2;          --���� ���ϼ����� ������ ����. �����;��� Ʋ�� �������
--    1!=1;

---------------------------------------------------------------------
--���̺� ����
--���ο� �÷� �߰�
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10)
);

--�ű� �÷� �߰�
ALTER TABLE emp_test ADD (deptno NUMBER(2));
desc emp_test;

--���� �÷� ����
ALTER TABLE EMP_TEST MODIFY (ename VARCHAR2(200));
desc emp_test;

ALTER TABLE EMP_TEST MODIFY (ename NUMBER);
desc emp_Test;

--�����Ͱ� �ִ� ��Ȳ���� �÷� ���� : �������̴�
INSERT INTO emp_test VALUES(9999,1000,10);
commit;

--������ Ÿ���� �����ϱ� ���ؼ��� �÷����� ����־�� �Ѵ�
ALTER TABLE EMP_TEST MODIFY (ename VARCHAR2(10));

--DEFAULT����
desc emp_test;
ALTER TABLE emp_test MODIFY (deptno DEFAULT 10);

--�÷��� ����
ALTER TABLE emp_test RENAME COLUMN deptno to dno;
desc emp_test;

--�÷� ����(DROP)
ALTER TABLE emp_Test DROP COLUMN dno;
--ALTER TABLE emp_Test DROP (dno);  --����
desc emp_Test;

--���̺� ���� : �������� �߰�
--PRIMARY KEY
ALTER TABLE emp_Test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

--PRIMARY KEY�������� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--UNIQUE���� -empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_Test UNIQUE (empno);

--UNIQUE���� ���� : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_Test;

--FOREIGN KEY �߰�
--�ǽ�
--1.DEPT���̺��� DEPTNO�÷����� PRIMARY KEY ������ ���̺� ����
--ddl�� ���� ����
desc dept;
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

--2.emp���̺��� empno�÷����� primary key ������ ���̺� ����
--ddl�� ���� ��
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

--3.emp���̺��� deptno�÷����� dept���̺��� deptno�÷��� �����ϴ� fk������ ���̺� ����
--ddl�� ���� ����
--emp --> dept (deptno)
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);


--�ǽ� emp_test -> dept.deptno fk ���� ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);

--CHECK ���� �߰�(ename���� üũ, ���̰� 3�����̻�)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK ( LENGTH(ename) > 3 );
INSERT INTO emp_test VALUES(9999,'brwon',10);
--����
INSERT INTO emp_test VALUES(9998,'br',10);
rollback;

--CHECK ���� ����
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

--NOT NULL���� �߰�
ALTER TABLE emp_test MODIFY (ename NOT NULL);

--NOT NULL ���� ����(NULL ���)
ALTER TABLE emp_test MODIFY (ename NULL);