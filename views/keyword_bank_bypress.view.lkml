include: "/views/keyword_bank_result.view"

view: keyword_bank_bypress {
  derived_table: {
    sql: WITH VW_KB_BANK_SUMM AS (
      SELECT  CASE
                  WHEN  keywordBankResult.S_NAME IN ('네이트', '네이버뉴스', '미디어다음', '뉴스줌')
                  THEN  REGEXP_REPLACE(keywordBankResult.SB_NAME, '[a-z]', '')
                  ELSE  keywordBankResult.S_NAME
              END                                   AS GRP_CAT
            , DATE(CRAWLSTAMP)                      AS CRL_DAT
            , COUNT(*)                              AS GRP_CNT
      FROM    `kb-daas-dev.master_200729.keyword_bank_result` as keywordBankResult
          ,   UNNEST(keywordBankResult.KPE)                   as keywordBankResultKpe
      WHERE   DATE(CRAWLSTAMP) <= {% parameter prmto %}
      AND     DATE(CRAWLSTAMP) >= {% parameter prmfrom %}
      AND     keywordBankResult.CHANNEL     = '뉴스'
      AND     SB_NAME NOT LIKE '%스포%'
      AND     ( S_NAME NOT LIKE '%스포%'
                AND S_NAME NOT IN ('포모스', '마이데일리' ) )   -- 제외언론
      AND     keywordBankResultKpe.keyword  = {% parameter prmkeyword %}
      GROUP BY GRP_CAT, DATE(CRAWLSTAMP)
),
VW_KB_BANK_RANK AS (
      SELECT  X.GRP_CAT
          ,   SUM(X.GRP_CNT)                             AS GRP_CNT
          ,   RANK() OVER (ORDER BY SUM(X.GRP_CNT) DESC) AS RANK
      FROM    VW_KB_BANK_SUMM  X
      GROUP BY X.GRP_CAT
)

SELECT  CASE
          WHEN A.GRP_CAT IN ( SELECT X.GRP_CAT FROM VW_KB_BANK_RANK X WHERE X.RANK < 20 ) -- 15번째 부터는 '기타'항목으로 통합
          THEN A.GRP_CAT
          ELSE '기타'
        END       AS GRP_CAT
    ,   A.CRL_DAT
    ,   SUM(A.GRP_CNT) AS GRP_CNT
FROM    VW_KB_BANK_SUMM  A
GROUP BY 1, 2
ORDER BY 2, 3 DESC
;;
  }

  filter: prmkeyword {
    type: string
  }

  filter: prmfrom {
    type: string
  }

  filter: prmto {
    type: string
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: mgrp_cnt {
    type: sum
    sql: ${TABLE}.GRP_CNT;;
    drill_fields: [detail*]
  }
  dimension: grp_cat {
    type: string
    sql: ${TABLE}.GRP_CAT ;;
  }

  dimension: crl_dat {
    type: date
    sql: ${TABLE}.CRL_DAT ;;
  }

  dimension: grp_cnt {
    type: number
    sql: ${TABLE}.GRP_CNT ;;
  }

  set: detail {
    fields: [grp_cat, crl_dat, grp_cnt]
  }
}
