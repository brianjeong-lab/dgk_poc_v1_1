view: keyword_relation_lv2_hist2 {
  derived_table: {
    sql:
          SELECT
            DATE(AAA.WRITESTAMP) as day
            , AAB.keyword as keyword
            , AAB.score
          FROM
            `kb-daas-dev.master_200729.keyword_bank_result` AAA,
            UNNEST(AAA.KPE) AS AAB,
            (
              SELECT
                TB.keyword AS LV1_keyword,
                SUM(TB.score) AS LV1_scr,
                COUNT(TB.keyword) AS LV1_cnt
              FROM
                `kb-daas-dev.master_200729.keyword_bank_result` TA,
                UNNEST(TA.KPE) AS TB
              WHERE
                TA.DOCID IN (
                  SELECT
                    A.DOCID
                  FROM
                    `kb-daas-dev.master_200729.keyword_bank_result` A,
                    UNNEST(A.KPE) K
                  WHERE
                    A.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                        AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                    AND DATE(A.WRITESTAMP) >= {% parameter prmfrom %}
                    AND DATE(A.WRITESTAMP) <= {% parameter prmto %}
                    AND K.keyword = {% parameter prmkeyword %}
                )
                AND TA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                    AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                AND DATE(TA.WRITESTAMP) >= {% parameter prmfrom %}
                AND DATE(TA.WRITESTAMP) <= {% parameter prmto %}
                AND TB.keyword != {% parameter prmkeyword %}
                AND LENGTH(TB.keyword) < 10
              GROUP BY
                TB.keyword
              ORDER BY
                SUM(TB.score) DESC,
                TB.keyword
              LIMIT
                10
            ) BBB
          WHERE
            AAB.keyword = BBB.LV1_keyword
            AND AAA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
            AND DATE(AAA.WRITESTAMP) >= {% parameter prmfrom %}
            AND DATE(AAA.WRITESTAMP) <= {% parameter prmto %}
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

  dimension: day {
    type: date
    sql: ${TABLE}.day  ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  measure: score {
    type: number
    sql: sum(ceil(${TABLE}.score)) ;;
  }

  set: detail {
    fields: [day, keyword, score]
  }
}