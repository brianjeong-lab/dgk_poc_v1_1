view: category_buzz {
  derived_table: {
    sql: SELECT
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
        AND DATE(TA.CRAWLSTAMP) >= {% parameter prmfrom %}
        AND DATE(TA.CRAWLSTAMP) <= {% parameter prmto %})
        AND KWD.KEYWORD={% parameter prmkeyword %}
        GROUP BY 1,2,3,4,5,6,7
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

  dimension: docid {
    type: number
    sql: ${TABLE}.DOCID ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.LABEL ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }

  measure: sum_cnt {
    type: sum
    sql: COALESCE(${TABLE}.cnt, 0) ;;
  }

  set: detail {
    fields: [
      docid,
      id,
      keyword,
      label,
      s_name,
      sb_name
    ]
  }
}
