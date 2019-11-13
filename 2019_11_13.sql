--unique table level contraint
drop table dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    --CONSTRAINT 제약조건 명 CONSTRAINT TYPE [(컬럼....)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname, loc)
);
INSERT INTO dept_test VALUES (1,'ddit','daejeon');
--첫번째 쿼리에 의해 dname, loc값이 중복되므로 두번째 쿼리는 실행되지 못한다.
INSERT INTO dept_test VALUES (2,'ddit','daejeon');

--foreign key(참조제약)
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1,'ddit','daejeon');
commit;

--emp_test (empno, ename, deptno)
CREATE TABLE emp_test(
    empno NUMBER(4)primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

--dept_test 테이블에 1번 부서번호만 존재하고 
--fk 제약을 dept_test.deptno 컬럼에 참조하도록 생성하여 
--1번이외의 부서번호는 emp_test에 입력될 수 없다.

--emp_test fk 테스트 insert
INSERT INTO emp_test VALUES(9999, 'brown', 1);

--2번부서는 dept_test 테이블에 존재하지않는 데이터이기 때문에 
--fk제약에 의해 INSERT가 정상적으로 동작하지 못한다.
INSERT INTO emp_test VALUES(9998, 'sally', 2);

--무결성 제약에러 발생시 뭘 해야될까??
--입력하려고 하는 값이 맞는건가?? (2번이 맞나? 1번아냐?)
-- .부모테이블에 값이 왜 입력안됐는지 확인 (dept_test 확인)

--fk제약 talbe level constraint
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(2) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno)
);

--FK제약을 생성하려면 참조하려는 컬럼에 인덱스가 생성되어 있어야 한다.
DROP TABLE emp_test;        --자식테이블 먼저 지워야함
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),  /* PRIMARY KEY --> UNIQUE 제약X --> 인덱스 생성X */
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptno컬럼에 인덱스가 없기때문에 정상적으로 fk제약을 생성할 수 없다.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

--테이블 삭제
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptno컬럼에 인덱스가 없기때문에 정상적으로 fk제약을 생성할 수 없다.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--안지워짐
DELETE dept_test WHERE deptno=1;

--dept_test테이블의deptno값을 참조하는 데이터가 있을 경우 삭제가 불가능
--즉, 자식테이블에서 참조하는 데이터가 없어야 부모테이블의 데이터를 삭제 가능하다
DELETE emp_test WHERE empnono=9999;
DELETE dept_test WHERE deptno=1;

--FK제약 옵션
--defulat : 데이터 입력/삭제시 순차적으로 처리해줘야 fk 제약을 위배하지 않음
--ON DELETE CASCADE : 부모 데이터 삭제시 참조하는 자식 테이블 같이 삭제
--ON DELETE NULL : 부모 데이터 삭제시 참조하는 자식 테이블 값 NULL설정
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--fk제약 default옵션시에는 부모테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는 데이터가 없어야 정상적으로 삭제가 가능했음
--ON DELETE CASCADE의 경우 부모 테이블 삭제시 참조하는 자식 테이블의 데이터를 같이 삭제한다.
--1.삭제 쿼리가 정상적으로 삭제 되는지? o
DELETE dept_test
WHERE deptno=1;   
--2.자식 테이블에 데이터가 삭제 되었는지? o
SELECT *
FROM emp_test;


--fk제약 ON DELETE SET NULL
DROP TABLE emp_test;

CREATE TABLE emp_test(
    empno NUMBER(4) primary key,
    ename VARCHAR2(10),
    deptno NUMBER(2), 
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);
SELECT *
FROM dept_test;

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

--fk제약 default옵션시에는 부모테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는 데이터가 없어야 정상적으로 삭제가 가능했음
--ON DELETE SET NULL의 경우 부모 테이블 삭제시 참조하는 자식 테이블의 데이터의 참조 컬럼을 NULL로 변경한다.
--1.삭제 쿼리가 정상적으로 삭제 되는지? o
DELETE dept_test
WHERE deptno=1;   
--2.자식 테이블에 데이터가 NULL로 변경되었는지? o
SELECT *
FROM emp_test;

--CHECK 제약: 컬럼의 값을 정해진 범위, 혹은 값만 들어오게끔 제약
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK(sal >= 0) 
);

