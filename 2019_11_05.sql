--년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
--201911->30 / 201912-->31

--한달 더한 후 원래값을 빼면 = 일수
--마지막날짜 구한 후 --> DD만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')), 'DD') as day_cnt
FROM dual;

--바인드( :yyyymm )
SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')), 'DD') as day_cnt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = '7369';   --문자열로 썼지만 실제실행될때는 숫자
--WHERE TO_CHAR(empno) = '7369';  --문자로 형변환. 실행될때 문자

--sql실행계획 보기
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--,표시/.소수점/L,l : 화폐단위
SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99')sal_fmt
FROM emp;

--중요. 활용도 높음
--function null
--nvl(col1, col1이 null일경우 대체할 값) 
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
    sal+comm, 
    sal + nvl(comm,0),
    nvl(sal + comm, 0)
FROM emp;


--nvl2(col1, col1이 null이 아닐경우 표현되는 값, col1이 null일경우 표현 되는 값)
SELECT empno, ename, sal, comm, nvl2(comm, comm, 0)+sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null (강제로 null을 만듦)
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp; 

--COALESCE(expr1, expr2, expr3...)
--함수 인자 중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, coalesce(comm, sal) --comm이 null이 아니면 comm이 옴. comm이 null이면 sal값이옴
FROM emp;

--null실습 fn4
SELECT empno, ename, mgr, 
        nvl(mgr, 9999) as mgr_n,
        nvl2(mgr, mgr, 9999) mgr_n,
        coalesce(mgr, 9999) mgr_n
FROM emp;

--null 실습 fn5
SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) as n_reg_dt
from users;

------------------------------------
--***case when
SELECT empno, ename, job, sal,
    case
        when job = 'SALESMAN' then sal*1.05
        when job = 'MANAGER' then sal*1.10
        when job = 'PRESIDENT' then sal*1.20
        else sal
    end as case_sal
FROM emp;

--***decode(col1, search1, return1, search2, return2.... default)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal*1.05, 
                'MANAGER', sal*1.10, 
                'PRESIDENT', sal*1.20,
                                        sal) as decode_sal
FROM emp;


--condition 실습 cond1
SELECT empno, ename,
    DECODE(deptno,  10, 'ACCOUNTING', 
                    20, 'RESEARCH',
                    30, 'SALES',
                    40, 'OPERATIONS', 
                                    'ddit') as dname
FROM emp;

--conditon 실습 cond2
SELECT empno, ename, hiredate,
    DECODE( MOD( (To_CHAR(SYSDATE,'YYYY')-TO_CHAR(hiredate,'YYYY')),2) ,0, '건강검진 대상자',
                                                                            '건강검진 비대상자') as contact_to_doctor
FROM emp;

--올해는 짝수인가? 홀수인가?
--1. 올해 년도 구하기(DATE --> TO CHAR(DATE, FORMAT))
SELECT TO_CHAR(SYSDATE,'YYYY'),
--2.올해 년도가 짝수인지 계산 (어떤 수를 2로 나누면 항상 나머지는 2보다 작다) (2로 나눌경우 나머지는 0,1)
       MOD(TO_CHAR(SYSDATE,'YYYY'),2)
FROM dual;

--emp테이블에서 입사일자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate, 
        CASE
            WHEN MOD(TO_CHAR(SYSDATE,'YYYY'),2)= MOD(TO_CHAR(hiredate,'YYYY'),2) 
            then '건강검진 대상'
            else'건강검진 비대상'
        END                                                           
FROM emp;

--condition 실습 cond3
SELECT userid, usernm, alias, reg_dt,
    case
        when MOD(TO_CHAR(SYSDATE,'YYYY'),2)= MOD(TO_CHAR(reg_dt,'YYYY'),2)
        then '건강검진 대상자'
        else '건강검진 비대상자'
    end as contacttodoctor
FROM users;

--그룹함수(AVG, MAX, MIN, SUM, COUNT)
--그룹함수는 NULL값을 계산대상에서 제외한다
--SUM(comm), COUNT(*), COUNT(mgr)
--직원중 가장 높은 급여를 받는 사람 급여
--직원중 가장 낮은 급여를 받는 사람의 급여
--직원의 급여평균(소수점 둘째자리까지만 나오게 --> 소수점 3째자리에서 반올림)
--직원의 급여전체합
--직원의 숫자
SELECT MAX(sal) as max_sal, MIN(sal) as min_sal,
       ROUND(AVG(sal),2) as avg_sal,
       SUM(sal) as sum_sal,
       COUNT(*) as emp_cnt, --행단위로 셀때
       COUNT(sal) as sal_cnt,
       COUNT(mgr) as mgr_cnt,    --null값은 연산에 포함안됨(null값 빼고 계산)
       SUM(comm) as comm_sum
FROM emp;

--부서별(10,20,30) 가장 높은 급여를 받는 사람의 급여
--GROUP BY절에 기술되지 않은 컬럼이 SELECT절에 기술되면 에러. 그룹화와 관련없는 임의의 문자열, 상수는 올 수 있음 ex) 'test',1
SELECT deptno, MAX(sal) as max_sal, MIN(sal) as min_sal,  --ename쓰면 오류/ cf. MIN(ename)은 가능,가장 높은급여 나온사람오는거아님.관련없음 / deptno없어도 됨
       ROUND(AVG(sal),2) as avg_sal,
       SUM(sal) as sum_sal,
       COUNT(*) as emp_cnt, 
       COUNT(sal) as sal_cnt,
       COUNT(mgr) as mgr_cnt,    
       SUM(comm) as comm_sum
FROM emp
GROUP BY deptno;

--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
--WHERE MAX(sal) > 3000     --여기에쓸수없음.오류
GROUP BY deptno
HAVING MAX(sal)>3000;

--group function 실습 grp1
SELECT max(sal) max_sal, min(sal) min_sal, 
        round(avg(sal),2) avg_sal, 
        sum(sal) sum_sal, 
        count(sal) count_sal, count(mgr) count_mgr, count(*) count_all
FROM emp;

--group function 실습 grp2
SELECT deptno, max(sal) max_sal, min(sal) min_sal, 
        round(avg(sal),2) avg_sal, 
        sum(sal) sum_sal, 
        count(sal) count_sal, count(mgr) count_mgr, count(*) count_all
FROM emp
GROUP BY deptno;

--group function 실습 grp3
SELECT DECODE(deptno, 30, 'ACCOUNTING', 20,'RESEARCH', 10, 'SALES') as dname, 
        max(sal) max_sal, min(sal) min_sal, 
        round(avg(sal),2) avg_sal, 
        sum(sal) sum_sal, 
        count(sal) count_sal, count(mgr) count_mgr, count(*) count_all
FROM emp
GROUP BY deptno;

--group function 실습 grp4
SELECT TO_CHAR(hiredate,'YYYYMM') as hire_yyyymm, count(sal)
FROM emp
GROUP BY hiredate;

--