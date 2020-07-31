view: big4_bank_sh {
  derived_table: {
    sql: SELECT C.KEYWORD
           , COUNT(C.KEYWORD) AS CNT
           ,C.WRITE_DAY
        FROM `kb-daas-dev.mart_200723.keyword_list` C
       WHERE C.ID IN (
             SELECT ID
               FROM `kb-daas-dev.mart_200723.keyword_list` B
              WHERE B.ID IN (
                    SELECT ID
                      FROM `kb-daas-dev.mart_200723.keyword_list`
                     WHERE {% condition WORD %} KEYWORD {% endcondition %}
                  )
                AND B.KEYWORD='신한은행'
           )
         AND C.KEYWORD NOT IN ({% parameter WORD %}, '신한은행' )
       GROUP BY 1,3
       ORDER BY CNT DESC LIMIT 10
                 ;;
  }

  filter: WORD {
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

  dimension: write_day {
    type: number
    sql: ${TABLE}.WRITE_DAY ;;
  }

  dimension: mydate {
    type: date
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', FORMAT('%08d',${TABLE}.WRITE_DAY)));;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.cnt ;;
  }

  set: detail {
    fields: [keyword, cnt]
  }
}
