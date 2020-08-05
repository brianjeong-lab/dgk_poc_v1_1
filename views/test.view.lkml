view: test {
  derived_table: {
    sql: SELECT LABEL,SUM(CNT) AS SUM_CNT,CRAWLSTAMP AS DATE FROM (SELECT
        A.DOCID,
        B.ID,
        KWD.keyword,
        CAT.LABEL,
        A.S_NAME,
        A.SB_NAME,
        A.CRAWLSTAMP,
        count(CAT.LABEL)as cnt
      FROM
        `kb-daas-dev.master_200729.keyword_bank_result`A,
        UNNEST(KPE) KWD,
        UNNEST(D2C) CAT,
        `kb-daas-dev.master_200729.keyword_bank`B
      WHERE
        A.DOCID=B.DOCID
        AND DATE(A.CRAWLSTAMP) >= '2020-06-01'
        AND DATE(A.CRAWLSTAMP) <= '2020-06-30'
        AND KWD.KEYWORD='서비스'
        group by 1,2,3,4,5,6,7) AS CATAGORY
        group by 1,3
        ORDER BY 2 DESC
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: label {
    type: string
    sql: ${TABLE}.LABEL ;;
  }

  dimension: sum_cnt {
    type: number
    sql: ${TABLE}.SUM_CNT ;;
  }

  dimension_group: date {
    type: time
    sql: ${TABLE}.DATE ;;
  }

  set: detail {
    fields: [label, sum_cnt, date_time]
  }
}
