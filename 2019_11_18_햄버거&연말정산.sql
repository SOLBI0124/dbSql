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

--------------------------------------------------------------------------
SELECT rownum, c.*
FROM
(SELECT a.sido, a.sigungu, ROUND(b.cnt/a.cnt,2) point
FROM
    (SELECT sido, sigungu, count(*) cnt
    FROM fastfood
    WHERE gb='롯데리아'
    GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                 FROM fastfood
                                 WHERE gb in('버거킹','맥도날드','KFC')
                                 GROUP BY sido, sigungu) b
WHERE a.sido=b.sido AND a.sigungu = b.sigungu
ORDER BY point desc)c;

--------------------------------------------------------------------------
SELECT rownum, d.*
FROM
(SELECT sido, sigungu, sal
FROM tax
ORDER BY sal desc) d;

--버거지수 시도, 시군구 | 연말정산 시도 시군구
--시도, 시군구, 버거지수, 시도, 시군구, 연말정산 납입액
--서울시 중구 5.7 경기도 수원시 18623591
SELECT e.*, f.*
FROM 
    (SELECT rownum r, c.*
    FROM
        (SELECT a.sido, a.sigungu, ROUND(b.cnt/a.cnt,2) point
        FROM
            (SELECT sido, sigungu, count(*) cnt
            FROM fastfood
            WHERE gb='롯데리아'
            GROUP BY sido, sigungu) a, (SELECT sido, sigungu, count(*) cnt
                                         FROM fastfood
                                         WHERE gb in('버거킹','맥도날드','KFC')
                                         GROUP BY sido, sigungu) b
      WHERE a.sido=b.sido AND a.sigungu = b.sigungu
      ORDER BY point desc) c) e, (SELECT rownum r, d.*
                                  FROM
                                    (SELECT sido, sigungu, sal
                                     FROM tax
                                     ORDER BY sal desc) d) f
WHERE e.r(+)=f.r;

--------------------------------------------------------------------------