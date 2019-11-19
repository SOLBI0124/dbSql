SELECT*
FROM user_views;

SELECT *
FROM ALL_views
WHERE OWNER = 'PC20';

SELECT *
FROM PC20.V_EMP_DEPT;

--pc20계정에서 조회권한을 받은 V_EMP_DEPT view를 hr계정에서 조회하기 위해서는
--계정명.view이름 형식으로 기술해야한다
--매번 계정명을 기술하기 귀찮으므로 시노님을 통해 다른 별칭을 생성

--Synonym V_EMP_DEPT이(가) 생성
CREATE SYNONYM V_EMP_DEPT FOR PC20.V_EMP_DEPT;

--PC20.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

--시소님 삭제
DROP TABLE 테이블명;

DROP SYNONYM 시노님명;
 
--hr 계정 비밀번호 : java
--hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER PC20 IDENTIFIED BY java; --본인 계정이 아니라 에러

--dictionary
--접두어 : USER : 사용자 소유 객체
--         ALL : 사용자가 사용가능한 객체
--         DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
--          V$ : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC20','HR');

--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨
--다음 sql들은 같은결과를 만들어 낼지 몰라도 DBMS에서는 서로 다른 SQL로 인식된다.
--pc20계정
SELECT /*bind_test*/ * FROM emp;
Select * FROM emp;
Select *  FROM emp;

SELECT /*bind_test*/ * FROM emp WHERE emp=:empno;

--system계정
SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%';

--------------------------------------------------------------------------
SELECT *
FROM fastfood;

--한도시의 발전수준 : (버거킹 + 맥도날드 + KFC) / 롯데리아
--시도, 시군구별 매장수 (버거킹, 맥도날드, KFC) : 
--시도, 시군구별 매장수 (롯데리아) : 
SELECT sido || sigungu sidogungu, count(*) cnt
FROM fastfood
WHERE gb='롯데리아'
GROUP BY sido, sigungu;

SELECT id, sido, sigungu,gb
FROM fastfood;

SELECT sido || sigungu sidogungu, count(*) cnt
FROM fastfood
WHERE gb in('버거킹','맥도날드','KFC')
GROUP BY sido, sigungu;


SELECT a.sido, a.sigungu, b.cnt bmk, a.cnt l, ROUND(b.cnt/a.cnt,2) rank
FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb='롯데리아'
    GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                 FROM fastfood
                                 WHERE gb in('버거킹','맥도날드','KFC')
                                 GROUP BY sido, sigungu) b
WHERE a.sido=b.sido AND a.sigungu = b.sigungu
ORDER BY rank desc;

