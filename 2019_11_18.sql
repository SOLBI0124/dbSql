SELECT*
FROM user_views;

SELECT *
FROM ALL_views
WHERE OWNER = 'PC20';

SELECT *
FROM PC20.V_EMP_DEPT;

--pc20�������� ��ȸ������ ���� V_EMP_DEPT view�� hr�������� ��ȸ�ϱ� ���ؼ���
--������.view�̸� �������� ����ؾ��Ѵ�
--�Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

--Synonym V_EMP_DEPT��(��) ����
CREATE SYNONYM V_EMP_DEPT FOR PC20.V_EMP_DEPT;

--PC20.V_EMP_DEPT --> V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

--�üҴ� ����
DROP TABLE ���̺��;

DROP SYNONYM �ó�Ը�;
 
--hr ���� ��й�ȣ : java
--hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER PC20 IDENTIFIED BY java; --���� ������ �ƴ϶� ����

--dictionary
--���ξ� : USER : ����� ���� ��ü
--         ALL : ����ڰ� ��밡���� ��ü
--         DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--          V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC20','HR');

--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� sql���� ��������� ����� ���� ���� DBMS������ ���� �ٸ� SQL�� �νĵȴ�.
--pc20����
SELECT /*bind_test*/ * FROM emp;
Select * FROM emp;
Select *  FROM emp;

SELECT /*bind_test*/ * FROM emp WHERE emp=:empno;

--system����
SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%';

--------------------------------------------------------------------------
SELECT *
FROM fastfood;

--�ѵ����� �������� : (����ŷ + �Ƶ����� + KFC) / �Ե�����
--�õ�, �ñ����� ����� (����ŷ, �Ƶ�����, KFC) : 
--�õ�, �ñ����� ����� (�Ե�����) : 
SELECT sido || sigungu sidogungu, count(*) cnt
FROM fastfood
WHERE gb='�Ե�����'
GROUP BY sido, sigungu;

SELECT id, sido, sigungu,gb
FROM fastfood;

SELECT sido || sigungu sidogungu, count(*) cnt
FROM fastfood
WHERE gb in('����ŷ','�Ƶ�����','KFC')
GROUP BY sido, sigungu;


SELECT a.sido, a.sigungu, b.cnt bmk, a.cnt l, ROUND(b.cnt/a.cnt,2) rank
FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb='�Ե�����'
    GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                 FROM fastfood
                                 WHERE gb in('����ŷ','�Ƶ�����','KFC')
                                 GROUP BY sido, sigungu) b
WHERE a.sido=b.sido AND a.sigungu = b.sigungu
ORDER BY rank desc;

