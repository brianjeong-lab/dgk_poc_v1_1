view: keyword_relation_lv2_hist {
  derived_table: {
    sql:
        SELECT
          DATE(TA.WRITESTAMP) as day,
          TB.keyword AS keyword,
          TB.score * 10 AS score,
          1 as CNT
        FROM
          `kb-daas-dev.master_200729.keyword_bank_result` TA,
          UNNEST(TA.KPE) AS TB,
          (
            SELECT
              keyword
            FROM (
              SELECT
                TB.keyword AS keyword,
                SUM(TB.score) AS score
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
                    AND A.DOCID not in (SELECT docid from `kb-daas-dev.mart_200729.keyword_bank_result_agg_remove_docid`)
                )
                AND TA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                    AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                AND DATE(TA.WRITESTAMP) >= {% parameter prmfrom %}
                AND DATE(TA.WRITESTAMP) <= {% parameter prmto %}
                AND TB.keyword != {% parameter prmkeyword %}
                AND TB.keyword not in (SELECT keyword from `kb-daas-dev.mart_200729.filter`)
                AND LENGTH(TB.keyword) < 10
              GROUP BY
                keyword
              ORDER BY score DESC
              LIMIT 10
          )
        ) TC
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
              AND A.DOCID not in (SELECT docid from `kb-daas-dev.mart_200729.keyword_bank_result_agg_remove_docid`)
          )
          AND TA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
              AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
          AND DATE(TA.WRITESTAMP) >= {% parameter prmfrom %}
          AND DATE(TA.WRITESTAMP) <= {% parameter prmto %}
          AND TB.keyword != {% parameter prmkeyword %}
          AND TB.keyword not in (SELECT keyword from `kb-daas-dev.mart_200729.filter`)
          AND LENGTH(TB.keyword) < 10
          AND TB.keyword = TC.keyword
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

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.cnt ;;
  }

  measure: sum_score {
    type:  number
    sql:  ceil(sum(${TABLE}.score)) ;;
  }

  measure: sum_cnt {
    type:  number
    sql:  sum(${TABLE}.cnt) ;;
  }

  set: detail {
    fields: [day, keyword, score, cnt, sum_score, sum_cnt]
  }
}
