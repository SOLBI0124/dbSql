--제약조건 활성화/비활성화
--어떤 제약조건을 활성화(비활성화) 시킬 대상??

--emp fk제약(dept테이블의 deptno컬럼참조)
--FK_EMP_DEPT 비활성화
ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

--제약조건에 위배되는 데이터가 들어 갈 수 있지 않을까?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

--FK_EMP_DEPT 비활성화
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;          --안됨

--제약조건에 위배되는 데이터 (소속 부서번호가 80번인 데이터)가 존재하여 제약조건 활성화 불가
--해당 데이터 삭제해야함
DELETE emp
WHERE empno = 9999;
--FK_EMP_DEPT 비활성화
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;          --가능

--현재 계정에 존재하는 테이블 목록 view : USER_TABLES
--현재 계정에 존재하는 제약조건 view : USER_CONSTRAINS 
--현재 계정에 존재하는 제약조건의 컬럼 view : USER_CONS_COLUMNS
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_name = 'EMP';

--FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

--테이블에 설정된 제약조건 조회(VIEW조인)
--테이블명/제약조건명/컬럼명/컬럼 포지션
SELECT a.TABLE_NAME, a.CONSTRAINT_NAME, b.COLUMN_NAME, b.POSITION
FROM user_constraints a, USER_CONS_COLUMNS b
where a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
AND a.CONSTRAINT_TYPE = 'P'        --PRIMARY KEY만 조회
ORDER BY a.table_name, b.position;

---------------------------------------------------------------------------------------------------
--emp 테이블과 8가지 컬럼 주석달기
--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

--테이블 주석 view : USER_TAB_COMMENTS
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

--emp 테이블 주석
COMMENT ON TABLE emp IS '사원';

--emp 테이블 컬럼주석
SELECT *
FROM user_col_comments
WHERE table_name='EMP';

--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '사원번호';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '관리자 사번';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '상여';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

--실습 comment1
SELECT a.table_name, a.table_type, a.comments tab_comment, column_name, b.comments col_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.table_name in('CYCLE','CUSTOMER','PRODUCT','DAILY')
AND a.table_name = b.table_name;
---------------------------------------------------------------------------------------------------

--system계정에 권한부여
GRANT CREATE VIEW TO pc20;

--VIEW 생성 (emp테이블에서 sal, comm두개 컬럼을 제외한다.)
CREATE OR REPLACE VIEW v_emp as
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno 
      FROM emp);
      
--VIEW (위 인라인뷰와 동일하다)
SELECT *
FROM v_emp;

--조인된 쿼리 결과를 view로 생성 : V_emp_dept
--emp, dept : 부서명, 사원번호, 사원명, 담당업무, 입사일자

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

--VIEW 제거
DROP VIEW v_emp;

--VIEW를 구성하는 테이블의 데이터를 변경하면 VIEW에도 변경됨
--dept 30 -SALES
SELECT *
FROM dept;

--dept테이블의 SALES --> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
--UPDATE dept SET dname = 'SALES'       --원래대로
WHERE deptno = 30;

--HR 계정에게 V_emp_dept view 조회권한을 준다
GRANT SELECT ON v_emp_dept TO hr;

---------------------------------------------------------------------------------------------------
--SEQUENCE 생성 (게시글 번호 부여용 시퀀스)
CREATE SEQUENCE seq_post
INCREMENT BY 1              --1씩증가
START WITH 1;               --시작은1

--nextval : 시퀀스의 다음값 조회
--currval : 현재 시퀀스 값 조회, nextval통해 값 가져온 다음 사용 가능
SELECT seq_post.nextval, seq_post.currval
FROM dual;

SELECT seq_post.currval
FROM dual;


SELECT *
FROM post
WHERE reg_id ='brown'
AND title = '하하하하 재밌다'
AND reg_dt = TO_DATE('2019//11/14 15:40:15','YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;


--시퀀스 복습
--시퀀스 : 중복되지 않은 정수값을 리턴해주는 객체
--1,2,3....
desc emp_test;
drop table emp_test;
create table emp_test(
    empno number(4) primary key, 
    enmae varchar2(15)
);
--시퀀스생성
CREATE SEQUENCE seq_emp_test;

                              --중복되지 않는 값
INSERT INTO emp_test values( seq_emp_test.nextval, 'brown');

SELECT seq_emp_test.nextval
FROM dual;

SELECT *
FROM emp_test;

rollback;       --시퀀스는 롤백안됨
---------------------------------------------------------------------------------------------------
--index 중요~!
--ROWID : 테이블 행의 물리적 주소, 해당 주소를 알면 빠르게 테이블에 접근하는 것이 가능하다
SELECT product.*, ROWID
FROM product;

--table : pid, pnm
--pk_product :pid
SELECT pid 
FROM product;

--실행계획을 통한 인덱스 사용여부 확인;
--emp 테이블에 empno컬럼을 기준으로 인덱스가 없을때
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--실행계획보기
EXPLAIN PLAN FOR  
SELECT *
FROM emp
WHERE empno = 7369;

--인덱스가 없기때문에 empno=7369인 데이터를 찾기 위해
--emp테이블을 전체를 찾아봐야한다 => TABLE FULL SCAN
SELECT *
FROM TABLE(dbms_xplan.display);

--실행계획읽는순서:위에서 아래로. 자식테이블있으면 자식먼저 1->0