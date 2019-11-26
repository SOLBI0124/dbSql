SELECT ename, sal, deptno,
        RANK()OVER (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK()OVER (PARTITION BY deptno ORDER BY sal) d_rank,
        ROW_NUMBER()OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--실습 ana1
SELECT empno, ename, sal, deptno,
    RANK() OVER (ORDER BY sal desc, empno) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
    ROW_NUMBER()OVER (ORDER BY sal desc, empno) sal_row_number
FROM emp;

--실습 no_ana2
SELECT b.empno, b.ename, a.deptno, a.cnt
FROM
    (SELECT deptno, count(*) cnt
    FROM emp
    GROUP BY deptno) a, emp b
WHERE a.deptno=b.deptno
ORDER BY deptno;
----------------------------------------------------------------------------
--COUNT 분석함수
--분석함수를 통한 부서별 직원수 구하기
SELECT empno, ename, deptno, 
    COUNT(*) OVER (PARTITION BY deptno) cnt             --order by 꼭 필요없음   
FROM emp;

--SUM 분석함수
--부서별 사원의 급여 합계
SELECT ename, empno, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno) sum_sal     
FROM emp;

--실습 ana2
SELECT empno, ename, sal, deptno,
    ROUND(AVG(sal) OVER(PARTITION BY deptno),2) cnt
FROM emp;

--실습 ana3, 실습 ana4
SELECT empno, ename, sal, deptno,
    MAX(sal) OVER(PARTITION BY deptno) max_sal,
    MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;
----------------------------------------------------------------------------
--부서별 사원번호가 가장 빠른사람
--부서별 사원번소가 가장 느린사람
--재확인 필요
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;
----------------------------------------------------------------------------
--LAG (이전행)
--현재행
--LEAD (다음행)
--급여가 높은 순으로 정렬 했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--                          자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, 
    LAG(sal) OVER (ORDER BY sal) lag_sal,
    LEAD(sal) OVER (ORDER BY sal) lag_sal
FROM emp;

--실습 ana5 급여 한단계 낮은사람
SELECT empno, ename, sal, 
    LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--실습 ana6
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
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든행
--CURRENT ROW : 현재행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
    --본인 포함, 본인보다 적은 급여를 받는 사람의 누적 합
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
    --전체합
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
    --자신, 자신보다 선행하는 1행, 후행하는 1행의 합
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

--실습 ana7
SELECT empno, ename, deptno, sal, 
    SUM(sal) OVER (PARTITION BY deptno 
                    ORDER BY deptno, sal 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
--current row일때 between and 생략 가능
--  SUM(sal) OVER (PARTITION BY deptno ORDER BY deptno, sal ROWS UNBOUNDED PRECEDING) c_sum           
FROM emp;

--
SELECT empno, ename, deptno, sal,
--ROWS : 급여가 동일할때 별도의 행으로 (더함)
    SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) rows_sum,
    SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum2,
--RANGE : 급여가 동일할때 하나의 행으로(더하지않음) 
    SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) RANGE_sum,
    SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) RANGE_sum2
FROM emp;