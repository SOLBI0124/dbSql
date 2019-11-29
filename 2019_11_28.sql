--실습 PRO_2
SELECT *
FROM dept_test;

CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc  IN dept.loc%TYPE)
IS
 
BEGIN
    INSERT INTO dept_test VALUES(p_deptno, p_dname, p_loc ) ;
    commit;
END;
/
exec registdept_test(99, 'ddit', 'daejeon');
    
--실습 PRO_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc  IN dept.loc%TYPE)
IS
 
BEGIN
    UPDATE dept_test SET dname=p_dname, loc=p_loc WHERE deptno=p_deptno;
    commit;
END;
/
exec UPDATEdept_test(99, 'ddit_m', 'DAEJEON');

SELECT *
FROM dept_test;
-----------------------------------------------------------------------------------
--ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조타입
set serveroutput on;

DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ',' || dept_row.dname || ',' || dept_row.loc);
END;
/
SELECT *
FROM dept;
/
-----------------------------------------------------------------------------------
--복합변수 : record
DECLARE
    --UserVo userVo;
    TYPE dept_row IS RECORD(        --dept_row라는 레코드타입 만듦. 한행에 두개의 컬럼
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    
--  v_dname dept.dname%TYPE;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/
-----------------------------------------------------------------------------------
--tabletype 여러행의 데이터 넣음
DECLARE
                                                    --인덱스의 타입
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
    v_dept dept_tab;
    bi BINARY_INTEGER;
BEGIN
    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept        --6건의 데이터 v_dept에 들어감 
    FROM dept;
    
    dbms_output.put_line(bi);
--    --인덱스1부터 시작
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
--    dbms_output.put_line(v_dept(5).dname);
   
    --FOR LOOP사용
    FOR i IN 1..v_dept.count LOOP           --v_dept.count = v_dept.size()
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
END;
/
SELECT *
FROM dept;
-----------------------------------------------------------------------------------
--IF
--ELSE IF --> ELSIF
-- END IF;
--블럭 없음
DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN 
        DBMS_OUTPUT.PUT_LINE(ind);
    ELSIF ind = 2 THEN
        DBMS_OUTPUT.PUT_LINE('ELSIF '||ind);
    ELSE
        DBMS_OUTPUT.PUT_LINE('ELSE');
    END IF;
END;
/
-----------------------------------------------------------------------------------
--FOR LOOP : 반복문
--FOR 인덱스 변수 IN 시작값.. 종료값 LOOP
--END LOOP;
DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : '|| i );
    END LOOP;
END;
/
-----------------------------------------------------------------------------------
--LOOP : 계속 실행 판단 로직을 LOOP안에서 제어
--java : while(true)
DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP 
        dbms_output.put_line(i);
        i := i+1;
        --loop계속 진행여부 판단
        EXIT WHEN i>=5;
    END LOOP;
END;
/
-----------------------------------------------------------------------------------
 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

SELECT *
FROM dt;
/

--실습 PRO_3
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;

    v_dt dt_tab;
    i NUMBER;
    sum1 NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt
    ORDER BY dt DESC;

    i := 1;
     
    LOOP 
        sum1 := sum1+(v_dt(i).dt-v_dt(i+1).dt);
        i := i+1;
    
    EXIT WHEN i = v_dt.count;
        
    END LOOP;
    dbms_output.put_line('날짜 간격 평균 : '|| sum1/(v_dt.count-1)||'일');
END;
/
--------------------------------------------------------------------------------------
--lead, lag  현재 행의 이전, 이후 데이터를 가져올 수 있다.
SELECT avg(diff)
FROM
    (SELECT dt,
        dt - LEAD(dt) OVER (ORDER BY dt desc) diff
    FROM dt);

--분석함수를 사용하지 못하는 환경에서
SELECT avg(s)
FROM
(SELECT (a.dt-b.dt) s
FROM
    (SELECT ROWNUM RN, dt
    FROM 
        (SELECT *
        FROM dt
        ORDER BY dt DESC)) a,
                            (SELECT ROWNUM RN, dt
                             FROM 
                                (SELECT *
                                FROM dt
                                ORDER BY dt DESC)) b
WHERE a.rn = b.rn(+)-1);

--------------------------------------------------------------------------------------
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)-1) avg
FROM dt;
--------------------------------------------------------------------------------------
--CURSOR 명시적커서
--여러건의 데이터를 테이블타입없이 작업
DECLARE 
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', '||v_dname);
        EXIT WHEN dept_cursor%NOTFOUND;     --더이상 읽을 데이터가 없을 때 종료
    END LOOP;
END;
/

--FOR LOOP CURSOR 결합
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
     v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/
--파라미터가 있는 명시적 커서
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job 
        FROM emp
        WHERE job = p_job;
    
BEGIN 
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ', ' || emp.ename ||', ' || emp.job);
    END LOOP;
END;
/