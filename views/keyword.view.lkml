view: keyword {
  sql_table_name: `kb-daas-dev.mart_200723.keyword`
    ;;

  dimension: channel {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.CNT ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  dimension: sum_score {
    type: number
    sql: ${TABLE}.SUM_SCORE ;;
  }

  dimension: mydate {
    type: date
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', FORMAT('%08d',${TABLE}.WRITE_DAY)));;
  }

  dimension: type {
    type: number
    sql: ${TABLE}.TYPE ;;
  }

  dimension: write_day {
    type: number
    sql: ${TABLE}.WRITE_DAY ;;
  }

  measure: count {
    type: count
    drill_fields: [s_name]
  }
}
