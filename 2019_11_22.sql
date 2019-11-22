--�ǽ�h_2
SELECT level lv, deptcd, LPAD(' ', 4*(level-1),' ') || deptnm as deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
--CONNECT BY p_deptcd = PRIOR deptcd;   --����
----------------------------------------------------------------------------
--����� ��������
--Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž�� �ƴ�)
--���������� �������� ���� �μ��� ��ȸ
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;     --���� ���� p_deptcd�� deptcd�� �ϴ� ����

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

--�ǽ�h_4
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
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);
commit;

--�ǽ�h_5
SELECT LPAD(' ',4*(LEVEL-1),' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;
----------------------------------------------------------------------------
--pruning branch (����ġ��)
--1.������������ **WHERE��**�� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�

--dtpt_h���̺��� �ֻ��� ������ ��������� ��ȸ
--���������� �ϼ��� ���� WHERE���� �����
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--2. 
--������ȹ�� �ؿ��ִ� �����μ��鵵 ���ܵ�
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '������ȹ��';

--CONNECT_BY_ROOT : col�� �ֻ��� ������ �÷� ��
--SYS_CONNECT_BY_PATH(col,������) : �÷��� �������� ������ �����ڷ� ���� ���
--      . LTRIM�� ���ؼ� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���
--CONNECT_BY_ISLEAF : �ش� row�� ������leaf node���� (1:leaf���, 0:leaf��� �ƴ�)
SELECT LPAD(' ',4*(LEVEL-1),' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

----------------------------------------------------------------------------
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;


SELECT *
FROM board_test;
--�ǽ� h6
SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq=parent_seq;

--�ǽ� h7,h8
SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq=parent_seq
ORDER SIBLINGS BY seq desc;             --���������� ������ ���¿��� ����

--�ǽ� h9
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
--�� �׷��ȣ �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 4*(level-1),' ') || title title
FROM board_Test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn desc, seq;
----------------------------------------------------------------------------
--�м��Լ�/window�Լ� outer����

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






