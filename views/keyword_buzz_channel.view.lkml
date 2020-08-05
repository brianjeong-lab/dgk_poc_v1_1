view: keyword_buzz_channel {
  derived_table: {
    sql: SELECT
        A.DOCID,
        B.ID,
        KWD.keyword,
        B.CHANNEL,
        A.S_NAME,
        A.SB_NAME,
        A.CRAWLSTAMP,
        SUM(KWD.score)

      FROM
        `kb-daas-dev.master_200729.keyword_bank_result`A,
        UNNEST(KPE) KWD,
        `kb-daas-dev.master_200729.keyword_bank`B
      WHERE
        A.DOCID=B.DOCID
        AND DATE(A.CRAWLSTAMP) >= {% parameter prmfrom %}
        AND DATE(A.CRAWLSTAMP) <= {% parameter prmto %}
        AND KWD.KEYWORD={% parameter prmkeyword %}
      GROUP BY
        A.DOCID,
        B.ID,
        KWD.keyword,
        A.S_NAME,
        A.SB_NAME,
        A.CRAWLSTAMP,
        B.CHANNEL
      ORDER BY 8 DESC
      LIMIT 1000
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

  dimension: channel {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }

  dimension_group: crawlstamp {
    type: time
    sql: ${TABLE}.CRAWLSTAMP ;;
  }

  dimension: f0_ {
    type: number
    sql: ${TABLE}.f0_ ;;
  }

  set: detail {
    fields: [
      docid,
      id,
      keyword,
      channel,
      s_name,
      sb_name,
      crawlstamp_time,
    ]
  }
}
