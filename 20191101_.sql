-- ����

-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : �ټ��� ���ڿ��� ��Ī, 
--            _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL (!= NULL �ƴ�)
-- AND, OR, NOT

-- emp���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ������
SELECT *
FROM emp
WHERE  hiredate between TO_DATE('19810601', 'YYYYMMDD') 
  AND TO_DATE('19861231', 'YYYYMMDD');

-- >=, >=
SELECT *
FROM emp
WHERE  hiredate >= TO_DATE('19810601', 'YYYYMMDD') 
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
--emp���̺��� �����ڰ� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr is not null;

------------------------------------------------------------------------
--�ǽ� where12
SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno LIKE '78%';


--�ǽ� where13
--empno�� ���� 4�ڸ����� ���
--empno : 78, 780, 7
--         7800~7899
--         780~789
--         78

desc emp;

SELECT *
FROM emp
WHERE job='SALESMAN'
   OR empno BETWEEN 7800 AND 7899
   OR empno BETWEEN 780 AND 789
   OR empno = 78;
   
   
--�ǽ� where 14
SELECT *
FROM emp
WHERE job='SALESMAN'
    OR (empno LIKE '78%' 
        AND hiredate > TO_DATE('19810601', 'YYYYMMDD'));

--ORDER BY �÷��� | ��Ī | �÷� �ε��� [ASC | DESC]
--ORDER BY ������ WHERE�� ������ ���
--WHERE���� ���� ��� FROM�� ������ ���
--ename�������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : default
--ASC�� �Ⱥٿ��� �� ������ ����
SELECT *
FROM emp
ORDER BY ename; --ASC

--�̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, ���� ���(empno)���� �ø����� ����
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;


--��Ī���� �����ϱ�
--��� ��ȣ(empno), �����(ename), ����(sal*12) as year_sal
--year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 2;
--2 �̸���
--4 ������

--�ǽ� orderby1
desc dept;

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY LOC DESC;

--�ǽ� orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, EMPNO;

--�ǽ� orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--�ǽ� orderby4
--1500�Ѵ� : sal > 1500
SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30)
--WHERE deptno IN (10,30)
    AND sal > 1500
ORDER bY ENAME DESC;



desc emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1;
--WHERE ROWNUM = 2; �ȵ�(1������ �о����)
--WHERE ROWNUM <= 5; ����
--WHERE ROWNUM > 10; �ȵ�(1~10���� ���о��� ����)

--emp���̺��� ���(empno), �̸�(ename)�� �޿��������� ��������, 
--���ĵ� ��������� ROWNUM����
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

--inline view
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;
--�ζ��κ� �ڿ� * ��Ī�����

--row_1
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;

--row_2 (ROWNUM���� 11~14�ΰ�) ROWNUM��Ī, ����� �ζ������� ���� where���� 
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)
WHERE rn between 11 and 14;

-----------------------------------------------
--FUNCTION
--DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

--���ڿ� ��ҹ��� ���õ� �Լ�
--LOWER, UPPER, INITCAP(ù���ڸ��빮��)
SELECT LOWER('HELLO, WORLD'), UPPER('hello, world'), INITCAP('hello, world')
FROM dual;

--�Ϲ����̺��� �ϸ� ������ �Ǽ���ŭ ����
SELECT 'HELLO WORLD'
FROM emp;

--FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--������ 7������
--1.�º��� �������� ���ƶ�
--�º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--Function BAsed Index -> FBI

--CONCAT : ���ڿ� ���� 
--�ΰ��� ���ڿ��� �����ϴ� �Լ�
SELECT CONCAT('HELLO', ', WORLD') as CONCAT
FROM dual;
--���ڿ� ���� ����
--SUBSTR : ���ڿ��� �κ� ���ڿ�(java : String.substring) 1�̻�5����
--LENGTH : ���ڿ��� ����
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD : ���ڿ��� Ư�� ���ڿ��� ����
SELECT CONCAT(CONCAT('HELLO', ','), 'WORLD') as CONCAT,
        SUBSTR('HELLO, WORLD', 0 ,5) substr1,
         SUBSTR('HELLO, WORLD', 1 ,5) substr2,
         LENGTH('HELLO, WORLD') length,
         INSTR('HELLO, WORLD', 'O') instr1,
         --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
         INSTR('HELLO, WORLD', 'O', 6) instr2,
         --LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ� ���̿� ��ġ�� ���Ұ�� ���ʿ� �߰��� ����)
         LPAD('HELLO, WORLD',15,'*') lpad1,
         LPAD('HELLO, WORLD',15) lpad2,         --lapd2, lapd3����
         LPAD('HELLO, WORLD',15,' ') lpad3,
         RPAD('HELLO, WORLD',15,'*') rpad1
FROM dual;




