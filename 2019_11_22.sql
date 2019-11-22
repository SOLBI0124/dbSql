--실습h_2
SELECT level lv, deptcd, LPAD(' ', 4*(level-1),' ') || deptnm as deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
--CONNECT BY p_deptcd = PRIOR deptcd;   --가능
----------------------------------------------------------------------------
--상향식 계층쿼리
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색 아님)
--디자인팀을 시작으로 상위 부서를 조회
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;     --내가 읽은 p_deptcd를 deptcd로 하는 조직

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;
commit;

--실습h_4
SELECT LPAD(' ', 4*(level-1),' ') || s_id s_id, value
FROM H_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
----------------------------------------------------------------------------
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);
commit;

--실습h_5
SELECT LPAD(' ',4*(LEVEL-1),' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;
----------------------------------------------------------------------------
--pruning branch (가지치기)
--1.계층쿼리에서 **WHERE절**은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다

--dtpt_h테이블을 최상위 노드부터 하향식으로 조회
--계층쿼리가 완성된 이후 WHERE절이 적용됨
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--2. 
--정보기획부 밑에있는 하위부서들도 제외됨
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '정보기획부';

--CONNECT_BY_ROOT : col의 최상위 데이터 컬럼 값
--SYS_CONNECT_BY_PATH(col,구분자) : 컬럼의 계층구조 순서를 구분자로 이은 경로
--      . LTRIM을 통해서 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
--CONNECT_BY_ISLEAF : 해당 row가 마지막leaf node인지 (1:leaf노드, 0:leaf노드 아님)
SELECT LPAD(' ',4*(LEVEL-1),' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

----------------------------------------------------------------------------
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;


SELECT *
FROM board_test;
--실습 h6
SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq=parent_seq;

--실습 h7,h8
SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq=parent_seq
ORDER SIBLINGS BY seq desc;             --계층구조가 유지된 상태에서 정렬

--실습 h9
--1)
SELECT seq, LPAD(' ', 4*(level-1),' ') || title title, 
        CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
        CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq=parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END desc,
                  seq;
--2)
SELECT *
FROM
    (SELECT seq, LPAD(' ', 4*(level-1),' ') || title title,
            CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq is null
    CONNECT BY PRIOR seq=parent_seq)
ORDER BY r_seq desc, seq;

--3)
--글 그룹번호 추가
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_Test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq;
----------------------------------------------------------------------------
--분석함수/window함수 outer조인

SELECT a.ename, a.sal, b.sal l_sal, a.rn, b.rn
FROM
    (SELECT ename, sal, rownum rn
    FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal desc)) a,  (SELECT ename, sal, rownum rn
                                 FROM
                                    (SELECT ename, sal
                                    FROM emp
                                    ORDER BY sal desc)) b
WHERE a.rn+1 = b.rn(+);






