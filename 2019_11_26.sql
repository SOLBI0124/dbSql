SELECT ename, sal, deptno,
        RANK()OVER (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK()OVER (PARTITION BY deptno ORDER BY sal) d_rank,
        ROW_NUMBER()OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--�ǽ� ana1
SELECT empno, ename, sal, deptno,
    RANK() OVER (ORDER BY sal desc, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
    ROW_NUMBER()OVER (ORDER BY sal desc, empno) sal_row_number
FROM emp;

--�ǽ� no_ana2
SELECT b.empno, b.ename, a.deptno, a.cnt
FROM
    (SELECT deptno, count(*) cnt
    FROM emp
    GROUP BY deptno) a, emp b
WHERE a.deptno=b.deptno
ORDER BY deptno;
----------------------------------------------------------------------------
--COUNT �м��Լ�
--�м��Լ��� ���� �μ��� ������ ���ϱ�
SELECT empno, ename, deptno, 
    COUNT(*) OVER (PARTITION BY deptno) cnt             --order by �� �ʿ����   
FROM emp;

--SUM �м��Լ�
--�μ��� ����� �޿� �հ�
SELECT ename, empno, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno) sum_sal     
FROM emp;

--�ǽ� ana2
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER(PARTITION BY deptno),2) cnt
FROM emp;

--�ǽ� ana3, �ǽ� ana4
SELECT empno, ename, sal, deptno,
    MAX(sal) OVER(PARTITION BY deptno) max_sal,
    MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;
----------------------------------------------------------------------------
--�μ��� �����ȣ�� ���� �������
--�μ��� ������Ұ� ���� �������
--��Ȯ�� �ʿ�
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;
----------------------------------------------------------------------------
--LAG (������)
--������
--LEAD (������)
--�޿��� ���� ������ ���� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                          �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal, 
    LAG(sal) OVER (ORDER BY sal) lag_sal,
    LEAD(sal) OVER (ORDER BY sal) lag_sal
FROM emp;

--�ǽ� ana5 �޿� �Ѵܰ� �������
SELECT empno, ename, sal, 
    LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--�ǽ� ana6
SELECT empno, ename, hiredate, job, sal,
    LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;
----------------------------------------------------------------------------
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.*, ROWNUM rn
    FROM
    (SELECT empno, ename, sal
    FROM emp
    GROUP BY empno, ename, sal
    ORDER BY sal) a)a,
                    (SELECT rownum rn, b.*
                     FROM 
                        (SELECT empno, ename, sal
                        FROM emp 
                        ORDER BY sal, empno) b)b
WHERE a.rn>=b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

--WINDOWING
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� �����
--CURRENT ROW : ������
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
    --���� ����, ���κ��� ���� �޿��� �޴� ����� ���� ��
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
    --��ü��
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    --�ڽ�, �ڽź��� �����ϴ� 1��, �����ϴ� 1���� ��
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

--�ǽ� ana7
SELECT empno, ename, deptno, sal, 
    SUM(sal) OVER (PARTITION BY deptno 
                    ORDER BY deptno, sal 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
--current row�϶� between and ���� ����
--  SUM(sal) OVER (PARTITION BY deptno ORDER BY deptno, sal ROWS UNBOUNDED PRECEDING) c_sum           
FROM emp;

--
SELECT empno, ename, deptno, sal,
--ROWS : �޿��� �����Ҷ� ������ ������ (����)
    SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) rows_sum,
    SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum2,
--RANGE : �޿��� �����Ҷ� �ϳ��� ������(����������) 
    SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RANGE_sum,
    SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) RANGE_sum2
FROM emp;