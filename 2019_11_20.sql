-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0
SELECT job, deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

-- job �÷�
-- case1. GROUPING(job)=1 AND GROUPING(deptno)=1
--        job --> '�Ѱ�'
-- case else
--        job --> job
SELECT CASE WHEN GROUPING(job)=1 AND                      
                 GROUPING(deptno) =1 THEN '�Ѱ�'          --job null->�Ѱ�
            ELSE job
        END as job, deptno, 
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT CASE WHEN GROUPING(job)=1 AND GROUPING(deptno) =1 THEN '�Ѱ�'          
            ELSE job
        END as job 
        ,CASE WHEN GROUPING(job)=0 AND GROUPING(deptno) = 1 THEN job || ' �Ұ�'
        ELSE TO_CHAR(deptno)
        END as deptno 
        ,GROUPING(job), GROUPING(deptno)
        ,sum(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--�ǽ�GROUP_AD3
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--�ǽ�GROUP_AD4
SELECT dname, job, sum(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);

--�ǽ�GROUP_AD5
SELECT CASE WHEN grouping(dname)=1 AND grouping(job)=1 THEN '����'
            ELSE dname
            END as dname
        , job, sum(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);
---------------------------------------------------------------------------
--CUBE(col, col2...)
--GROUP BY CUBE(job, deptno)
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY -- ��� �����Ϳ� ���ؼ�...(�Ѱ�)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);
---------------------------------------------------------------------------
--GROUP BY �ٽ�
SELECT deptno, MIN(ename), sum(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, sum(sal)             --group by���� ���� �÷��� select���� ����ϸ� �ȵ�
FROM emp                            --group by���� �ִ� �÷��� select���� ������ϴ°� �������
GROUP BY deptno, job;
---------------------------------------------------------------------------
--subquery�� ���� ������Ʈ

DROP TABLE emp_test;
--emp���̺��� �����͸� �����ؼ� ��� �÷��� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test���̺� dept���̺��� �����ǰ��ִ� dname�÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

--emp_test���̺� dname�÷��� dept���̺� �ִ� dname�÷� ������ ������Ʈ�ϴ� �����ۼ�
UPDATE emp_test SET dname = (SELECT dname 
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (7369,7399);
COMMIT;

SELECT *
FROM emp_Test;


--�ǽ� sub_a1
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER(6));

UPDATE dept_test SET empcnt = (SELECT count(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno);
---------------------------------------------------------------------------
--�ǽ� sub_a2
insert into dept_test values(99, 'it', 'daejeon', 0);
insert into dept_test values(98, 'it', 'daejeon', 0);

SELECT *
FROM dept_Test;

SELECT *
FROM emp;

DELETE FROM dept_test
WHERE NOT EXISTS (SELECT 'x'
                    FROM emp
                    WHERE deptno = dept_test.deptno);
                
--�ǽ� sub_a3
SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = sal+200
WHERE SAL < (SELECT AVG(sal)
             FROM emp_test b
             WHERE b.deptno=a.deptno);

--emp, emp_test empno�÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno=emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal �ش� ���(emp���̺� ����)�� ���� �޿����

SELECT a.empno, a.ename, a.sal, a.sal1, a.deptno, b.avg
     FROM 
        (SELECT emp.empno empno , emp.ename ename, emp.sal sal , emp_test.sal sal1, emp.deptno deptno
         FROM emp, emp_test
         WHERE emp.empno=emp_test.empno) a, (select deptno, round(avg(sal),2) avg
                                             from emp
                                             group by deptno) b
WHERE a.deptno=b.deptno
order by empno;

select deptno, round(avg(sal),2)
from emp
group by deptno;