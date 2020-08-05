view: bank_buzz {
  derived_table: {
    sql: SELECT
        TB.DOCID,
        WORD.keyword,
        TTA.BANK_CATEGORY,
        TB.S_NAME,
        TB.SB_NAME
      FROM (
        SELECT
          TA.DOCID AS CA_ID,
          TA.BANK_CATEGORY
        FROM (
          SELECT
            DOCID,
            KWD.keyword,
            CASE
              WHEN KWD.keyword IN ('국민은행', 'KB', 'KB은행', 'KB국민은행','KBBANK','kbbank') THEN '국민은행'
              WHEN KWD.keyword IN ('우리은행','WOORIBANK','wooribank') THEN '우리은행'
              WHEN KWD.keyword IN ('신한은행', '신한','SINHANBANK','sihanbank') THEN '신한은행'
              WHEN KWD.keyword IN ('농협',
              'NH',
              '농협은행',
              'NH은행',
              'NH농협은행',
              'NHBANK',
              'nhbank') THEN '농협은행'
              WHEN KWD.keyword IN ('하나은행','HANABANK','hanabank') THEN '하나은행'
            ELSE
            '6'
          END
            AS BANK_CATEGORY
          FROM
            `kb-daas-dev.master_200729.keyword_bank_result`,
            UNNEST(KPE) KWD
          WHERE
            DATE(CRAWLSTAMP) >= {% parameter prmfrom %}
            AND DATE(CRAWLSTAMP) <= {% parameter prmto %}) AS TA
        WHERE
          (TA.BANK_CATEGORY <> '6'
            OR TA.BANK_CATEGORY IS NULL)) AS TTA,
        `kb-daas-dev.master_200729.keyword_bank_result` TB,
        UNNEST(KPE) WORD,
        UNNEST(D2C) CAT
      WHERE
        TTA.CA_ID=TB.DOCID
        AND DATE(TB.CRAWLSTAMP) >= {% parameter prmfrom %}
        AND DATE(TB.CRAWLSTAMP) <= {% parameter prmto %}
        AND WORD.keyword={% parameter prmkeyword %}
      GROUP BY
        TB.DOCID,
        WORD.keyword,
        TTA.BANK_CATEGORY,
        TB.S_NAME,
        TB.SB_NAME
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

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension: bank_category {
    type: string
    sql: ${TABLE}.BANK_CATEGORY ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }

  set: detail {
    fields: [docid, keyword, bank_category, s_name, sb_name]
  }
}
