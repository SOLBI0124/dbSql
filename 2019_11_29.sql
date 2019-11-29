--CURSOR�� ��������� �������� �ʰ�
--LOOP�ȿ��� inline���·� cursor���
set serveroutput on;
--�͸���
DECLARE
    --cursor ���� --> LOOP���� inline����
BEGIN
--  for(String str : list)
--  FOR ���ڵ� IN �����Ŀ�� LOOP
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno||', '|| rec.dname);
    END LOOP;
END;
/
--------------------------------------------------------------------------------------
--�ǽ� pro_3
DECLARE
BEGIN
    FOR rec IN (SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1) avg FROM dt) LOOP
        dbms_output.put_line('avg:'||rec.avg);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE avgdt
IS
    --�����
    
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt���̺� ��� ������ ��ȸ
    FOR rec IN (SELECT * FROM dt ORDER BY dt desc)  
    LOOP
        --rec : dt�÷�
        --�������� ������(dt) - ���� ������(dt) :      
        IF ind = 0 THEN         --LOOP�� ù���� 
            prev_dt := rec.dt;
        ELSE 
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        
        ind := ind+1;       
    END LOOP;
     dbms_output.put_line('diff : '||diff/(ind-1));
END;
/
exec avgdt;
/
--------------------------------------------------------------------------------------
--�ǽ� pro_4
SELECT *
FROM CYCLE;
--1 100 2 1
--1�� ���� 100�� ��ǰ�� ������(2)�� �Ѱ��� �Դ´�

--CYCLE
--1 100 2 1

--DAILY
--1 100 20191104 1
--1 100 20191111 1
--1 100 20191118 1
--1 100 20191125 1

SELECT *
FROM daily;
--�ش� ������ 1�Ϻ��� �������� �������鼭..? �����ι�... daily���̺�insert

--
CREATE OR REPLACE PROCEDURE create_daily_sales (p_yyyymm IN VARCHAR2)
IS
    --�޷��� �������� ������ RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1));
        
    --�޷��� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;                   --cal_row�� ���� �� ������ �� �ִ� table type
    cal calendar;
    
    --�����ֱ� cursor
    CURSOR cycle_cursor IS 
                            SELECT *
                            FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (level-1),'YYYYMMDD') dt, 
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (level-1),'D') d
           BULK COLLECT INTO cal
    FROM dual   
    CONNECT BY LEVEL <=  TO_NUMBER(TO_CHAR( LAST_DAY( TO_DATE(p_yyyymm, 'YYYYMM') ),'DD' ));
    
    --�����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --�����ֱ� loop
    FOR rec IN cycle_cursor LOOP
    
    --   DBMS_OUTPUT.PUT_LINE(rec.day);
    
         FOR i IN 1..cal.count LOOP
            --�����ֱ� �����̶� ���� �����̶� ������ ��
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt );
            END IF;        
        END LOOP;
    END LOOP;
    
    commit; 
END;
/

exec create_daily_sales('201912');

select *
from daily;

commit;

--join
DELETE daily
WHERE dt LIKE '201912%';

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM
    cycle, 
    (SELECT TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (level-1),'YYYYMMDD') dt, 
               TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM') + (level-1),'D') d
               
    FROM dual   
    CONNECT BY LEVEL <=  TO_NUMBER(TO_CHAR( LAST_DAY( TO_DATE(:p_yyyymm, 'YYYYMM') ),'DD' ))) cal
WHERE cycle.day=cal.d;