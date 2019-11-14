--�������� Ȱ��ȭ/��Ȱ��ȭ
--� ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���??

--emp fk����(dept���̺��� deptno�÷�����)
--FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

--�������ǿ� ����Ǵ� �����Ͱ� ��� �� �� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

--FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;          --�ȵ�

--�������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)�� �����Ͽ� �������� Ȱ��ȭ �Ұ�
--�ش� ������ �����ؾ���
DELETE emp
WHERE empno = 9999;
--FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;          --����

--���� ������ �����ϴ� ���̺� ��� view : USER_TABLES
--���� ������ �����ϴ� �������� view : USER_CONSTRAINS 
--���� ������ �����ϴ� ���������� �÷� view : USER_CONS_COLUMNS
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_name = 'EMP';

--FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

--���̺� ������ �������� ��ȸ(VIEW����)
--���̺��/�������Ǹ�/�÷���/�÷� ������
SELECT a.TABLE_NAME, a.CONSTRAINT_NAME, b.COLUMN_NAME, b.POSITION
FROM user_constraints a, USER_CONS_COLUMNS b
where a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
AND a.CONSTRAINT_TYPE = 'P'        --PRIMARY KEY�� ��ȸ
ORDER BY a.table_name, b.position;

---------------------------------------------------------------------------------------------------
--emp ���̺�� 8���� �÷� �ּ��ޱ�
--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

--���̺� �ּ� view : USER_TAB_COMMENTS
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

--emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

--emp ���̺� �÷��ּ�
SELECT *
FROM user_col_comments
WHERE table_name='EMP';

--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

--�ǽ� comment1
SELECT a.table_name, a.table_type, a.comments tab_comment, column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name in('CYCLE','CUSTOMER','PRODUCT','DAILY')
AND a.table_name = b.table_name;
---------------------------------------------------------------------------------------------------

--system������ ���Ѻο�
GRANT CREATE VIEW TO pc20;

--VIEW ���� (emp���̺��� sal, comm�ΰ� �÷��� �����Ѵ�.)
CREATE OR REPLACE VIEW v_emp as
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno 
      FROM emp);
      
--VIEW (�� �ζ��κ�� �����ϴ�)
SELECT *
FROM v_emp;

--���ε� ���� ����� view�� ���� : V_emp_dept
--emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

--VIEW ����
DROP VIEW v_emp;

--VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� �����
--dept 30 -SALES
SELECT *
FROM dept;

--dept���̺��� SALES --> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
--UPDATE dept SET dname = 'SALES'       --�������
WHERE deptno = 30;

--HR �������� V_emp_dept view ��ȸ������ �ش�
GRANT SELECT ON v_emp_dept TO hr;

---------------------------------------------------------------------------------------------------
--SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1              --1������
START WITH 1;               --������1

--nextval : �������� ������ ��ȸ
--currval : ���� ������ �� ��ȸ, nextval���� �� ������ ���� ��� ����
SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval
FROM dual;


SELECT *
FROM post
WHERE reg_id ='brown'
AND title = '�������� ��մ�'
AND reg_dt = TO_DATE('2019//11/14 15:40:15','YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;


--������ ����
--������ : �ߺ����� ���� �������� �������ִ� ��ü
--1,2,3....
desc emp_test;
drop table emp_test;
create table emp_test(
    empno number(4) primary key, 
    enmae varchar2(15)
);
--����������
CREATE SEQUENCE seq_emp_test;

                              --�ߺ����� �ʴ� ��
INSERT INTO emp_test values( seq_emp_test.nextval, 'brown');

SELECT seq_emp_test.nextval
FROM dual;

SELECT *
FROM emp_test;

rollback;       --�������� �ѹ�ȵ�
---------------------------------------------------------------------------------------------------
--index �߿�~!
--ROWID : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺� �����ϴ� ���� �����ϴ�
SELECT product.*, ROWID
FROM product;

--table : pid, pnm
--pk_product :pid
SELECT pid 
FROM product;

--�����ȹ�� ���� �ε��� ��뿩�� Ȯ��;
--emp ���̺� empno�÷��� �������� �ε����� ������
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--�����ȹ����
EXPLAIN PLAN FOR  
SELECT *
FROM emp
WHERE empno = 7369;

--�ε����� ���⶧���� empno=7369�� �����͸� ã�� ����
--emp���̺��� ��ü�� ã�ƺ����Ѵ� => TABLE FULL SCAN
SELECT *
FROM TABLE(dbms_xplan.display);

--�����ȹ�д¼���:������ �Ʒ���. �ڽ����̺������� �ڽĸ��� 1->0