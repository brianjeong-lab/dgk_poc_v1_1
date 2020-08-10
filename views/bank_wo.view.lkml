view: bank_wo {
  derived_table: {
    sql:  SELECT  TK.KEYWORD,
        SUM (TK.score) AS SCR,
        COUNT(TK.KEYWORD) AS CNT
FROM `kb-daas-dev.master_200729.keyword_bank_result` B ,  UNNEST (KPE) TK WHERE
DATE (B.CRAWLSTAMP ) >= {% parameter prmfrom %}
AND DATE (B.CRAWLSTAMP ) <= {% parameter prmto %}
AND B.DOCID IN (
  SELECT A.DOCID
    FROM `kb-daas-dev.master_200729.keyword_bank_result` A
    WHERE DATE (A.CRAWLSTAMP ) >= {% parameter prmfrom %}
      AND DATE (A.CRAWLSTAMP ) <= {% parameter prmto %}
      AND EXISTS (SELECT * FROM UNNEST (A.KPE ) WHERE KEYWORD = {% parameter prmkeyword %} )
      AND EXISTS (SELECT * FROM UNNEST (A.KPE ) WHERE KEYWORD IN ('우리은행','WOORIBANK') )
     )
AND TK.KEYWORD NOT IN ({% parameter prmkeyword %},'우리은행','WOORIBANK')
GROUP BY TK.KEYWORD
ORDER BY SCR DESC
LIMIT 10
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
