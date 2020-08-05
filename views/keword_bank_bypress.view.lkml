view: keword_bank_bypress3 {
  derived_table: {
    sql: WITH keword_bank_bypress2 AS (WITH keyword_bank_bypress AS (SELECT
       S_NAME
       ,SB_NAME
       , CHANNEL
       , CRAWLSTAMP
       , DATE(CRAWLSTAMP) AS crawlstampDate
FROM `kb-daas-dev.master_200729.keyword_bank_result` as keywordBankResult
      , UNNEST(keywordBankResult.KPE) as keywordBankResultKpe
WHERE keywordBankResultKpe.keyword  LIKE {% parameter searchKeyword %}
and keywordBankResult.CHANNEL  = '뉴스'
 AND (S_NAME NOT LIKE '%스포%'
    AND S_NAME != '포모스'
    AND S_NAME != '마이데일리')
and SB_NAME NOT LIKE '%스포%'
and DATE(CRAWLSTAMP) >= {% parameter endDate %}
and DATE(CRAWLSTAMP) <= {% parameter startDate %}
)
SELECT RANK() OVER (partition by resultCrawlstampDate
                    ORDER BY pressDateGroupCount DESC) as countRank
       , press
       , resultCrawlstampDate
       , pressDateGroupCount

      FROM(
            SELECT
                  case when keyword_bank_bypress.S_NAME in ('네이트', '네이버뉴스', '미디어다음', '뉴스줌') THEN  REGEXP_REPLACE(keyword_bank_bypress.SB_NAME, '[a-z]', '') ELSE
                  keyword_bank_bypress.S_NAME
                  end as press
                  , keyword_bank_bypress.crawlstampDate as resultCrawlstampDate
                  , COUNT(*) as pressDateGroupCount
            FROM keyword_bank_bypress
            GROUP BY press, resultCrawlstampDate
      )
)

SELECT countRank
       , press
       , resultCrawlstampDate
       , pressDateGroupCount
FROM keword_bank_bypress2
 ;;
  }

  filter: searchKeyword {
    type: string
  }

  filter: startDate {
    type: string
  }

  filter: endDate {
    type: string
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: press_date_group_count_mesure {
    type: sum
    sql: ${TABLE}.pressDateGroupCount;;
  }

  dimension: count_rank {
    type: number
    sql: ${TABLE}.countRank ;;
  }

  dimension: press {
    type: string
    sql: ${TABLE}.press ;;
  }

  dimension: result_crawlstamp_date {
    type: date
    sql: ${TABLE}.resultCrawlstampDate ;;
  }

  dimension: press_date_group_count {
    type: number
    sql: ${TABLE}.pressDateGroupCount ;;
  }

  set: detail {
    fields: [count_rank, press, result_crawlstamp_date, press_date_group_count]
  }
}