--sal 컬럼은 CHECK제약 조건에 의해 0이거나 , 0보다 큰값만 입력이 가능하다.
INSERT INTO emp_test VALUES(9999,'brown',10000);
INSERT INTO emp_test VALUES(9999,'sally',-10000);

--
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01-정직원, 02-인턴
    emp_gb VARCHAR2(2) CHECK (emp_gb in ('01','02'))
);

INSERT INTO emp_test VALUES(9999,'brown','01');
--emp_gb컬럼 체크제약에 의해 01,02가 아닌 값은 입력될 수 없다.
INSERT INTO emp_test VALUES(9998,'sally','03');


--SELECT 결과를 이용한 TABLE 생성
--Create Talbe 테이블명 AS
--SELECT 쿼리
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

--CUSTOMER 테이블을 사용하여 CUSTOMER_TEST 테이블로 생성
--CUSTOMER 테이블의 데이터도 같이 복제, primary key와 foreign key, check조건 복제 안됨. 순수하게 데이터만 복제가능
CREATE TABLE CUSTOMER_test AS
SELECT *
FROM CUSTOMER;

SELECT *
FROM CUSTOMER_test;

create table test AS
SELECT sysdate dt
from dual;

SELECT *
from test;

DROP TABLE test;

--데이터는 복제하지 않고 특정 테이블의 컬럼 형식만 가져올순 없을까?
DROP TABLE customer_test;

CREATE TABLE CUSTOMER_test AS
SELECT *
FROM CUSTOMER
WHERE 1=2;          --절대 참일수없는 조건을 넣음. 데이터없이 틀만 만들어짐
--    1!=1;

---------------------------------------------------------------------
--테이블 변경
--새로운 컬럼 추가
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10)
);

--신규 컬럼 추가
ALTER TABLE emp_test ADD (deptno NUMBER(2));
desc emp_test;

--기존 컬럼 변경
ALTER TABLE EMP_TEST MODIFY (ename VARCHAR2(200));
desc emp_test;

ALTER TABLE EMP_TEST MODIFY (ename NUMBER);
desc emp_Test;

--데이터가 있는 상황에서 컬럼 변경 : 제한적이다
INSERT INTO emp_test VALUES(9999,1000,10);
commit;

--데이터 타입을 변경하기 위해서는 컬럼값이 비어있어야 한다
ALTER TABLE EMP_TEST MODIFY (ename VARCHAR2(10));

--DEFAULT설정
desc emp_test;
ALTER TABLE emp_test MODIFY (deptno DEFAULT 10);

--컬럼명 변경
ALTER TABLE emp_test RENAME COLUMN deptno to dno;
desc emp_test;

--컬럼 제거(DROP)
ALTER TABLE emp_Test DROP COLUMN dno;
--ALTER TABLE emp_Test DROP (dno);  --가능
desc emp_Test;

--테이블 변경 : 제약조건 추가
--PRIMARY KEY
ALTER TABLE emp_Test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

--PRIMARY KEY제약조건 삭제
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--UNIQUE제약 -empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_Test UNIQUE (empno);

--UNIQUE제약 삭제 : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_Test;

--FOREIGN KEY 추가
--실습
--1.DEPT테이블의 DEPTNO컬럼으로 PRIMARY KEY 제약을 테이블 변경
--ddl을 통해 생성
desc dept;
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

--2.emp테이블의 empno컬럼으로 primary key 제약을 테이블 변경
--ddl을 통해 상성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

--3.emp테이블의 deptno컬럼으로 dept테이블의 deptno컬럼을 참조하는 fk제약을 테이블 변경
--ddl을 통해 생성
--emp --> dept (deptno)
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);


--실습 emp_test -> dept.deptno fk 제약 생성
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);

--CHECK 제약 추가(ename길이 체크, 길이가 3글자이상)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK ( LENGTH(ename) > 3 );
INSERT INTO emp_test VALUES(9999,'brwon',10);
--오류
INSERT INTO emp_test VALUES(9998,'br',10);
rollback;

--CHECK 제약 제거
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

--NOT NULL제약 추가
ALTER TABLE emp_test MODIFY (ename NOT NULL);

--NOT NULL 제약 제거(NULL 허용)
ALTER TABLE emp_test MODIFY (ename NULL);