view: bank_wo {
  derived_table: {
    sql: SELECT
        WORD.KEYWORD,
        SUM (WORD.score) AS scr,
        COUNT(WORD.KEYWORD) AS CNT
      FROM
        `kb-daas-dev.master_200729.keyword_bank_result` TB,
        UNNEST(KPE) WORD
      WHERE
        TB.DOCID IN (
        SELECT
          TA.DOCID
        FROM
          `kb-daas-dev.master_200729.keyword_bank_result` TA,
          UNNEST(KPE) KWD
        WHERE
          TA.DOCID IN (
          SELECT
            A.DOCID
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
          AND KWD.KEYWORD IN ('우리은행','WOORIBANK')
          AND DATE(TA.CRAWLSTAMP) >= {% parameter prmfrom %}
          AND DATE(TA.CRAWLSTAMP) <= {% parameter prmto %})
        AND WORD.KEYWORD NOT IN ({% parameter prmkeyword %},
          '우리은행','WOORIBANK' )
        AND DATE(TB.CRAWLSTAMP) >= {% parameter prmfrom %}
        AND DATE(TB.CRAWLSTAMP) <= {% parameter prmto %}
      GROUP BY
        1
      ORDER BY
        SUM(WORD.score) DESC
      LIMIT
        10
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

  measure: sum_cnt {
    type: sum
    sql: COALESCE(${TABLE}.cnt, 0) ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: scr {
    type: number
    sql: ${TABLE}.scr ;;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.CNT ;;
  }

  set: detail {
    fields: [keyword, scr, cnt]
  }
}
