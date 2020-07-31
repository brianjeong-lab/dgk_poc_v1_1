view: keyword_relation_lv1 {
  derived_table: {
    sql: SELECT  {% parameter prm_keyword %}   AS LV1
            ,   TB.keyword AS LV2
            ,   TB.keyword
            ,   SUM(TB.score)     AS scr
            ,   COUNT(TB.keyword) AS cnt
            ,   TB.keyword || ' (' || ROUND(SUM(TB.score)) || ')' AS label
        FROM    `kb-daas-dev.master_200723.keyword_bank_result` TA, UNNEST(TA.KPE) AS TB
        WHERE   TA.ID IN (
                    SELECT  A.ID
                    FROM    `kb-daas-dev.master_200723.keyword_bank_result` A
                    WHERE   DATE(A.CRAWLSTAMP) >= {% parameter prm_from %}
                    AND     DATE(A.CRAWLSTAMP) <= {% parameter prm_to %}
                    AND     EXISTS (
                                SELECT  *
                                FROM    UNNEST(A.KPE)
                                WHERE   keyword = {% parameter prm_keyword %}
                            )
                )
        AND     DATE(TA.CRAWLSTAMP) >= {% parameter prm_from %}
        AND     DATE(TA.CRAWLSTAMP) <= {% parameter prm_to %}
        GROUP BY TB.keyword
        ORDER BY SUM(TB.score) DESC, TB.keyword
        LIMIT   100
       ;;
  }

  filter: prm_keyword {
    type: string
  }

  filter: prm_from {
    type: string
  }

  filter: prm_to {
    type: string
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

  dimension: scr {
    type: number
    sql: ${TABLE}.scr ;;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.cnt ;;
  }

  dimension: label {
    type:  string
    sql: ${TABLE}.label ;;
  }

  set: detail {
    fields: [lv1, lv2, scr, cnt, label]
  }
}
