view: big4_bank_sh {
  derived_table: {
    sql: SELECT
  WORD.KEYWORD,
  SUM (WORD.score) AS scr,
  COUNT(WORD.KEYWORD) AS cnt
FROM
  `kb-daas-dev.master_200729.keyword_bank_result` TB,
  UNNEST(KPE) WORD
WHERE
  TB.ID IN (
  SELECT
    TA.ID
  FROM
    `kb-daas-dev.master_200729.keyword_bank_result` TA,
    UNNEST(KPE) KWD
  WHERE
    TA.ID IN (
    SELECT
      A.ID
    FROM
      `kb-daas-dev.master_200729.keyword_bank_result` A
    WHERE
      DATE(A.CRAWLSTAMP) >= {% parameter prmfrom %}
      AND DATE(A.CRAWLSTAMP) <= {% parameter prmto %}
      AND EXISTS (
      SELECT
        *
      FROM
        UNNEST(A.KPE)
      WHERE
        keyword = {% parameter prmkeyword %}))
    AND KWD.KEYWORD IN ('신한은행','SINHANBANK','신한')
    AND DATE(TA.CRAWLSTAMP) >= {% parameter prmfrom %}
    AND DATE(TA.CRAWLSTAMP) <= {% parameter prmto %})
  AND WORD.KEYWORD NOT IN ({% parameter prmkeyword %},
    '신한은행' )
GROUP BY
  1
ORDER BY
  SUM(WORD.score) DESC
LIMIT
  20
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

  measure: sum_cnt {
    type: sum
    sql: COALESCE(${TABLE}.cnt, 0) ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: write_day {
    type: number
    sql: ${TABLE}.WRITE_DAY ;;
  }

  dimension: mydate {
    type: date
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', FORMAT('%08d',${TABLE}.WRITE_DAY)));;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.cnt ;;
  }

  set: detail {
    fields: [keyword, cnt]
  }
}
