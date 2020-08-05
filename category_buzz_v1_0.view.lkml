view: category_buzz_v1_0 {
  derived_table: {
    sql: WITH category_buzz AS (SELECT
        A.DOCID,
        B.ID,
        KWD.keyword,
        CAT.LABEL,
        A.S_NAME,
        A.SB_NAME,
        A.CRAWLSTAMP
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
       )
SELECT
  category_buzz.LABEL  AS category_buzz_label,
  COUNT(*) AS category_buzz_count
FROM category_buzz

GROUP BY 1
HAVING
  (COUNT(*) > 500)
ORDER BY 1 DESC
LIMIT 50
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category_buzz_label {
    type: string
    sql: ${TABLE}.category_buzz_label ;;
  }

  dimension: category_buzz_count {
    type: number
    sql: ${TABLE}.category_buzz_count ;;
  }

  set: detail {
    fields: [category_buzz_label, category_buzz_count]
  }
}
