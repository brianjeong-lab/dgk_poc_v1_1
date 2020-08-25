view: category_buzz {
  derived_table: {
    sql: SELECT
        A.CHANNEL,
        CAT.LABEL,
        A.SB_NAME,
        A.S_NAME


FROM
`kb-daas-dev.master_200729.keyword_bank_result`A,
UNNEST(D2C) CAT
WHERE EXISTS (SELECT * FROM UNNEST (A.KPE) WHERE KEYWORD = {% parameter prmkeyword %} )
AND DATE(A.CRAWLSTAMP) >= {% parameter prmfrom %}
AND DATE(A.CRAWLSTAMP) <= {% parameter prmto %}
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

  dimension: CHANNEL {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  measure: sum_cnt {
    type: sum
    sql: COALESCE(${TABLE}.cnt, 0) ;;
  }

  set: detail {
    fields: [
      CHANNEL,
      label,
      sb_name,
      s_name,
      count
    ]
  }
}
