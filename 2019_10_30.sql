-- SELECT : 조회할 컬럼 명시
--      전체 컬럼 조회  : *
--      일부 컬럼      : 해당 컬럼명 나열
-- FROM : 조회할 테이블 명시

--모든 컬럼을 조회
SELECT * FROM prod;

    -- 쿼리를 여러줄에 나누어서 작성해도 상관 없다.
    -- 단 keyword는 붙여서 작성
SELECT * 
FROM prod;

--특정 컬럼만 조회 
SELECT prod_id, prod_name       --prod 컬럼 중 prod_id, prod_name만 가져옴
FROM prod;

--1) lprod 테이블에서 모든 데이터를 조회하는 쿼리 작성
SELECT * FROM lprod;

--2) buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리 작성
SELECT buyer_id, buyer_name 
From buyer;

--3) cart테이블에서 모든 데이터를 조회하는 쿼리
SELECT * FROM cart;

--4) member 테이블에서 mem_id, mem_pass, mem_name컬럼만 조회하는 쿼리
SELECT mem_id, mem_pass, mem_name 
FROM member;



--연산자 / 날짜연산
--date type + 정수 : 일자를 더한다
--null을 포함한 연산의 결과는 항상 null이다
SELECT userid, usernm, reg_dt, 
    reg_dt + 5 reg_dt_after5,       -- reg_dt + 5의 컬럼명 reg_dt_after5로 바꿈(as(column alias) 써도되고 안써도 됨)
    reg_dt - 5 as reg_dt_before5
FROM users;


--실습1) prod테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리
--      (단, prod_id -> id, prod_name->name으로 컬럼 별칭 지정)
SELECT prod_id as id, prod_name as name
FROM prod;

--2) lprod테이블에서 lprod_gu(gu로 별칭), lprod_nm(nm으로 별칭) 두 컬럼 조회 쿼리
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--3) buyer 테이블에서 byer_id(바이어아이디로 별칭), buyer_name(이름으로 별칭) 두 컬럼 조회 쿼리
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


-- 문자열 결합
-- java + -> sql ||
-- CONCAT(str, str) 함수
-- users테이블의 userid, usrnm 결합 (데이터에는 영향X. 조회할때만 결합됨)

SELECT userid, usernm, 
    userid || usernm,
    CONCAT(userid, usernm)
FROM users;

--문자열 상수 (컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' || userid,
        concat('사용자 아이디 : ', userid)
FROM users;

--실습 sel_con1
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY
FROM user_tables;


--desc table
--테이블에 정의된 컬럼을 알고 싶을때
--1.desc
--2.select  * ...
desc emp;

SELECT *
FROM emp;

--WHERE절, 조건 연산자
SELECT *
FROM users
WHERE userid = 'brown';

--usernm이 샐리인 데이터를 조회하는 쿼리 작성
SELECT *
FROM users
WHERE usernm = '샐리';