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

--------------------------------------------------------------------------
SELECT rownum, c.*
FROM
(SELECT a.sido, a.sigungu, ROUND(b.cnt/a.cnt,2) point
FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb='�Ե�����'
    GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                 FROM fastfood
                                 WHERE gb in('����ŷ','�Ƶ�����','KFC')
                                 GROUP BY sido, sigungu) b
WHERE a.sido=b.sido AND a.sigungu = b.sigungu
ORDER BY point desc)c;

--------------------------------------------------------------------------
SELECT rownum, d.*
FROM
(SELECT sido, sigungu, sal
FROM tax
ORDER BY sal desc) d;

--�������� �õ�, �ñ��� | �������� �õ� �ñ���
--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
--����� �߱� 5.7 ��⵵ ������ 18623591
SELECT e.*, f.*
FROM 
    (SELECT rownum r, c.*
    FROM
        (SELECT a.sido, a.sigungu, ROUND(b.cnt/a.cnt,2) point
        FROM
            (SELECT sido, sigungu, count(*) cnt
            FROM fastfood
            WHERE gb='�Ե�����'
            GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                         FROM fastfood
                                         WHERE gb in('����ŷ','�Ƶ�����','KFC')
                                         GROUP BY sido, sigungu) b
      WHERE a.sido=b.sido AND a.sigungu = b.sigungu
      ORDER BY point desc) c) e, (SELECT rownum r, d.*
                                  FROM
                                    (SELECT sido, sigungu, sal
                                     FROM tax
                                     ORDER BY sal desc) d) f
WHERE e.r(+)=f.r;

--------------------------------------------------------------------------