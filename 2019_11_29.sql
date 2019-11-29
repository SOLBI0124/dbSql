--CURSOR를 명시적으로 선언하지 않고
--LOOP안에서 inline형태로 cursor사용
set serveroutput on;
--익명블록
DECLARE
    --cursor 선언 --> LOOP에서 inline선언
BEGIN
--  for(String str : list)
--  FOR 레코드 IN 선언된커서 LOOP
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno||', '|| rec.dname);
    END LOOP;
END;
/
--------------------------------------------------------------------------------------
--실습 pro_3
DECLARE
BEGIN
    FOR rec IN (SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1) avg FROM dt) LOOP
        dbms_output.put_line('avg:'||rec.avg);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE avgdt
IS
    --선언부
    
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt테이블 모든 데이터 조회
    FOR rec IN (SELECT * FROM dt ORDER BY dt desc)  
    LOOP
        --rec : dt컬럼
        --먼저읽은 데이터(dt) - 다음 데이터(dt) :      
        IF ind = 0 THEN         --LOOP의 첫시작 
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
--실습 pro_4
SELECT *
FROM CYCLE;
--1 100 2 1
--1번 고객은 100번 제품을 월요일(2)에 한개를 먹는다

--CYCLE
--1 100 2 1

--DAILY
--1 100 20191104 1
--1 100 20191111 1
--1 100 20191118 1
--1 100 20191125 1

SELECT *
FROM daily;
--해당 연월의 1일부터 마지막일 루프돌면서..? 루프두번... daily테이블에insert

--
CREATE OR REPLACE PROCEDURE create_daily_sales (p_yyyymm IN VARCHAR2)
IS
    --달력의 행정보를 저장할 RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1));
        
    --달력의 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;                   --cal_row를 여러 건 저장할 수 있는 table type
    cal calendar;
    
    --애음주기 cursor
    CURSOR cycle_cursor IS 
                            SELECT *
                            FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (level-1),'YYYYMMDD') dt, 
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + (level-1),'D') d
           BULK COLLECT INTO cal
    FROM dual   
    CONNECT BY LEVEL <=  TO_NUMBER(TO_CHAR( LAST_DAY( TO_DATE(p_yyyymm, 'YYYYMM') ),'DD' ));
    
    --생성하려고 하는 년월의 실적 데이터를 삭제한다.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --애음주기 loop
    FOR rec IN cycle_cursor LOOP
    
    --   DBMS_OUTPUT.PUT_LINE(rec.day);
    
         FOR i IN 1..cal.count LOOP
            --애음주기 요일이랑 일자 요일이랑 같은지 비교
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