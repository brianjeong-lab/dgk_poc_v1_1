view: bodo {
  derived_table: {
    sql: SELECT  TB.DOCID,
        TA.bodo,
        TB.CHANNEL,
        TB.SB_NAME,
        TB.S_NAME
        FROM (
          SELECT
            DOCID,
            CASE
              WHEN S_NAME IN ('네이버뉴스','네이버 뉴스','네이버 스포츠','네이버 증권','네이버카페','네이버금융','네이버블로그') THEN '네이버'
              WHEN S_NAME IN ('다음뉴스','다음 뉴스','Daum news','Daum','다음카페','다음블로그','미디어다음','다음자동차','다음 금융') THEN '다음'
              WHEN S_NAME LIKE '한국경제%' THEN '한국경제'
              WHEN S_NAME IN ('EBN물류','EBN화학','EBN스틸','EBN종합') THEN 'EBN'
              WHEN S_NAME IN ('뉴데일리경제','뉴데일리') THEN '뉴데일리'
              WHEN S_NAME LIKE 'CNB%' THEN 'CNB'
              WHEN S_NAME LIKE 'KBS%' THEN 'KBS'
              WHEN S_NAME LIKE '이데일리%' THEN '이데일리'
              WHEN S_NAME LIKE '조선%' THEN '조선일보'
              WHEN S_NAME LIKE '경향%' THEN '경향신문'
              WHEN S_NAME LIKE '네이트%' THEN '네이트'
              WHEN S_NAME LIKE '뉴스줌%' THEN '뉴스줌'
              WHEN S_NAME LIKE '매일경제%' THEN '매일경제'
              WHEN S_NAME LIKE '%경제%' THEN '경제보도사'
            ELSE
            '기타'
          END
            AS bodo
          FROM
            `kb-daas-dev.master_200729.keyword_bank_result`
          WHERE
            DATE(CRAWLSTAMP) >= {% parameter prmfrom %}
            AND DATE(CRAWLSTAMP) <= {% parameter prmto %}) AS TA , `kb-daas-dev.master_200729.keyword_bank_result` TB WHERE TA.DOCID=TB.DOCID
            AND DATE(TB.CRAWLSTAMP) >= {% parameter prmfrom %}
            AND DATE(TB.CRAWLSTAMP) <= {% parameter prmto %}
            AND EXISTS (SELECT * FROM UNNEST (TB.KPE ) WHERE KEYWORD = {% parameter prmkeyword %}
            AND TB.CHANNEL='뉴스'
            )
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension: docid {
    type: number
    sql: ${TABLE}.DOCID ;;
  }

  dimension: bodo {
    type: string
    sql: ${TABLE}.bodo ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  set: detail {
    fields: [docid, bodo, channel, sb_name, s_name]
  }
}
