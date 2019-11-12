--sub7 (과제)
--1번 고객이 먹는 애음제품
--2번 고객도 먹는 애음제품
--고객명 추가
SELECT cycle.cid, customer.cnm, product.pid, day, cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid FROM cycle WHERE cid=2);

--sub9 (과제)
SELECT pid, pnm
FROM product
WHERE NOT EXISTS (SELECT 'x'
                  FROM cycle
                  WHERE pid = product.pid
                  and cid=1);
--------------------------------------------------------------
INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);

SELECT *
FROM emp
WHERE empno=9999;

rollback;

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name='EMP'; --테이블명 대문자로 찾아야함

INSERT INTO emp 
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null,40);
rollback;

--SELECT결과 (여러건)를 INSERT

INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;
commit;

--UPDATE
--UPDATE 테이블 SET 컬럼=갑, 컬럼=값....
--WHERE condition

UPDATE dept SET dname='대덕IT', loc='ym'
WHERE deptno=99;

SELECT *
FROM emp;

--DELETE 테이블명
--WHERE coldition

--사원번호가 9999인 직원을 emp테이블에서 삭제
DELETE emp
WHERE empno=9999;

--부서테이블을 이용해서 emp테이블에 입력한 5건의 데이터를 삭제
--10,20,30,40,99 --> empno < 100 , empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;
rollback;

--SELECT절로 확인
SELECT *
FROM emp
WHERE empno < 100; 

DELETE emp
WHERE empno BETWEEN 10 AND 99;
rollback;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

DELETE emp WHERE empno=9999;
commit;

--DDL : AUTO COMMIT, rollback이 안된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,           --숫자 타입
    ranger_name VARCHAR2(50),   --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : sysdate
);
desc ranger_new;

SELECT *
FROM ranger_new;

--ddl은 rollback이 적용되지 않는다
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brwons');
commit;

--EXTRACT : 날짜 타입에서 특정 필드가져오기 
--ex) sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, 
        TO_CHAR(reg_dt, 'MM'),
        EXTRACT(MONTH FROM reg_dt) mn, 
        EXTRACT(YEAR FROM reg_dt) year,
        EXTRACT(day FROM reg_dt) day
FROM ranger_new;

--제약조건
--DEPT 모방해서 DEPT_TEST생성
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,   --deptno컬럼을 식별자로 지정
    dname varchar2(14),             --식별자로 지정이 되면 값이 중복이 될 수 없으며, null일 수도 없다.
    loc varchar2(13)
);
desc dept_test;

--primary key제약조건 확인
--1.deptno컬럼에 null이 들어갈 수 없다
--2.deptno컬럼에 중복된 값이 들어 갈 수 없다.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES(1, 'ddit','daejeon');
INSERT INTO dept_test VALUES(1, 'ddit2','daejeon');

rollback;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY, 
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT  여러개를 컬럼 하나로 봄
DROP table dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');   --dname 다르기 때문에 들어감

rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(1,null,'daejeon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(2,'ddit','daejeon');   --dname 같아서 오류(unique하지않음)
rollback;