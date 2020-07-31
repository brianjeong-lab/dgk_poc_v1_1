view: sentence_poc {
  derived_table: {
    sql: /* FORMATTED ON  (SQL FORMATTER V1.0.1) */
      SELECT B.ID
           , B.KEYWORD
           , A.SB_NAME
           , A.SENTENCE1
           , A.SENTENCE2
           , A.SENTENCE3
           , A.CATEGORY
        FROM `kb-daas-dev.mart_200723.sentence` A
           , `kb-daas-dev.mart_200723.keyword_list` B
           , `kb-daas-dev.mart_200723.keyword` C
       WHERE A.ID=B.ID
         AND B.KEYWORD=C.KEYWORD
         AND {% condition word %} B.KEYWORD {% endcondition %}
         AND C.SUM_SCORE > 1
         AND A.CATEGORY='산업 및 경제'
       GROUP BY 1
           , 2
           , 3
           , 4
           , 5
           , 6
           , 7
       ORDER BY 1 DESC LIMIT 5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.ID ;;
  }

  filter: word {
    type: string
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: sentence1 {
    type: string
    sql: ${TABLE}.SENTENCE1 ;;
  }

  dimension: sentence2 {
    type: string
    sql: ${TABLE}.SENTENCE2 ;;
  }

  dimension: sentence3 {
    type: string
    sql: ${TABLE}.SENTENCE3 ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }


  dimension: mydate {
    type: date
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', FORMAT('%08d',${TABLE}.WRITE_DAY)));;
  }

  set: detail {
    fields: [
      id,
      keyword,
      sentence1,
      sentence2,
      sentence3,
      category
    ]
  }
}
