--��ü ������ �޿����
SELECT ROUND(avg(sal),2) avg
FROM emp;

--�μ��� ������ �޿� ��� 10 XXXX, 20 YYYY, 30 ZZZZ
SELECT deptno, ROUND(avg(sal),2) avg
FROM emp
GROUP BY deptno;

--
SELECT *
FROM 
    (SELECT deptno, ROUND(avg(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE  d_avgsal > (SELECT ROUND(avg(sal),2)
                   FROM emp);
                   
--���� ���� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�
WITH dept_avg_sal AS (SELECT deptno, ROUND(avg(sal),2) d_avgsal
                      FROM emp
                      GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(avg(sal),2)
                  FROM emp);
---------------------------------------------------------------------------
--�޷� �����
--STEP1. �ش� ����� ���� �����
--CONNECT BY LEVEL

--201911
--DATE + ���� = ���� ���ϱ� ����
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1)
FROM dual
CONNECT BY LEVEL <=  TO_CHAR( LAST_DAY( TO_DATE(:YYYYMM, 'YYYYMM') ),'DD' );
--
SELECT  TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1),'iw') iw,                     --���� �������� ��¥ ��ħ. group by ����
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1),'day') d                      --day : ���� / d:������ ���ڷ�(1-�Ͽ���)
FROM dual a
CONNECT BY LEVEL <=  TO_CHAR( LAST_DAY( TO_DATE(:YYYYMM, 'YYYYMM') ),'DD' );

--
SELECT a.w,
      DECODE(d, 1, dt) sun,DECODE(d, 2, dt) mon,DECODE(d, 3, dt) tue,
      DECODE(d, 4, dt) wed, DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
      DECODE(d, 7, dt) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'w') w,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a;

--
SELECT decode(d, 1, a.iw+1, a.iw) iw,
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
       MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
       MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'iw') iw,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level-1), 'd') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY decode(d, 1, a.iw+1, a.iw)
ORDER BY decode(d, 1, a.iw+1, a.iw);
---------------------------------------------------------------------------
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

commit;

SELECT *
FROM sales;

SELECT NVL(max(DECODE(TO_CHAR(dt,'MM'),'01', sum(sales))),0) jan,
       NVL(max(DECODE(TO_CHAR(dt,'MM'),'02', sum(sales))),0) feb,
       NVL(max(DECODE(TO_CHAR(dt,'MM'),'03', sum(sales))),0) mar,
       NVL(max(DECODE(TO_CHAR(dt,'MM'),'04', sum(sales))),0) apr,
       NVL(max(DECODE(TO_CHAR(dt,'MM'),'05', sum(sales))),0) may,
       NVL(max(DECODE(TO_CHAR(dt,'MM'),'06', sum(sales))),0) june
FROM sales
group by TO_CHAR(dt,'MM');

---------------------------------------------------------------------------
--��������
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;



--��������
--START WITH : ������ ���� �κ��� ����
--CONNECT BY : ������ ���� ������ ����

--����� ���� ���� (���� �ֻ��� ������������ ��� ������ Ž��)
--                          ���ڿ�, ��ü����, ���ڿ���ŭ ä�� ����
SELECT dept_h.*, LEVEL, LPAD(' ',(LEVEL-1)*4,' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'    --START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR ���� ���� ������(XXȸ��)

SELECT dept_h.*
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;
