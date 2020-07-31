view: keyword_relation_lv1 {
  derived_table: {
    sql: SELECT  '신혼부부'   AS LV1
          ,   TB.keyword AS LV2
          ,   SUM(TB.score) AS score
      FROM    `kb-daas-dev.master_200723.keyword_bank_result` TA, UNNEST(TA.KPE) AS TB
      WHERE   TA.ID IN (
                  SELECT  A.ID
                  FROM    `kb-daas-dev.master_200723.keyword_bank_result` A
                  WHERE   DATE(A.CRAWLSTAMP) >= '2020-06-01'
                  AND     DATE(A.CRAWLSTAMP) <= '2020-06-30'
                  AND     EXISTS (
                              SELECT  *
                              FROM    UNNEST(A.KPE)
                              WHERE   keyword = '신혼부부'
                          )
              )
      AND     DATE(TA.CRAWLSTAMP) >= '2020-06-01'
      AND     DATE(TA.CRAWLSTAMP) <= '2020-06-30'
      GROUP BY TB.keyword
      ORDER BY 2 DESC, 1
      LIMIT   100
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: lv1 {
    type: string
    sql: ${TABLE}.LV1 ;;
  }

  dimension: lv2 {
    type: string
    sql: ${TABLE}.LV2 ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  set: detail {
    fields: [lv1, lv2, score]
  }
}
