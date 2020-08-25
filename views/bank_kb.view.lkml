view: bank_kb {
  derived_table: {
    sql: SELECT  (CASE WHEN TK.keyword = "KBALBERT" THEN "KB알버트" ELSE TK.keyword END) as keyword,
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
      AND EXISTS (SELECT * FROM UNNEST (A.KPE ) WHERE KEYWORD IN ('국민은행','KBBANK','KB국민은행','KB은행') )
      AND A.D2C[SAFE_OFFSET(0)].label != '야구'
      AND A.docid not in (SELECT docid from `kb-daas-dev.mart_200729.keyword_bank_result_agg_remove_docid`)
     )
AND TK.KEYWORD NOT IN ({% parameter prmkeyword %},'국민은행','KBBANK','KB국민은행','KB은행','하나은행','HANABANK')
AND TK.KEYWORD NOT in (SELECT keyword from `kb-daas-dev.mart_200729.filter`)
GROUP BY KEYWORD
ORDER BY SCR DESC
LIMIT 15
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
