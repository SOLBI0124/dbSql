-- SELECT : ��ȸ�� �÷� ���
--      ��ü �÷� ��ȸ  : *
--      �Ϻ� �÷�      : �ش� �÷��� ����
-- FROM : ��ȸ�� ���̺� ���

--��� �÷��� ��ȸ
SELECT * FROM prod;

    -- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
    -- �� keyword�� �ٿ��� �ۼ�
SELECT * 
FROM prod;

--Ư�� �÷��� ��ȸ 
SELECT prod_id, prod_name       --prod �÷� �� prod_id, prod_name�� ������
FROM prod;

--1) lprod ���̺��� ��� �����͸� ��ȸ�ϴ� ���� �ۼ�
SELECT * FROM lprod;

--2) buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ���� �ۼ�
SELECT buyer_id, buyer_name 
From buyer;

--3) cart���̺��� ��� �����͸� ��ȸ�ϴ� ����
SELECT * FROM cart;

--4) member ���̺��� mem_id, mem_pass, mem_name�÷��� ��ȸ�ϴ� ����
SELECT mem_id, mem_pass, mem_name 
FROM member;



--������ / ��¥����
--date type + ���� : ���ڸ� ���Ѵ�
--null�� ������ ������ ����� �׻� null�̴�
SELECT userid, usernm, reg_dt, 
    reg_dt + 5 reg_dt_after5,       -- reg_dt + 5�� �÷��� reg_dt_after5�� �ٲ�(as(column alias) �ᵵ�ǰ� �Ƚᵵ ��)
    reg_dt - 5 as reg_dt_before5
FROM users;


--�ǽ�1) prod���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ����
--      (��, prod_id -> id, prod_name->name���� �÷� ��Ī ����)
SELECT prod_id as id, prod_name as name
FROM prod;

--2) lprod���̺��� lprod_gu(gu�� ��Ī), lprod_nm(nm���� ��Ī) �� �÷� ��ȸ ����
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--3) buyer ���̺��� byer_id(���̾���̵�� ��Ī), buyer_name(�̸����� ��Ī) �� �÷� ��ȸ ����
SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;


-- ���ڿ� ����
-- java + -> sql ||
-- CONCAT(str, str) �Լ�
-- users���̺��� userid, usrnm ���� (�����Ϳ��� ����X. ��ȸ�Ҷ��� ���յ�)

SELECT userid, usernm, 
    userid || usernm,
    CONCAT(userid, usernm)
FROM users;

--���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        concat('����� ���̵� : ', userid)
FROM users;

--�ǽ� sel_con1
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY
FROM user_tables;


--desc table
--���̺� ���ǵ� �÷��� �˰� ������
--1.desc
--2.select  * ...
desc emp;

SELECT *
FROM emp;

--WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ���� �ۼ�
SELECT *
FROM users
WHERE usernm = '����';