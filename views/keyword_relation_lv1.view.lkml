view: keyword_relation_lv1 {
  derived_table: {
    sql: SELECT  {% parameter prmkeyword %}   AS LV1
            ,   TB.keyword AS LV2
            ,   TB.keyword
            ,   SUM(TB.score)     AS scr
            ,   COUNT(TB.keyword) AS cnt
            ,   TB.keyword || ' (' || ROUND(SUM(TB.score)) || ')' AS label
        FROM    `kb-daas-dev.master_200723.keyword_bank_result` TA, UNNEST(TA.KPE) AS TB
        WHERE   TA.ID IN (
                    SELECT  A.ID
                    FROM    `kb-daas-dev.master_200723.keyword_bank_result` A
                    WHERE   DATE(A.CRAWLSTAMP) >= {% parameter prmfrom %}
                    AND     DATE(A.CRAWLSTAMP) <= {% parameter prmto %}
                    AND     EXISTS (
                                SELECT  *
                                FROM    UNNEST(A.KPE)
                                WHERE   keyword = {% parameter prmkeyword %}
                            )
                )
        AND     DATE(TA.CRAWLSTAMP) >= {% parameter prmfrom %}
        AND     DATE(TA.CRAWLSTAMP) <= {% parameter prmto %}
        GROUP BY TB.keyword
        ORDER BY SUM(TB.score) DESC, TB.keyword
        LIMIT   100
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

  measure: sum {
    type: number
    sql:  SUM(${TABLE}.scr) ;;
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
